---
id: 9eb29a501715
kind: feature
title: S4 Verify worker readiness before assignment
seq: 490
status: todo
priority: p1
labels:
    - group-productivity
    - fleet-autonomy
created: 2026-11-18T21:27:41.463835Z
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
---

Check the exact tool/model binding, credential state, required capabilities, execution venue and capacity before assignment. Report readiness reasons and freshness; distinguish installed from demonstrated usable. Reuse and link existing bound-model auth probe issue todo:5b3c245aae22 rather than duplicating it. Acceptance: unusable bindings are excluded or produce an actionable refusal before work launches; capability and capacity findings have evidence/freshness; checks respect existing account and spending permissions. Dependencies: S0.
