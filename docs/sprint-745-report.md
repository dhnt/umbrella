# Sprint 745 report: human-in-the-loop "needs you" routing

Sprint `79f14d8a-2015-5a93-ba77-60cb7f70e108`, epic `hitl`, 2026-11-28.
Conductor: claude-opus5.5-s745. Spec: bashy `shapeware/hitl/SKILL.md`.

## Outcome

An agent or sprint manager now puts a typed question to its human through
`bashy approve`, the existing queue of decisions waiting for a human:

    bashy approve request --kind decision --title "Ship the check-in hotfix?" \
        --option "ship:Ship now" --option hold --recommend ship \
        --ref sprint:741 --deadline 4h --urgency urgent --risk deploy --sprint 741 --key hotfix

- **Delegate.** The human designates one agent, normally the steward's:
  `bashy approve delegate --to NAME [--kind ...] [--sprint ...] [--allow-risk ...]`.
  In-scope requests go to it, and its answer is recorded on the human's behalf.
  Requests tagged `deploy`, `security`, `credentials`, `money`, `delete` or
  `access` stay with the human unless the human allows the tag.
- **Human only.** Only the human designates, revokes (`--revoke`) and
  overrides (`--override`). An override keeps the replaced decision.
- **Audit.** `approve list --all --on-behalf` lists what was decided on the
  human's behalf.
- **Alert.** What waits on the human is a Needs-you alert on the sprint board
  web UI. The signed-in owner answers it with the request's options; the
  unauthenticated loopback view shows the shell line instead. The sprint card
  (`bashy sprint show`) lists the sprint's open requests.
- **Resume.** `approve wait key:K` returns the answer, and the requesting
  agent is notified.

Delivered: yoke `04f13f6d` (pkg/ask, pkg/webconsole, pkg/weave) and bashy
`851b4c4f` (spec folder and yoke pin), then bashy `afafaea3` (reference commit, gate evidence,
parallel mutate) and `72365e3e` (stories accepted), and the umbrella pins.

## Route and review

The operator's review on 2026-11-28 rescoped the sprint:
- an alert on the sprint board is enough, and external channels are deferred
  to todo `8baccf0ce8be`;
- extend `bashy approve`, with as few subcommands as possible;
- the conductor folded H5 into H2;
- a sandbox e2e closes the sprint, and live accounts are proven later through
  software shaping.

The work followed the kb runbook `shapeware-issue-to-spec`:
- no shapeware surface covered approve, so a narrow `hitl` surface was lifted
  first; A-01 to A-06 pin the argv approvals unchanged;
- H1 to H4 became features: `needs-request`, `scoped-delegate` (critical),
  `board-alert` and `authenticated-answer` (critical);
- external channels became the `tbd` feature `external-channels`.

The operator asked for one report at completion, so gate 1 was settled by the
conductor. Every ruling is in SKILL.md "Decisions" (D1 to D9) and open
questions Q1 to Q3, for the operator to reverse.

A cross-vendor code review (codex) found five issues. Four were fixed before
merge:
- a paired-device session could answer as the owner;
- risk tags were case-sensitive;
- a narrowed delegation left a request stuck as delegated;
- an override had a gap that could lose a racing decision.

Three limits are recorded as known issues:
- KI-3: shell identity comes from the environment, so a hostile same-user
  process can pose as the delegate or the human;
- KI-4: the non-delegable set relies on the requester's risk tags;
- KI-5: a delegate answer can race a revoke.

## Evidence (fresh runs, the Windows test host's Linux lane)

| Check | Result |
|---|---|
| yoke `pkg/ask`, `pkg/webconsole`, `pkg/weave` unit tests | PASS (full packages) |
| yoke board browser tests (`-tags verifydom -run TestDOMSprint`) | PASS |
| cross-OS `go vet` of the three changed packages (linux, darwin, windows) | PASS |
| bashy build linux, darwin/arm64, windows/amd64; `go vet ./internal/agentos`; adapters | PASS |
| bashy `go test ./internal/agentos` at the bumped pin | PASS (466 s) |
| `conform spec check shapeware/hitl` | clean |
| hitl `test` (sandbox e2e: fake human, stranger, manager, delegate and intruder in a fresh HOME) | 39 of 39 PASS |
| hitl `cert` | PASS, 3 runs, none noisy (210 s) |
| hitl `alone` (lone copy, clone at the reference, build, test) | 39 of 39 PASS (66 s) |
| hitl `mutate` | 132/132 killed; 8 parallel shards (1481 s) plus the missed shard 0 as 8 sub-shards (381 s); serial was projected at about 50 min |

## Pre-existing failures (not caused by this sprint, recorded, not repaired)

| Finding | Evidence | Classification | Tracked |
|---|---|---|---|
| yoke `scripts/crossvet.sh` fails on every GOOS in the lane | identical failure at yoke origin/main 4b756baa; the lane's worktrees lack the `external/ollama` submodule | venue | this report |
| `shapeware/index.bsh check` fails every surface | identical at bashy origin/main b65f6960; bare `conform` reaches bashy's built-in conform, which has no `spec` | product defect, pre-existing | bashy todo `7dd90046` |
| `conform mutate` takes about 50 min for 39 assertions | every mutant reruns the whole contract, serially | judge performance | conform todo `1fe89580` |

## Judge time (operator rule, 2026-11-28)

The operator ruled that verification must not take longer than the fix. Here
`mutate` would have taken about 50 min serially. Running shards in parallel
cut that to about 25 min, which is still too long: each shard reruns a full
baseline, every mutant reruns the whole contract, and the seven cited go tests
dominate each run. The generic fix is conform todo `1fe89580` (stop a mutant
at its first killing assertion; run in parallel by default). Until it lands,
other surfaces' judges should shard the same way.

## Not done

- External channels (email, Klatch, Google, calendar timing, quiet hours,
  digests): deferred by the operator, todo `8baccf0ce8be`.
- Live-account proof: deferred by the operator to software shaping.
- The dev-host install and smoke of the new build is the operator's
  `bashy update`.
