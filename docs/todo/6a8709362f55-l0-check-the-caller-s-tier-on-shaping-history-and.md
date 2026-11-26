---
id: 6a8709362f55
kind: bug
title: L0 Check the caller's tier on shaping history and incident reads
seq: 811
status: todo
priority: p0
labels:
    - shaping
created: 2026-11-26T21:30:30.699797Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: on an owned web app, any signed-in caller can read the owner's version history, diffs and incidents. The gate only requires a verified identity for /api paths, the handler only requires a principal, and the read resolves to the owner's line and store for every caller. Callers that wish creation refuses (signed-in, account, visitor) can still read. Incident ids are guessable (inc-<timestamp>-<sig8>). Restore, undo and name act on the caller's own line while the view shows the owner's line.
Behavior: history, diff and incident reads apply the same tier and scope check as wish creation; a caller outside the app's shape or edit scope is refused. Restore, undo and name resolve the same line the view shows, or are refused. The ledger read view added by L1 goes through the same check.
Code inspected (2026-11-26, yoke 0bc70d51): yoke/pkg/webconsole/gate.go:70-115; coopauth/guard.go:148-157; shaped_candidate.go:664-684 (shapeCaller), :775-797 (the check wish creation has); shaped_history.go:176-193 (historyFor), :187, :266,302,319 (writes on the raw principal); shaped_incident_capture.go:356-377; yoke/pkg/shape/service.go:173-178 (QueuePrincipal). No test refuses a non-owner; shaped_scope_test.go:287 reads history as the owner only. Found by reading; not reproduced live.
Verification: unit tests in yoke/pkg/webconsole that a signed-in non-member, an account holder and a member outside the scope are refused history, diff and incident reads on an owned app, and that an in-scope member and the owner still read.

Triage (2026-11-26, review): p0, no dependencies, lands first. The ledger widens these reads, so nothing in L1 to L4 ships before this. Was the open point 'still to verify in L5'; now confirmed. No coding until Sprint 730 completes (operator, 2026-11-26).
