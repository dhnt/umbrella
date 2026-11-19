---
id: f9e4868ddaf2
kind: bug
title: Repair resource identity and claim handle review findings
seq: 530
status: assigned
priority: p0
created: 2026-11-19T12:08:51.203686Z
weave: 101
assignee: codex-gpt6-sol
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

Repair the submitted Sprint 666 #524 candidate in preserved run95 nested worktrees: Yoke b671b0a2 + 62ec5abf, Bashy 03541f71. Do not restart from scratch or push/pin. Preserve original worker commits and commit your rework with your own truthful Agent trailer. Review findings: (1) mutable canonical claim name strands live leases on rename; use immutable persisted identity or safe atomic refusal/migration and test acquire, wait, refresh, release, queue, attached continuity; (2) numeric/hex resource names/aliases can be mistaken for seq/UUID and select wrong target, refuse ambiguous input; (3) qualified remote parent/seq must resolve within parent while bare foreign seq refuses; (4) set/rm must accept same UUID/scoped slug/seq handles as show; (5) Bashy registry test assumes obsolete local/build-seat instead of persisted local/store UUID; (6) concurrent legacy mint and actual CLI JSON roundtrip regressions. Keep manager #523 physical Address fix distinct; merge it later after review. Focused tests, three-OS touched-package vet. Report exact nested SHAs, tests and risks. No shared checkout, no private host data.
