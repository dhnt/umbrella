---
id: 68dba07e6977
kind: refactor
title: S5 Complete physical Bash and Bash# engine separation
seq: 28
status: todo
priority: p1
labels:
    - layer-separation
created: 2026-11-06T21:04:32.06735Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

The operator moved full relevant engine separation into Sprint 575, including evaluator and parser previously deferred to 581. Minimum necessary changes; exact design independently reviewed before coding. Canonical homes qiangli/bash and bashsharp/bashsharp, dependency Bash <- Bash#. Move sh source into the Bash home and retire qiangli/sh references; owned fork permitted if needed; no external upstream tracking requirement. Preserve released semantics and test expectations; fixed accepted lower pins and independent fresh-checkout build/test gates in official image. Private parser/Runner coupling is documented in docs/s575-separation-review.md. No naive move or huge accessor interface assumed.
