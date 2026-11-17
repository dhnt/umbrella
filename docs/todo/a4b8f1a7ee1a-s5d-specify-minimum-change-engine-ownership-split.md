---
id: a4b8f1a7ee1a
kind: spike
title: S5D Specify minimum-change engine ownership split without upstream constraints
seq: 453
status: assigned
priority: p0
labels:
    - layer-separation
created: 2026-11-17T21:57:03.382068Z
assignee: s575-split-design
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Operator requires full physical three-product separation and standalone build/test with fixed lower versions. Updated authorization: minimum necessary changes, including necessary structural seams; new owned fork permitted if needed, external upstream tracking/merge compatibility not required. Use existing product homes qiangli/bash, bashsharp/bashsharp, qiangli/bashy. Read docs/s575-separation-review.md and current master plan. Specify exact package ownership and Go module graph; compare smallest local parser/runtime seam to an owned fork. No runtime duplication by default, no wholesale rewrite or feature/bug fixes, no test weakening. Deliver decision-complete function/type interface changes, move map, dependency/pin order and named unchanged-suite checks; explain why each changed Classic site is necessary. Read-only design only; independent review before coding.
