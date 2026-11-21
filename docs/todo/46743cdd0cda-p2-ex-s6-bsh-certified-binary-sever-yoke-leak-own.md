---
id: 46743cdd0cda
kind: refactor
title: 'P2 (ex-S6): bsh certified binary - sever yoke leak, own core catalog, bsh entry, frozen digest'
seq: 556
status: todo
priority: p1
labels:
    - bashy
    - coreutils
    - yoke
    - architecture
created: 2026-11-20T10:01:53.955495Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repos: bashy, coreutils, yoke. Re-scoped to v3 P2; supersedes Sprint 575 S1/S1C. Cut the yoke/pkg/fleet import leak so the core catalog is owned without upper-layer imports: empty coreImportAllowlist in cmd/bashy/core_imports_test.go; bsh = Bash 5.3 + Bash# + POSIX-required coreutils, ZERO yoke packages; bsh entry point recognized. Gate: Bash 5.3 86/86 BOTH modes by fixture name on gate host/official image; record frozen bsh digest on this story (later changes need re-certification). Acceptance: TestCoreImportBoundary green with empty allowlist; bsh size + warm build time measured vs P1 baseline.
