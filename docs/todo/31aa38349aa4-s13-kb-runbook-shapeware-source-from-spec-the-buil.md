---
id: 31aa38349aa4
kind: doc
title: 'S13 kb runbook shapeware-source-from-spec: the builder''s guide (forward)'
seq: 780
status: done
priority: p1
labels:
    - shaping
created: 2026-11-26T05:33:12.033028Z
assignee: claude-opus5.5
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: sound spec, validator, minimal model, judge band'
closed: 2026-11-26T11:19:35.411919Z
closed_by: claude-opus5.5
---

Operator 2026-11-25. A bashy kb runbook a builder agent follows to write source from a shapeware spec:
- read the rules sections first and treat every stated rule as a requirement;
- implement every assertion and acceptance line;
- for every stated input format, implement it or report it as unsupported, never silently drop it (the Sprint 722 finding);
- UI: the accessible inventory rules;
- the self-check loop: conform run CONTRACT.md until clean;
- the deliverable layout and the launcher;
- report what was implemented, against the feature ids.
NOT given to Sprint 723 subjects (it would change the measured condition); its effect is the next iteration's measured variable.

Plan: umbrella docs/plan-spec2src-calibration.md and docs/shapeware-qualification-process.md (system view).
