---
id: 98f5050d8378
kind: doc
title: T4 short report of the trip and a kb runbook for the operate stages
seq: 799
status: assigned
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:56:52.257229Z
assignee: claude-fable5.2
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
---

Report: stage by stage, who did it, the gate, the result and the band; limitations. Runbook: how an agent takes a shapeware folder from build to a running command or service, with the traps found in T2. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip' (operator 2026-11-26). Reuse agent-bench packs/spec2src with venue/, the Sprint 723 grader and kb runbook spec-to-source-drill. Operator review before start.

## Done (conductor, 2026-11-26)

- Report: `docs/sprint-731-report.md` (stage table with who, gate, result and band; what was built; every run; seven findings; limits; what comes next), with its line in `docs/INDEX.md` and abstract in `docs/README.md`.
- The stage states of `docs/shapeware-workflow-standard.md` (stages 4 to 7) now cite the report.
- Runbook: kb page `shapeware-operate-from-dag` (added with `bashy kb add`, status candidate): the steps, the gates, and the six traps found in this sprint.
