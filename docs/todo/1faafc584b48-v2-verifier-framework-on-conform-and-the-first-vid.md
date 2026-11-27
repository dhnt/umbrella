---
id: 1faafc584b48
kind: feature
title: V2 verifier framework on conform and the first video verifier
seq: 845
status: todo
priority: p1
labels:
    - sgi
created: 2026-11-27T20:13:40.108659Z
sprint: 740
sprint_id: b85ffe97-1e8c-56cf-90f2-fefca3e0885d
sprint_title: 'SGI: bashy commands as a service, per call, for credits (on Sprint 739 offers)'
---

Plan: docs/sprint-740-master-execution-plan.md §3.2, §5 V2. Verifiers are conform contracts per artifact kind (shared check library per plan §3.5, reused by transcribe, dub and later kinds), packaged as named bashy commands; checks as their own commands: ffprobe (duration, resolution, fps, codec), EBU R128 loudness, black/silence detection, captions present and in sync, transcript WER vs script, spec scene coverage. Deterministic verdict with pinned thresholds; LLM/vision judge advisory only unless the offer opts in (pinned model, majority of 3). Measure strength with conform's mutation harness. Accept: fixture videos pass/fail as expected, identical verdicts across two runs. Code inspected 2026-11-27: yoke pkg/broker audit.go peerlimit.go broker.go, pkg/feed sign.go key.go, pkg/fleet commands.go command_schema.go cloudboxfake/, pkg/binmgr sigstore.go, conform/ README + contract runner, appstore/ (categories.yaml, apps/<id>/); depends on Sprint 739 K1-K4 (not yet built).
