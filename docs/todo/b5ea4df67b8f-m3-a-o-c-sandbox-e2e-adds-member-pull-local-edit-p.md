---
id: b5ea4df67b8f
kind: test
title: M3 A/O/C sandbox e2e adds member pull, local edit, push, owner approves
seq: 730
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T22:59:40.112255Z
assignee: codex-gpt6.2-astra
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
closed: 2026-11-25T00:15:30.866976Z
closed_by: claude-opus5.5
---

Extend the Sprint 706 A/O/C sandbox e2e (bashy tests/group-shaping-e2e, dag target test-group-shaping-e2e, official image, fake accounts, stub agent) with the member pull/push path: C calls shape_pull through <mount>/mcp, edits the returned source locally inside the container, calls shape_push with the patch and the pulled revision; the candidate is verified on O's host; O approves; history credits C; the served site switches version. A second push on the now-stale revision is refused naming both revisions. A member without the shape scope, an account and an anonymous caller are refused shape_pull and shape_push. Existing 44 checks stay green. The satellite token exchange is covered by M1's unit tests (the satellite is private), not by this sandbox.
Acceptance: green twice on the gate host (claim it), raw logs kept; depends on M1 and M2.
