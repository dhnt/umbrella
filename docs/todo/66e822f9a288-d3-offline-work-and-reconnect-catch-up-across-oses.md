---
id: 66e822f9a288
kind: feature
title: D3 offline work and reconnect catch-up across OSes
seq: 617
status: wontfix
priority: p2
labels:
    - shaping
created: 2026-11-21T21:59:33.220193Z
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
closed: 2026-11-24T18:16:07.962666Z
---

Problem: a device that cannot reach the line authority must keep working. Behavior: shaping works locally while offline; on reconnect pull + rebase (D2) run automatically and report the result; identical on macOS, Linux and native Windows (fail, never degrade). Verification: unit tests with an unreachable authority; final integration pass on the fleet test hosts. Depends on D1, D2.

## Closed won't do 2026-11-24

Operator decision 2026-11-24: covered by the single-venue model. The shaping line lives on the app's host; a second device of the same owner shapes it remotely (site MCP owner tools, gateway run shape), the same path as a granted member. No per-device line, push or offline merge. The rebase-and-re-verify rule is carried into Sprint 706 R5. Retired as wontfix, not delivered.
