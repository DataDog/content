# The datadog branch

The `datadog` branch of DataDog/content is upstream ComplianceAsCode master
at the base commit that `branches.yml` names, plus one commit for every
commit of the branches it lists, cherry-picked in that order.
`datadog.py sync` rebuilds it from the branches, and `datadog.py check`
verifies it. Each of its commits keeps the author and message of its source
and ends with two trailers that name the source:

	Datadog-Branch: sshd-private-key-cis
	Datadog-Source: 0123456789abcdef0123456789abcdef01234567

- `branches.yml`: the base and the ordered branches. An entry contributes the
  commits of its branch beyond the base and the earlier entries, so a branch
  stacked on another contributes its own commits: one, or the number its
  `commits` field gives. A squash entry contributes one commit holding a
  whole upstream pull request.
- `resolve/<branch>.yml`: when the pick of a branch conflicts with the
  branches before it, the texts that replace each conflict block, in order.
- `datadog.py`: `list`, `sync`, `check`, `restack` the branches stacked on an
  amended one, `rebase` onto a new upstream master, `push` to DataDog/content,
  and `notes` for a release.
- `tests/`: `python3 -m unittest discover -s .datadog/tests`.

## Changing a branch

After amending a branch, `datadog.py restack <branch> <old head>` moves the
branches stacked on it. Then `sync`, `check` and `push`: `push` checks
`datadog` again and sends every changed branch in one atomic `git push`,
each under a lease.

## Releases

A tag `v<release>-dd.<YYYYMMDD>.<N>` on the head of `datadog` makes
`.github/workflows/datadog-release.yaml` publish a release. `<release>` is
the newest release upstream published before the base, such as 0.1.82,
`<YYYYMMDD>` the UTC commit date of the base, and `<N>` counts the releases
on that base, from 1.

The workflow checks the branch with `datadog.py check --trailers` and builds
rhel8, rhel9, rhel10, almalinux9, al2023, ubuntu2204 and ubuntu2404, with
`<release>-dd.<YYYYMMDD>.<N>` as the version of every data stream. It then
publishes `scap-security-guide-<version>.zip`, its `.sha512`, and
`manifest.json`, which lists the base and the head of every branch.

A push to `datadog` runs the same check and build as a dry run and keeps the
zip for 14 days. The workflow refuses a tag whose release exists, so a bad
release gets the next tag.
