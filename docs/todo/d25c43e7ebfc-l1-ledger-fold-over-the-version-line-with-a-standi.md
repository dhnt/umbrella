---
id: d25c43e7ebfc
kind: feature
title: L1 Ledger fold over the version line, with a standing per attempt
seq: 803
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T19:45:24.90768Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: an app's shaping records are never assembled, so nobody (agent or person) can see why earlier changes were made.
Behavior: derive a per-app ledger grouped by problem (a wish, an incident, or a follow-up naming an earlier one). Each attempt: revision, agent, actor, request, rationale, predicted, observed verdict, and a standing (active, undone, restored, superseded, rejected, failed). The ledger is DERIVED from the version line plus candidate and incident records and holds no state of its own, so undo and restore can never leave it stale: they are activations and are inputs to the fold. Undo marks an attempt undone and keeps it; restore marks it active again; nothing is deleted. The view is relative to a base revision: what is live at R, with undone and later attempts marked. A problem stays open across versions and reopens on a new incident with the same signature. Entries name the principal line they belong to. Expose a read view with --json beside shape history.
Not in MVP: choosing an agent per step.
Code inspected (2026-11-26): yoke/pkg/shape/service.go:98-136 (Candidate fields), :27-36 (states); yoke/pkg/src/activate.go:389-396 (activation block incl. Trigger) and history.go:29-41,159-213,625 (VersionEntry; undo/restore recorded as activations); yoke/pkg/shape/helpers.go:171-180 (Shape-* trailers); bashy web console shaped_incident.go:61-86 (Incident, attempts, base_rev).
Verification: unit tests in yoke/pkg/shape for grouping, standing across undo/restore, and the view at a base revision.

Triage (2026-11-26): p1, no dependencies, runs in parallel with L2. The viewer filter moves here from L5: the view takes a viewer (owner sees everything; a member or contractor view leaves out host paths, board ids and other members' addresses, following the shape scopes), because L4 exposes the ledger to a contractor and nothing may leave unfiltered. Planning only until Sprints 726 and 730 are done.

Operator input (2026-11-26): OTel is supported. Give each attempt an optional evidence reference (trace or log id) for its observed result, cited rather than copied; no new store.

Review (2026-11-26, code re-read at yoke 0bc70d51 and bashy eb41d87b):
- Sequencing: no longer fully parallel with L2. The fold reads records L2 defines (commit trailers, the problem key, structured undo and restore records, the reject record), so the record format is agreed first; then L1 and L2 proceed side by side. L0 6a8709362f55 lands before any of this.
- Undo and restore are NOT activations. They are forward commits made by restoreUnlocked (yoke/pkg/src/history.go:560-643) with no second parent, and walkLine guesses their kind from the commit subject (:171-180). The undone version is not recorded, a second undo is a redo (LastKnownGood, :635-637), and a system rollback after a failed repair release (shaped_repair.go:324) looks the same as a user undo. Standing is derived from the trailers L2 adds, with the subject-line guess only as a fallback for old entries.
- Join key: an activation names its candidate only by revision (Revision trailer plus second parent); there is no candidate id and drafts have none. The fold joins on revision.
- Problem key: the linked todo id if there is one (--story / --todo, tracking.go:46-127), else the incident id, else the candidate's own tracking item, read from the Shape-Problem trailer L2 writes. A sprint id is the wrong grain. The viewer filter shows non-owners an opaque alias, never the board id.
- 'Reopens on a new incident with the same signature' does not match the code: Observe (shaped_incident.go:196-214) reuses the existing incident for a signature unless it is refused or external. The fold groups by signature across incident records.
- All principal lines are readable in one fold: refs/shaping/<slug>/line, listed by PrincipalLines (activate.go:107). On owned web apps members activate onto the owner's line with an Author trailer.
- Tidy (yoke/pkg/src/tidy.go:256-320) re-creates kept entries without second parents and history stops at the tidy base. The fold must read the Original-* trailers and treat the tidy base as the ledger's horizon.
- Evidence reference: the shaping path has no OTel and no trace id reaches the verdict. Use the existing public-safe locator shape-evidence:<rev> (tracking.go:190-198) or the incident id. A trace id is deferred.
- Viewer filter field list, from the candidate reply review: workspace, tracking_root, tracking_item, verdict.evidence, verdict.detail and error text, actor, activation_principal (the owner's email), agent_identity, agent_receipt, artifact paths. Todo 3895d1c38be7 reuses this filter.
- CLI: add 'ledger APP' beside history at bashy/internal/agentos/shape.go:65, with cases in shape_local.go:73,112 and shape_remote.go:156.
- Tests to extend: yoke/pkg/src/history_test.go (s525a10Fixture), first_undo_test.go; yoke/pkg/shape/scope_test.go (fakeMemberDelegate, newScopedOwnerFixture).
No coding until Sprint 730 completes (operator, 2026-11-26).

Revision 2 (2026-11-26, operator review; code at yoke 1ae2290c): start approved; plan in docs/sprint-732-master-execution-plan.md "Revision 2". Rescoped: fold over the decision log (not git trailers) per app and base revision; incident joins the problem of the attempt live at its base revision; standing; size bound; viewer filter; bashy shape ledger --json behind L0. Size M.

Build brief (conductor 2026-11-26; reads exactly the L2 record format on story e5b46eba):
- yoke pkg/shape/ledger.go: Fold(lines []state.AutoDecision, app, base string) Ledger. Problems newest first; each attempt: candidate id, agent, principal, line, request, why, expect, observed (verdict pass/fail detail or incident id), rev, standing.
- Standing from events only: activation -> active; a later activation in the same problem -> earlier one superseded; undo of rev R -> undone; restore of R -> active (restored); reject -> rejected; failing verdict or failed generation with no activation -> failed. Nothing is deleted; old lines without the new fields fold as best they can (no problem key -> own problem).
- Incident join: an incident problem ("incident:<id>") joins the problem of the attempt active at the incident's base revision; no match keeps its own problem.
- Base: the view is relative to a base revision; attempts after the base are marked later, not hidden.
- Size bound for small-context models: open problems in full, closed ones one line, newest first, at most N bytes (default 8 KiB, a parameter); truncation says so.
- Viewer filter: ForViewer(l Ledger, owner bool, self string) Ledger. Owner sees all. Others: problem key becomes an opaque alias (stable short hash), no host paths, board/todo ids, other principals' addresses (own kept), host actor, agent receipts; reuse shape.MemberView's scrub for detail text.
- Reads: console route GET /api/shape/{app}/ledger through shapeReadCaller (L0) with the caller's viewer filter; bashy CLI `bashy shape ledger APP [--base REV] [--json]` (owner on the host; site/console callers go through the route). Register the verb in bashy internal/agentos/shape.go beside incident.
- Tests (targeted): fold standing for wish -> activate -> repair (incident join) -> undo -> restore; reject and failed attempts kept; size bound; viewer filter drops each listed field; route refuses an out-of-scope caller (reuse the L0 fixtures).

Delivery rules (conductor 2026-11-26, Sprint 732 started):
- Work on current heads: yoke 625c20d9, bashy 25e87ba4, ycode cfa8bdc or later on origin main (fetch first; L0 changed the history handlers you touch). Commit inside the submodule on a branch named s732-<story-short-id> and push that branch; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #732, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: the smallest change that meets this story. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.
- Repos: yoke (ledger, route) and bashy (CLI verb); bashy builds against yoke under the umbrella go.work; the conductor bumps pins.
