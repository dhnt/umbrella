---
id: 3895d1c38be7
kind: bug
title: Site MCP candidate reply returns host paths to members
seq: 808
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T19:45:26.116178Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

The full Candidate JSON returned by shape_wish/verify/preview over the site MCP includes workspace, tracking_root and artifact_path. Members and contractors should not receive host paths. Code inspected (2026-11-26): bashy/internal/agentos/mcp_site.go:595-603; yoke/pkg/shape/service.go:98-136. Found by reading; not reproduced live.

Triage (2026-11-26): linked to Sprint 732; rides with L4.

Review (2026-11-26, code re-read at bashy eb41d87b and yoke 0bc70d51): raised to p1. It lands before L4 and reuses the viewer filter from L1; nothing new goes to a contractor while this reply is unfiltered.
- Fields a member in shape scope receives beyond the three first listed: tracking_item (an id on the owner's board), verdict.evidence (an absolute path under the host's src/.evidence), verdict.detail and error text that may hold paths, actor (the host process identity), activation_principal (the owner's email), agent_identity and agent_receipt. workspace and tracking_root are set for every candidate (service.go:528, tracking.go:182). Artifact paths are set only for host-kind apps.
- Calls affected: shape_wish and shape_verify return the full Candidate; shape_preview returns it with a loopback console url (shape_local.go:179-183,212; mcp_site.go:590). shape_push already returns a reduced map.
- No redaction helper exists for candidates. RelativizeWorkspace cleans only coverage and NEXT text (helpers.go:196-247); ShapeEvidenceReference gives the public-safe locator shape-evidence:<rev> (tracking.go:190-198) to use in place of the evidence path.
- The end-to-end harness reads two of the leaked fields (tests/group-shaping-e2e/sandbox.py:272, :311). Change them in the same commit.
- Other members' candidates are not exposed (canAccessCandidate, service.go:288-302).
No coding until Sprint 730 completes (operator, 2026-11-26).

Revision 2 (2026-11-26, operator review; code at yoke 1ae2290c): start approved; plan in docs/sprint-732-master-execution-plan.md "Revision 2". Known leak, fixed here; first, in parallel with L0. Its filter is shared with L1 (whichever lands first owns it; the other reuses it). Lands before L4.
