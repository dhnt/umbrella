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

## Outcome
Measure the resulting maintenance workflow using existing agent-bench machinery.

Dependencies: S2-S9 and S11. S10/S12 are design-only limitations, not implemented benefits.

## Acceptance
- Extend maintenance tasks exercising check/repair, contracts and policy failures.
- Freeze and record Bash#, Bash and Go candidate identities, model/tool/policy versions, capabilities and controlled budgets.
- Report functional correctness, regressions, human intervention, tokens and total verification cost; retain raw evidence.
- Distinguish original, repeat and follow-up experiments; equal small-sample scores imply neither superiority nor equivalence.
- Run costly campaigns on existing remote infrastructure; no duplicate benchmark framework.
- Bound any fence-security claims to the delivered Sprint 600 evidence.

Planning record only: implementation requires a separate execution instruction. Leave this story todo and unassigned; no code, worker launch or release is authorized by this rewrite.
