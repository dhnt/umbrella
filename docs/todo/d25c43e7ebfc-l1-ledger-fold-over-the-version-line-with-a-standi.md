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
