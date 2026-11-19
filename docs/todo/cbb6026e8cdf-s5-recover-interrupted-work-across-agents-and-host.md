---
id: cbb6026e8cdf
kind: feature
title: S5 Recover interrupted work across agents and hosts
seq: 491
status: done
priority: p1
labels:
    - group-productivity
    - fleet-autonomy
created: 2026-11-18T21:27:41.998064Z
weave: 87
assignee: codex-gpt6-astra
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
closed: 2026-11-19T08:07:38.095465Z
closed_by: s666-codex-manager
---

Compose existing continuity records, workspaces, task identities and ownership mechanisms to transfer candidate identity, changed files, verification evidence, pending decisions and next safe steps to a replacement. Acceptance: concurrent ownership is prevented; recovery after agent death and host interruption preserves work and source identity; uncertain external effects are reconciled before retry; cancellation and pending approvals remain visible. Portable vendor session state is not required and a task identifier alone is not treated as proof of exactly-once external effects. Dependencies: S0; coordinate with S4.
