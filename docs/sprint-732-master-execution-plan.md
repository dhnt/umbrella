# Sprint 732: a shared shaping ledger

Sprint UUID: `f71a8649-8650-54de-9d57-9b5b04015fef`. Epic: software-shaping.
Status: backlog, planning only. No coding yet: implementation waits until Sprints 726 and 730 are done (operator, 2026-11-26), and operator review comes first.
Follows Sprint 706 (shaping scopes, A/O/C) and Sprint 709 (member pull/push).

## Why

An app is shaped by many hands over many versions: a premium-model agent adds a
feature, a different vendor's agent repairs a runtime error, a local model runs
the build and test, a contractor's own agent sends a patch. Today each of them
inherits the code and nothing else. The brief an agent receives carries the
active revision and, for a repair, one line saying the previous attempt failed.
Why a change was made, what it was expected to fix and what was observed are
recorded in pieces and shown to no one.

The idea is borrowed from arXiv 2611.18856 (Self-Improvement Memory): a record
keyed by problem, holding for each attempt the change, the reason, the
prediction and the observed result, with where it came from. That paper shows a
new model given only the code tends to rewrite inherited work it does not
understand. Its measured gain is small and its evidence thin, so this sprint
borrows the record and makes no performance claim (operator, 2026-11-26: the
value is memory shared across agents in group shaping, not benchmark points).

## Primary goal

Every agent and participant shaping an app inherits why earlier changes were
made, what they were expected to fix and what was observed, across vendors,
versions and the contractor hop.

## What exists (code inspected 2026-11-26, yoke `0bc70d51`, bashy `eb41d87b`, both at origin head)

- **One venue.** Candidates, version history, incidents and tracking live on the
  owner's host. A support member works in the owner's console; a contractor
  reaches the same host over the site MCP. No new sync channel is needed and
  the hosted plane stays relationship data only.
- **Most of an entry is already recorded.** `Candidate` holds request,
  principal, actor, agent, coverage, next steps, verdict and revisions
  (`yoke/pkg/shape/service.go:98-136`). The candidate commit carries
  `Shape-Request`, `Shape-Principal`, `Shape-Agent` and `Shape-Next` trailers
  (`helpers.go:171-180`). An activation records request, verdict, evidence,
  principal, author and `Trigger`, the incident id of a repair
  (`yoke/pkg/src/activate.go:389-396`). Undo and restore are activations with
  their own kind (`yoke/pkg/src/history.go:173-176`).
- **One entry point for agents, with a slot already in the brief.**
  `BriefWithExtra(app, wish, extra)` (`helpers.go:94`) takes extra text; one
  console caller uses it today (`yoke/pkg/webconsole/shaped_candidate.go:358`).
  The closing block COVERED / NOT COVERED / NEXT is parsed at `helpers.go:39`.

## Gaps

1. Nothing assembles the records per problem, and the brief does not carry them.
2. No rationale or prediction is asked of the agent.
3. Reject removes the candidate and keeps nothing (`service.go:925-943`).
4. The agent name is not passed to the activation (`production.go:230`).
5. A contractor's push carries the patch only: the request is recorded as the
   fixed text "Import member patch" (`transfer.go:135`), with no agent, reasons
   or contractor as actor, and pull returns source only.

## Design

**The ledger is derived.** It is recomputed from the version line and the
candidate and incident records, and holds no state of its own. Undo and restore
are inputs to the fold like any other activation, so they cannot leave the
ledger stale.

**Versioning, undo and redo.** Shaping is ongoing and iterative, and the ledger
follows the version line.

- Every attempt is tied to its revision and has a standing: active, undone,
  restored, superseded, rejected or failed.
- Undo marks an attempt undone and keeps it. Restore marks it active again.
  Nothing is deleted.
- An undo is evidence that a direction did not work; undo and restore may carry
  a reason.
- The view is relative to a base revision: what is live there, with undone and
  later attempts marked, so a restored old version does not present later work
  as if it were in the code.
- A problem collects attempts across versions and reopens on a new incident
  with the same signature.
- Each principal has its own version line; entries name their line.

**Shown to every agent.** The view for the candidate's base revision goes into
the wish brief and the repair brief, and into a file in the work clone that is
kept out of the commit. Entries are presented as prior experience, not
instructions. The size is bounded for small-context local models: open
problems in full, closed ones as one line, newest first.

**Filtered by viewer.** The owner sees everything. A member or contractor view
leaves out host paths, board ids and other members' addresses, following the
existing shape scopes. The filter is part of the view from the first story,
since nothing may reach a contractor unfiltered.

## Stories and triage

| # | Story | Pri | Repos | Depends on |
|---|---|---|---|---|
| L1 `d25c43e7ebfc` | Ledger fold over the version line, standing per attempt, viewer-filtered view, `--json` | p1 | yoke | none |
| L2 `e5b46eba0de6` | Capture rationale, prediction, reject line, agent at activation, reason on undo/restore | p1 | yoke | none |
| L3 `ddfb81fa062f` | Ledger in both briefs and as a file in the work clone, size-bounded | p1 | yoke | L1 |
| L4 `08b77aabb1f9` | Contractor hop: ledger on pull, reasons and the contractor as actor on push | p2 | yoke, bashy | L1, L2 |
| L5 `86e8a12324d7` | Group end-to-end test (acceptance) and the two open points | p1 | bashy | L1 to L4 |
| `3895d1c38be7` | Site MCP candidate reply returns host paths to members | p2 | bashy, yoke | with L4 |
| `759c57a66ff5` | `bashy delegate` has no depth counter for genie-to-genie nesting | p3 | yoke, ycode | none |

Triage decisions:

- **Viewer filter moved from L5 into L1.** L4 exposes the ledger to a
  contractor, so the filter has to exist before it. L5 is now the acceptance
  test only.
- **L3 is smaller than first filed.** The brief already has an `extra` slot;
  the CLI wish path and the repair brief need to pass the ledger through it.
- **L1 and L2 run in parallel.** L1 adds new files; L2 touches `helpers.go`,
  `service.go` and `production.go`. They meet only at the `Candidate` fields,
  which L2 adds and L1 reads when present.
- **Smallest useful cut: L1, L2, L3.** That delivers the shared memory for the
  owner and support member on one host. L4 extends it to the contractor.
- **Cuttable inside L2:** the reason on undo and restore. Standing is derived
  without it.
- **`3895d1c3` rides with L4** (same handler, same concern as the filter).
- **`759c57a6` is linked at the operator's request but independent.** It is not
  on the acceptance path and can move off the sprint without affecting it.
- **Not in MVP:** choosing an agent per step. The ledger yields the track
  record that would need; routing is a separate decision.

## Sequence

1. L1 and L2 in parallel, each on current heads, unit tests on the branch.
2. L3 after L1 merges.
3. L4 with `3895d1c3` after L1 and L2 merge.
4. L5 on integrated main.
5. `759c57a6` whenever a worker is free.

## Checks

- Fast unit tests per story in `yoke/pkg/shape` and the bashy site MCP handlers.
- Acceptance (L5): one sandbox end-to-end test with fake accounts and fake
  agents, minutes long, on the gate host in the official image, never the dev
  box. A member's wish is built by agent X with a rationale; a runtime incident
  is repaired by agent Y, whose brief contains X's rationale and prediction and
  whose attempt lands under the same problem; a contractor pulls the filtered
  ledger and pushes a patch with reasons, recorded with the contractor as
  actor; undo then restore changes standing and deletes nothing; a `dag.md`
  test step reads the ledger file in the work clone.
- No release and no hosted deploy. Hosted-plane code is untouched.

## Open points

- Whether the console's history and incident reads are already tier-checked
  (the handlers do no check of their own).
- How the `dag.md` build and test step reaches the local model, and so where it
  reads the ledger file.
- The satellite side of admission was not inspected; it is outside this
  workspace.

## Risks

- A stale reason can anchor a stronger agent. Hence "prior experience, not
  instructions", and the standing on every entry.
- One ledger widens what participants see of each other. The filter is in L1
  and the acceptance test checks it.
- New fields are optional everywhere, so older agents, records and MCP clients
  keep working; rollback is removing the brief text and the pull field.
