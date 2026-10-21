#!/usr/bin/env python3
"""datadog: build and check the datadog branch of DataDog/content.

usage: datadog.py [-C repo] [--remote name] [--no-sign] command [args]

The datadog branch is a commit of ComplianceAsCode master, the base, plus
the commits of our branches, cherry-picked in the order that
.datadog/branches.yml gives. An entry contributes the commits of its branch
beyond the base and the branches of the earlier entries, so a branch
stacked on another contributes its own commits: one, or the number its
commits field gives. A squash entry contributes one commit holding all of
them, authored as the entry says.

An entry marked "onto: datadog" names a Datadog-only branch built on the
datadog branch itself, as the entries before it make it: it contributes
its last commits, one or the number its commits field gives, which must
sit on a datadog commit. When the entries before it change, sync moves
those commits onto the new datadog state and the branch with them.

A pick that conflicts takes the recorded resolution in
.datadog/resolve/<branch>.yml, which maps each conflicted path to the
texts that replace its conflict blocks, in order. Every datadog commit
keeps the author and message of its source and ends with the trailers
Datadog-Branch and Datadog-Source, which name the branch and the commit it
comes from. Its committer date is the base's: the release build takes
the head's as SOURCE_DATE_EPOCH, so the same content builds the same bytes.

The list and the resolutions are read from the branch datadog-release.
Branches resolve to refs/heads/<name>, or with --remote to
refs/remotes/<name>/<branch>. Every commit is written with git commit-tree
and every ref with git update-ref, so the checkout's HEAD, index and
working tree stay as they are.

commands:
  list                print each entry and the commits it contributes
  sync                rebuild refs/heads/datadog, keeping its unchanged prefix
  check [rev]         recompute every step and compare it with rev (datadog)
  check --trailers    compare rev with the branch heads, trees aside
  restack branch old...
                      move the branches stacked on old onto branch's head
  rebase base         move every branch onto the new base, then sync
  rebase --continue   resume a rebase stopped by a conflict
  push [url]          check, then push every changed branch and datadog
  notes tag dir       write notes.md and manifest.json for the release tag
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile

import yaml

LIST_BRANCH = "datadog-release"
LIST = ".datadog/branches.yml"
RESOLVE = ".datadog/resolve"
TARGET = "datadog"
ZERO = "0" * 40
BLOCK = re.compile(r"^<<<<<<< .*?\n.*?^>>>>>>> [^\n]*\n", re.M | re.S)
TAG = re.compile(r"^v([0-9]+\.[0-9]+\.[0-9]+)-dd\.([0-9]{8})\.([0-9]+)$")
TRAILER = re.compile(r"^[A-Za-z0-9][A-Za-z0-9-]*: ")
KEYS = {"pick", "squash", "author", "title", "source", "pr", "commits", "onto"}


class Error(Exception):
    pass


class Conflict(Error):
    def __init__(self, branch, commit, paths, onto, mbase):
        Error.__init__(self, "%s: %s conflicts in %s, picked onto %s with merge base %s"
                       % (branch, commit[:12], ", ".join(paths), onto, mbase))
        self.branch = branch
        self.commit = commit
        self.paths = paths


class Repo:
    def __init__(self, path, remote=None, sign=True):
        self.path = path
        self.remote = remote
        self.sign = sign

    def git(self, *args, stdin=None, env=None, check=True):
        e = dict(os.environ, GIT_OPTIONAL_LOCKS="0")
        if env:
            e.update(env)
        r = subprocess.run(["git", "-C", self.path] + list(args), input=stdin, env=e,
                           capture_output=True, text=True)
        if check and r.returncode != 0:
            raise Error("git %s: %s" % (" ".join(args), r.stderr.strip()))
        return r

    def out(self, *args, **kw):
        return self.git(*args, **kw).stdout.strip()

    def ref(self, branch):
        if self.remote:
            return "refs/remotes/%s/%s" % (self.remote, branch)
        return "refs/heads/%s" % branch

    def rev(self, name):
        return self.out("rev-parse", "--verify", name + "^{commit}")

    def head(self, branch):
        return self.rev(self.ref(branch))

    def has(self, name):
        return self.git("rev-parse", "--verify", "-q", name + "^{commit}",
                        check=False).returncode == 0

    def blob(self, rev, path):
        r = self.git("cat-file", "blob", "%s:%s" % (rev, path), check=False)
        if r.returncode != 0:
            return None
        return r.stdout

    def merge_tree(self, mbase, ours, theirs):
        """Runs a three-way merge with git merge-tree, with the conflict style
        pinned so that conflict blocks, and so recorded resolutions, read the
        same everywhere. Returns the exit status and the output lines: the
        tree, then the conflicted paths."""
        r = self.git("-c", "merge.conflictStyle=merge", "merge-tree", "--write-tree",
                     "--name-only", "--no-messages", "--merge-base=%s" % mbase, ours, theirs,
                     check=False)
        if r.returncode not in (0, 1):
            raise Error("merge-tree %s %s: %s" % (ours[:12], theirs[:12], r.stderr.strip()))
        return r.returncode, r.stdout.split("\n")

    def ancestor(self, a, b):
        return self.git("merge-base", "--is-ancestor", a, b, check=False).returncode == 0

    def commit_info(self, c):
        """Returns the parents, tree, author and message of a commit, the
        author as name, email and raw date, the message verbatim."""
        raw = self.git("cat-file", "commit", c).stdout
        header, _, message = raw.partition("\n\n")
        parents, tree, author = [], None, None
        for line in header.split("\n"):
            if line.startswith("tree "):
                tree = line[5:]
            elif line.startswith("parent "):
                parents.append(line[7:])
            elif line.startswith("author "):
                m = re.match(r"author (.*) <(.*)> (\d+ [+-]\d{4})$", line)
                author = (m.group(1), m.group(2), m.group(3))
        return parents, tree, author, message

    def committer_date(self, rev):
        return self.out("log", "-1", "--format=%cd", "--date=raw", rev)

    def update_ref(self, branch, new, old):
        ref = "refs/heads/%s" % branch
        head = self.git("symbolic-ref", "-q", "HEAD", check=False).stdout.strip()
        if head == ref:
            raise Error("%s is checked out here: refusing to move it" % branch)
        self.git("update-ref", ref, new, old or ZERO)


class Step:
    def __init__(self, kind, branch, source, mbase, author, message, on_datadog=False):
        self.kind = kind
        self.branch = branch
        self.source = source
        self.mbase = mbase
        self.author = author
        self.message = message
        self.on_datadog = on_datadog


def load(repo):
    rev = repo.head(LIST_BRANCH)
    text = repo.blob(rev, LIST)
    if text is None:
        raise Error("%s has no %s" % (LIST_BRANCH, LIST))
    spec = yaml.safe_load(text)
    resolutions = {}
    for e in spec["entries"]:
        name = entry_branch(e)
        for k in e:
            if k not in KEYS:
                raise Error("%s: unknown key %r in %s" % (name, k, LIST))
        t = repo.blob(rev, "%s/%s.yml" % (RESOLVE, name))
        if t is not None:
            resolutions[name] = yaml.safe_load(t) or {}
    return spec, repo.rev(spec["base"]), resolutions


def entry_branch(e):
    if "pick" in e:
        return e["pick"]
    if "squash" in e:
        return e["squash"]
    raise Error("entry without pick or squash: %r" % (e,))


def parse_author(text):
    m = re.match(r"^(.*?) <(.*)>$", text)
    if not m:
        raise Error("bad author %r" % text)
    return m.group(1), m.group(2)


def trailers(message, branch, source):
    """Returns message ending with the trailers that name the branch and the
    commit a datadog commit comes from. They join the last paragraph when it
    holds only trailers, as git interpret-trailers does, and start a new one
    otherwise."""
    body = message.rstrip("\n")
    paras = body.split("\n\n")
    joins = len(paras) > 1 and all(TRAILER.match(x) for x in paras[-1].split("\n"))
    return "%s%sDatadog-Branch: %s\nDatadog-Source: %s\n" % (
        body, "\n" if joins else "\n\n", branch, source)


def read_trailers(message):
    last = message.rstrip("\n").split("\n\n")[-1]
    return dict(re.findall(r"(?m)^Datadog-(Branch|Source): (\S+)$", last))


def steps(repo, spec, base):
    """Returns the steps of the datadog branch, one per contributed commit
    and one per squash entry, and the head of every entry's branch. A pick
    entry must contribute as many commits as its commits field says, one by
    default, which catches a branch left on the old head of an amended
    one."""
    seen = [base]
    out = []
    heads = {}
    for e in spec["entries"]:
        name = entry_branch(e)
        head = repo.head(name)
        heads[name] = head
        if on_datadog(e):
            out.extend(datadog_steps(repo, e, name, head, base))
            seen.append(head)
            continue
        revs = repo.out("rev-list", "--reverse", "--topo-order", head, "--not", *seen).split()
        if not revs:
            raise Error("%s contributes no commit: drop it from %s" % (name, LIST))
        if "squash" in e:
            name_, email = parse_author(e["author"])
            date = repo.commit_info(head)[2][2]
            message = "%s\n\nSquash of the %d commits of %s at %s, by %s.\n" % (
                e["title"], len(revs), e["source"], head[:12], name_)
            mbase = repo.out("merge-base", head, base)
            out.append(Step("squash", name, head, mbase, (name_, email, date),
                            trailers(message, name, head)))
        else:
            want = e.get("commits", 1)
            if len(revs) != want:
                raise Error("%s contributes %d commits where %s expects %d: restack the "
                            "branches stacked on an amended branch, or fix the list"
                            % (name, len(revs), LIST, want))
            for c in revs:
                parents, _, author, message = repo.commit_info(c)
                if len(parents) != 1:
                    raise Error("%s: %s is a merge" % (name, c[:12]))
                out.append(Step("pick", name, c, parents[0], author,
                                trailers(message, name, c)))
        seen.append(head)
    return out, heads


def on_datadog(e):
    """Tells whether an entry's branch is built on the datadog branch."""
    if e.get("onto", TARGET) != TARGET:
        raise Error("%s: unknown onto %r" % (entry_branch(e), e["onto"]))
    return "onto" in e


def datadog_steps(repo, e, name, head, base):
    """Returns the steps of an entry built on the datadog branch: the last
    commits of its branch, as many as its commits field says, which must
    sit on the base or on a commit of the datadog branch."""
    if "squash" in e:
        raise Error("%s: a squash entry cannot be on datadog" % name)
    want = e.get("commits", 1)
    revs = repo.out("rev-list", "--reverse", "--first-parent", "--max-count=%d" % want,
                    head).split()
    out = []
    for c in revs:
        parents, _, author, message = repo.commit_info(c)
        if len(parents) != 1:
            raise Error("%s: %s is a merge" % (name, c[:12]))
        out.append(Step("pick", name, c, parents[0], author, trailers(message, name, c), True))
    under = out[0].mbase if out else None
    if len(out) != want or (under != base and "Branch" not in read_trailers(
            repo.commit_info(under)[3])):
        raise Error("%s holds %d commits on datadog where %s expects %d: put them on a "
                    "datadog commit, or fix the commits field" % (name, len(out), LIST, want))
    return out


def restack_on(repo, steps_, cur, resolutions):
    """Moves the commits of an entry built on the datadog branch onto cur,
    the datadog commit before it, and its branch with them. Returns the
    steps of the moved commits."""
    name = steps_[0].branch
    head = repo.head(name)
    out = []
    at = cur
    for s in steps_:
        _, _, author, message = repo.commit_info(s.source)
        try:
            tree = pick_tree(repo, at, s, resolutions)
        except Conflict as c:
            raise Error("%s: %s conflicts with the datadog commit %s in %s. Rebase the branch "
                        "onto %s by hand, sign it, move refs/heads/%s, then sync again"
                        % (name, s.source[:12], cur[:12], ", ".join(c.paths), cur,
                           name)) from None
        new = commit(repo, tree, at, author, message)
        out.append(Step("pick", name, new, at, author, trailers(message, name, new), True))
        at = new
    repo.update_ref(name, at, head)
    print("sync: moved %s onto datadog %s" % (name, cur[:12]))
    return out


def line_end(text):
    """Returns text ending in a newline, or empty for a block that goes."""
    if text and not text.endswith("\n"):
        return text + "\n"
    return text


def resolve(repo, tree, texts_by_path, paths):
    missing = [p for p in paths if p not in texts_by_path]
    if missing:
        return None
    with tempfile.TemporaryDirectory() as d:
        env = {"GIT_INDEX_FILE": os.path.join(d, "index")}
        repo.git("read-tree", tree, env=env)
        for p in paths:
            text = repo.git("cat-file", "blob", "%s:%s" % (tree, p)).stdout
            blocks = BLOCK.findall(text)
            texts = texts_by_path[p]
            if len(blocks) != len(texts):
                raise Error("%s has %d conflict blocks, %d recorded resolutions"
                            % (p, len(blocks), len(texts)))
            it = iter(texts)
            text = BLOCK.sub(lambda m, it=it: line_end(next(it)), text)
            if "<<<<<<< " in text or ">>>>>>> " in text:
                raise Error("markers left in %s" % p)
            mode = repo.out("ls-tree", tree, "--", p).split()[0]
            blob = repo.out("hash-object", "-w", "--stdin", stdin=text)
            repo.git("update-index", "--cacheinfo", "%s,%s,%s" % (mode, blob, p), env=env)
        return repo.out("write-tree", env=env)


def pick_tree(repo, cur, step, resolutions):
    """Returns the tree of step applied on cur: a three-way merge whose base
    is the parent of the picked commit, or the fork point of a squash."""
    status, lines = repo.merge_tree(step.mbase, cur, step.source)
    if status == 0:
        return lines[0].strip()
    paths = [line for line in lines[1:] if line]
    tree = None
    if step.branch in resolutions:
        tree = resolve(repo, lines[0].strip(), resolutions[step.branch], paths)
    if tree is None:
        raise Conflict(step.branch, step.source, paths, cur, step.mbase)
    return tree


def commit(repo, tree, parent, author, message, date=None):
    env = {"GIT_AUTHOR_NAME": author[0], "GIT_AUTHOR_EMAIL": author[1],
           "GIT_AUTHOR_DATE": author[2]}
    if date:
        env["GIT_COMMITTER_DATE"] = date
    args = ["commit-tree", tree, "-p", parent]
    if repo.sign:
        args.append("-S")
    return repo.out(*args, stdin=message, env=env)


def chain(repo, base, target):
    """Returns the commits of target after base, oldest first, and whether
    the history between them is linear."""
    if not repo.ancestor(base, target):
        return [], False
    revs = repo.out("rev-list", "--reverse", "--first-parent", target, "^" + base).split()
    merges = repo.out("rev-list", "--merges", target, "^" + base).split()
    return revs, not merges


def cmd_list(repo, args):
    spec, base, _ = load(repo)
    st, heads = steps(repo, spec, base)
    print("base %s" % base[:12])
    for s in st:
        subject = s.message.split("\n", 1)[0]
        print("%-6s %-44s %s %s" % (s.kind, s.branch, s.source[:12], subject))


def cmd_sync(repo, args):
    spec, base, resolutions = load(repo)
    st, _ = steps(repo, spec, base)
    target = repo.ref(TARGET)
    old = repo.rev(target) if repo.has(target) else None
    existing, linear = chain(repo, base, old) if old else ([], False)
    if not linear:
        existing = []
    date = repo.committer_date(base)
    cur, kept, built = base, 0, 0
    i = 0
    while i < len(st):
        s = st[i]
        if s.on_datadog and (i == 0 or st[i - 1].branch != s.branch):
            n = 1
            while i + n < len(st) and st[i + n].branch == s.branch:
                n += 1
            if s.mbase != cur:
                st[i:i + n] = restack_on(repo, st[i:i + n], cur, resolutions)
                s = st[i]
        tree = pick_tree(repo, cur, s, resolutions)
        if i == kept and i < len(existing):
            parents, etree, author, message = repo.commit_info(existing[i])
            if parents == [cur] and etree == tree and author == s.author and message == s.message:
                cur = existing[i]
                kept += 1
                i += 1
                continue
        cur = commit(repo, tree, cur, s.author, s.message, date)
        built += 1
        i += 1
    if cur != old:
        repo.update_ref(TARGET, cur, old)
    print("datadog %s: %d commits on %s, %d kept, %d new"
          % (cur[:12], len(st), base[:12], kept, built))


def problems(repo, spec, base, resolutions, target, trees=True):
    """Returns why target is not datadog as the list and the branches make
    it, empty when it is. Without trees, it compares the parents, authors
    and messages, trailers included, and leaves out the picks, whose trees
    another git release could merge differently."""
    st, heads = steps(repo, spec, base)
    existing, linear = chain(repo, base, target)
    if not repo.ancestor(base, target):
        return ["%s does not descend from the base %s" % (target[:12], base[:12])]
    if not linear:
        return ["%s holds merge commits after the base" % target[:12]]
    cur = base
    for i, s in enumerate(st):
        if i >= len(existing):
            return ["missing the commit of %s %s and %d more"
                    % (s.branch, s.source[:12], len(st) - i - 1)]
        parents, etree, author, message = repo.commit_info(existing[i])
        what = []
        if parents != [cur]:
            what.append("parent")
        t = read_trailers(message)
        if t.get("Branch") != s.branch or t.get("Source") != s.source:
            what.append("trailers")
        if author != s.author:
            what.append("author")
        if message != s.message:
            what.append("message")
        if s.on_datadog and (i == 0 or st[i - 1].branch != s.branch) and s.mbase != cur:
            what.append("datadog base")
        if trees and not what and etree != pick_tree(repo, cur, s, resolutions):
            what.append("tree")
        if what:
            return ["%s differs from %s %s in %s: the branch moved, run sync"
                    % (existing[i][:12], s.branch, s.source[:12], ", ".join(what))]
        cur = existing[i]
    if len(existing) > len(st):
        return ["%d commits after the last entry" % (len(existing) - len(st))]
    return []


def cmd_check(repo, args):
    spec, base, resolutions = load(repo)
    target = repo.rev(args.rev or repo.ref(TARGET))
    found = problems(repo, spec, base, resolutions, target, not args.trailers)
    if found:
        for p in found:
            print("check: %s" % p, file=sys.stderr)
        sys.exit(1)
    print("datadog %s is in sync with the %d entries on %s"
          % (target[:12], len(spec["entries"]), base[:12]))


def cmd_restack(repo, args):
    """Moves the branches stacked on the old head of a branch onto its new
    head, keeping authors and messages. It walks the list in order, so a
    branch stacked on a moved one follows it. The arguments pair branches
    with their old heads."""
    if len(args.pairs) % 2:
        raise Error("restack takes pairs of a branch and its old head")
    spec, _, _ = load(repo)
    pairs = list(zip(args.pairs[::2], [repo.rev(x) for x in args.pairs[1::2]]))
    moved = {old: repo.head(name) for name, old in pairs}
    for e in spec["entries"]:
        if on_datadog(e):
            # sync moves the branches built on the datadog branch.
            continue
        name = entry_branch(e)
        head = repo.head(name)
        olds = [o for o in moved if repo.ancestor(o, head) and not repo.ancestor(moved[o], head)]
        if not olds:
            continue
        old = max(olds, key=lambda o: int(repo.out("rev-list", "--count", o)))
        cur = moved[old]
        for c in repo.out("rev-list", "--reverse", head, "^" + old).split():
            parents, _, author, message = repo.commit_info(c)
            if len(parents) != 1:
                raise Error("%s: %s is a merge" % (name, c[:12]))
            status, lines = repo.merge_tree(parents[0], cur, c)
            if status != 0:
                again = " ".join("%s %s" % (n, o[:12]) for n, o in pairs + [(name, head)])
                raise Error("%s: %s conflicts with %s in %s. Rebase %s onto %s by hand, "
                            "sign it, move refs/heads/%s, then run restack %s"
                            % (name, c[:12], cur[:12], ", ".join(x for x in lines[1:] if x),
                               name, moved[old], name, again))
            cur = commit(repo, lines[0].strip(), cur, author, message)
        repo.update_ref(name, cur, head)
        moved[head] = cur
        pairs.append((name, head))
        print("restack: %s %s on %s" % (name, cur[:12], moved[old][:12]))


def cmd_push(repo, args):
    if repo.remote:
        raise Error("push sends the local branches: drop --remote")
    spec, base, resolutions = load(repo)
    found = problems(repo, spec, base, resolutions, repo.head(TARGET))
    if found:
        raise Error("not pushing: %s" % "; ".join(found))
    remote = {}
    for line in repo.out("ls-remote", "--heads", args.url).splitlines():
        sha, ref = line.split("\t")
        remote[ref[len("refs/heads/"):]] = sha
    refspecs, leases = [], []
    for name in [entry_branch(e) for e in spec["entries"]] + [TARGET]:
        local = repo.head(name)
        if remote.get(name) == local:
            continue
        refspecs.append("%s:refs/heads/%s" % (local, name))
        leases.append("--force-with-lease=refs/heads/%s:%s" % (name, remote.get(name, "")))
    if not refspecs:
        print("push: %s already holds every branch" % args.url)
        return
    repo.git("push", "--atomic", *leases, args.url, *refspecs)
    for r in refspecs:
        print("push: %s" % r.split(":refs/heads/")[1])


def state_path(repo, args):
    if args.state:
        return args.state
    gitdir = repo.out("rev-parse", "--absolute-git-dir")
    return os.path.join(gitdir, "datadog-rebase.json")


def cmd_rebase(repo, args):
    path = state_path(repo, args)
    if args.cont:
        with open(path) as f:
            state = json.load(f)
    else:
        if os.path.exists(path):
            raise Error("a rebase is in progress (%s): use --continue" % path)
        spec, base, _ = load(repo)
        new = repo.rev(args.base)
        if not repo.ancestor(base, new):
            raise Error("%s does not descend from the base %s" % (new[:12], base[:12]))
        st, heads = steps(repo, spec, base)
        state = {"base": base, "new": new, "heads": heads, "moved": {}, "done": [],
                 "dropped": [], "entries": spec["entries"]}
    base, new = state["base"], state["new"]
    moved, done = state["moved"], state["done"]
    seen = [base]
    for e in state["entries"]:
        name = entry_branch(e)
        old_head = state["heads"][name]
        if on_datadog(e):
            # The sync at the end moves it onto the new datadog branch.
            seen.append(old_head)
            continue
        own = repo.out("rev-list", "--reverse", "--topo-order", old_head, "--not", *seen).split()
        seen.append(old_head)
        if name in done or "squash" in e:
            continue
        first_parent = repo.commit_info(own[0])[0][0]
        if repo.ancestor(first_parent, base):
            onto = new
        else:
            onto = moved.get(first_parent, first_parent)
        if onto == first_parent:
            done.append(name)
            continue
        head = repo.head(name)
        if head != old_head:
            # Resolved by hand after a stop: the branch must now sit on onto.
            if not repo.ancestor(onto, head):
                raise Error("%s moved to %s, which does not descend from %s"
                            % (name, head[:12], onto[:12]))
            moved[old_head] = head
            done.append(name)
            continue
        cur = onto
        for c in own:
            parents, _, author, message = repo.commit_info(c)
            status, lines = repo.merge_tree(parents[0], cur, c)
            if status != 0:
                state["stopped"] = {"branch": name, "commit": c, "onto": cur}
                with open(path, "w") as f:
                    json.dump(state, f, indent=1)
                raise Error("%s: %s conflicts with %s in %s. Rebase the branch onto %s by "
                            "hand, sign it, move refs/heads/%s, then run rebase --continue"
                            % (name, c[:12], cur[:12], ", ".join(x for x in lines[1:] if x),
                               cur, name))
            tree = lines[0].strip()
            if tree == repo.commit_info(cur)[1]:
                state["dropped"].append({"branch": name, "commit": c})
                continue
            cur = commit(repo, tree, cur, author, message)
        if cur == onto:
            print("rebase: %s is upstream now: drop it from %s" % (name, LIST))
        repo.update_ref(name, cur, head)
        moved[old_head] = cur
        done.append(name)
    if os.path.exists(path):
        os.unlink(path)
    rebase_list(repo, new)
    print("rebase: every branch is on %s" % new[:12])
    for d in state["dropped"]:
        print("rebase: %s %s became empty" % (d["branch"], d["commit"][:12]))
    cmd_sync(repo, args)


def rebase_list(repo, new):
    """Points the base of the list at new, amending the datadog-release
    commit, which holds the list."""
    head = repo.head(LIST_BRANCH)
    text = repo.blob(head, LIST)
    updated, n = re.subn(r"(?m)^base: .*$", "base: %s" % new, text)
    if n != 1:
        raise Error("%s holds %d base lines" % (LIST, n))
    if updated == text:
        return
    parents, tree, author, message = repo.commit_info(head)
    with tempfile.TemporaryDirectory() as d:
        env = {"GIT_INDEX_FILE": os.path.join(d, "index")}
        repo.git("read-tree", tree, env=env)
        blob = repo.out("hash-object", "-w", "--stdin", stdin=updated)
        repo.git("update-index", "--cacheinfo", "100644,%s,%s" % (blob, LIST), env=env)
        tree = repo.out("write-tree", env=env)
    repo.update_ref(LIST_BRANCH, commit(repo, tree, parents[0], author, message), head)


def cmd_notes(repo, args):
    m = TAG.match(args.tag)
    if not m:
        raise Error("tag %s does not read v<release>-dd.<YYYYMMDD>.<N>" % args.tag)
    spec, base, _ = load(repo)
    st, heads = steps(repo, spec, base)
    date = repo.out("log", "-1", "--format=%cd", "--date=format-local:%Y%m%d", base,
                    env={"TZ": "UTC"})
    if m.group(2) != date:
        raise Error("tag date %s, base %s committed on %s" % (m.group(2), base[:12], date))
    target = repo.rev(args.rev or repo.ref(TARGET))
    entries = []
    for e in spec["entries"]:
        name = entry_branch(e)
        commits = [{"commit": s.source, "subject": s.message.split("\n", 1)[0]}
                   for s in st if s.branch == name]
        entries.append({"branch": name, "kind": "squash" if "squash" in e else "pick",
                        "head": heads[name], "pr": e.get("pr"), "commits": commits})
    upstream = spec.get("upstream", "ComplianceAsCode/content")
    manifest = {"tag": args.tag, "version": args.tag[1:], "datadog": target,
                "upstream": {"repository": upstream, "release": m.group(1),
                             "commit": base, "date": date},
                "entries": entries}
    os.makedirs(args.dir, exist_ok=True)
    with open(os.path.join(args.dir, "manifest.json"), "w") as f:
        json.dump(manifest, f, indent=1)
        f.write("\n")
    lines = ["SCAP Security Guide %s, built from the datadog branch at %s:" % (
        args.tag[1:], target[:12]),
        "upstream %s master at %s (%s), after release %s, plus these changes:"
        % (upstream, base[:12], date, m.group(1)), ""]
    for e in entries:
        subject = e["commits"][0]["subject"]
        ref = ", %s#%s" % (upstream, e["pr"]) if e.get("pr") else ""
        lines.append("- %s (`%s`%s)" % (subject, e["branch"], ref))
    with open(os.path.join(args.dir, "notes.md"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("wrote %s/manifest.json and %s/notes.md" % (args.dir, args.dir))


def main():
    p = argparse.ArgumentParser(description="build and check the datadog branch")
    p.add_argument("-C", dest="repo", default=".")
    p.add_argument("--remote", help="read branches from refs/remotes/REMOTE")
    p.add_argument("--no-sign", action="store_true", help="write unsigned commits")
    p.add_argument("--state", help="rebase state file (default in the git dir)")
    sub = p.add_subparsers(dest="cmd")
    sub.add_parser("list")
    sub.add_parser("sync")
    c = sub.add_parser("check")
    c.add_argument("rev", nargs="?")
    c.add_argument("--trailers", action="store_true",
                   help="compare with the branch heads, trees aside")
    rs = sub.add_parser("restack")
    rs.add_argument("pairs", nargs="+", metavar="branch old")
    ps = sub.add_parser("push")
    ps.add_argument("url", nargs="?", default="git@github.com:DataDog/content.git")
    r = sub.add_parser("rebase")
    r.add_argument("base", nargs="?")
    r.add_argument("--continue", dest="cont", action="store_true")
    n = sub.add_parser("notes")
    n.add_argument("tag")
    n.add_argument("dir")
    n.add_argument("--rev")
    args = p.parse_args()
    if args.cmd == "rebase" and not args.cont and not args.base:
        p.error("rebase needs a base or --continue")
    repo = Repo(args.repo, args.remote, not args.no_sign)
    cmds = {"list": cmd_list, "sync": cmd_sync, "check": cmd_check, "restack": cmd_restack,
            "rebase": cmd_rebase, "push": cmd_push, "notes": cmd_notes}
    if args.cmd not in cmds:
        p.error("missing command")
    try:
        cmds[args.cmd](repo, args)
    except Error as e:
        print("datadog: %s" % e, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
