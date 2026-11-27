---
id: 86e8a12324d7
kind: feature
title: L5 Group end-to-end test (acceptance) and the open points
seq: 807
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T19:45:25.908582Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: one ledger holding everyone's attempts widens what participants see of each other.
Behavior: the owner sees everything; a member or contractor view leaves out host paths, board ids and other members' addresses, following the existing shape scope rules. Then the sprint's acceptance test: sandbox, fake accounts and fake agents, minutes long, on the gate host (never the dev box): member wish built by agent X; runtime incident repaired by agent Y under the same problem with X's reasons in its brief; contractor pull and push with reasons; undo then restore changes standing only; a dag.md test step reads the ledger file.
Open points to settle here: whether console history and incident reads are already tier-checked; how the dag.md build/test step reaches the local model.
Code inspected (2026-11-26): yoke/pkg/shape/service.go:288-304 (canAccessCandidate); yoke/pkg/webconsole/shaped_history.go:176-193; shaped_candidate.go:724-775; bashy/internal/agentos/shape_scope.go:18-124.
Verification: the end-to-end test above plus unit tests for the filter.

Triage (2026-11-26): p1, depends on L1 to L4, runs on integrated main. The viewer filter moved to L1; this story is now the acceptance test and the two open points only. Planning only until Sprints 726 and 730 are done.

Operator input (2026-11-26): the local model can be run or proxied by the satellite, so the dag.md build and test step reaches it there and reads the ledger file in the work clone (open point settled). OTel is supported: an attempt may cite a trace or log reference as its observed evidence, and ledger reads can be traced. Still to verify here: whether console history and incident reads are tier-checked in code.

Review (2026-11-26, code re-read at bashy eb41d87b): large. The harness covers none of the new scenarios today.
- Open point closed: console history and incident reads are NOT tier-checked. Filed as L0 6a8709362f55 (p0), which lands first; this test then asserts the refusal.
- The stub agent (tests/group-shaping-e2e/codex) answers two fixed prompts with a sed edit and one line of text. It prints no COVERED / NOT COVERED / NEXT block, so it cannot carry RATIONALE or PREDICTED, and it exits 2 on any other prompt, including the repair brief (shaped_repair.go:142).
- There is one binding (codex:gpt6-sol, sandbox.py:343-347). Agents X and Y need a second stub and binding; stub-events counts edits by exact list (sandbox.py:263,314).
- Incidents, undo and restore are not exercised. Drive an incident with the owner CLI ('incident APP msg --kind script --path / --agent'); a passing repair activates by itself. Undo is shape_undo (owner only); restore is CLI only.
- 'A dag.md test step reads the ledger file' cannot be met as worded: the web verifier runs checks/*.bsh frozen from the base (verify/contract.go:65) and treats dag.md only as a protected file. Reword to a check script that reads the ledger file in the work clone, and first confirm the contained check process can see an excluded file there.
- Redaction (todo 3895d1c38be7) breaks two existing checks that read leaked fields: sandbox.py:272 (verdict.evidence) and :311 (workspace). Switch them to the owner CLI, as member_pull_push does at :204-206.
- OTel: the shaping path has no spans and no trace id at the verdict. Evidence references are shape-evidence:<rev> or the incident id; tracing ledger reads is deferred.
- The 'never the dev box' rule is enforced only by run.py:21 (linux and GROUP_SHAPING_GATE=1). Claim the lane by hand.
- Today's baseline: 62 checks (5 setup, 39 scenario, 18 member pull and push), two passing runs required.
No coding until Sprint 730 completes (operator, 2026-11-26).

Revision 2 (2026-11-26, operator review; code at yoke 1ae2290c): start approved; plan in docs/sprint-732-master-execution-plan.md "Revision 2". Acceptance reworded to the revision 2 records (decision log, .git/shape-ledger.json); runs once on integrated main on the gate host.

Build brief (conductor 2026-11-26, after L1-L4 merge; venue: the group-shaping harness, bashy tests/group-shaping-e2e, which passes 65 checks on bashy 9b3d488e via ~/.bashy/evidence/s732/lane-e2e.sh on the gate lane):
- Stub: the codex fixture prints the closing block (COVERED/NOT COVERED/WHY/EXPECT/NEXT) with a distinct WHY and EXPECT per prompt, appends its whole prompt to $HOME/stub-prompts, and answers the repair brief with a deterministic fix. Two bindings on the same stub (X = codex:gpt6-sol, Y = codex:gpt6-terra or similar), proven by delegate dry runs.
- Scenario additions, in order: (1) member wish by X records why/expect (owner `bashy shape ledger APP --json`); (2) owner CLI incident on the active revision with --agent Y; the repair activates by itself; Y's recorded prompt contains X's WHY and EXPECT inside the LEDGER fence, and the ledger files Y's attempt under X's problem; (3) contractor shape_pull returns a filtered ledger (no owner address, no host paths) and shape_push with why/expect/agent is recorded with the contractor as principal; (4) owner undo then restore: standings change (undone, then restored) and the attempt count is unchanged; (5) a check step (checks/*.bsh in the website template, or the verifier record) proves .git/shape-ledger.json was readable in the work clone; (6) an out-of-scope caller is refused the ledger route and reads.
- Keep every existing check green; count before and after.

