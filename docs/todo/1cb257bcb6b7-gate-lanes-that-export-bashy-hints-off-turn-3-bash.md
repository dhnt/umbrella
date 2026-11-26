---
id: 1cb257bcb6b7
kind: bug
title: Gate lanes that export BASHY_HINTS=off turn 3 bashy hint-asserting tests red (venue)
seq: 745
status: wontfix
priority: p3
labels:
    - test
    - venue
created: 2026-11-25T07:22:20.230854Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
closed: 2026-11-26T11:15:45.243019Z
---

Seen 2026-11-25 by the 709 pin round on gate lane 2 (run 264): 3 bashy tests that assert hint output fail only because the lane wrapper exports BASHY_HINTS=off; they pass with it unset on the same candidate b8cce989. Classification: environment (lane wrapper). Fix in the venue: unset BASHY_HINTS in the gate lane, or have those tests clear it in their own env. Release gates run with it unset meanwhile.
