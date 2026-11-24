---
id: 13b6214a0a79
kind: feature
title: G4 single-writer lease on the shared shaping draft
seq: 621
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-21T21:59:45.908351Z
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
---

Problem: when several humans or agents edit one shared shaping draft at once, two writers can apply conflicting steps. Behavior: an optional single-writer lease on the logical draft buffer (yoke/pkg/webconsole/shaped_draft.go session), held at the line authority with a fencing epoch; taken only when more than one writer is present (a single owner, even on several devices, needs none - compare-and-swap push from Sprint 689 D1 decides races); others keep editing the request text live and see each step land; UI shows who holds it; explicit logged override. Depends on Sprint 689 D1. Verification: unit tests for take, hand-off, stale-holder refusal, override.
