---
id: cd3092bf0b83
kind: task
title: 'B1 Phase B harness: spec-only workspace, isolated agent run, snapshot + grade with conform'
seq: 763
status: todo
priority: p2
labels:
    - conform
created: 2026-11-25T21:22:19.575687Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

agent-bench pack packs/shapeware/t5-spec-to-source: setup builds a fresh workspace with only CONTRACT.md, SKILL.md, features.yaml and TASK.md (sha256 recorded); runs one subject binding with a 30 min cap; snapshots + hashes the workspace at agent end; grades the snapshot in a separate sandbox through bashy conform (visible contract, hidden cases supplied at grade time from outside the workspace, UI inventory + interactions + JSON API); writes the per-run record (verdicts per layer + accounting per protocol). Controls: reference x3, null candidate. Venue: gate host lane.

Protocol: umbrella docs/conform-phase-b-protocol.md (fixed before runs). Depends on Phase A (A3-A7).
