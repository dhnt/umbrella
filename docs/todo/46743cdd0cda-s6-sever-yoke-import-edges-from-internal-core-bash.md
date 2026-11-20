---
id: 46743cdd0cda
kind: refactor
title: 'S6: Sever yoke import edges from internal/core (bashy_core ~29 MB, <1s build) and wire bsh entry point'
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

Repos: bashy, coreutils, yoke. Empty coreImportAllowlist in cmd/bashy/core_imports_test.go by decoupling internal/core/commands.go from yoke/pkg/fleet's heavy transitive graph (telemetry, provider, room, secrets, appserver). Add bsh as a recognized Bash#-default entry point alongside bash, sh, and bashy. Acceptance: TestCoreImportBoundary passes with an empty allowlist; cmd/bashy -tags bashy_core links zero yoke packages, builds in <1s warm to ~29 MB, and serves Bash 5.3 + Bash# + --source=go + 116 in-process POSIX Coreutils. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
