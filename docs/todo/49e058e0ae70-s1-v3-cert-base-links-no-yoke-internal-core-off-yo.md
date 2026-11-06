---
id: 49e058e0ae70
kind: refactor
title: 'S1 V3: cert base links no yoke (internal/core off yoke/pkg/fleet)'
seq: 24
status: todo
priority: p0
labels:
    - layer-separation
created: 2026-11-06T21:04:31.553118Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Problem: -tags bashy_cert_base ./cmd/bashy links 21 qiangli/yoke packages incl. telemetry and cloud providers via bashy/internal/core -> yoke/pkg/fleet. Change: move what internal/core needs into a dependency-free leaf package. Exit: GOWORK=off go list -deps -tags bashy_cert_base ./cmd/bashy shows 0 yoke packages; S0 allowlist entry removed; make test green. Plan: docs/plan-s575-master-execution.md
