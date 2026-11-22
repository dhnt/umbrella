---
id: ec0a696b907c
kind: enhancement
title: 'S2: Strip symbol table (-s -w) on non-Linux cmd/bashy builds (-20.4 MB on Darwin)'
seq: 552
status: wontfix
priority: p1
labels:
    - build
    - bashy
created: 2026-11-20T10:01:53.41457Z
assignee: genie-glm-5.3
sprint: 692
closed: 2026-11-22T13:41:41.515866Z
---

WONTFIX (operator rescope 2026-11-22, Sprint 692 plan docs/plan-sprint-692-release-thin-bashy.md): not required to release v1.0.0-rc.40 as the thin bashy core + shapeable commands. Size nice-to-have; the thin core makes it moot for now. Reopen with the per-command module sprint.

Repo: bashy. Kept under v3, applies to EVERY binary (bsh, bashy, per-command slot builds). Pass -s -w when GOOS != linux (dag build path + scripts/build-bashy-artifact.sh + slot builder), keep -w only on linux (SHT_SYMTAB/runtime.fwdSig). Acceptance: Darwin size drop ~20.4 MB on monolith-era binary (re-measure per binary class after P2); elfaudit --bashy-signal, releaseeligibility, bashysignalprobe pass on Darwin + Linux ELF artifacts.
