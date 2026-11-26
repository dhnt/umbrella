# Sprint 637 master execution plan: reminders that fire

Sprint UUID: `a8b3d759-ebd1-5fe5-b44c-ae68c465f22f`. Epic: collaboration. Status: backlog, planning only until the operator starts it. Reviewed with the operator 2026-11-25.

## Context

A reminder set through any bashy front door is stored in `coreutils/pkg/schedule`, but the engine (`schedule` fleet unit) is opt-in and nothing tells the user when it is off. The sprint was filed planning-only 11 days ago. This review re-checks every story against current heads and live state, trims the sprint to its MVP, and lays out execution. Nothing starts until the operator starts the sprint.

## Code inspected (2026-11-25; coreutils f9833f72, yoke d617ba6a, bashy 6af53a3c)

| Claim | Now |
|---|---|
| No engine-state check in `coreutils/pkg/schedule` | Still true. Only `claimDaemonAdmission` (`service.go:14`, used at `schedule.go:684`). One commit since filing (219d672b, 11-19) touched shell paths only. |
| Unit opt-in, disabled | Still true: `yoke/pkg/fleet/baseline/services/schedule.yaml` `enabled: false`; `bashy service status` shows `schedule false inactive`. |
| Jobs never fired on the dev box | **Changed.** `last_run` is now 2026-11-22 04:11 PST on the 15m jobs: an engine ran after filing and stopped silently on 11-22. 7 of 8 jobs are on and 3 days overdue, still with no warning. Who ran it and why it stopped is unknown. |
| `NotifyEvent` comment is stale | Still true: callers are `notify.go:244` and `yoke/pkg/todo/notify.go:59` only. |
| No kb page for reminders | Still true (`bashy kb search reminder`: none). |
| Calendar F1 needs acceptance notes | **Moot.** Sprint 616 is done; `bashy/examples/calendar/README.md` already names `bashy schedule` as the reminder route and settles on 404. |
| No overdue-todo notifier, no Windows toast | Still true. `todo --json` already carries `overdue`; `usage-alarm.bsh` is the model. |
| Related | S632 E3 (6a4586c7) is wontfix. Comms C3/C6 are todo, in no sprint. 8624c8fab52e stays separate. |

Existing pieces to reuse: `coreutils/pkg/nudge/nudge.go` (the `bashy-hint-v1` stderr hint emitter, off with `BASHY_HINTS=off`), `coreutils/pkg/lockfile` `Owner(path)` (read-only holder lookup), `claimDaemonAdmission` lock path, `bashy/examples/llm-usage/usage-alarm.bsh`.

## Triage

| Story | Verdict | Change |
|---|---|---|
| **R1** 80394689a60f p1 bug | **Keep; change coreutils in place, coordinated with Sprint 385** | Operator 11-25: one scheduler code base, no duplicate in yoke (avoids sync and drift); make the needed changes in `coreutils/pkg/schedule`, coordinated with the POSIX certification sprint manager because POSIX is not yet certified. Engine state = daemon lock holder + overdue count. Hint on `schedule add` and `notify --in/--at`. `schedule list` (text and `--json`) gains engine state. Whether `at`/`batch`/`crontab` also print the hint is the 385 manager's call; default is no change to their output. Add the 11-22 silent-stop finding to the body. |
| **R2** bbb480c01f56 p3 chore | **Keep, decide: delete the comment** | `notify --in` already is the one-line reminder; wiring five applets is feature work on POSIX names. Conductor, own commit. |
| **R4** a9915c7ff9e8 p2 doc | **Keep, shrink** | kb runbook only, in bashy `kb/defaults`. Drop the Sprint 616 comment and the 403/404 item (both resolved). Add one README line in `examples/calendar` naming `notify --at/--in`. Depends on R1 (cites the hint). |
| **R6** e79e4ac55079 p2 chore | **Keep, refresh, operator-owned** | Rewrite body with current facts: jobs fired until 11-22; two jobs call a Go 1.26.0 path (baseline is 1.27.4); one `echo ok` test job; one job already off. Operator prunes and decides on `bashy service enable schedule`. Record what ran the engine and why it stopped. |
| **R3** 302a91ea9f57 p2 enhancement | **Move out of 637** (unlink, keep as todo, p3) | New feature, not needed for "fires or says why". |
| **R5** 77b9b977826d p2 feature | **Move out of 637** (unlink, keep as todo) | Three-OS feature with a Windows test matrix; belongs with comms C3/C6 when those are planned. R4 states "no desktop toast on Windows yet". |

Resulting sprint: R1, R2, R4, R6 (4 stories). Goal items r3 and r5 are removed from the checklist.

## Step 1 — triage updates (done 2026-11-25; no code)

1. `bashy todo edit` the four kept stories (`--note` re-supplies the full body plus a "Code inspected 2026-11-25" line); R3 and R5 `--sprint 0 --priority p3` with a note pointing back to 637.
2. Write `docs/sprint-637-master-execution-plan.md` (this plan, scrubbed: hosts by role) and add its line to `docs/INDEX.md` and abstract to `docs/README.md`.
3. `bashy sprint edit 637 --spec docs/sprint-637-master-execution-plan.md`; `bashy sprint comment 637 "…" --kind review` with the triage summary.
4. Commit in the umbrella with pathspec (`git commit -- docs/todo/<6 files> docs/sprint-637-… docs/INDEX.md docs/README.md`), `Adhoc:` trailer, add+commit in one command. The three already-modified 722 story files are not mine and stay out.

No `sprint take` or `sprint start`: the sprint stays in backlog until the operator starts it.

## Step 1b — coordinate with the Sprint 385 manager (before any R1 code)

Sprint 385 (*Official POSIX certification preparation*, doing) is managed by `agy-gemini4-carbon`. The scheduler store, the daemon lock and `at`/`batch`/`crontab` are in its area until certification.

1. Send the manager one message (`bashy mb`) and record the same text as a `--kind note` comment on Sprint 385 and on story R1:
   - **Proposed coreutils change (637 R1):** in `pkg/schedule` only — a new read-only `EngineState()` (lock holder via `lockfile.Owner`, overdue count), one engine line and `engine` JSON object in `schedule list`, one `bashy-hint-v1` hint on `schedule add` when no daemon holds the lock. No change to the job format, state path, lock path, `pkg/lockfile`, or to `at`/`batch`/`crontab`/`atq`/`atrm` output.
   - **Questions:** does any of the 67 non-pass resolutions touch `pkg/schedule`, `pkg/lockfile`, the job format, the lock, or the at-family applets, landed or in flight? Does any certification test observe `schedule list` output or stderr of a command that reaches `schedule add`? May the hint also be printed by `at`/`batch`/`crontab` (default: no)? Which coreutils head should R1 branch from, and when may it merge without disturbing a frozen candidate or evidence run?
2. R1 does not start until the manager answers; the answer and the agreed merge window are recorded on R1.
3. The R1 coreutils commit is sent to the 385 manager for review before merge, and announced on `bashy mb` when merged so 385 lanes rebase onto it.
4. If 385 has scheduler or lock work in flight, R1 waits and rebases onto it. R2, R4 and R6 proceed meanwhile.
5. If the manager reports that R1 would invalidate a frozen candidate or sealed evidence, R1 is held until 385 releases the freeze; this is reported to the operator, not worked around.

## Step 2 — execution (after the operator starts 637)

Before any code: fetch coreutils, yoke, bashy; `bashy mod drift`; bump to heads; claim the pin bump; `bashy mb` what is changing; check `ListAgents`, `bashy weave list`, `bashy claim list`.

| Order | Story | Repo | Owner | Size |
|---|---|---|---|---|
| 1 | R1a engine state + `schedule list` + hint on `schedule add` | coreutils `pkg/schedule` | agy-gemini4, in the window agreed with 385 | < 30 min |
| 2 | R1b hint on `notify --in/--at` | yoke `pkg/bus/notify.go` | agy-gemini4, after R1a is pushed and pinned | < 20 min |
| 2 | R2 delete stale comment | yoke `pkg/bus/notify.go:37` | conductor | 1 line |
| 3 | R4 kb runbook + calendar README line | bashy `kb/defaults`, `examples/calendar/README.md` | conductor | small |
| any | R6 dev-box hygiene | none | operator | — |

R1 stays one story; a/b are its two commits (producer coreutils pushed first, then yoke).

**R1 design.** In `coreutils/pkg/schedule`, next to `claimDaemonAdmission`: `EngineState()` reads the lock holder with `lockfile.Owner` (never takes the lock, so no race with a starting daemon) and counts enabled jobs whose `next_run` is past; exported so yoke's `notify` calls the same function. The `schedule add` command handler (not the shared store path that `at`/`batch`/`crontab` use) emits one hint through `pkg/nudge` when no daemon holds the lock: "schedule engine is not running: this job will not fire. `bashy service enable schedule`, or `bashy schedule tick` to fire due jobs once." The job is always stored; exit code unchanged. Nothing is added to the stored job format. The first thing the worker confirms is the call path from the at-family applets into the store, so the hint cannot reach them.

**Tests (targeted, on a claimed gate-host lane, not the dev box):** coreutils `go test ./pkg/schedule/... ./cmds/at/... ./cmds/batch/... ./cmds/crontab/...`; yoke `go test ./pkg/bus/...`; `GOWORK=off` after the pin bump. New cases: no holder → hint + job stored; holder present → no hint; `BASHY_HINTS=off` → no hint; `list --json` carries `engine`; at-family output byte-identical with the engine off. Existing tests stay green by name. Any POSIX conformance rerun is the 385 manager's decision, in the official venue.

**Merge:** submodule commits with `Sprint:/Story:/Story-ID:/Agent:` trailers, pushed submodule-first; `bashy mod sync` (coreutils → yoke → bashy); one umbrella pin bump `sync: bump coreutils + yoke + bashy pins (Sprint 637 R1/R2/R4)`. No release, no deploy; ships with the next train.

## Verification (sprint close)

- Engine off: `bashy schedule add --every 1h -- true` and `bashy notify --in 1h --to <agent> x` each print the hint and the job appears in `schedule list`.
- Engine on (`bashy schedule daemon` in a scratch `BASHY_HOME` on the gate host): no hint; `schedule list` shows the daemon pid.
- `at`/`batch`/`crontab` output unchanged with the engine off.
- 385 manager's answer and review recorded on R1.
- `bashy kb search reminder` finds the runbook.
- `grep NotifyEvent yoke/pkg/bus/notify.go` comment matches the callers.
- `bashy mod drift` clean for coreutils, yoke, bashy.
- R6: decision recorded on the story by the operator.

## Risks

- **Uncertified POSIX baseline:** R1 changes coreutils while 385 is preparing certification. Controlled by Step 1b (scope agreed first, manager review before merge, agreed window, hold if a candidate is frozen) and by keeping at-family output unchanged.
- **Stale lock after a crash:** the worker confirms how `lockfile.Owner` reports an orphaned lock; a pid-alive check is added in `EngineState()` if needed.

## Operator decisions (defaults above apply unless changed)

1. Move R3 and R5 out of 637 (default: yes).
2. R2: delete the comment rather than implement `--notify` (default: delete).

Decided 11-25: the scheduler stays one code base in coreutils (no yoke duplicate); R1 changes it there, coordinated with the Sprint 385 manager.
