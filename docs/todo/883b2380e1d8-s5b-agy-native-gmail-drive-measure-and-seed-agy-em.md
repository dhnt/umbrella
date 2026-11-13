---
id: 883b2380e1d8
kind: feature
title: 'S5b agy native Gmail/Drive: measure and seed agy email.read / drive.read (read-only)'
seq: 192
status: done
priority: p1
created: 2026-11-13T01:09:34.366409Z
weave: 25
assignee: agy-gemini3.8-flash
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
closed: 2026-11-13T02:11:20.051128Z
closed_by: claude-opus5.5-s626
---

Spec: docs/sprint-626-master-execution-plan.md (S5 lane: agy-gemini3.8-flash explores native Google access). Operator 2026-11-12: agy is Google's CLI, so measure its native Gmail/Drive access properly. Measure on the wire, READ-ONLY: list/search only, count or ids only, nothing sent, drafted, shared, created or deleted. No --dangerously-skip-permissions or any bypass; use an exec: override (like agy:plan / agy:pdf) with the narrowest agy mode that still reads. Seed as dotted roles email.read / drive.read (never bare email/drive; the selector refuses read-only commands for *.send / *.write). If agy cannot reach Gmail/Drive headlessly, record command, exit and output instead of seeding. Dated # MEASURED comment with agy version and elapsed. Base on yoke origin/main; verify bashy email|drive --provider agy:email.read|agy:drive.read --json; commit with Sprint/Story/Story-ID and Agent: agy-gemini3.8-flash; do not push.
