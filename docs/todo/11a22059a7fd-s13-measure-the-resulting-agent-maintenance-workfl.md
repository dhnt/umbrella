---
id: 11a22059a7fd
kind: test
title: S13 Measure the resulting agent maintenance workflow
seq: 92
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:58.055498Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S2-S9 and S11; document S10/S12 as design-only limitations. Extend existing agent-bench maintenance tasks to exercise checking, repair, contracts and policy failures.
Acceptance: compare Bash# with Bash and Go baselines using recorded model/tool/policy/candidate identities and controlled budgets. Report correctness, regressions, human intervention, tokens and total verification cost; retain raw evidence and distinguish repeat/follow-up runs from original experiments. No claim of superiority or equivalence from equal small-sample scores. Run costly campaigns on existing remote test infrastructure. Reuse existing benchmark machinery.
Planning-only creation; no benchmark workers or coding authorized by filing this story.
