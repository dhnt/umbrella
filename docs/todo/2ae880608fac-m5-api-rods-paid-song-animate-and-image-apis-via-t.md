---
id: 2ae880608fac
kind: feature
title: 'M5 api rods: paid song, animate and image APIs via toolcmd mode: http with vault-bound keys'
seq: 185
status: done
priority: p2
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:28.813095Z
weave: 26
assignee: codex-gpt6-sol
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
closed: 2026-11-13T02:18:57.03586Z
closed_by: claude-opus5.5-s627
---

Spec: docs/sprint-627-master-execution-plan.md. Depends M1. Effects include spend; --yes required; --dry-run prints cost class without calling.

SPEND/VENUE RULE (conductor per operator mb:13557, 2026-11-13): tests stub the HTTP layer (fixture responses, no network); --dry-run prints the cost class. Never commit or print a key (vault-bound only). Make NO paid API call and never pass --yes yourself: a live paid smoke is a remaining check for the operator to approve - record it in the submit. No model downloads or live model/ollama/podman runs on this dev host (mb:13538). Contract: bashy docs/service-rod-contract.md (M1).
