---
id: 66e822f9a288
kind: feature
title: D3 offline work and reconnect catch-up across OSes
seq: 617
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-21T21:59:33.220193Z
sprint: 689
sprint_id: e1b53489-0d6c-5b8e-bd21-da802e2684fa
sprint_title: 'Shaping sync: one owner, many devices'
---

Problem: a device that cannot reach the line authority must keep working. Behavior: shaping works locally while offline; on reconnect pull + rebase (D2) run automatically and report the result; identical on macOS, Linux and native Windows (fail, never degrade). Verification: unit tests with an unreachable authority; final integration pass on the fleet test hosts. Depends on D1, D2.
