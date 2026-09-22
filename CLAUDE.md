# CLAUDE.md — umbrella (public)

Guidance for Claude Code and other agentic tools (Codex, OpenCode, ycode) in
`dhnt/umbrella`: a thin git superproject that mounts every **open-source**
`dhnt` project as a flat sibling submodule so the `../<X>` replace
directives resolve and each project builds on its own. `AGENTS.md` is a
one-screen redirect to this file — keep it that way.

**Everything in this repository is public.** Stories, sprint plans, notes,
evidence — all of it. Never a machine name, an OS login, an IP or address,
a credential, or a path under a home directory: describe hosts by ROLE
("the Windows host", "the dev box"). `script/scrub-gate.sh` runs at
`pre-commit` and is fail-closed; keep private patterns in the gitignored
`.scrub-patterns.local`. Never quote internals of the hosted control plane
(`cloudbox`): OSS notes refer to the public wire protocol only.

## Source of truth for work

**`bashy sprint` is the source of requests, plans and details for every
agent.** The board, the sprint card (spec-ref, acceptance, continuity
record, lease) and its stories are authoritative; this file never is. A
todo (`bashy todo`) needs no sprint to exist; sprint work is tracked as
stories on the card. Every delivery commit carries the provenance trailers
(`Sprint:` / `Story:` / `Story-ID:`); the `commit-msg` hook is fail-closed.
Stories live in the committed `docs/todo/` store and carry their sprint as
`sprint_id` in frontmatter, so a sprint travels with the clone: another
host materializes its own card from the stories on the first verb that
names it (same uuid, local number). Sprint numbers are host-local labels;
the uuid is the identity.

Delivery and verification proportionate to the change: reuse passing
evidence tied to the candidate; one shared evidence record per candidate;
close a story as soon as its own criteria + relevant regression pass; use
the existing runners and acceptance commands — no bespoke verifiers that
establish no new fact; make owner, host (by role), blocker and remaining
checks explicit; an unresolved failure is never "fixed".

## Name

**`dhnt`** (spoken *dahenito*) is the canonical name of the whole — system +
language, all code/wire/repo/org identifiers. **Tessaro** (`tessaro.sh`) is
the hosted front door (portal, pooled-LLM gateway). **"The umbrella"** is
this repo. Subproject names are unchanged.

Vision: *a language + a system for turning the computers you already own
into one coherent, self-hostable, agent-operable mesh — pooled LLMs and
durable agentic fleets on your own models, cloud as a thin, replaceable
relay.* Build stack: **bash** (pure-Go foundation) → **weave** (git-isolated
workspace) → **p2p sphere / ollama sharding** → **k8s cluster**.

## Execution tiers

Six tiers, foundation → payoff (use the names precisely):

| # | Tier | Scope | Components (bashy verb) |
|---|------|-------|-------------------------|
| 1 | **userland** | single-node, native | **bashy** (bash + coreutils + agentic ext) |
| 2 | **workspace** | single-node, fs-isolated | weave · dag · loom · sdlc · sprint |
| 3 | **sandbox** | single-node, OCI container | `bashy oci` (`sandbox` alias; podman/docker hidden) |
| 4 | **sphere** | multi-node, peer-direct | p2p ollama routing/LB/sharding — `bashy sphere` (fronts outpost) |
| 5 | **cluster** | your machines, orchestrated | k8s/k3s/DKS — `bashy kubectl` / `helm` |
| 6 | **cloud** | hosted providers | `bashy aws` / `azure` / `gcloud` / `doctl` |

`sandbox` = podman only (a `weave` clone is a `workspace`); the peer pool is
`sphere`, never `cluster`; `cloud` = external hosted providers. Tier-5/6
CLIs come from a declarative registry; non-permissive provider CLIs are
never vendored.

## Layout

Fifteen submodules (`github.com/qiangli/<name>` unless noted), all flat
siblings. Module path may differ from the dir (`mvdan.cc/sh/v3 => ../sh`,
`github.com/bashsharp/bashsharp => ../bashsharp`,
`github.com/ergochat/readline => ../readline`).

```
appstore/          DKS app catalog — Helm chart pointers (github.com/dhnt/appstore)
bashsharp/         Bash# language front door: front · transpile · cmd (github.com/bashsharp/bashsharp; ENGINE stays in sh)
bashsharp-tests/   Bash# conformance gate: Go profile + POSIX-2016 suite (github.com/bashsharp/bashsharp-tests)
bashsharp-tour/    the Bash# tour + install-matrix CI (repo `tour`, github.com/bashsharp/tour)
bashy/             product — pure-Go Bash 5.3 drop-in CLI; consumes sh
bonsai/ gfy/       embedded DB and its dep (pulled by version; mounted for hacking)
coreutils/         the CERTIFIED POSIX package (116 POSIX names ∪ GNU coreutils); stable, bug fixes only
filebrowser/       File Browser fork; fbembed seam → outpost `files` builtin
nadir/             ycode dep
outpost/           home-host agent (bridge)
readline/          ergochat/readline fork; sh interactive dep
sh/                mvdan.cc/sh/v3 fork — the engine (+ Bash# evaluator/lower/gosource/polyglot/grammar)
ycode/             local agentic dev tool
yoke/              agentic userland — everything non-POSIX split out of coreutils; imports coreutils, never the reverse
docs/ script/      docs + todo store; gates and bootstrap
```

**Not here:** `cloudbox/` (the hosted control plane), `kg/`,
`vsc-pcts-harness-kit/` — proprietary, kept in a private superproject. No
`go.mod` in this tree path-replaces into them; nothing here needs them to
build. They are gitignored so a person with access can clone them beside
the others. Anything that touches the control plane's wire (matrix-tunnel
protocol, bearer scopes, fleet/LLM registries, sandbox provider, fleet
upgrade envelope, trace propagation) is done in the private superproject
where both sides sit together; this repo then receives a pin bump.

`.agents/`, `.claude/`, `.gfy-out/` are gitignored scratch, never canonical.

## Branches and CI

This umbrella and the public subprojects work on `main` directly. CI here is
the cheap umbrella lint (shell syntax + gitlink pins); the real gates run in
each subproject and on the release hosts.

## Submodule workflow — READ THIS

The umbrella pins **commit SHAs**. To change code in a submodule: `cd` into
it, edit + commit + push there, THEN `git add <subproject>` at the root and
commit the pin bump. A `git commit` at the root commits only the (unchanged)
pointer — the edits look lost on a fresh clone. `modified content` in root
`git status` means "finish the work inside that subproject". Never
`git add -A` at the root; other agents work the umbrella concurrently.

`script/sync.sh` pulls the default branch in each submodule, propagates
`.sibling-pins` in the consumers that carry one, and stages the bumps.
Commit message: `sync: bump submodule pins`, or `sync: bump <a> + <b> pins
(<why>)`.

Cleanup after a completed assignment is mechanical: remove a branch only
when it is an ancestor of `main`/`master` or `git cherry` proves every patch
integrated; stop a weave through its own lifecycle command, remove its
worktree only when clean, prune, then delete the proven branch. Leave
branches with unique commits alone and report them.

## Build & test

`script/bootstrap.sh` hydrates submodules (including `yoke`'s nested
`external/ollama/src` and `external/podman/src`, which `bashy`'s go.mod
path-replaces even for the lean build) and installs the git hooks. No
`go.work` or root Makefile — each `go.mod` is self-contained; every
cross-project dep is `replace … => ../<X>` (flat sibling, never nested).
Full reference: `docs/build.md`.

```bash
cd bashy    && make test && make test-bash # BOTH — test-bash 86/86 serial is the release gate
cd bashsharp && go test ./...
bashsharp-tests/harness/run.sh            # tests the BUILT ../bashy/bashy; TDD-first, red ≠ regression
cd outpost  && go test -short ./...       # internal/agent/shell needs a controlling TTY (hangs headless)
cd ycode    && go test -short ./...       # same for bonsai, sh, nadir, gfy
cd coreutils && go test ./...
cd yoke     && go test $(go list ./... | grep -v /external/)
```

Heavy suites run on a remote test host, never the dev box. Direction is
load-bearing: yoke imports coreutils, never the reverse.

## Subproject docs

Each subproject's `CLAUDE.md` is the source of truth for code inside it —
read it before non-trivial changes. Public-repo rule for every one of them:
no real hostnames, user ids or addresses; describe hosts by role.

## Umbrella docs

`docs/INDEX.md` — one line per doc. `docs/README.md` — the abstract per doc.
When you add a doc: abstract in `README.md`, one line in `INDEX.md`, nothing
here. Hard gate before conformance work: never run a foreign test suite
natively on a dev box (`docs/build.md` → Gotchas).
