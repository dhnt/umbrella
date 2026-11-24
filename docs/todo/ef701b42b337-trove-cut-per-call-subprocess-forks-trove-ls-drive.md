---
id: ef701b42b337
kind: enhancement
title: 'trove: cut per-call subprocess forks (trove ls /drive ~25 bashy jq calls, ~4 s CPU) — the hosted capacity limit'
seq: 707
status: todo
priority: p2
created: 2026-11-24T16:20:20.287477Z
---

Sprint 691 H5 (2026-11-24): the 4-tool MVP mix is bounded by trove at 6.6 req/s on the pilot (4,081 ms CPU per call) versus ~51 req/s without trove. Profile trove.bsh: resolve the layout once per call and do JSON shaping in one jq pass or in Bash# natively. Accept: trove ls /drive CPU per call reduced at least 5x on the hosted-runner load mode, rows unchanged (bashy-node-v1 validation).
