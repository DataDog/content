#!/usr/bin/env python3
"""Tests of datadog.py on throwaway repositories.

Run with: python3 -m unittest discover -s .datadog/tests
"""

import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

import yaml

TOOL = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "datadog.py")


def load_tool():
    spec = importlib.util.spec_from_file_location("datadog", TOOL)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


class Fixture:
    """A repository built with plumbing alone, isolated from the user's git
    configuration."""

    def __init__(self):
        self.dir = tempfile.mkdtemp(prefix="datadog-test-")
        self.env = dict(os.environ,
                        GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1",
                        GIT_AUTHOR_NAME="A U Thor", GIT_AUTHOR_EMAIL="author@example.com",
                        GIT_AUTHOR_DATE="1700000000 +0000",
                        GIT_COMMITTER_NAME="C O Mitter",
                        GIT_COMMITTER_EMAIL="committer@example.com",
                        GIT_COMMITTER_DATE="1700000000 +0000")
        self.git("init", "-q")

    def close(self):
        shutil.rmtree(self.dir)

    def git(self, *args, stdin=None, env=None, dir=None):
        e = dict(self.env)
        if env:
            e.update(env)
        return subprocess.run(["git", "-C", dir or self.dir] + list(args), input=stdin, env=e,
                              capture_output=True, text=True, check=True).stdout.strip()

    def commit(self, parent, files, message, author=None):
        index = os.path.join(self.dir, ".git", "fixture-index")
        env = {"GIT_INDEX_FILE": index}
        if os.path.exists(index):
            os.unlink(index)
        if parent:
            self.git("read-tree", parent, env=env)
        else:
            self.git("read-tree", "--empty", env=env)
        for path, text in files.items():
            if text is None:
                self.git("update-index", "--force-remove", path, env=env)
                continue
            blob = self.git("hash-object", "-w", "--stdin", stdin=text)
            self.git("update-index", "--add", "--cacheinfo", "100644,%s,%s" % (blob, path),
                     env=env)
        tree = self.git("write-tree", env=env)
        cenv = {}
        if author:
            cenv = {"GIT_AUTHOR_NAME": author[0], "GIT_AUTHOR_EMAIL": author[1]}
        args = ["commit-tree", tree] + (["-p", parent] if parent else [])
        return self.git(*args, stdin=message + "\n", env=cenv)

    def branch(self, name, commit):
        self.git("update-ref", "refs/heads/" + name, commit)

    def head(self, name):
        return self.git("rev-parse", "refs/heads/" + name)

    def show(self, rev, path):
        return self.git("cat-file", "blob", "%s:%s" % (rev, path)) + "\n"

    def run(self, *args, env=None):
        e = dict(self.env)
        if env:
            e.update(env)
        return subprocess.run([sys.executable, TOOL, "-C", self.dir, "--no-sign"] + list(args),
                              env=e, capture_output=True, text=True)


class TrailersTest(unittest.TestCase):
    def test_trailers(self):
        t = load_tool().trailers
        self.assertEqual(t("scripts: fix x\n", "b", "c"),
                         "scripts: fix x\n\nDatadog-Branch: b\nDatadog-Source: c\n")
        self.assertEqual(t("fix x\n\nThe body.\n\n", "b", "c"),
                         "fix x\n\nThe body.\n\nDatadog-Branch: b\nDatadog-Source: c\n")
        self.assertEqual(t("fix x\n\nSigned-off-by: A <a@example.com>\n", "b", "c"),
                         "fix x\n\nSigned-off-by: A <a@example.com>\n"
                         "Datadog-Branch: b\nDatadog-Source: c\n")


class DatadogTest(unittest.TestCase):
    def setUp(self):
        self.f = f = Fixture()
        self.base = f.commit(None, {"a": "1\n2\n3\n", "c": "x\n"}, "base")
        f.branch("master", self.base)
        pr = ("P R Author", "pr@example.com")
        self.pr1 = f.commit(self.base, {"pr": "one\n"}, "pr one", author=pr)
        self.pr2 = f.commit(self.pr1, {"pr": "one\ntwo\n"}, "pr two", author=pr)
        f.branch("pr", self.pr2)
        self.a = f.commit(self.base, {"a": "1\nA\n3\n"}, "topic a")
        f.branch("topic-a", self.a)
        self.b = f.commit(self.a, {"b": "b\n"}, "topic b on a")
        f.branch("topic-b", self.b)
        self.c = f.commit(self.base, {"c": "y\n"}, "topic c")
        f.branch("topic-c", self.c)
        self.entries = [
            {"squash": "pr", "author": "P R Author <pr@example.com>", "title": "Add the PR",
             "source": "example/upstream#1", "pr": 1},
            {"pick": "topic-a"}, {"pick": "topic-b"}, {"pick": "topic-c"},
            {"pick": "datadog-release"},
        ]
        self.write_list()

    def tearDown(self):
        self.f.close()

    def write_list(self, resolutions=None, base=None, parent=None):
        doc = {"base": base or self.base, "upstream": "example/upstream", "entries": self.entries}
        files = {".datadog/branches.yml": yaml.safe_dump(doc, sort_keys=False)}
        for name, res in (resolutions or {}).items():
            files[".datadog/resolve/%s.yml" % name] = yaml.safe_dump(res)
        self.f.branch("datadog-release", self.f.commit(parent or base or self.base, files,
                                                       "Add the datadog release workflow"))

    def commits(self):
        out = self.f.git("rev-list", "--reverse", "refs/heads/datadog", "^" + self.base)
        return out.split()

    def assertOK(self, r):
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    def assertFails(self, r, text):
        self.assertNotEqual(r.returncode, 0, r.stdout)
        self.assertIn(text, r.stderr)

    def test_sync_and_check(self):
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("check"))
        cs = self.commits()
        self.assertEqual(len(cs), 5)
        head = self.f.head("datadog")
        self.assertEqual(self.f.show(head, "a"), "1\nA\n3\n")
        self.assertEqual(self.f.show(head, "b"), "b\n")
        self.assertEqual(self.f.show(head, "c"), "y\n")
        self.assertEqual(self.f.show(head, "pr"), "one\ntwo\n")
        squash = self.f.git("log", "-1", "--format=%an <%ae>%n%B", cs[0])
        self.assertIn("P R Author <pr@example.com>", squash)
        self.assertIn("Squash of the 2 commits of example/upstream#1 at %s, by P R Author."
                      % self.pr2[:12], squash)
        self.assertEqual(self.f.git("log", "-1", "--format=%s", cs[2]), "topic b on a")
        self.assertEqual(self.f.git("rev-list", "--merges", "refs/heads/datadog"), "")

    def test_trailers_and_committer_date(self):
        r = self.f.run("sync", env={"GIT_COMMITTER_DATE": "1800000000 +0000"})
        self.assertOK(r)
        sources = [("pr", self.pr2), ("topic-a", self.a), ("topic-b", self.b),
                   ("topic-c", self.c), ("datadog-release", self.f.head("datadog-release"))]
        for c, (branch, source) in zip(self.commits(), sources):
            body = self.f.git("log", "-1", "--format=%B", c)
            self.assertTrue(body.endswith("\n\nDatadog-Branch: %s\nDatadog-Source: %s"
                                          % (branch, source)), body)
            self.assertEqual(self.f.git("log", "-1", "--format=%cd", "--date=raw", c),
                             "1700000000 +0000")

    def test_sync_keeps_unchanged_prefix(self):
        self.assertOK(self.f.run("sync"))
        before = self.commits()
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "z\n"}, "topic c"))
        r = self.f.run("sync")
        self.assertOK(r)
        self.assertIn("3 kept, 2 new", r.stdout)
        after = self.commits()
        self.assertEqual(before[:3], after[:3])
        self.assertNotEqual(before[3], after[3])
        self.assertOK(self.f.run("check"))

    def test_check_finds_a_moved_branch(self):
        self.assertOK(self.f.run("sync"))
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "w\n"}, "topic c"))
        self.assertFails(self.f.run("check"), "topic-c")

    def test_check_trailers(self):
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("check", "--trailers"))
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "z\n"}, "topic c"))
        self.assertFails(self.f.run("check", "--trailers"), "trailers")

    def test_check_finds_a_hand_edit(self):
        self.assertOK(self.f.run("sync"))
        head = self.f.head("datadog")
        self.f.branch("datadog", self.f.commit(head, {"extra": "x\n"}, "extra"))
        self.assertFails(self.f.run("check"), "after the last entry")

    def test_recorded_resolution(self):
        self.f.branch("topic-d", self.f.commit(self.base, {"a": "1\nD\n3\n"}, "topic d"))
        self.entries.insert(4, {"pick": "topic-d"})
        self.write_list()
        self.assertFails(self.f.run("sync"), "topic-d")
        self.write_list(resolutions={"topic-d": {"a": ["AD\n"]}})
        self.assertOK(self.f.run("sync"))
        self.assertEqual(self.f.show(self.f.head("datadog"), "a"), "1\nAD\n3\n")
        self.assertOK(self.f.run("check"))

    def test_commit_count(self):
        self.f.branch("topic-c", self.f.commit(self.c, {"c2": "y\n"}, "topic c, part two"))
        self.assertFails(self.f.run("sync"), "topic-c contributes 2 commits")
        self.entries[3]["commits"] = 2
        self.write_list()
        self.assertOK(self.f.run("sync"))
        self.assertEqual(len(self.commits()), 6)
        self.assertOK(self.f.run("check"))

    def test_restack(self):
        e = self.f.commit(self.b, {"e": "e\n"}, "topic e on b")
        self.f.branch("topic-e", e)
        self.entries.insert(3, {"pick": "topic-e"})
        self.write_list()
        self.assertOK(self.f.run("sync"))
        self.f.branch("topic-a", self.f.commit(self.base, {"a": "1\nAA\n3\n"}, "topic a"))
        self.assertFails(self.f.run("sync"), "topic-b contributes 2 commits")
        self.assertOK(self.f.run("restack", "topic-a", self.a))
        self.assertEqual(self.f.git("rev-parse", "refs/heads/topic-b^"), self.f.head("topic-a"))
        self.assertEqual(self.f.git("rev-parse", "refs/heads/topic-e^"), self.f.head("topic-b"))
        self.assertEqual(self.f.git("log", "-1", "--format=%s", "refs/heads/topic-e"),
                         "topic e on b")
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("check"))

    def test_restack_stops_and_resumes(self):
        b = self.f.commit(self.a, {"a": "1\nAB\n3\n"}, "topic b on a")
        self.f.branch("topic-b", b)
        self.f.branch("topic-e", self.f.commit(b, {"e": "e\n"}, "topic e on b"))
        self.entries.insert(3, {"pick": "topic-e"})
        self.write_list()
        a2 = self.f.commit(self.base, {"a": "1\nAA\n3\n"}, "topic a")
        self.f.branch("topic-a", a2)
        self.assertFails(self.f.run("restack", "topic-a", self.a),
                         "restack topic-a %s topic-b %s" % (self.a[:12], b[:12]))
        self.f.branch("topic-b", self.f.commit(a2, {"a": "1\nAAB\n3\n"}, "topic b on a"))
        self.assertOK(self.f.run("restack", "topic-a", self.a, "topic-b", b))
        self.assertEqual(self.f.git("rev-parse", "refs/heads/topic-e^"), self.f.head("topic-b"))
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("check"))

    def test_push(self):
        remote = tempfile.mkdtemp(prefix="datadog-test-remote-")
        self.addCleanup(shutil.rmtree, remote)
        self.f.git("init", "-q", "--bare", remote)
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("push", remote))
        for name in ("pr", "topic-a", "topic-b", "topic-c", "datadog-release", "datadog"):
            self.assertEqual(self.f.git("rev-parse", "refs/heads/" + name, dir=remote),
                             self.f.head(name))
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "z\n"}, "topic c"))
        self.assertFails(self.f.run("push", remote), "not pushing")
        self.assertOK(self.f.run("sync"))
        r = self.f.run("push", remote)
        self.assertOK(r)
        self.assertEqual(r.stdout, "push: topic-c\npush: datadog\n")
        self.assertEqual(self.f.git("rev-parse", "refs/heads/datadog", dir=remote),
                         self.f.head("datadog"))

    def test_empty_resolution(self):
        self.f.branch("topic-d", self.f.commit(self.base, {"a": "1\n3\n"}, "topic d"))
        self.entries.insert(4, {"pick": "topic-d"})
        self.write_list(resolutions={"topic-d": {"a": [""]}})
        self.assertOK(self.f.run("sync"))
        self.assertEqual(self.f.show(self.f.head("datadog"), "a"), "1\n3\n")

    def test_rebase(self):
        self.assertOK(self.f.run("sync"))
        new = self.f.commit(self.base, {"m": "m\n"}, "upstream moves")
        r = self.f.run("rebase", new)
        self.assertOK(r)
        for name in ("topic-a", "topic-c", "datadog-release"):
            self.assertEqual(self.f.git("rev-parse", "refs/heads/%s^" % name), new, name)
        self.assertEqual(self.f.git("rev-parse", "refs/heads/topic-b^"), self.f.head("topic-a"))
        self.assertEqual(self.f.head("pr"), self.pr2)
        listed = yaml.safe_load(self.f.show(self.f.head("datadog-release"),
                                            ".datadog/branches.yml"))
        self.assertEqual(listed["base"], new)
        self.assertEqual(self.f.show(self.f.head("datadog"), "m"), "m\n")
        self.assertOK(self.f.run("check"))

    def test_rebase_stops_and_continues(self):
        self.assertOK(self.f.run("sync"))
        new = self.f.commit(self.base, {"c": "w\n"}, "upstream changes c")
        self.assertFails(self.f.run("rebase", new), "topic-c")
        self.f.branch("topic-c", self.f.commit(new, {"c": "yw\n"}, "topic c"))
        self.assertOK(self.f.run("rebase", "--continue"))
        self.assertEqual(self.f.show(self.f.head("datadog"), "c"), "yw\n")
        self.assertOK(self.f.run("check"))

    def test_rebase_reports_an_upstream_change(self):
        self.assertOK(self.f.run("sync"))
        new = self.f.commit(self.base, {"c": "y\n"}, "upstream takes topic c")
        r = self.f.run("rebase", new)
        self.assertIn("topic-c is upstream now", r.stdout)
        self.assertFails(r, "topic-c contributes no commit")

    def add_on_datadog(self, files, message="datadog only x", commits=None):
        """Builds datadog, then a branch dd-x on its last commit before
        datadog-release, listed on datadog before datadog-release."""
        self.assertOK(self.f.run("sync"))
        under = self.commits()[-2]
        x = self.f.commit(under, files, message)
        self.f.branch("dd-x", x)
        e = {"pick": "dd-x", "onto": "datadog"}
        if commits:
            e["commits"] = commits
        self.entries.insert(4, e)
        self.write_list()
        return x

    def test_on_datadog(self):
        x = self.add_on_datadog({"b": "b\nx\n"})
        self.assertOK(self.f.run("sync"))
        self.assertOK(self.f.run("check"))
        head = self.f.head("datadog")
        self.assertEqual(self.f.show(head, "b"), "b\nx\n")
        self.assertEqual(self.f.head("dd-x"), x)
        body = self.f.git("log", "-1", "--format=%B", self.commits()[4])
        self.assertTrue(body.endswith("Datadog-Branch: dd-x\nDatadog-Source: %s" % x), body)

    def test_on_datadog_moves_with_the_entries_before_it(self):
        x = self.add_on_datadog({"b": "b\nx\n"})
        self.assertOK(self.f.run("sync"))
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "z\n"}, "topic c"))
        self.assertFails(self.f.run("check"), "topic-c")
        r = self.f.run("sync")
        self.assertOK(r)
        self.assertIn("moved dd-x", r.stdout)
        moved = self.f.head("dd-x")
        self.assertNotEqual(moved, x)
        self.assertEqual(self.f.git("rev-parse", moved + "^"), self.commits()[3])
        self.assertEqual(self.f.git("log", "-1", "--format=%s", moved), "datadog only x")
        head = self.f.head("datadog")
        self.assertEqual(self.f.show(head, "c"), "z\n")
        self.assertEqual(self.f.show(head, "b"), "b\nx\n")
        self.assertOK(self.f.run("check"))

    def test_on_datadog_follows_a_reworded_entry(self):
        x = self.add_on_datadog({"b": "b\nx\n"})
        self.assertOK(self.f.run("sync"))
        tree = self.f.git("rev-parse", self.c + "^{tree}")
        reworded = self.f.git("commit-tree", tree, "-p", self.base, stdin="topic c, reworded\n")
        self.f.branch("topic-c", reworded)
        self.assertFails(self.f.run("check"), "topic-c")
        r = self.f.run("sync")
        self.assertOK(r)
        self.assertIn("moved dd-x", r.stdout)
        self.assertEqual(self.f.git("rev-parse", self.f.head("dd-x") + "^"), self.commits()[3])
        self.assertNotEqual(self.f.head("dd-x"), x)
        self.assertOK(self.f.run("check"))

    def test_check_finds_a_stale_datadog_base(self):
        self.add_on_datadog({"b": "b\nx\n"})
        self.assertOK(self.f.run("sync"))
        stale = self.f.commit(self.commits()[2], {"b": "b\nx\n"}, "datadog only x")
        self.f.branch("dd-x", stale)
        self.assertFails(self.f.run("check"), "datadog base")

    def test_on_datadog_commit_count(self):
        x = self.add_on_datadog({"b": "b\nx\n"})
        self.f.branch("dd-x", self.f.commit(x, {"y": "y\n"}, "datadog only y"))
        self.assertFails(self.f.run("sync"), "dd-x holds 1 commits on datadog where")
        self.entries[4]["commits"] = 2
        self.write_list()
        self.assertOK(self.f.run("sync"))
        self.assertEqual(len(self.commits()), 7)
        self.assertOK(self.f.run("check"))

    def test_on_datadog_conflict(self):
        self.add_on_datadog({"c": "y\nx\n"})
        self.assertOK(self.f.run("sync"))
        self.f.branch("topic-c", self.f.commit(self.base, {"c": "z\n"}, "topic c"))
        self.assertFails(self.f.run("sync"), "Rebase the branch onto")

    def test_unknown_key(self):
        # YAML 1.1 reads a bare on as true.
        text = ("base: %s\nupstream: example/upstream\nentries:\n"
                "  - pick: topic-a\n    on: datadog\n" % self.base)
        self.f.branch("datadog-release",
                      self.f.commit(self.base, {".datadog/branches.yml": text}, "list"))
        self.assertFails(self.f.run("sync"), "topic-a: unknown key True")

    def test_rebase_leaves_on_datadog_to_sync(self):
        self.add_on_datadog({"b": "b\nx\n"})
        self.assertOK(self.f.run("sync"))
        new = self.f.commit(self.base, {"m": "m\n"}, "upstream moves")
        r = self.f.run("rebase", new)
        self.assertOK(r)
        self.assertIn("moved dd-x", r.stdout)
        head = self.f.head("datadog")
        self.assertEqual(self.f.show(head, "m"), "m\n")
        self.assertEqual(self.f.show(head, "b"), "b\nx\n")
        self.assertOK(self.f.run("check"))

    def test_notes(self):
        self.assertOK(self.f.run("sync"))
        out = os.path.join(self.f.dir, "out")
        self.assertFails(self.f.run("notes", "v0.1.82-dd.20990101.1", out), "base")
        self.assertFails(self.f.run("notes", "0.1.82", out), "does not read")
        self.assertOK(self.f.run("notes", "v0.1.82-dd.20231114.1", out))
        with open(os.path.join(out, "manifest.json")) as f:
            m = json.load(f)
        self.assertEqual(m["version"], "0.1.82-dd.20231114.1")
        self.assertEqual(m["upstream"]["release"], "0.1.82")
        self.assertEqual([e["branch"] for e in m["entries"]],
                         ["pr", "topic-a", "topic-b", "topic-c", "datadog-release"])
        with open(os.path.join(out, "notes.md")) as f:
            notes = f.read()
        self.assertIn("- Add the PR (`pr`, example/upstream#1)", notes)


if __name__ == "__main__":
    unittest.main()
