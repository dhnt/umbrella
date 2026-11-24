---
id: 02c94743e789
kind: feature
title: D2 rebase and re-verify local candidates on pull
seq: 616
status: wontfix
priority: p1
labels:
    - shaping
created: 2026-11-21T21:59:33.050638Z
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
closed: 2026-11-24T18:16:00.443245Z
---

Problem: when a pull moves the line, local candidates and the active version must not silently diverge. Behavior: replay local candidates onto the new line, re-run the verifier (yoke/pkg/shape/verify); conflicts or failures become failed and never activate; last known good is kept; a change already on the line replays empty and drops out. Verification: unit tests for clean rebase, conflict, verify failure, empty replay. Depends on D1.

## Closed won't do 2026-11-24

Operator decision 2026-11-24: covered by the single-venue model. The shaping line lives on the app's host; a second device of the same owner shapes it remotely (site MCP owner tools, gateway run shape), the same path as a granted member. No per-device line, push or offline merge. The rebase-and-re-verify rule is carried into Sprint 706 R5. Retired as wontfix, not delivered.
