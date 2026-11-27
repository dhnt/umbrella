# Sprint 732: a shared shaping ledger

Sprint UUID: `f71a8649-8650-54de-9d57-9b5b04015fef`. Epic: software-shaping.
Status: reviewed with the operator 2026-11-26 and approved to start. Sprints 726 and 730 are done.
Follows Sprint 706 (shaping scopes, A/O/C) and Sprint 709 (member pull/push).
Revision 2 (2026-11-26) re-plans on the records Sprint 730 added; see "Revision 2" first. The sections after it are the first plan and its review, kept for the record; where they disagree, Revision 2 wins.

## Revision 2: execution plan on the existing workflow (2026-11-26)

Code re-read at yoke `1ae2290c` (origin main). The idea stays borrowed from SIM
(Self-Improvement Memory, arXiv 2611.18856): per problem, each attempt's change,
reason, prediction, observed result and provenance. What changes is where it is
kept: on the workflow records Sprint 730 already added, not on new ones.

Operator rulings for this revision: a known bug in scope is fixed in this sprint
(MVP means minimal, not broken; it must work end to end); the rest is the
conductor's judgment.

### What Sprint 730 changed

| First plan assumed | Now on yoke main | Effect |
|---|---|---|
| No problem key; add a `Shape-Problem` trailer | `Source{Kind, Ref}` on every wish and candidate (`892a1149`, `shape/service.go:83`) | The key exists. No trailer. |
| A new append-only record for rejects and failures | The decision log `<home>/shape/auto-decisions.jsonl` (`shape/state/auto.go`): trigger, attempt, verdict, activation, refusal, keyed by source and ref (`8514373c`, `1ae2290c`). No non-test reader yet. | This is the SIM record. Widen it; build nothing parallel. |
| Six brief paths, no shared entry point | `FenceUntrusted` shared by the wish, context and repair briefs (`shape/helpers.go`) | The ledger is one fenced block from one helper. |
| History and incident reads unchecked | Unchanged (`gate.go`, `shaped_history.go`) | L0 still first. |

Because the record is an append-only host file rather than git trailers, these
first-plan items fall away: trailers on undo and restore commits, carrying
reasons through tidy as `Original-*`, and records lost when a draft is saved or
a candidate rejected. Standing is a fold over the log's events.

### Design (revision 2)

- **One record.** `AutoDecision` gains optional fields: `Rev`, `Agent`,
  `Principal`, `Line`, `Problem`, `Why`, `Expect`. Human wishes are logged too
  (`source: human`); unattended-only behaviour (off switch, refusal) keys on
  `Source.Unattended()` and is unchanged. New events: `reject`, `undo`,
  `restore`, each with the actor and `by: person|system` (a rollback after a
  failed repair release is `system`). Old lines without the new fields still
  parse. The log stays a record, not a gate.
- **Problem key.** `Source.Ref` when set (incident id, feed ref), else the
  linked todo or story, else the candidate's tracking item. An incident joins
  the problem of the attempt that is live at its base revision, so a repair
  files under the wish it repairs.
- **Reason and prediction.** The brief's closing block (COVERED / NOT COVERED /
  NEXT) gains `WHY:` and `EXPECT:`, parsed like `ParseCoverage`. A contractor's
  push carries them as fields.
- **Fold.** Per app and base revision: problems, newest first; each attempt
  with agent, principal line, request, why, expect, observed verdict or
  incident, and standing (active, undone, restored, superseded, rejected,
  failed). Size bound: open problems in full, closed ones one line.
- **Viewer filter.** The owner sees everything. Members and contractors get no
  host paths, board ids, others' addresses, host actor or agent receipts; the
  problem shows as an opaque alias. The same filter serves the site MCP
  candidate reply (`3895d1c3`). Every read goes through L0.
- **Shown to every agent.** `LedgerBrief` renders the filtered fold inside
  `FenceUntrusted("LEDGER", ...)`, labelled prior experience, not
  instructions, on the four paths: service wish, console wish, draft step,
  incident repair. The same view is written to `.git/shape-ledger.json` in the
  work clone: inside the clone, never committed, so no exclude and no
  self-commit guard are needed, and a build or test step (a local model via the
  satellite) can read it.

### Stories (the existing ids; none added)

| Order | Story | Pri | Size | Repos | Scope in revision 2 |
|---|---|---|---|---|---|
| 1 | L0 `6a8709362f55` | p0 | S | yoke | Unchanged: tier and scope check on history, diff, incident reads; undo/restore/name on the line the view shows |
| 1 | `759c57a66ff5` delegate depth | p1 | S | yoke, ycode, bashy | Known bug, fixed here: `BASHY_DELEGATE_DEPTH` mirroring `BASHY_MEET_DEPTH`; genie allowlists; pin bumps |
| 1 | `3895d1c38be7` site MCP reply | p1 | S | bashy, yoke | Known leak, fixed here: filter the candidate reply; update the two harness checks |
| 2 | L2 `e5b46eba0de6` | p1 | M | yoke | Widen the decision log; log human wishes; reject/undo/restore events; `WHY:`/`EXPECT:`; agent name to the activation |
| 3 | L1 `d25c43e7ebfc` | p1 | M | yoke, bashy | Fold, standing, size bound, viewer filter, `bashy shape ledger --json` |
| 4 | L3 `ddfb81fa062f` | p1 | S | yoke | `LedgerBrief` on four paths; `.git/shape-ledger.json` |
| 4 | L4 `08b77aabb1f9` | p1 | M | yoke, bashy | Ledger on pull; `why`/`expect`/agent on push, recorded with the contractor as principal |
| 5 | L5 `86e8a12324d7` | p1 | M | bashy | Acceptance end-to-end test |

L4 stays: the sprint goal names the contractor hop. `3895d1c3` lands before L4,
since nothing new goes to a contractor over an unfiltered reply.

### Sequence

0. Start on current heads: fetch, `bashy mod drift`, bump the touched pins
   (ycode's yoke and coreutils pins are stale; bashy is in sync), build and run
   unit tests. Claim the pin bump; announce on `bashy mb`.
1. L0, delegate depth and `3895d1c3` in parallel: independent, small.
2. L2 (record format first, in its story).
3. L1.
4. L3 and L4 in parallel.
5. Merge order per change: yoke, then `bashy mod sync` with the bashy change,
   then umbrella gitlinks. Delegate depth also bumps ycode.
6. L5 once, on integrated main, on the gate host, in the official image.

Fast unit tests per story on its branch; the end-to-end test runs once at the
end. No release, no hosted deploy.

### Acceptance (revision 2)

One sandbox end-to-end test with fake accounts and fake agents on the gate
host: a member's wish built by agent X records why and expect; a runtime
incident repaired by agent Y whose brief contains X's why and expect, filed
under the same problem; a contractor pulls the filtered ledger and pushes a
patch with reasons, recorded with the contractor as principal; undo then
restore changes each attempt's standing and deletes nothing; a check step reads
`.git/shape-ledger.json` in the work clone; an out-of-scope caller is refused
the ledger. Unit tests pass for the L0 refusals, fold, size bound, viewer
filter, MCP reply filter and the delegate depth limit.

### Risks (revision 2)

- The decision log is host-wide and grows without bound; the fold filters by
  app and the view is size-bounded. Rotation is not in this sprint.
- A member's repair activates on the caller's line while incidents sit in the
  owner's store (`shaped_repair.go:311`); one host-wide log makes the join
  possible, and L5 exercises it.
- To confirm in L3: the contained check process sees `.git/` in the clone. If
  not, the file moves beside the clone and its path is passed in the
  environment.

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

## Review (2026-11-26)

The code was re-read at yoke `0bc70d51` and bashy `eb41d87b`, the same commits
the first plan was written against. The goal and the overall shape stand. Five
findings change the stories and the order.

1. **History and incident reads are not access-checked.** On an owned web app,
   any signed-in caller can read the owner's version history, diffs and
   incidents. The gate only requires a verified identity for `/api` paths
   (`yoke/pkg/webconsole/gate.go:70-115`), the handler only requires a principal
   (`shaped_candidate.go:664-684`), and the read resolves to the owner's line
   and store for every caller (`shaped_history.go:187`,
   `shaped_incident_capture.go:356-377`, `shape/service.go:173-178`). This was
   an open point for L5; it is confirmed and becomes story L0, first.
2. **Reasons kept only on the candidate record would be lost.** Draft save
   deletes the draft directory (`shaped_draft.go:533-535`), reject deletes the
   candidate directory (`service.go:925-976`), and only the approve path
   archives the record (`service.go:890-922`). Tidy re-creates entries without
   their second parent (`src/tidy.go:256-320`).
3. **Standing cannot be derived from today's undo records.** Undo and restore
   are not activations. They are forward commits with no second parent, and
   their kind is guessed from the commit subject (`src/history.go:171-180`,
   `:560-643`). The undone version is not recorded, a second undo is a redo, and
   a system rollback after a failed repair release (`shaped_repair.go:324`)
   looks the same as a user undo.
4. **Nothing groups attempts into a problem.** An activation names its candidate
   only by revision, drafts have no candidate id, and no field names an earlier
   attempt. A problem key is added (see Design).
5. **There is no single entry point for agent briefs.** Six paths build a brief;
   `BriefWithExtra` serves two of them. L3 is larger than first triaged.

Corrections to the first plan:

- Tracing: the shaping path has no OTel spans and no trace id reaches the
  verdict. The evidence reference is the existing locator `shape-evidence:<rev>`
  (`shape/tracking.go:190-198`) or the incident id. A trace id is deferred.
- Actor on push: the contractor is already recorded as the candidate's principal
  and as the history author. `Actor` is the host process identity and stays so.
- Contractor is a circle, not a tier. `bashy/internal/agentos/shape_scope.go` is
  the owner's scope-admin command and decides no tier; tiers are resolved in
  `mcp_site.go:76-125`.
- The candidate reply over the site MCP exposes more than three path fields: it
  also carries the owner's email, a board item id and the evidence path
  (todo `3895d1c3`).
- A `dag.md` step is not executed by the web verifier, which runs `checks/*.bsh`
  frozen from the base (`shape/verify/contract.go:65`). The acceptance item is
  reworded to a check script.
- "Reopens on a new incident with the same signature" is not how incidents work:
  `Observe` reuses the existing incident for a signature unless it is refused or
  external (`shaped_incident.go:196-214`).

## What exists

- **One venue.** Candidates, version history, incidents and tracking live on the
  owner's host. A support member works in the owner's console; a contractor
  reaches the same host over the site MCP. No new sync channel is needed and
  the hosted plane stays relationship data only.
- **Most of an entry is already recorded.** `Candidate` holds request,
  principal, actor, agent, coverage, next steps, verdict and revisions
  (`yoke/pkg/shape/service.go:98-136`). The candidate commit carries
  `Shape-Request`, `Shape-Principal`, `Shape-Agent` and `Shape-Next` trailers
  (`helpers.go:175-180`), except when the agent committed itself (`:165-167`).
  An activation records request, verdict, evidence, principal, author and
  `Trigger`, the incident id of a repair (`yoke/pkg/src/activate.go:389-396`),
  and its second parent is the candidate commit.
- **What survives.** Approved candidates are archived under
  `shape-work/.approved` with no time limit. Repair candidates are never
  removed. Every candidate has a tracking todo (`tracking.go:174-182`), and each
  verified revision has a sealed evidence record. Incidents hold a signature,
  base revision and attempts (`webconsole/shaped_incident.go:61-87`).
- **All lines are readable in one pass.** Each principal has a ref
  `refs/shaping/<slug>/line`, listed by `PrincipalLines` (`activate.go:107`).
  On owned web apps members activate onto the owner's line with an `Author`
  trailer.
- **Grouping already exists for todos.** `--story` and `--todo` link several
  candidates to one tracking item (`tracking.go:46-127`).

## Gaps

1. History and incident reads have no tier or scope check (L0).
2. Nothing assembles the records per problem, and no problem key is recorded.
3. No rationale or prediction is asked of the agent, and the candidate record
   is not a durable place to keep them.
4. Undo and restore record neither their kind, the version undone, the actor,
   nor whether a person or the system did it.
5. Reject removes the candidate and keeps no ledger line; failed attempts are
   overwritten on retry or lost with a draft.
6. The agent name is not passed to the activation (`production.go:141,230`).
7. Four brief paths in scope do not carry earlier reasons.
8. A contractor's push carries the patch only: the request is the fixed text
   "Import member patch" (`transfer.go:135`), with no agent or reasons, and pull
   returns source only.
9. The candidate reply over the site MCP is unfiltered.

## Design

**The ledger is a derived view over durable records.** It is recomputed from the
version line and its commit trailers, the incident records, and one small
append-only record for attempts that never reach the version line (rejects and
failures). It keeps no summary state of its own, so undo and restore cannot
leave it stale. The first plan said "no state of its own"; the reject line and
the failure line are the one exception, and they are append-only.

**Reasons live in commit trailers.** `Shape-Rationale` and `Shape-Predicted` go
on the candidate commit and on each draft step commit, beside the existing
`Shape-*` trailers, and are kept on the candidate record too. Tidy carries them
forward as `Original-*`. The tidy base is the ledger's horizon.

**Problem key.** The linked todo id if the wish names one, else the incident id,
else the candidate's own tracking item. It is written as a `Shape-Problem`
trailer so the fold reads git alone and does not depend on the todo store, which
is mutable. A sprint id is the wrong grain: a sprint holds many problems and a
consumer shaping an app has none. Non-owners see an opaque alias, never the
board id. Sprint 730's issue ids can join this key later; a slot is reserved.

**Versioning, undo and redo.**

- Every attempt is tied to its revision and has a standing: active, undone,
  restored, superseded, rejected or failed.
- Undo and restore commits carry trailers: kind, the revision undone, the actor,
  and whether a person or the system did it, with an optional reason. Old
  entries fall back to the subject-line guess.
- Undo marks an attempt undone and keeps it. Restore marks it active again.
  Nothing is deleted.
- The view is relative to a base revision: what is live there, with undone and
  later attempts marked.
- A problem collects attempts across versions and across incident records that
  share a signature.
- Entries name the principal line they belong to.

**Shown to every agent.** The view for the candidate's base revision goes into
the brief on four paths: service wish, console wish, draft step and incident
repair. Protected-page intent and core repair of bashy itself are out of scope.
The same view is written to a file in the work clone, kept out of the commit by
`.git/info/exclude`; verification refuses a candidate whose tree contains it,
which covers agents that commit themselves. Entries are presented as prior
experience, not instructions. The size is bounded for small-context local
models: open problems in full, closed ones as one line, newest first.

**Filtered by viewer.** The owner sees everything. A member or contractor view
leaves out host paths, board ids, the owner's and other members' addresses,
the host actor and agent receipts. The filter is built in L1 and reused for the
candidate reply (`3895d1c3`). Every read of the ledger goes through the access
check from L0.

## Stories and triage

| # | Story | Pri | Size | Repos | Depends on |
|---|---|---|---|---|---|
| L0 `6a8709362f55` | Check the caller's tier on shaping history and incident reads | p0 | S | yoke | none |
| L2 `e5b46eba0de6` | Capture rationale, prediction, problem key, agent at activation; structured undo/restore records; reject and failure record | p1 | L | yoke | record format |
| L1 `d25c43e7ebfc` | Ledger fold, standing per attempt, viewer-filtered view, `shape ledger --json` | p1 | M | yoke, bashy | L0, record format |
| `3895d1c38be7` | Filter the candidate reply over the site MCP | p1 | S | bashy, yoke | L1 filter |
| L3 `ddfb81fa062f` | Ledger in four briefs and as an excluded file in the work clone | p1 | M | yoke | L1 |
| L4 `08b77aabb1f9` | Contractor hop: ledger on pull, reasons and agent on push | p2 | M | yoke, bashy | L1, L2, `3895d1c3` |
| L5 `86e8a12324d7` | Group end-to-end test (acceptance) | p1 | L | bashy | L0 to L4 |
| `759c57a66ff5` | `bashy delegate` has no depth counter | p2 | S | yoke, ycode, bashy | none |

Triage decisions:

- **L0 is new and lands first.** The ledger widens exactly the reads that are
  open today.
- **L1 and L2 are no longer fully parallel.** They share a record format
  (trailers, problem key, undo and restore records, the reject record). That is
  agreed first, as a short written step; then they proceed side by side.
- **L2 grew.** Durable carriers, the problem key and structured undo and restore
  records are required. Only the free-text reason on undo and restore remains
  cuttable.
- **L3 grew.** Four brief paths, an exclude, and a guard against self-commits.
- **`3895d1c3` raised to p1** and placed before L4. Nothing new goes to a
  contractor while the candidate reply is unfiltered. It changes two harness
  checks that read leaked fields (`tests/group-shaping-e2e/sandbox.py:272,311`).
- **L4's actor wording changed.** Add the contractor's agent and reasons; leave
  `Actor` as the host.
- **`759c57a6` raised to p2.** Confirmed: the allow list reaches the child, so
  genie-to-genie nesting is bounded only by timeouts and spend. Still
  independent and off the acceptance path.
- **Smallest useful cut: L0, L2, L1, L3.** That delivers the shared memory for
  the owner and support member on one host. `3895d1c3` and L4 extend it to the
  contractor.
- **Not in MVP:** choosing an agent per step; a trace id as evidence; members
  linking a follow-up to an existing problem, which needs an operator today
  (`shaped_candidate.go:771`) and is an owner decision.

## Sequence

Nothing starts until Sprint 730 completes.

1. L0.
2. Agree the record format in writing.
3. L2 and L1, each with unit tests on its branch.
4. `3895d1c3`, then L3.
5. L4.
6. L5 on integrated main.
7. `759c57a6` whenever a worker is free.

Each change that spans repos merges yoke first, then `bashy mod sync` with the
bashy change, then the umbrella gitlinks. bashy pins yoke `b7ca202e`, two
commits behind yoke head at review time. `759c57a6` also needs the ycode genie
allowlist and a pin bump.

## Checks

- Fast unit tests per story in `yoke/pkg/shape`, `yoke/pkg/src`,
  `yoke/pkg/webconsole` and the bashy site MCP handlers. Existing fixtures to
  extend: `fakeMemberDelegate` and `newScopedOwnerFixture`
  (`shape/scope_test.go`), `s525a10Fixture` (`src/history_test.go`),
  `historyFixture` and `repairShaper` (webconsole tests).
- L0: a signed-in non-member, an account holder and a member outside the scope
  are refused history, diff and incident reads on an owned app.
- Acceptance (L5): one sandbox end-to-end test with fake accounts and fake
  agents, on the gate host in the official image, never the dev box. A member's
  wish is built by agent X with a rationale; a runtime incident is repaired by
  agent Y, whose brief contains X's rationale and prediction and whose attempt
  lands under the same problem; a contractor pulls the filtered ledger and
  pushes a patch with reasons; undo then restore changes standing and deletes
  nothing; a check script reads the ledger file in the work clone; an
  out-of-scope caller is refused the ledger.
- Harness work this needs: the stub agent prints no closing block and exits on
  any prompt but its two fixed ones, there is one binding, and incidents, undo
  and restore are not exercised. Baseline today is 62 checks.
- No release and no hosted deploy. Hosted-plane code is untouched.

## Open points

- **Settled: the local model.** It can be run or proxied by the satellite, so a
  build and test step reaches it there and reads the ledger file in the work
  clone.
- **Settled: access check.** History and incident reads are not tier-checked;
  see L0.
- **Changed: observation and audit.** No trace id is available on the shaping
  path. Attempts cite `shape-evidence:<rev>` or the incident id. Tracing ledger
  reads is deferred.
- **To confirm in L3:** that the contained check process can see an excluded
  file in the work clone.
- **To confirm in L2:** whether draft saves and incident repairs create a
  tracking item as ordinary wishes do; if not, they key on the incident id or
  get one.
- **Owner decision:** whether a member may name an earlier problem by its alias.
- The satellite side of admission was not inspected; it is outside this
  workspace.

## Risks

- A stale reason can anchor a stronger agent. Hence "prior experience, not
  instructions", and the standing on every entry.
- One ledger widens what participants see of each other. L0 closes the open
  read first, the filter is in L1, and the acceptance test checks both.
- The repair path stores incidents in the owner's store but activates on the
  caller's line (`shaped_repair.go:311`); for a member on an owned app these
  differ, and the fold has to join across them.
- New fields are optional everywhere, so older agents, records and MCP clients
  keep working; rollback is removing the brief text and the pull field.
