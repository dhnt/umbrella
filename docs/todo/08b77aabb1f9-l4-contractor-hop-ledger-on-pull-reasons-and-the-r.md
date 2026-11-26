---
id: 08b77aabb1f9
kind: feature
title: 'L4 Contractor hop: ledger on pull, reasons and the right actor on push'
seq: 806
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-26T19:45:25.656652Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: a contractor's code already syncs (pull returns the owner's source, push returns a patch), but push carries only base_revision and patch. The request is recorded as the fixed text 'Import member patch', the contractor's agent and reasons do not cross, the recorded actor is not the contractor, and pull gives the contractor's agent no history.
Behavior: shape_pull also returns the viewer-filtered ledger for the pulled revision; shape_push accepts optional request, agent, rationale and predicted and records the contractor as actor. Fields optional so older clients keep working. No new sync channel; the hosted plane is untouched.
Code inspected (2026-11-26): bashy/internal/agentos/mcp_site.go:543-552,572-578,595-603,621-625; yoke/pkg/shape/transfer.go:23-32,59-142 (SourceSnapshot, PushPatch, importChanges); bashy/internal/agentos/shape_local.go:138-153.
Verification: unit tests on the site MCP handlers for pull with ledger and push with and without the new fields.

Triage (2026-11-26): p2, depends on L1 and L2. Not part of the smallest useful cut (L1, L2, L3 serve owner and support member on one host); this story extends it to the contractor. Todo 3895d1c38be7 (host paths in the candidate reply) rides with it: same handler, same concern. Verified at source: PushPatch records Wish{Request: "Import member patch"} at yoke/pkg/shape/transfer.go:135. Planning only until Sprints 726 and 730 are done.
