# Sprint 616 master execution plan: collaboration MVP follow-ups

Sprint 616 `b1288158-05dc-57cc-8abe-0bef9d310d11`, epic `collaboration`. It closes the Sprint 614 carry-over. Reviewed 2026-11-11.

## Authorization and source of truth

This is a planning document only. The sprint stays in backlog, unclaimed, and all eight stories stay in todo until the operator starts it. Planned owners are not assignments. The card and the story bodies are authoritative. This plan records the reviewed sequence, the facts verified in the code, the delegation and the gates. The sprint's acceptance is unchanged: KISS/MVP, one-way web-to-CLI parity, placement in `examples/`, shaping hooks, and root cause before fix.

## Baseline (2026-11-11)

| Item | Value |
| --- | --- |
| Pins = checkout HEADs | bashy `292fa022`, yoke `d0ba2a11`, outpost `614654e7` |
| cloudbox (private, `dev`) | `07411af` = HEAD. The suites/circle server landed earlier; `07411af` is the console bundle. |
| Known red | F3 collaboration-e2e (pre-existing, never recorded green); F4 `TestToolFenceRejectsCatalogDriftAfterAnalysis` |
| Dev host disk | about 35 GB free (93% full). Sprint grade attempts take about 9.5 GB and nothing reclaims them. |
| Installed bashy | built against an older yoke, so it rejects `weave start --base` (see F7-2) |

## Story review: verified at source

| Story | Pri | What was verified | Scope after review |
| --- | --- | --- | --- |
| **F1** calendar MVP `eebd9e94a8b9` | p1 | `examples/calendar` does not exist. Desk `kit` and `contracttest`, the `memo` fixture and the notepad CLI/invite patterns can be reused. There is no ICS code anywhere. No Desk tool has save/load-to-dir. `examples/google` already has the calendar verbs. | As the story says. Roughly 1.5–2k lines (Go server and CLI, a minimal ICS subset, tests). New pieces: the event entity with an IANA tz, the agenda page, ICS read/write with idempotent `source.uid`, save/load to a Git dir (the tool itself never runs git; composes `collab-save`), and Google import/export that composes `examples/google`. |
| **F2** deployed suite→circle e2e `14bb7d2b5eab` | p1 | The existing multi-satellite e2e harness has no suite/circle scenario. The share-revoke scenario is the template. The yoke `bashy suite` verbs and `outpost apps share --circle` are at HEAD. The released rc.27 predates them. | Add one scenario (200 / 403 / 401, plus live revoke when a member leaves the circle or an app leaves the suite). Run it with the harness's local-build mode at the candidate commits. Before asserting, confirm the server's 401-vs-403 split. Change server code only for a recorded defect. |
| **F3** browser e2e root cause `be9b532f76da` | p2 | No last-green venue or version is recorded anywhere. The only runs on record are failures (node 22.11, Playwright 1.65, Chromium 1254). Preflight checks only that node exists, not its version. The brainstorm runner was last touched on 2026-11-07, after the gate was built. | Step 1 is to establish whether it was **ever** green (git history of the runners and the gate). If never green, classify it as a test/venue defect, not a regression. Bisect the brainstorm runner change. Add a `node >= 20` preflight. |
| **F4** TestToolFence root cause `c0f8d08479ff` | p2 | Reproduced on the dev box (targeted test). Probable cause: yoke `2094f216` (catalog memo, 2026-11-10) returns a shallow `slices.Clone`. The fence's analyzed snapshot therefore shares `Commands` with the cache, and drift goes undetected. In the `slash` subtest the drifted call is **dispatched**. | This is a product defect in yoke. First confirm the cause by bisect (the todo claims it was red before that date, so check). Then deep-copy at the memo boundary, add a yoke regression test, and bump the yoke pin. |
| **F5** cloudbox macOS build `8d0750959802` | p3 | The k3s-backed part is confined to a few files. The API layer uses none of it. The stub surface is about 3 symbols, and a few pure helpers move to an untagged file. | Small and low-risk. Linux behavior unchanged. Proven by macOS `go build`/`go test` of the API, handler, db and server packages, plus the Linux full set. |
| **F6** fleet auth probe `5b3c245aae22` | p3 | The default fleet roster probes bare tools with no model. The ready classifier treats unrecognized output as OK. The model-error signatures lack `model_not_found`. The agent `codex-gpt6.1-sol` exists only as a host-local agent file, and its model is not in the catalog. | Probe each agent's bound model. Add the signature. Treat unknown output as UNKNOWN, not READY. The host-local agent file is cleanup on that host, not a code change. |
| **F7** weave/sprint friction `64b3fab2aabd` | p3 | (1) grade tamper diff against the original base: present. (2) `--base`: **not a code bug**, a stale install. (3) merge cleanliness ignores `info/exclude`: present. (4) KB.md is *tracked* in bashy and yoke, so excluding it cannot work and workers commit it: present. (5) merge leaves the run undecided: present. | Fix (1), (3) and (5) in yoke with regression tests. Fix (4) in the repos: untrack KB.md and gitignore it. Close (2) as venue, fixed by reinstalling from HEAD. |
| **F8** disk hygiene `bf2f149daa87` | p3 | Several pruners already exist (`weave gc`/`prune`, `sprint prune`, the `bashy prune` overview, a shared GOCACHE LRU cap). Missing: reclaim of sprint grade attempts, host build caches outside weave, and a single check verb. | Add a grade-attempt pruner (ended sprints, age-based) and a host-cache pruner as registered `bashy prune` rods with `--dry-run`/`--json`. Never touch live runs. |

## Delegation (spread across vendors; claude conducts, reviews, gates and merges)

| Lane | Stories | Repo · area | Planned worker |
| --- | --- | --- | --- |
| A | F1 | bashy `examples/calendar` | codex-gpt6-sol |
| B | F4 | yoke `pkg/fleet` memo, then the bashy pin | opencode-glm-5.3 |
| C | F2 scenario authoring | cloudbox e2e harness | claude-sonnet5.5 |
| D | F5 | cloudbox cluster package | agy-gemini3.8-flash |
| E | F6 | yoke `pkg/weave` fleet probe, `pkg/agentctl` | muse-spark1.3 |
| F | F7 → F8 (serial; both near sprint grade) | yoke `pkg/weave`, `pkg/prune`; repo `.gitignore` | codex-gpt5.6-sol (F7), opencode-glm-5.3-flash (F8) |
| G | F3 root cause | bashy collaboration-e2e, Linux test host | claude (conductor) |

Lanes are carved by file so they do not collide. The yoke lanes B, E and F share one yoke integration: merge them sequentially, then make **one** yoke pin bump in bashy (go.mod, `src_mount.go` pins, regenerated goldens) and in outpost.

## Sequence

**Wave 0: conductor, before start.**
- Reinstall bashy from HEAD. This closes F7-2 and stops workers from hitting the stale flag.
- Reclaim ended-sprint grade attempts by hand. Keep at least 50 GB free.
- Take the `host:` claim for the Linux test host.
- Record a priority override on the card so that p2/p3 lanes run in parallel with the p1 lanes. They are file-disjoint, and the card enforces priority-first focus.

**Wave 1: parallel.** A (F1), B (F4), C (F2 authoring), D (F5), E (F6), and F starting with F7.

**Wave 2.**
- F8 after F7 merges.
- G (F3) on the Linux test host: find the last green, reproduce, bisect venue vs code, record the cause, fix where it lives.
- Merge the yoke lanes, then do the single pin bump.

**Wave 3: one final validation pass on the Linux test host, after all features land.** This is the only e2e run:
- F1 browser round trip and desk contract.
- collaboration-e2e (F3).
- F2 scenario against a satellite built from the candidate commits.
- Relevant bashy/yoke/outpost targeted suites.
- cloudbox full set (F5).

Then pin bumps, one shared evidence record, and sprint end.

## Gates

- Per story: targeted `GOWORK=off go test` of the touched packages on the dev box, plus the story's own done-when.
- cloudbox tests run on Linux until F5 lands. After that, the macOS unit subset also runs.
- Heavy and e2e runs happen only in Wave 3, on the Linux test host, with evidence tied to candidate SHAs.
- Pre-existing failures stay tracked by name, never skipped silently. A new failure or a newly skipped green test blocks closure.

## Shaping and composition

- **F1:** calendar is an `examples/` Desk app. Every page action is a CLI verb with a `bashy-calendar-v1` JSON envelope, so shaping can rewrite the page or compose verbs. ICS and Google import/export are verbs over plain files that compose `examples/google`, not a sync engine. There is no recurrence, RSVP, reminders, CalDAV or sync.
- **F8:** small pruner rods registered under the existing `bashy prune` overview. The "check and reclaim" helper is a thin composition, not a new monolith.

## Open decisions for the operator

1. **F1 audience status:** notepad returns 403 to non-members, but the calendar decision doc says 404. Plan: calendar follows the doc (404). Notepad's 403 is filed as a separate todo and not changed here.
2. **F7-4:** untracking KB.md in bashy and yoke changes repo content that every worker sees. The plan proceeds unless the operator objects.
3. **Dogfooding:** F7 changes the grade/merge tooling this sprint itself uses. Merge F7 early, reinstall, and use the new binary for every later merge.

No release is authorized by this sprint.
