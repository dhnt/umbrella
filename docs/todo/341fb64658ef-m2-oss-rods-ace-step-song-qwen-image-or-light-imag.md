---
id: 341fb64658ef
kind: feature
title: 'M2 oss rods: ACE-Step song, Qwen-Image or light image model, Chatterbox/Kokoro narrate, WhisperX transcribe; pinned provisioning + disk preflight'
seq: 182
status: assigned
priority: p1
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:28.364915Z
weave: 18
assignee: muse-conductor
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md (open-source picks). Depends M1. Re-verify each LICENSE (permissive commercial only); weights on first use behind disk-headroom preflight; Mac host for these stages. Verify: one artifact per rod via bashy <verb> --route oss --json.

VENUE RULE (operator mb:13538, 2026-11-13): this dev host is the operator's primary workstation. NO model/weight downloads and NO live model, ollama or podman runs here. Keep M2 to code + stubbed/fixture unit tests: provider records, the requires/has= unavailable path, disk-headroom preflight logic, and the bashy-svc-v1 envelope (fake model stand-ins, pattern MEDIA_VOICE_PY in examples/media/test.sh). Re-verify each LICENSE. Defer real weight downloads and live oss renders ('bashy <verb> --route oss --json') to a claimed test host (elephant or a droplet), recorded as a remaining check. Contract: bashy docs/service-rod-contract.md (M1).
