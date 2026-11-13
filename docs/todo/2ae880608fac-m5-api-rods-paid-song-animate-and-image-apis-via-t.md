---
id: 2ae880608fac
kind: feature
title: 'M5 api rods: paid song, animate and image APIs via toolcmd mode: http with vault-bound keys'
seq: 185
status: assigned
priority: p2
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:28.813095Z
assignee: codex-gpt6-sol
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md. Depends M1. Effects include spend; --yes required; --dry-run prints cost class without calling.

SPEND/VENUE RULE (conductor, 2026-11-13): tests stub the HTTP layer (fixture responses, no network); never commit or print a key (vault-bound only). No paid API call without operator consent: a live call needs --yes AND is limited to ONE minimal-cost smoke per rod, recorded with its cost in the submit; otherwise leave the live smoke as a remaining check. No model downloads or live model/ollama/podman runs on this dev host (operator mb:13538). Contract: bashy docs/service-rod-contract.md (M1).
