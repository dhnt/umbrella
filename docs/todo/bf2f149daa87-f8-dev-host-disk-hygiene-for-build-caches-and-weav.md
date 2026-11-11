---
id: bf2f149daa87
kind: chore
title: F8 Dev-host disk hygiene for build caches and weave/grade checkouts
seq: 129
status: todo
priority: p3
labels:
    - collaboration-followup
created: 2026-11-11T09:56:33.048261Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Sprint 614 ran the dev host to 0 bytes free (Go build cache 65 GB, temp 41 GB, grade attempts and weave workspaces). Add a bashy-visible check and a safe, age-based reclaim verb (go-build cache trim, stale go-build temp dirs, grade attempts of ended sprints, workspaces of merged/abandoned runs) with --dry-run and --json; never touch other agents' live work.
