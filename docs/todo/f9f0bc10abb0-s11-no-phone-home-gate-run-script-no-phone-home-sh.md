---
id: f9f0bc10abb0
kind: task
title: 'S11 no-phone-home gate: run script/no-phone-home.sh on every fork; remove third-party telemetry, replace with bashy OTel'
seq: 219
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-13T12:18:16.147096Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

Conductor gate before accepting any S3-S10 or S2b delivery: script/no-phone-home.sh <app dir> must have zero unexplained hits, plus a runtime check that the app makes no unexpected outbound connections. Third-party telemetry, analytics and update checks are removed; bashy OTel (env-gated OTLP to the owner's store, W3C propagation; pattern filebrowser/telemetry) replaces them and is added where useful. Rules: docs/shapeable-apps-worker-brief.md. Next: register the gate as a bashy custom command (bashy commands add).
