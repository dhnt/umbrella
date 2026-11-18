---
id: 16b92ae5073f
kind: enhancement
title: Bring bashy's own commands to the command contract where the checker found gaps
seq: 459
status: todo
priority: p3
labels:
    - yoke
created: 2026-11-18T17:30:03.346948Z
---

Found by examples/command-check (yoke dab16d1e) on 2026-11-18; recorded in yoke/docs/command-contract.md change log. Conformance is optional; this is follow-up work, ideally done by shaping. Gaps: C11 'bashy sprint show --json', 'bashy todo list --json', 'bashy shape wish|verify --json' print their own JSON shapes, not the envelope; C7 'bashy todo list --dry-run' exits 1 (should be 0 or 2); C12 bashy-hint-v1 records still print with BASHY_HINTS=off exported, and bashy-recommend-v1 is not silenced by it. Re-check each with 'bashy command-check -- bashy CMD ...'.
