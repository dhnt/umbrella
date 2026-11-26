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
