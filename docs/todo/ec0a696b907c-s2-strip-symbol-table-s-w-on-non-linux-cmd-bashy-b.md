---
id: ec0a696b907c
kind: enhancement
title: 'S2: Strip symbol table (-s -w) on non-Linux cmd/bashy builds (-20.4 MB on Darwin)'
seq: 552
status: todo
priority: p0
labels:
    - build
    - bashy
created: 2026-11-20T10:01:53.41457Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. Linux ELF cmd/bashy requires SHT_SYMTAB (runtime.fwdSig), so BASHY_LDFLAGS currently omits -s everywhere. Darwin and Windows use bashy_runtime_snapshot / debug/buildinfo and do not use ELF SHT_SYMTAB. Pass -s -w on GOOS != linux in Makefile, scripts/build-bashy-artifact.sh, and Darwin/Windows release scripts while keeping -w on GOOS == linux. Acceptance: Darwin bin/bashy shrinks by ~20.4 MB (241.7 MB -> 221.3 MB); tools/elfaudit --bashy-signal, releaseeligibility, and bashysignalprobe pass on Darwin and Linux ELF artifacts. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
