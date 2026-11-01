# Building the public umbrella

The umbrella pins eighteen public repositories as Git submodules. The root
`go.work` selects live sibling modules for development. Each project's `go.mod`
retains versioned dependencies for standalone builds and CI with `GOWORK=off`.
Private services, credentials and licensed test fixtures are not prerequisites
for public builds.

The Go baseline is **Go 1.27 with toolchain go1.27.2**. Run commands from the
subproject that owns the code. There is no root Makefile or single package tree
covered by a root `go test ./...`.

## Hydrate or synchronize

```bash
script/bootstrap.sh
```

Bootstrap checks initialized submodules for local edits, hydrates the committed
pins recursively, and installs provenance and public-content hooks. It never
force-resets an interrupted or edited checkout. Preserve and review local work
before repairing a failed bootstrap.

To advance the umbrella to published integration heads:

```bash
script/sync.sh
```

Sync discovers modules from `.gitmodules`, requires clean working trees, fetches
without recursively following obsolete nested pins, and validates every target
before switching branches. It refuses feature branches, divergent local branches
and detached commits not integrated in the selected remote `main` or `master`.
After fast-forwarding and hydrating nested pins, it stages only gitlinks for
review. A network or checkout failure may leave some checkouts advanced; inspect
them and rerun after resolving the error. Sync does not change dependency
versions, commit or push.

Changes inside a submodule must be committed and pushed **inside that submodule**
before the parent gitlink is committed. Never use `git add -A` at the umbrella
root. Commits require `Sprint:`, `Story:` and `Story-ID:` provenance trailers.

## Workspace and standalone builds

For development across sibling projects, normal Go commands discover the root
`go.work`. For a standalone check, turn workspace mode off explicitly:

```bash
cd bashy
GOWORK=off go build ./...
GOWORK=off make test
```

A standalone clone resolves public dependencies at the versions in its own
`go.mod`; it does not need sibling clones. A project with nested source
submodules, such as Yoke, still requires `git submodule update --init --recursive`
inside that clone. Examples and fixtures not listed in `go.work` should also run
with `GOWORK=off`.

Workspace success alone does not prove the published dependency pins work.
Validate standalone mode after changing dependencies, and validate workspace
mode when changing coordinated siblings. Do not replace published dependency
versions with mandatory paths outside the repository. Local workspace overrides
are development configuration; they must not become private CI dependencies.

## Existing build and test entrypoints

Heavy builds and full suites run on prepared test hosts, not the development
machine. Select a candidate and record its repository SHAs, toolchain, operating
system and artifact identifiers before running the relevant gates.

| Project | Command from its root | Notes |
|---|---|---|
| Bashy | `make build` | Builds the product and shell binaries through the supported build path. |
| Bashy | `make test && make test-bash` | Unit/build-isolation gates and the serial Bash compatibility gate are both required. |
| Bashsharp | `go test ./...` | Language front end and command tests. |
| Outpost | `go test -short ./...` | Shell/readline tests need a controlling TTY. |
| Ycode, Bonsai, Sh, Nadir, Gfy | `go test -short ./...` | Run in each project's root. |
| Coreutils | `go test ./...` | POSIX implementation package tests. |
| Yoke | `go test $(go list ./... \| grep -v /external/)` | Match its documented project gate; nested modules have their own checks. |

Read each subproject's `CLAUDE.md`, Makefile and suite definitions for the full
candidate-specific matrix. Short unit tests are not substitutes for full
integration or conformance gates. Do not silently omit TTY-dependent tests to
make a headless run green; schedule them with a PTY and report lane coverage.

The Bash# conformance corpus consumes a built binary. Point `BASHY_BIN` at the
exact candidate artifact when running `bashsharp-tests/harness/run.sh`. Record
all outcomes and compare failures with the documented implementation baseline;
a baseline failure is still a failure, not a pass.

## Bash compatibility and POSIX conformance

Bashy's Go tests do not measure Bash compatibility. `make test` includes build
isolation and supply-chain checks beyond `go test ./...`; `make test-bash` runs
the Bash 5.3 compatibility suite through the existing runner. The serial release
gate expects all 86 measured fixtures. Use the existing suite definitions for
additional shell, utility and platform coverage.

Never run foreign conformance suites natively on a development machine. Use
prepared, isolated test hosts and the established runners. Licensed certification
harnesses and fixtures stay in separate private infrastructure and consume the
public candidate through explicit paths or artifact versions. Only approved,
sanitized summaries belong in public evidence. Do not traverse live conformance
workspaces to monitor progress: even reads may alter filesystem timestamps.
Inspect completed journals and retain raw outcomes unchanged.

An engineering conformance run is not an official certification award. Report
FAIL, UNRESOLVED, INSPECT, skipped and incomplete outcomes explicitly, together
with the exact candidate and suite coverage.

## Public workspace checks

The umbrella CI checks every shell script, each gitlink and public-content
scrubbing. The same lightweight checks can run locally:

```bash
for script in script/*.sh; do bash -n "$script"; done
script/scrub-gate.sh --all
```

The scrub gate supplements review; it does not establish that arbitrary private
material is safe to publish. Keep public documentation free of credentials,
private implementation details, real machine names and local home paths.
