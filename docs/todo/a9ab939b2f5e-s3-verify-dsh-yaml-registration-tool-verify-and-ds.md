---
id: a9ab939b2f5e
kind: test
title: S3 Verify dsh.yaml registration, tool verify, and dsh --dump-config smoke checks
seq: 78
status: done
priority: p1
labels:
    - fleet
    - cli
    - test
created: 2026-11-10T15:56:59.713308Z
assignee: agy-gemini3.8-flash
sprint: 608
sprint_id: 409cb1b5-7378-5651-8937-ba149e395500
sprint_title: Add dsh custom agent CLI example and document agentic CLI support
closed: 2026-11-10T18:15:58.776726Z
closed_by: agy-gemini3.8-flash
---

Verify bashy tool add, bashy tool show dsh, bashy tool verify dsh, and validate generated cordis.patch.yml overlays against dsh (--profile headless --dump-config and --profile acp --dump-config) in both gateway (base_url set) and native (base_url empty) modes.
