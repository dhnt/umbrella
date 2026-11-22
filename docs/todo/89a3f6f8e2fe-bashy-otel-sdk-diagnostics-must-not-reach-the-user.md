---
id: 89a3f6f8e2fe
kind: task
title: 'bashy: OTel SDK diagnostics must not reach the user''s stderr; validate endpoint form at startup'
seq: 426
status: wontfix
priority: p2
created: 2026-11-17T19:25:28.957421Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-22T13:41:44.22786Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 656 ended): not critical for the next release, which is v1.0.0-rc.40 under Sprint 692 (docs/plan-sprint-692-release-thin-bashy.md). Re-file if rc.40 reproduces it.

Product half of outpost todo c84bb044: when an inherited OTEL_EXPORTER_OTLP_ENDPOINT is unusable, bashy prints SDK parse/export errors on every command. Route SDK diagnostics to the bashy log; warn once. FROZEN until v1.0.0-rc.37 is promoted (no bashy change during the release). Regression test required.
