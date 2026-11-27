---
id: 08b77aabb1f9
kind: feature
title: 'L4 Contractor hop: ledger on pull, reasons and the right actor on push'
seq: 806
status: todo
priority: p1
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

Review (2026-11-26, code re-read at bashy eb41d87b and yoke 0bc70d51):
- 'Records the contractor as actor' needs rewording. The contractor's verified identity is already recorded: Candidate.Principal comes from the signed Remote-User (mcp_site.go:576-578, service.go:517) and history shows the contractor as author. Candidate.Actor is the host process identity (mcp_site.go:572, bus.ResolveAuthoredActor). Keep Actor as the host and add the contractor's agent, request, rationale and predicted; do not overwrite Actor.
- Contractor is a circle, not a tier. Tiers are owner, member, account and anonymous (mcp_site.go:37-42), resolved at :76-125; the member gate is allowShape (:155-184), checked again in yoke (transfer.go:34-56). shape_scope.go is the owner's scope-admin command and decides no tier.
- shape_push already returns a reduced map with no paths (shape_local.go:150-153). It verifies at once (transfer.go:141), and a stale base is refused naming both revisions.
- The site MCP exposes no history, restore or incident verbs. Ledger on pull is the contractor's only read of it; keep it that way.
- Depends on L1, L2, L0 6a8709362f55 and todo 3895d1c38be7, which lands first.
- Two repos: merge yoke first, then bashy mod sync with the bashy change, then the umbrella gitlinks. bashy pins yoke b7ca202e, two commits behind yoke head.
No coding until Sprint 730 completes (operator, 2026-11-26).

Revision 2 (2026-11-26, operator review; code at yoke 1ae2290c): start approved; plan in docs/sprint-732-master-execution-plan.md "Revision 2". Kept and raised to p1: the sprint goal names the contractor hop. After L1, L2 and 3895d1c3; in parallel with L3.
