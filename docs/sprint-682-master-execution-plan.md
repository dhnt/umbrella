# Sprint 682: closure plan (master execution plan)

Sprint 682 makes every bashy example app consumer-shapeable. Design and story
spec of record: `plan-s682-consumer-shaping-example-apps.md`. This document is
the closure plan written at the conductor's review on 2026-11-23, after the
sprint had sat in `doing` for two days with five of seven stories accepted.
The card and its stories (in the bashy story store) are authoritative.

## Where the sprint stands (reviewed 2026-11-23)

| Story | State | Evidence |
|---|---|---|
| C1 viewer and chart shaped | accepted 11-21 | bashy `a156c7a4`, `acb83615` |
| C1b `app show --runtime` discovery | accepted 11-21 | yoke `299a502d`, bashy `acb83615` |
| C2 session shaped | accepted 11-21 | bashy `29537381` |
| C3 genie.examples, whiteboard path, binaries | accepted 11-21 | bashy `6f41b85f` |
| keychain (automation Chrome, no OS keychain) | accepted 11-21 | yoke `97fd8985`, bashy `9af6b6ba` |
| C4 member e2e across apps + runbook | open (p1) | script, matrix doc and kb page merged in bashy `e4cd35ea`; kb walkthrough PASS on the gate host 11-21 (hello-world, production Genie, paired Chrome, manifest SHA on the thread); the five-app live matrix never ran green |
| C4b land the C4 fixes + yoke pin | submitted 11-21, never accepted | yoke `be872cc5`, bashy `0605b1ec`, both on main and inside the current pins |

Goal checklist: c1, c2, c3, c1b, keychain done; c4 and kb open, both tied to
C4. The card lists C4b as uncovered by the plan.

What blocked C4 and what has happened since:

- The 2026-11-21 gate run classified three blockers, and the operator approved
  exactly three fixes plus one paid rerun of form, notepad, viewer, chart and
  session on the shared Sonnet route (operator form, 2026-11-21).
- Fix 1, gateway tool-call framing: yoke `be872cc5`, on main, inside bashy's
  yoke pin. Fix 2, host Node 18 and `ws` preflight helper: bashy `93fed833`,
  on main. Fix 3, bounded screenshot: bashy `0605b1ec` and yoke `be872cc5`.
- The Sprint 677 adapter regression that killed the first matrix row (the
  standalone DAG adapter exporting itself as the job's self path) is fixed on
  bashy main (`0c812a16`); Sprint 677 ended 2026-11-22, so the "wait for run
  #139" condition on C4b is satisfied.

## Review findings

1. **C4b is done but not closed.** codex submitted it on 11-21 with the three
   landings; a later claim by another session left it `assigned`. The card
   shows it as uncovered by the plan. Action: accept it with the evidence
   above and link it to goal c4.
2. **The third fix component never landed.** The Genie receiver normalization
   in ycode (`40b5066`, branch `s682/c4-receiver`: complete model-door
   `<invoke>` frames are recognized before dispatch) was only ever in the
   private gate build. ycode main did not have it, and bashy's ycode pin
   (`4c6cee7`) predates it. Without it the live matrix would hit the same
   framing failure as on 11-21 on viewer, chart and notepad. Action (C4c, a
   small baseline-proven repair, its own commits): cherry-pick onto ycode
   main with its tests, bump bashy's ycode pin and the umbrella gitlink.
   Done 2026-11-23: ycode `5323b1b` on main, package tests green.
3. **C4's assignee is idle.** agy-gemini4-hydrogen took C4 on 11-21 and did
   nothing after the gate was paused; the live run is the conductor's by the
   plan. Action: reassign C4 to the conductor before any commit touches it,
   so the attribution hook stays clean.
4. **Stale runs and branches.** bashy weave 133 (abandoned, isolation
   violated) and 134 (killed) are terminal; `git cherry` shows their commits
   integrated on main. Branch `origin/s682/c4-gate` is fully integrated.
   Action: prune the runs, delete the integrated branch, leave the `review/*`
   remote branches alone, delete `s682/c4-receiver` once the pin is bumped.
5. **Four bypass entries on the thread** (one on 11-20, three on 11-21, all
   story-file commits made under the wrong identity). The automatic manage
   score will read detected-bypass at sprint end. Recorded here, not
   repaired; history stays as it is.
6. **Install-wrapped rows are outside the approval.** board, whiteboard and
   table need an operator pre-install on the gate host and are not in the
   approved five-app rerun. The matrix records them as SKIP with the reason,
   never as a pass. They were never green, so this is not newly skipped
   coverage. Action: a standalone follow-up todo for the operator-prepared
   rows; Sprint 683 (owner side) is unaffected.
7. **Venue contention.** Sprint 697 started 2026-11-23 and its wave 1 builds
   on the gate host. The matrix needs the Windows host's WSL lane for one
   session. Action: take the lane claim and announce on `mb` before the run.

## Closure steps

Owner: the conductor (claude-fable5.1), holding the 682 seat from the
interactive session; seat verbs run as the seat. Venue: dev box for
module-local unit tests and bookkeeping only; the Windows host's WSL lane
for the build and the matrix.

| # | Step | Spend | Status |
|---|---|---|---|
| 1 | Take the seat; accept C4b with its evidence; link C4b to goal c4; set this plan as the card's spec | none | done 2026-11-23 |
| 2 | C4c: land ycode `40b5066` on ycode main (cherry-pick, `go test ./internal/harness/turn/...`), push | none | done 2026-11-23 (`5323b1b`) |
| 3 | Bump bashy's ycode pin (ycode is a versioned dependency, not a sibling pin, so `go get` not `mod sync`); bump the umbrella `ycode` and `bashy` gitlinks | none | done 2026-11-23 (bashy `b6394ca6`; umbrella sync commit) |
| 4 | Reassign C4 to the conductor; commit and push the story file first | none | done 2026-11-23 (bashy `d64886dc`) |
| 5 | Prune: weave 133 and 134 records (nothing reclaimable; both terminal), branch `s682/c4-gate` (integrated, deleted), `s682/c4-receiver` (integrated, deleted) | none | done 2026-11-23 |
| 6 | Gate-host preflight, no model call: claim the WSL lane; build the frozen candidate (bashy main at the bumped pin, `GOWORK=off`); disposable installation per `examples/shaping/hello-world/e2e-matrix.md`; register the five apps; `e2e-agent.sh --dry-run`; recursive DAG fixture; Node 18 and `ws` via `run-node-ws.sh --preflight`; paired Chrome for two synthetic members | none | pending |
| 7 | The ONE approved paid run: `e2e-agent.sh` for form, notepad, session, viewer, chart as member A on the shared Sonnet route; board, whiteboard, table SKIP by design; per-row evidence log, DOM assertions from the paired browser, screenshot optional and bounded | one paid matrix | awaiting the operator's word to launch (approval of 11-21 stands; new facts: the ycode pin bump and lane sharing with 697) |
| 8 | Green: accept C4 (closes goals c4 and kb), write `docs/sprint-682-evidence.md` (wire-level, hosts by role, per-row markers, candidate SHAs, manifest SHA), file the pre-install follow-up todo. Red: root cause on the story first; no second paid run without the operator | none | pending |
| 9 | `sprint end 682` (every story closed, repos pushed and pinned, drift read); release the lane; record the scorecard beside this plan | none | pending |

## Paid run recipe (step 7)

- Candidate: bashy main after step 3, built once on the gate host with
  `GOWORK=off`; record the bashy, yoke and ycode SHAs and the binary SHA-256.
- Installation: fresh `HOME`, `BASHY_HOME`, `BASHY_FLEET_DIR`, private PATH
  with the pinned binary as `bashy`, writable disposable tracking store, two
  paired synthetic principals in fresh browser profiles, a private
  `E2E_CONTEXT` file holding resource references only. Readiness is the open
  `/login` endpoint, not the protected `/` (11-21 lesson).
- Apps registered with their shipped `register.sh`; the Genie child must see
  the disposable `BASHY_FLEET_DIR` (catalog placement lesson); the CLI
  handoff for a paired member uses the console-issued address and data path
  explicitly, read from the console's descendant process (discovery is
  local-operator only by design, C1b).
- Agent: the shared Sonnet binding already configured, named in
  `E2E_AGENT_ID`; a real agent must produce every candidate.
- Result reading: `E2E_<APP>_PASS` is a claim; the conductor checks each
  retained evidence log before accepting. BLOCKED or FAILED on any approved
  row is a red for step 8.

## Gates for `sprint end`

- Stories: C4 and C4b closed; the five earlier acceptances stand.
- Repositories: ycode, bashy and umbrella committed, pushed and pinned;
  `bashy mod drift` read for the touched modules (the pre-existing stale
  consumer pins in bashsharp and yoke are not this sprint's and are not
  repaired here).
- Runs: 133 and 134 terminal and pruned; no working run linked.
- Evidence: `docs/sprint-682-evidence.md` committed; scrub gate clean.
- Scorecard: the four bypass entries are a known auto-fail; read with this
  plan, not instead of it.

## Decisions for the operator

1. Launch the one approved paid matrix now (step 7), with the ycode pin
   bump included in the candidate and the lane shared with Sprint 697.
2. If a row is red after root cause: fund a second run, or close C4 on the
   runbook walkthrough plus the green rows and carry the red row as a todo.
3. Whether to schedule the operator pre-install for board, whiteboard and
   table rows before Sprint 683, or leave them as the follow-up todo.

## Not doing

Owner/producer shaping (Sprint 683); repairing the stale consumer pins of
other modules; any release; repairing the bypass history; a second paid run
without a decision.
