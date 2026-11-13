---
id: f9f0bc10abb0
kind: task
title: 'S11 no-phone-home gate: run script/no-phone-home.sh on every fork; remove third-party telemetry, replace with bashy OTel'
seq: 219
status: done
priority: p1
labels:
    - shaping
created: 2026-11-13T12:18:16.147096Z
assignee: claude-fable5.1-s632
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:47:16.284181Z
closed_by: claude-fable5.1-s632
---

Conductor gate (phase 1 of Sprint 632) before accepting any delivery that touches a fork (S4b board, S5b whiteboard, S2c files, and the parity stories A2-A5): script/no-phone-home.sh <app dir> must have zero unexplained hits, plus a runtime check on the gate venue that the app makes no unexpected outbound connections. Third-party telemetry, analytics and update checks are removed, not disabled; bashy OTel (env-gated OTLP to the owner's store, W3C propagation; pattern filebrowser/telemetry) replaces them where useful. Rules: docs/shapeable-apps-worker-brief.md.

Run the gate with the fixed script from origin/main (or PATH=/usr/bin:/bin); an older copy fails open. Record the gate output on each accepted story. Deferred to phase 2: registering the gate as a bashy custom command (bashy commands add).
