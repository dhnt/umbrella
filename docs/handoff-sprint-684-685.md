# Handoff after Sprints 684 and 685 (group shaping)

Written 2026-11-24 by the supervisor of both sprints, for whoever conducts
Sprint 699 (release train) or Sprint 703 (follow-ups) next. Detail and
evidence: `sprint-684-685-master-execution-plan.md`. The sprint cards and
stories are authoritative.

## State in one screen

| Sprint | State | What it is |
|---|---|---|
| 684 | done, 4 of 4 | revision store in the desk kit; Page, Session and Notepad adopt it |
| 685 | done, 2 of 2 | `meet poll` ballot fix; coverage matrix |
| 703 | backlog, not reviewed, nobody assigned | every bug and issue still to resolve from 684 and 685: 18 stories, first one (F0, p0) is the pin cleanup below |
| 699 | backlog | release train; integration stories I1 and I2 of this epic live here |

Merged heads from these sprints: bashy `9135c8c8` (features; later pin-only
commits follow), yoke `c2d6591f`. No release, no tag, no hosted-plane change
was made.

## Do this first, before any freeze, tag or release cut

The pins were NOT clean when these sprints closed: Sprint 675's coreutils pin
sync was in flight and is the next writer of them. Do not cut anything until
all four checks pass on the commit you intend to freeze.

1. Fetch every repository, then run at the umbrella root:

   ```bash
   bashy mod drift
   ```

   Required: no `stale` row. Known stale on 2026-11-24: bashy → bashsharp and
   ycode → bashsharp (pinned `fa2401af`; bashsharp `main` had `abe0538`, then
   `08fabb3`). A `cycle` row for the bashy/ycode pair is expected, at one
   commit: those two modules require each other.

2. Check every umbrella gitlink against its repository's default-branch head.
   Known behind on 2026-11-24: bashsharp, coreutils, yoke, outpost.

3. If either check fails: ask on `bashy mb` who is syncing (Sprint 675's
   manager was), take the claim, and bump producer first with `bashy mod sync`;
   the bashy/ycode pair by hand. Forward only: a new gitlink must contain the
   one on origin (`git merge-base --is-ancestor OLD NEW`). Commit to the
   umbrella from a worktree on the origin head with a pathspec, never from the
   shared checkout's local `main`.

4. Build and unit-test each changed consumer on the gate host through the
   venue wrapper, and compare test results BY NAME with the run before the
   pin change, in the same venue, on an idle lane.

## Known red tests (carry as failures, never as passes)

| Test | Where | Tracking | Note |
|---|---|---|---|
| `TestHarnessStreamWaitsForAppendNotifications` | ycode `pkg/ycode` | `08ee6df70b5d`, Sprint 703, p1 | real defect: with a current bashy the agent's kb lookup returns no context; needs the operator's ruling on what the kb command may receive before any code |
| `TestStandaloneHelpAndDeps` | `bashy/yoke/fetch` | `bf5c8c71f65e`, Sprint 703 | fails before and after these sprints' pin changes; not yet investigated |
| `TestBenchmark_QualityLatency`, `TestTUIOverPTY`, `TestTUILiteralHandoffOverPTY` | ycode | `5469f847be3f`, Sprint 703 | fail only when the gate host is busy; pass on an idle lane |

Any failure not in this table is new and blocks.

## The gate venue

`script/gate-lane.sh` is the venue. On the Linux gate lane it is installed
as `gate-lane`: `gate-lane check` is the preflight (must print `ok`),
`gate-lane run CMD` runs a command in the venue (Go equal to the `go.mod`
toolchain, a bashy with the local module proxy, warm Go caches, no
controlling terminal). Desk apps test with `GOWORK=off` from their own
directory; suites that build sibling binaries (bashsharp) need an umbrella
checkout with submodules. A candidate module version is built only against a
private proxy and private caches; the shared proxy sees a version once, after
acceptance.

## What to start next

- **Sprint 699, I1 and I2** are this epic's integration tests. I1 is the
  group-shape skill-script on Page, Session and Notepad; I2 is the Klatch
  owner/member workflow (the operator confirms before that instance is
  started). Run them on integrated main at the frozen commits.
- **Sprint 703** must be reviewed with the operator before anything is
  assigned. Order: F0 `c901b030` (pins at heads, p0; it is the check in the
  section above and gates the release train); then the two p1 stories: the
  agent kb bug `08ee6df70b5d`, which needs a decision before code, and the
  kit handler lift `60b4624b22f9`, which should land before another app
  adopts the store; then the p2 bugs (red tests, test teardown, board, fleet
  probe, viewer, gate host bashy, weave resume); the p3 items last (shared
  agent name, sprint comment author, `ps` keywords, and the four coverage
  follow-ups: whiteboard, storyboards, brainstorm registration, table).

## Lessons for the next manager

- Record worker rules on a story before assigning it; after that, a manager's
  commit to that story's file is logged as a bypass and fails the scorecard.
- `sprint assign` and `sprint accept` write the story file only in the shared
  checkout: publish status and assignee to origin yourself (story
  `de2aa2298503` asks the board to do it).
- Use fresh runs; `weave start --resume` spins (`5771d343ce2a`).
- The fleet probe can call an agent usable when its vendor quota is
  exhausted (`255b1585220c`). If a new manager posts nothing within a few
  minutes, read its session log before waiting longer.
- A green test that turns red gets an investigator first: name the tests,
  compare venue and commit with the last green run, classify, record, then
  fix where the cause lives.
