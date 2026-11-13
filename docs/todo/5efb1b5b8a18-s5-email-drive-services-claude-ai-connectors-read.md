---
id: 5efb1b5b8a18
kind: feature
title: 'S5 email/drive services: claude.ai connectors (read-only default), bashy google provider, agy native exploration'
seq: 178
status: done
priority: p1
labels:
    - vendor-services
created: 2026-11-12T23:18:14.648291Z
weave: 16
assignee: claude-opus5.5
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
closed: 2026-11-13T01:06:56.414064Z
closed_by: claude-opus5.5-s626
---

Spec: docs/sprint-626-master-execution-plan.md. Depends F,S0. claude -p restricted to Gmail/Drive connector read tools; send/write variants declare effects + confirm. Register bashy google (gws) as provider. agy-gemini3.8-flash explores native Google access. Verify: read-only search/list smokes; nothing sent or shared.

Conductor constraints (2026-11-12, after F/S1/S6): (1) providerselector now matches a dotted role to a tool command by its head (email.send -> email), so do NOT seed one "email" command for both read and send: seed read-only commands only (e.g. role email.read / drive.read) and keep any send path a separate command with the send effect so --yes gates it; add a selector test proving email.send never selects a read-only command. (2) Never use --dangerously-skip-permissions or any yolo flag: the uncontained-host guard refuses the default launch; use an exec: override like claude:plan/agy:plan. (3) Base on yoke origin/main and bashy origin/main; commit with Sprint/Story/Story-ID and Agent: claude-opus5.5 trailers; do not push.
