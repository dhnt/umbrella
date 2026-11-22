# Sprint 692 plan of record: release v1.0.0-rc.40, the thin bashy core + shapeable commands

Rescoped by the operator on 2026-11-22 (KISS/MVP). Supersedes the 677-closure scope in
`handoff-sprint-692.md`, which stays as history. Conductor: claude-fable5.1.

## The one goal

Tag and release **v1.0.0-rc.40**: bashy = the invariant core (`bsh`: Bash 5.3 + Bash# + the
POSIX-required coreutils, plus the internal bashy verbs: model/agent/tool, commands, app, skill,
self, and the dispatcher) and every other command (`optional/`, `toolchain/`, `yoke/`, `custom/`,
`examples/`) an independently built, shapeable binary reached through its Bash# adapter. The
command surface is unchanged: users still type `bashy <verb>`.

## Where we start (bashy main 4d926bd1)

Sprint 677 delivered `bsh` as its own module (`bashsharp/cmd/bsh`, zero yoke, 86/86 both modes)
and one adapter + `main.go` per command. bashy's hand-written switch already calls the adapters
(`internal/agentos/adapter_dispatch.go`), so dispatch is the production path. What is left:

1. bashy still links the old in-process command code beside the adapters (about 2,276 packages,
   241 MB). Removing what no case uses is P5 (`aa693f4a`), the only feature in this sprint.
2. Two adapter first-use defects: cold build fork-bombs under `BASHY_AGENTIC=1` (`42f79daa`) and
   fails inside git hooks because of inherited `GIT_DIR` (`3dd8b4ec`).
3. `bashy dag test` on the gate host had 15 failures at d9598792 (`3043a867`); the env-leak fix
   (`22d478f9`, bashy 86c645bc) is merged and clears part of them.
4. The vulnerability gate passes only under a logged operator override (`3f6a38f3` C, `0774dc22` C2).

## Done when

- (a) `go list -deps ./cmd/bashy` contains no package from the five command folders and no dead
  in-process command wiring; a link test (modelled on `bashsharp/cmd/bsh/main_test.go`) enforces it.
- (b) `gate.final` is green on the gate host in the official image with the frozen candidate:
  `bashy dag build`, `bashy dag test`, sealed Bash 5.3 gate 86/86 both modes by fixture name.
- (c) The 3-OS dispatch e2e (`TestE2EAllListedCommandsDispatch`) passes from a fresh install with a
  cold adapter cache (Linux lane, Windows native on the gate host, macOS QA host).
- (d) The local release gate receipt passes with the vulnerability override retired.
- (e) rc.40 is built once from the `-dev` tag, gets a tier verdict, and is promoted on the
  operator's typed go.

Out of scope (operator decisions 2026-11-22): one `go.mod` per command (follow-up planned sprint;
rc.40 keeps per-folder pins), size and build-time targets, WSL keep-alive, symbol strip, catalog
dispatch wiring, any new feature.

## Stories

| id | story | priority | owner (vendor) |
|---|---|---|---|
| 42f79daa + 3dd8b4ec | adapter first-use bugs (bashy store) | p0 / p1 | codex |
| aa693f4a | P5 contract: bashy = bsh + dispatcher + internal verbs; import-boundary test; decision record | p0 | claude |
| 3f6a38f3 + 0774dc22 | dependency bumps for reachable advisories, fresh govulncheck, override retired | p0 | agy (gate-host lane) |
| 3043a867 | dag test red: root cause, classify, fix where the cause lives | p0 | muse (gate-host lane) |
| 458628c0 | rc.40 candidate gate: gate.final + 3-OS dispatch e2e on the frozen tip | p0 | agy (gate-host lane) |
| release story | changelog, receipt, `-dev` tag, one release.yml run, tier verdict, promote | p0 | conductor |
| 22d478f9 | adapter env leak | done (merged 86c645bc) | accepted |

Closed wontfix in this rescope: K1/K1b/K1c WSL keep-alive (`73dbfa3a`, `ffd48cc9`, `80b2540c`;
design note kept in `plan-wsl-keepalive-supervisord.md`), S2 symbol strip (`ec0a696b`),
per-command build-time table (`40a432e3`), bsh benchmark (`fa807380`). Sprints 575 and 656 were
ended the same day; their open stories are wontfix with the reason on each story.

## Waves

- **Wave 1** (parallel, disjoint files, at most three headless runs on the dev box at once):
  codex bugs; claude P5; agy C/C2 with govulncheck on a claimed gate-host lane; muse 3043a867 on
  another lane. Merge order: C/C2, codex, P5 (rebases and tidies go.mod), muse. The conductor bumps
  consumer and umbrella pins after each merge.
- **Wave 2**: candidate gate on the merged frozen tip (agy, gate-host lane). Evidence appended to
  `sprint-677-integration-evidence.md`. A red leg is root-caused on `3043a867` or its own story and
  fixed by the same vendor; only the red leg reruns, plus the Bash gate if engine inputs changed.
- **Wave 3**: release by the conductor following `bashy/docs/release-runbook.md`: local release
  gate receipt as a Git note, `evidence_commit`, `v1.0.0-rc.40-dev`, one `release.yml` run, tier
  verdict on the QA hosts, QA refs, bare tag and `promote.yml` on the operator's go.

## Rules (binding, from CLAUDE.md and the card)

Start every story on current heads (`bashy mod drift`, bump pins, resolve first, rebase before
submit). Unit tests per story; integration only at the candidate gate. Heavy runs only on claimed
gate-host lanes in the official image, never the dev box. Root cause recorded on the story before
any fix; venue problems are fixed in the venue. Expand, switch, contract: P5 deletes only what is
dead. Every commit carries Sprint/Story/Story-ID trailers plus Agent; submodule commit and push
first, then the umbrella pin. Hosts by role only. No tag or publish without the operator.

## Gate loop rules (operator, 2026-11-22: "do it in this sprint")

The purpose of this sprint and its predecessors is a fast build and release
loop for software shaping: the certified shell separated from the rest, every
bashy tool built on its own. The candidate gate must follow the same idea. One
red cost about an hour in the first three runs (story, hand-off, merge, full
serial rerun on a cold cache); these rules cut that to the cost of the leg.

1. **Legs run in parallel.** After `dag build`, legs 2 (`dag test`), 3 (sealed
   Bash gate), 4 (dispatch e2e per OS) and 5 (shaping smoke) are independent.
   The gate worker claims two gate-host lanes plus the Windows-native and macOS
   resources and runs them concurrently; a full run is bounded by the
   `go test` body (about 15 minutes), not the sum of the legs.
2. **Rerun only what the fix touched.** The sealed Bash gate reruns only when
   an engine input changed (bash, bashsharp, sh, coreutils pins or sources).
   Dispatch e2e reruns only when the adapter path or an adapter template
   changed. A test-only fix in a package reruns leg 2 alone. The last run that
   covered every leg at the frozen tip, plus the leg reruns on later tips,
   together form the candidate evidence; the evidence doc names which run
   covers which leg for the tip that is tagged.
3. **Warm cache for intermediate reruns, fresh cache for the final run.** A fix
   verification reuses the lane's cache volume. The run that produces the
   evidence for the tagged tip uses a fresh volume, as before.
4. **The gate worker fixes test-class and venue-class reds in place.** Root
   cause and class are recorded on the story first (unchanged rule). When the
   class is test or venue, the same worker fixes it, re-executes that test or
   target in the image, and commits; the conductor merges and reruns the
   affected leg. Product-class reds still get their own story and owner. The
   sealed Bash gate is never edited by this rule.
5. **No masked failures.** Every `go test` body runs with a timeout large
   enough for the biggest package on the capped lane (`-timeout 30m` today),
   so a run reports every failing name the first time.

These rules apply to the remaining cycle of this sprint (leg 2 rerun after
`TestToolShortcutE2E`, then the release) and are inherited by follow-up
sprints.
