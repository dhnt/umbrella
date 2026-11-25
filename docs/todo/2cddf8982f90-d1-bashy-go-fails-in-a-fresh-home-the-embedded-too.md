---
id: 2cddf8982f90
kind: bug
title: 'D1 bashy go fails in a fresh HOME: the embedded toolchain/go adapter has no sources to build its launcher'
seq: 746
status: todo
priority: p1
labels:
    - toolchain
    - shaping
created: 2026-11-25T07:27:06.908357Z
sprint: 714
sprint_id: 3e487908-1ba5-5dc0-85ae-41a6833869d5
sprint_title: 'A/O/C on Page: bashy go in a fresh HOME, then the Page leg (709 follow-up)'
---

Found by Sprint 709 M4 (6ba1b4777931), 2026-11-25. Pre-existing; not caused by 709.

Root cause (conductor, code + repro): `bashy go` dispatches to the embedded adapter toolchain/go/go.bsh (bashy internal/agentos/agentos.go `case "go"` -> runCommandAdapter). On first use go.bsh compiles its launcher from main.go + go.mod beside it into ${BASHY_ADAPTER_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/bashy/adapters}/toolchain/go. The adapter embed carries only .bsh scripts by design (bashy internal/agentos/adapterembed/sync.go:28; embed.go:18), so in a fresh HOME the materialized directory holds go.bsh alone and the build fails ("go: go.mod file not found" / "no Go files"). It works only where an earlier source-tree build left a compiled launcher in the adapter cache.
Repro (dev box, Go already cached, no network): HOME=$(mktemp -d) BASHY_BIN_CACHE=<host binmgr cache> bashy go version -> go: go.mod file not found.
Impact: every shape verifier check that runs `bashy go` fails (checks always get a fresh HOME), so a shaped Go app (examples/desk/page) cannot pass its verifier under A/O/C on any host; likely also a user's first `bashy go` on a fresh install (to confirm on a released binary). Other embedded toolchain adapters with a main.go may share it (audit).
Options discussed with the operator (decision deferred, 2026-11-25: "come up with the right solution later"):
- In-process fallback: when main.go is absent, go.bsh execs the linked path `BASHY_ADAPTER_INPROC=1 bashy go` (gotoolchain.NewGoCmd is already in the binary); no network, no compile.
- Embed the adapter's main.go/go.mod (touches the embed sync rules; known red 01b745b8 there).
- Fetch the adapter source on demand: needs network exactly where it fails (offline checks); not recommended.
Acceptance: operator picks the design; fix + a fresh-HOME unit/integration test on the gate host; then 714's M4 Page leg runs.
