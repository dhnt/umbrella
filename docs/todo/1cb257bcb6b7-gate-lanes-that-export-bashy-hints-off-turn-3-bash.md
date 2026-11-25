---
id: 1cb257bcb6b7
kind: bug
title: Gate lanes that export BASHY_HINTS=off turn 3 bashy hint-asserting tests red (venue)
seq: 745
status: todo
priority: p3
labels:
    - test
    - venue
created: 2026-11-25T07:22:20.230854Z
sprint: 713
sprint_id: 867b4689-21ed-53db-93f9-b2a926b28de6
sprint_title: 'Known reds triage after train 1: decide fix or won''t do for each pre-existing test red'
---

Seen 2026-11-25 by the 709 pin round on gate lane 2 (run 264): 3 bashy tests that assert hint output fail only because the lane wrapper exports BASHY_HINTS=off; they pass with it unset on the same candidate b8cce989. Classification: environment (lane wrapper). Fix in the venue: unset BASHY_HINTS in the gate lane, or have those tests clear it in their own env. Release gates run with it unset meanwhile.
