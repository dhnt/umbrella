---
id: ec0a696b907c
kind: enhancement
title: 'S2: Strip symbol table (-s -w) on non-Linux cmd/bashy builds (-20.4 MB on Darwin)'
seq: 552
status: assigned
priority: p1
labels:
    - build
    - bashy
created: 2026-11-20T10:01:53.41457Z
weave: 136
assignee: genie-glm-5.3
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. Kept under v3, applies to EVERY binary (bsh, bashy, per-command slot builds). Pass -s -w when GOOS != linux (dag build path + scripts/build-bashy-artifact.sh + slot builder), keep -w only on linux (SHT_SYMTAB/runtime.fwdSig). Acceptance: Darwin size drop ~20.4 MB on monolith-era binary (re-measure per binary class after P2); elfaudit --bashy-signal, releaseeligibility, bashysignalprobe pass on Darwin + Linux ELF artifacts.
