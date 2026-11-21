---
id: 622ea2bc2803
kind: task
title: 'bashy fmtcheck is red: 51 tracked .go files have unsorted import groups after the qiangli/sh to qiangli/bash module path move'
seq: 614
status: todo
created: 2026-11-21T20:53:09.129787Z
---

Found while delivering Sprint 660 R4 (bbd047d08c53), which added
`bashy dag --makefile --check` to bashy's `fmtcheck` target. **Pre-existing and
unrelated to R4** — R4 changed no `.go` file, and `scripts/fmtcheck.sh` reads
only tracked `.go` files. Recorded here rather than repaired, per the
root-cause-before-fix rule.

Root cause (classified: **product/source defect**, not venue): `gofmt -l` on
the tracked set reports 51 files whose import blocks are no longer sorted,
because the `mvdan.cc/sh/v3` -> `github.com/qiangli/bash/...` module path move
renamed import paths in place without re-sorting the group. Example
(`internal/agentos/limit.go`): `github.com/qiangli/bash/interp` sorts before
`github.com/qiangli/yoke/pkg/atlas`, but sits after it.

Venue checked: gofmt 1.27.4 (matches the repo's Go baseline, go1.27.4);
import-group sorting is version-independent, so this is not a toolchain
artifact.

Repair is mechanical but must NOT be a blind `gofmt -w` sweep:
`scripts/fmtcheck.sh` exists precisely because gofmt also rewrites
doc-comment text (an ASCII single-quote pair becomes a curly closing quote,
which has already corrupted `tools/bash53suite/main.go`). Read the diff per
file, take the import reordering, and reject any doc-comment text change.
