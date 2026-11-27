# Sprint 732 report: a shared shaping ledger

Sprint UUID `f71a8649-8650-54de-9d57-9b5b04015fef`, epic software-shaping.
Plan: `docs/sprint-732-master-execution-plan.md` (revision 2). Conductor
claude-opus5.5; workers codex-gpt6.2-astra, claude-fable5.2 and
agy-gemini4-hydrogen. Started 2026-11-26 9:28 PM PST, all eight stories
accepted 2026-11-27.

## Outcome

Every agent shaping an app now inherits why earlier changes were made, what
they were expected to do, and what happened. That holds across vendors,
versions and the contractor hop. The record borrows the SIM idea (Self-Improvement
Memory, arXiv 2611.18856) on the existing workflow: the Sprint 730 decision
log is widened, not duplicated.

- Every attempt (wish, draft step, repair, push) logs its candidate, agent,
  principal, line, problem, base and revision, with the agent's `WHY:` and
  `EXPECT:`. Rejects, undo and restore are logged too, with whether a person or
  the system acted.
- The ledger is a fold over that log. Problems come newest first, and each
  attempt has a standing: active, restored, undone, superseded, rejected, failed,
  pending or later. Nothing is deleted.
- It is filtered by viewer. A member or contractor sees no host paths, board ids,
  other people's addresses, host actor or receipts. It is bounded for small
  contexts: open problems are shown in full, and closed ones as one line that keeps
  the live attempt's reasons.
- It is shown to every shaping agent: in four briefs (service wish, console
  wish, draft step, incident repair) inside a `LEDGER` fence, and as
  `.git/shape-ledger.json` in the work clone and in the verifier's clone.
- Read it with `bashy shape ledger APP [--base REV] [--max-bytes N] [--json]` or
  `GET /api/shape/{app}/ledger`. A contractor's `shape_pull` carries it.
  `shape_push` takes `why`, `expect` and `agent`.

## Stories

| Story | Delivered | Worker |
|---|---|---|
| L0 `6a8709362f55` | History, diff and incident reads use the wish scope check; members cannot write the owner's line (yoke `bb8cec4e`) | codex |
| `3895d1c38be7` | Site MCP member replies filtered (`MemberView`, yoke `d30dc26d`; bashy `1bb79469`); conductor closed the push-reply and failed-verify leaks (`be97dd45`) | fable, conductor |
| `759c57a66ff5` | `BASHY_DELEGATE_DEPTH`: a delegated child cannot delegate again (yoke `625c20d9`, ycode `cfa8bdc`); conductor pinned the genie module so it ships (bashy `7e292eb4`) | agy, conductor |
| L2 `e5b46eba0de6` | The record format on the decision log (yoke `717e14c0`) | codex |
| L1 `d25c43e7ebfc` | Fold, standing, bound, viewer filter, route and CLI (yoke `cfed8da2`, bashy `270bf1aa`); conductor added the candidate id per line (`997d9c1c`) | fable, conductor |
| L3 `ddfb81fa062f` | Ledger in four briefs and the work clone (yoke `d8adb72d`); conductor: verifier clone gets the file, member repair activates on the sealed line (`1a440575`) | agy, conductor |
| L4 `08b77aabb1f9` | Ledger on pull; why, expect and agent on push (yoke `7cba4b1d`, bashy `fbde5b38`) | codex |
| L5 `86e8a12324d7` | Acceptance e2e in the group-shaping harness (bashy `649bed00`); product fix found by it (yoke `65f6149a`) | conductor |

Final heads: yoke `65f6149a`, bashy `1663bd27`, ycode `2c7c7cf`. ycode's
stale sibling pins (yoke, coreutils, bashsharp) were refreshed to heads. Its
`go build ./...` passed, and `go test -short ./...` matches ycode main exactly:
the one red, `TestHarnessStreamWaitsForAppendNotifications`, is a known
baseline (todos `08ee6df70b5d`, `6ba1b4777931`). `bashy mod drift` now shows
only the designed bashy and ycode cycle.

## Verification

All runs were on the gate host lane 3, never the dev box.

- Each yoke story ran `go vet` plus `go test` for `pkg/shape/...`, `pkg/src` and
  `pkg/webconsole`. Each bashy merge ran the build, a Windows cross-build,
  `go vet` and the agentos shape/site/ledger tests. ycode ran
  `internal/harness/bashy` and `examples/genie`.
- Group-shaping e2e: 62 checks at sprint start, 65 after the member-view checks,
  and 78 with L5. Two consecutive runs on bashy `649bed00` passed, 78 ok and 0 not ok
  (`run-20261127T032920`, `run-20261127T033014`), and again on the final tip
  `1663bd27` (`run-20261127T035139`). The run takes about 70 s.
- The acceptance as run: X's member wish records why and expect. Y repairs an
  owner-raised incident; its brief carries X's reasons inside the `LEDGER` fence
  and its work clone holds `.git/shape-ledger.json`. The incident files under
  X's problem. Undo then restore change standing only. C's pull carries the
  filtered ledger, and C's push is recorded with C as principal, C's reasons and
  C's agent. A, who has edit scope only, is refused pull and push.
- The check that a frozen verifier check can read the ledger is a unit test
  (`TestCopyWorkLedgerIntoIsolatedClone`). The e2e proves the read by a step in
  the work clone.

## Findings (root cause recorded; fixed in this sprint)

1. **Member push reply leaked the owner's address, and a failed verify leaked host
   paths** (product). Fixed in bashy `be97dd45`. Three expectations asserted the
   leak and were updated: the unit test `TestSiteMCPMemberSourceTransfer`, and
   `sandbox.py:220`, found by the first e2e run after the merge.
2. **Ledger attempts could merge.** Console draft and repair lines carried no
   candidate id (product). Fixed with an explicit `candidate` field (yoke `997d9c1c`).
3. **The verifier's isolated clone never saw the work-clone ledger** (product).
   It is now copied in (yoke `1a440575`).
4. **A member's incident repair activated on the member's line**, while its evidence
   was sealed for the owner's line (product, pre-existing). It now uses the
   activation line, with the member as author (yoke `1a440575`).
5. **The e2e stub agent replayed the wrong edit** once briefs quoted earlier
   requests (test defect). It now reads only the REQUEST fence (bashy `53fd349a`).
6. **The bounded ledger hid the reasons for what is live.** An incident joins a
   closed problem, which is shown as one line (product, found by L5). The summary
   now keeps the live attempt's why and expect (yoke `65f6149a`).
7. **The genie allowlist for the depth fix was not shipped.** bashy pins
   `ycode/examples/genie` on its own replace line (found by `bashy mod drift`).
   It is now pinned, with a test (bashy `7e292eb4`).

## Left out, recorded as future input

- A trace id as evidence. Attempts cite `shape-evidence:<rev>` or the incident id.
- Rotation of the host-wide decision log. The view is bounded; the file is not.
- Members linking a follow-up to an existing problem by its alias (an owner
  decision).
- `yoke/pkg/webconsole/shaped_delegate.go` keeps an unused copy of the delegate
  env allowlist; consolidate it.
- A stale-refused approval leaves the attempt `pending`. The candidate is still on
  disk and cannot activate. A `stale` standing would read better.
- Auto-repair still needs a named base release (todo `0924f59ba807`). The e2e
  releases the active version first.
