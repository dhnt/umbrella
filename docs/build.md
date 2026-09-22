# Building the umbrella

There is **no single "build everything" command**, no umbrella `go.work`, and no
umbrella `Makefile`. the umbrella is a thin superproject that tracks each subproject as a
git submodule by commit SHA. Each subproject's `go.mod` is self-contained;
cross-project `replace github.com/qiangli/<X> => ../<X>` directives resolve to
the flat sibling submodules mounted at the umbrella root. So "building the repo"
means: hydrate submodules once, then build/test each subproject from its own
root.

## Step 0 — Fresh clone: hydrate submodules

```bash
script/bootstrap.sh        # git submodule update --init --recursive + hooks (idempotent)
```

Fetches every submodule at its pinned SHA and prints the per-subproject quick
checks.

## Step 1 — Build/test a subproject from its own root

| Subproject | Command | Notes |
|---|---|---|
| `outpost`  | `cd outpost && go test -short ./...` | `internal/agent/shell` tests need a controlling TTY and hang headless. Headless: `go test -short $(go list ./... \| grep -v internal/agent/shell)` |
| `ycode`    | `cd ycode && go test -short ./...` | |
| `bashy`    | `cd bashy && make build` | builds **two** binaries; needs `../sh` + `../coreutils`. See [Building bashy](#building-bashy-bash--bashy) below. |
| `bonsai`   | `cd bonsai && go test -short ./...` | needs `../gfy` |
| `sh`       | `cd sh && go test -short ./...` | fork of `mvdan.cc/sh/v3` |
| `nadir`    | `cd nadir && go test -short ./...` | |
| `gfy`      | `cd gfy && go test -short ./...` | |
| `coreutils`| `cd coreutils && go test ./...` | hermetic — no network, no system git |

To produce a binary for a normal Go subproject: `cd <subproject> && go build ./...`.

## Step 2 — Standalone clone (outside the umbrella)

If you cloned a single subproject instead of the umbrella, clone its sibling
deps next to it (`./<project>` + `./<dep>`) so the `../<X>` replaces resolve.
`bonsai → gfy`; `outpost → sh, coreutils`; `bashy → sh`.

## Gotchas

- **No umbrella build target** — don't look for a root `Makefile`/`go.work`.
- **outpost shell tests need a TTY** — exclude them in headless environments.
- The umbrella only tracks SHAs: to change subproject code, edit + commit + push
  *inside* the submodule first, then `git add <subproject>` at the umbrella root
  to bump the pin. Committing from the umbrella root does **not** commit your
  in-submodule edits.

## Building `bashy` (`bash` + `bashy`)

The `bashy` subproject builds **two independent binaries** from a shared core
(`internal/cli`) — separate `main` packages under `cmd/`, disjoint import graphs:

- **`bin/bash`** (`cmd/bash`) — pure-Go Bash 5.3 drop-in. Import graph never
  includes coreutils, so it stays lean (~8 MB). The compliance harness drives
  this one.
- **`bin/bashy`** (`cmd/bashy`) — the AgentOS shell: same core + coreutils
  userland (cat/ls/grep/… + `yc` verbs) + front-door subcommands
  (`bashy weave …`, `bashy podman …`). ~40 MB.

```bash
cd bashy
make build                # → bin/bash + bin/bashy
make build VERSION=v0.1.0 # stamp a real version
make install              # go install both into GOBIN
make dist                 # cross-compile both for all 6 platforms → bin/dist/
make test                 # go test ./...
make tidy                 # go mod tidy + gofmt -s -w . + go vet ./...
```

Just one binary, if wanted:

```bash
go build -o bin/bash  ./cmd/bash      # pure drop-in only
go build -o bin/bashy ./cmd/bashy     # AgentOS shell only
```

**Sibling deps** — `go.mod` has `replace mvdan.cc/sh/v3 => ../sh` and
`replace github.com/qiangli/coreutils => ../coreutils`. Inside the umbrella both
are submodules already mounted as flat siblings (just hydrate with
`script/bootstrap.sh`). In a standalone clone run `./scripts/bootstrap-siblings.sh`
to clone them at the SHAs in `.sibling-pins`.

**Bash 5.3 compliance harness** (optional, measures `bin/bash`):

```bash
mkdir -p external && ln -s /path/to/bash-5.3 external/bash-5.3   # gitignored symlink, one-time
make test-bash          # drive bin/bash against bash's own 5.3 suite (86/86)
make test-bash-list     # list fixtures
```

**PATH gotcha:** if a `ycode` shim shadows `sh` in `PATH` (common on the dev
machine), shell-forking Go tests misbehave. Run with a clean PATH:

```bash
PATH=/bin:/usr/bin:$(dirname $(which go)) go test ./...
```

## Verification

```bash
script/bootstrap.sh                          # submodules hydrated, status printed
cd coreutils && go test ./...                # fastest hermetic sanity check
cd ycode && go build ./... && go test -short ./...
```

## Umbrella build & test — full text
On a fresh clone, hydrate the submodules first:

```bash
script/bootstrap.sh        # git submodule update --init --recursive
```

Each subproject builds from its own root. There is no umbrella `go.work` and
no umbrella Makefile — every per-subproject `go.mod` is self-contained, and
sibling-path replaces (`../<name>`) resolve as flat siblings inside the
umbrella, which is exactly where the submodules are mounted.

```bash
cd bashy    && make test && make test-bash       # BOTH — see the release gate below
cd bashsharp && go test ./...             # the Bash# front door + cmd/bashsharp; needs only ../sh (D1 ratchet in front/)
bashsharp-tests/harness/run.sh               # bash++ conformance; BASHY_BIN defaults to ../bashy/bashy
cd outpost  && go test -short ./...       # `internal/agent/shell` tests need a controlling TTY (will hang in pure-headless runs)
cd ycode    && go test -short ./...
cd bonsai   && go test -short ./...
cd sh       && go test -short ./...
cd nadir    && go test -short ./...
cd gfy      && go test -short ./...
cd coreutils && go test ./...             # hermetic — the certified required set only (no engines, no submodules)
cd yoke     && go test $(go list ./... | grep -v /external/)   # the agentic userland; external/ forks excluded as in CI
```

Three test-invocation caveats worth knowing up front:

- **`outpost`'s `internal/agent/shell` tests need a controlling TTY.** They
  drive `ergochat/readline` against a PTY; in a TTY-less environment
  (headless CI, some agent harnesses) the readline goroutine blocks on
  `read()` and the test hangs to the `-timeout` ceiling. Run them on a real
  dev machine, or run the rest with `go test -short $(go list ./... | grep
  -v internal/agent/shell)` in headless runs.
- **`bashy`'s Go unit tests are NOT its release gate — and `make test` ≠
  `go test ./...`.** `make test` runs two extra lanes *before* the Go tests
  (`test-build-fail-closed`, `test-isolated-lanes` — the supply-chain
  fail-closed and build-isolation scripts under `bashy/scripts/`), so a bare
  `go test ./...` silently skips them. Neither says anything about bash-5.3
  conformance — the engine lives in `sh/`
  and is *measured* here. `make test-bash` (serial, 86/86) is the mandatory gate
  before tagging any bashy release; `make test-bash-parallel` fans the same
  suite across cores. A `sh/` change that looks green under `go test` can still
  regress fixtures. Heavy suites (`dag suites.md`, `test-bash-parallel`) are
  memory-hungry — run them on a remote test host, not the dev box. Details +
  the other scoreboards (yash, zsh, uutils) in `bashy/CLAUDE.md`.
- **`bashsharp-tests` is a shell script, not a `go test` tree**, and it tests a
  *binary*: `harness/run.sh` resolves `BASHY_BIN` to `../bashy/bashy` by
  default, so it only works against a **built** bashy sitting as a flat
  sibling — which is exactly the umbrella layout. Build bashy first
  (`cd bashy && make build`), and expect deliberate failures: the suite is
  TDD-first, so unimplemented features in the Go-1.27-shaped Bash++ profile
  are *supposed* to fail until `bash++` implements them. The implementation
  modules retain a Go 1.26.5 compatibility floor; the conformance corpus and
  oracle are pinned to exact Go 1.27.0. Don't read a red line there as a
  regression without checking whether that feature has landed.

### Canonical sibling-replace convention

Every cross-project `replace` is of the form `replace github.com/qiangli/<X>
=> ../<X>`. It resolves to the same path in two contexts:

- **Inside the umbrella** — `../<X>` from any submodule's root lands on
  `dhnt/<X>`, which is where the `<X>` submodule is mounted.
- **Standalone clone** — clone the project + its sibling deps next to each
  other (`./<project>` + `./<dep>`); `../<X>` from `<project>/` lands on
  `<dep>/` the same way.

When adding a new `qiangli/<X>` dep to any submodule, mount it at the
umbrella root as a flat sibling submodule — never nest it inside another
submodule. The two replace targets currently in play that exercise this:

- `bashsharp/go.mod`: `replace mvdan.cc/sh/v3 => ../sh` (the language over the engine; imports nothing from bashy/coreutils/yoke — `front/import_graph_test.go`); `bashy/go.mod`: `replace github.com/bashsharp/bashsharp => ../bashsharp` (Sprint 211: `sh` ← `bashsharp` ← `bashy`; the ONE non-`qiangli` module path — the language moved to the `bashsharp` org 2026-09-19, the sibling DIR is still the repo name)
- `ycode/go.mod`: `replace github.com/qiangli/nadir => ../nadir`
- `outpost/go.mod`, `ycode/go.mod`, `bashy/go.mod`: `replace mvdan.cc/sh/v3 => ../sh`
- `outpost/go.mod`, `ycode/go.mod`, `bashy/go.mod`, `yoke/go.mod`: `replace
  github.com/qiangli/coreutils => ../coreutils`; `outpost/go.mod`,
  `ycode/go.mod`, `bashy/go.mod`: `replace github.com/qiangli/yoke => ../yoke`
  (bashy additionally replaces yoke's nested modules — `external/otel`,
  `pkg/oci`, and the ollama/podman fork paths under `../yoke/external/…` —
  because cross-module replaces don't propagate from yoke's own go.mod).
  **Direction is load-bearing (Sprint 208): yoke imports coreutils; coreutils
  never imports yoke.** The two seams are package-level variables
  (`weavecli.DetectTool`, `schedule.DefaultAdmission`) set by yoke at init.
- `bonsai/go.mod`: `replace github.com/qiangli/gfy => ../gfy`
- `bashy/go.mod`: `replace github.com/ergochat/readline => ../readline`
  (same module-path-≠-dir-name case as `sh`/`filebrowser`: the fork keeps
  the upstream `ergochat/readline` module string, sibling dir is `readline`;
  the `sh` interactive package pulls it in, so `sh`/`outpost`/`bashy` share
  the pin)
  (like `mvdan.cc/sh/v3 => ../sh`, the module path keeps the upstream/fork
  name but the sibling dir is the repo name — the convention is the flat
  layout, not the module string; outpost embeds its `fbembed` seam as the
  `files` builtin)

If you add a new `qiangli/<X>` dep, follow the same pattern — flat sibling,
no nesting, no published-pseudo-version replace. Unified SHA across every
project is the whole point of the layout (the `sh` divergence between
outpost and ycode is what triggered the migration).

