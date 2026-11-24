---
id: 47a76966edf4
kind: feature
title: 'Follow-up: a finer role as a field on the one audience rule (replaces G2 item path and role on share)'
seq: 577
status: todo
priority: p3
labels:
    - group-shaping
created: 2026-11-20T21:42:54.605828Z
---

Unlinked from Sprint 684 on 2026-11-24. As written, G2 extended bashy share add|ls|rm|who with an item path and a role; those verbs call the hosted relationship API (yoke/pkg/fleet/share_grant_cmd.go), which Sprints 684/685 must not change, and a per-app role would be a second group model beside the roster Klatch and Page already share (owner and member). If a finer role is needed later it is one field on the audience rule, for every app at once, planned as its own hosted-plane story. Not scheduled. Plan: docs/sprint-684-685-master-execution-plan.md.
