# Sprint 617 master execution plan: bashy dogfooding through software shaping

Sprint 617 `08692c1f-daed-5ad4-831e-c24feb4b9ac8`, epic `software-shaping`. Status: backlog, unclaimed, 0/10 stories closed. Reviewed 2026-11-11 against the source at the current pins.

## Context

The goal is to shape bashy with bashy. Changes flow from local installations, to the qiangli/* staging repos, to the new dhnt/* upstream. Shaping becomes mandatory in stages, gated by real pilots: first skill-scripts, then the CLI, then coupled native changes.

The card says this is planning only. Nothing is executed or released until the operator starts the sprint. This plan:
- checks every story against the code,
- records the gaps the stories assume away, and
- fixes the sequence, lanes, venues and two operator decisions.

**Operator decisions (2026-11-11):**
- **(a) Trusted check.** The trusted evidence check is a **required status check on the dhnt/* protected branch**. It runs only the bundle verifier, with no tests, on a self-hosted runner. There is no cloudbox dependency.
- **(b) Two waves.** Sprint 617 delivers **P0–P6**. **P7–P9 move to a follow-up backlog sprint**, which starts only after the P5 and P6 pilots are qualified.

## Baseline (verified at source)

| Item | Value |
|---|---|
| Pins = HEAD | bashy `ed43deb5`, yoke `72b3062c` (match the umbrella gitlinks) |
| Self-registration | None shipped. Unregistered `bashy` falls back to the reserved report-only target (`yoke/pkg/shape/bashy.go:14-42`; `bashy/internal/agentos/shape_local.go:16-41`). A bashy registered with `shaping.kind: cli` and managed source gets the full lifecycle: wish/import/verify/preview/approve/undo/restore/submit plus remote/outgoing/push/incoming/pull. |
| Refusal guards | `ErrBashyActivation` in `service.go`, `program_runtime.go`, `submit.go`, `promotion.go`. These guard only the *unregistered* reserved target. Keep them. |
| Side slots | `yoke/pkg/shape/slot/slot.go`. Release bytes are retained, and undo/restore never rebuild. Routing in `shape_slot.go:57-152` sends mutations, `self`/`upgrade`/`mcp` and script/shell entry to the retained release. |
| Installation identity | **Absent.** The state key is `$BASHY_HOME` and the scope label is "host". Two installs coexist only by setting separate `BASHY_HOME`. |
| Promotion tiers | `org` and `upstream` only (`yoke/pkg/src/upstream.go`). There is no staging concept. The upstream default is `allowedRepos` → qiangli. No dhnt entries. |
| Org-before-upstream | **Not enforced.** `Push` (`promotion.go:573+`) does not check that the change is already in org. The ordering exists only in help text. |
| Evidence | HMAC-sealed with a per-host key (`evidence/evidence.go`). It is **non-portable by design**: only `evidence_path`, a local path string, travels in the PR body. |
| Qualification manifest / per-platform hashes | None. Slot `Version` holds one digest with no GOOS/GOARCH. |
| Release | `release.yml` builds once from `-dev` tags. `promote.yml` byte-promotes and verifies provenance with `gh attestation verify -R $REPO`. `qiangli/bashy` is hard-coded in `.goreleaser.yaml`, `internal/agentos/self.go:26`, `engines_common.go:266`, `yoke/pkg/binmgr/transcription.go:84`, `yoke/external/meshagent/meshagent.go:45`, `scripts/generate-install-channels.py:21`, and the ghcr `qiangli/bashy-scratch` image. These matter for the follow-up sprint (P8). |

**Carried stories, all still open:**
- **H5 `5f0412e066bd` and H7 `515557c02505`** (Sprint 579, todo). They carry recorded failures: census `packages_test.go:77`, the macOS ratchet and disk failures, and the Linux 80/86 run that was later 86/86. Those stay on record.
- **Dogfood `0a10de8d63f2`** (p0, no sprint). Still to do: the hello-world lifecycle on the installed release and a two-host round trip through a scratch org remote.

**Interaction with Sprint 616:** no file overlap with shaping. Its single yoke pin bump does collide with ours, so yoke integrations are serialized: 616's bump lands first, or ours rebase on it.

**Side findings, to be filed as todos and not fixed here:**
- `.goreleaser.yaml` ldflags stamp `github.com/qiangli/bashsharp/transpile.ShellRuntimeCommit`, but the module is `github.com/bashsharp/bashsharp`, so the `-X` is probably a no-op. Root-cause it first by checking the stamp in a built binary.
- `.sibling-pins` was removed in `a8539117`, but CLAUDE.md, `sync.sh` text and some docs still describe it.

## Story review and scope after review

| Story | Verified | Scope after review |
|---|---|---|
| **P0** `42672de1c28a` | Card and stories are coherent. The "staging" term has no code counterpart. | **Map, don't add:** tier `org` = qiangli staging, tier `upstream` = dhnt. No new tier name. Closes when this plan is committed and the card is split. |
| **P1** `bac372b79573` | Baseline above. | Turn the table above into the committed baseline matrix (implemented / missing / unqualified / intentionally unsupported). Host-kind offer/adopt/incident are intentionally unsupported. Link H5/H7/0a10 without closing them. Targeted unit tests only: `go test ./pkg/shape/... ./pkg/src/...` in yoke and `./internal/agentos -run Shape` in bashy, with `GOWORK=off`. |
| **P2** `b0e65f57985c` | Registration is manual (`app add --type shaped`, build/test argv, `shape remote set org/upstream`). There is no installation ID. | (1) yoke: an opaque installation ID created once in `$BASHY_HOME` and shown in `shape status --json`. Scope becomes "installation"; the host role stays separate. (2) bashy `examples/shaping-setup/shaping-setup.bsh`: an idempotent composition of existing verbs (`app add`, `src`, `shape remote set`, a release-identity check). It reports the reserved fallback with an actionable status when prerequisites are missing. It never activates old report-only records. No new core verb. |
| **P3** `2c44103207bb` | Evidence is per-host HMAC, and nothing travels. | yoke `pkg/shape/qualify`: a versioned **qualification manifest v1**. It binds the candidate commits across repos, the go.mod pins, the verifier policy ID, the toolchain, and per-platform `{goos/goarch, artifact sha256, receipt digests, installation ID, host role}`. Each installation signs it with its own ed25519 key. Public keys are enrolled in a committed `allowed_signers`-style trust file in the upstream repo. The bundle travels on a pushed ref, `refs/shape/<candidate>/qualification`, not in a local path. A pure `Verify(bundle, trust, policy)` is shared by `shape qualify verify` (exit 0/3/1) and the dhnt required check. Tests cover tampered, stale, mismatched and duplicate-installation bundles, missing platforms, a WSL-as-Windows attempt, and bypass by direct push. The existing HMAC store stays the local cache. |
| **P4** `c1c795fc06a8` | `Push` has no org-before-upstream check, and allowedRepos is qiangli-only. | (1) In `Push(upstream)`, fail closed unless the proposal's patch IDs are on the frozen org ref **and** the P3 bundle verifies for the exact proposal commit. (2) A dhnt required check runs the same verifier. (3) dhnt repo inventory for Wave 1 is **bashy and yoke only**, the repos the pilots edit. Module paths stay qiangli, and qiangli keeps every qualified commit. sh/coreutils are frozen baseline and readline/filebrowser/forks are untouched, so they are not mirrored yet. (4) Scratch-remote round trip first, using a throwaway org pair, before any dhnt repo is created. **Creating the dhnt repos and branch protection is an operator action.** |
| **P5** `e545a503401b` | Bash# fenced skills already give receipts and a sha256 identity (`yoke/pkg/skills/run.go`). | One `.bsh` dev-workflow skill-script (the P2 setup extended to wish → verify → preview → activate → undo → submit → push org → qualify → push upstream). Pick one real improvement and drive it through the full path on three native OSes plus a second installation. Afterwards, make shaping mandatory only for covered skill-script changes. |
| **P6** `5560a9e0cdfe` | Side slots exist. The H5 self-shape case and H7 scenario B are the same lifecycle. | One small real CLI change, taken through the full lifecycle on native macOS, native Windows and Linux from one frozen candidate, plus a second installation doing exchange and rollback. **Absorb** H5's self-shape case, H7's scenario B and 0a10's two-host round trip as shared evidence. Close those stories only against their full original criteria; their other cells stay open. The web-shaping regression must stay green. |
| **P7–P9** | Out of Wave 1. | Move to a new backlog sprint, "617b: coupled shaping, dhnt release ownership, shaping-first enforcement". Story IDs and bodies stay as they are. Prerequisite: P5 and P6 qualified. |

## Delegation (Wave 1; claude conducts, reviews, gates and merges)

| Lane | Story | Repo · area | Planned worker |
|---|---|---|---|
| A | P1 baseline | read-only plus targeted tests | claude (conductor) |
| B | P2 installation ID | yoke `pkg/src`, `pkg/shape` status | opencode-glm-5.3 |
| B2 | P2 session slots, trust and memory | yoke `pkg/weave` (slots, root), `pkg/agentctl/trust.go` | codex-gpt5.6-sol |
| C | P2 setup skill-script | bashy `examples/shaping-setup` | muse-spark1.3 |
| D | P3 qualification manifest and verifier | yoke `pkg/shape/qualify` (new) | codex-gpt6-sol |
| E | P4 push enforcement and scratch round trip | yoke `pkg/shape/promotion.go`, `pkg/src/upstream.go` | claude-sonnet5.5 |
| F | P4 dhnt required-check workflow (verifier only) | bashy `.github/workflows/` (self-hosted runner) | agy-gemini3.8-flash |
| G | P5 and P6 pilots on three OSes | test hosts | claude (conductor) |

Lanes B, D and E all touch yoke. They are file-disjoint but merge **sequentially**, followed by **one** yoke pin bump in bashy (go.mod, `src_mount.go` pins, goldens), coordinated with Sprint 616's bump. Every commit carries `Sprint:`/`Story:`/`Story-ID:` and the worker's `Agent` trailer.

## Sequence

1. **Wave 0 (conductor, before start).**
   - Get the operator's start authorization.
   - `sprint take 617`.
   - Split P7–P9 into the follow-up sprint.
   - Claim test hosts: the Windows test host, the Linux test host or a droplet, and a macOS test host. Use only the authorized test venues. No heavy suites on the dev box.
   - Stage current bashy on Windows first.
2. **P1** (Lane A). The baseline matrix is committed, and the carried stories are linked.
3. **In parallel:**
   - P2 B → C (C needs the installation ID).
   - P3 D.
   - P4 E, starting the scratch round trip after P1. Push enforcement consumes D's `Verify`.
4. **Integration.** Yoke merges B → D → E, then one pin bump, then F's required check on the scratch org. The operator creates dhnt/bashy and dhnt/yoke with branch protection.
5. **P5 pilot** (Lane G). Native macOS, Windows and Linux, plus a second installation. Then enable the skill-script mandate.
6. **P6 pilot** (Lane G). Reconcile H5, H7 and 0a10 evidence. Then enable the CLI mandate.
7. **Close-out.** Record the checkpoint and handoff to 617b. No release; release stays operator-approved and v1.0.0 stays gated on POSIX certification.

## Gates and verification

- **Per story:** targeted `GOWORK=off go test` on the touched yoke/bashy packages, plus the story's acceptance demo. Full suites and `make test-bash-gate` run once at the Wave-1 candidate, in the sealed lane on the authorized test venue. The gate must show both modes 86/86 with fixture-name comparison against the last green. Any red goes through root-cause-before-fix.
- **P3/P4 bypass tests:**
  - A tampered bundle exits 1.
  - A stale candidate is blocked.
  - Duplicate receipts don't count as two installations.
  - A direct `git push` to dhnt without the check is rejected by branch protection.
  - Calling `shape push upstream` without org presence exits 1.
- **Pilots:** one frozen candidate commit. Three native-OS receipts with differing artifact hashes. Second-installation exchange and exact rollback (hash before = hash after). A broken candidate leaves retained `shape status/undo/restore` working.
- **Public hygiene:** host roles and opaque installation IDs only. Raw logs are scrubbed by `script/scrub-gate.sh` before entering public bundles.

## Follow-up 1: readiness ladder for switching

The switch to shaping-first happens in steps. Each step needs the operational evidence named below, not just the command existing. Durations are estimates based on recent sprints (S614 closed 16 stories in about a day) and assume the operator inputs are available.

| Level | Meaning | Needs | Est. after start |
|---|---|---|---|
| R0 | today: manual registration only, no portable evidence | — | — |
| R1 | **opt-in local shaping** of bashy on one installation | P1, P2 (including the session workspace, Follow-up 2), P3 verifier | 2–3 days |
| R2 | staging→upstream path enforced on scratch remotes, then on dhnt | P4, plus the operator creating dhnt/bashy and dhnt/yoke with branch protection | +1 day |
| R3 | **mandatory for skill-script changes** | P5 pilot: three native OSes + second installation | +1 day |
| R4 | **mandatory for CLI changes**, which is the practical "switch" for daily bashy development | P6 pilot, H5/H7/0a10 evidence reconciled, full gates green | +1–2 days, so about 1–1.5 weeks total |
| R5 | coupled changes and release ownership on dhnt | the follow-up sprint (P7–P9), plus an operator-approved rc | +1–2 weeks; release timing set by the operator |

- **Blocking operator inputs:** the start authorization, the dhnt repos and branch protection, and test-host availability (Windows first).
- **Rollback:** each mandate is a guard setting, and going back one level means relaxing that guard. No history rewrite.

## Follow-up 2: installation workspace (session slots built on weave)

**Verified at source:**
- Weave clones a full workspace for every run: `clone --local --no-hardlinks --no-checkout` + checkout (`yoke/pkg/weave/weave_impl.go:4074`). The path `issue-<N>` is new every run (`:3689`).
- The weave root is `~/.bashy/weave` from `os.UserHomeDir()` and **ignores `$BASHY_HOME`** (`:586-597`). Two installations therefore share weave state, which is a **P2 defect**.
- Trust preseed (`yoke/pkg/agentctl/trust.go`) covers Claude (`~/.claude.json` per path), Codex (`config.toml` per git top-level) and opencode. There is no recipe for Gemini or agy.
- The Claude preseed works. Two real problems remain:
  - It writes `~/.claude.json` with a plain `os.WriteFile` and no lock or rename, so it can race with a running Claude instance and lose that instance's writes.
  - Because every run has a new path, `~/.claude.json`/`config.toml` gain one entry per run and nothing ever removes them.
- Vendor home and memory isolation exists only for booth runs (`booth.go`; Claude gets `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`). Ordinary runs and chat use the operator's real HOME and the caller's cwd. There is no default interactive workspace.
- Cross-session memory that bashy owns already exists: `WEAVE_MEMORY.md` (the queue memory store) and `KB.md` (recall plus retro write-back), both git-excluded in the workspace.

**Design:** a pool of **stable session slots per installation**, kept clean on every reuse.
- **Location:** `$BASHY_HOME/weave/<repo-queue>/slots/slot-<k>`, with the weave root following `$BASHY_HOME` and falling back to the current root. Every installation then has its own slots.
- **Clean session:** each session leases a slot and resets it: `fetch` from the source, `checkout -B <session-branch> <base>`, `clean -ffdx`, `reset --hard`. The workspace content is pristine, but the path stays stable.
- **Lightweight:** the slot is created once, using hardlinked objects (drop `--no-hardlinks`). Git objects and packs are immutable, and refs/HEAD stay separate, so the isolation argument in the `:4066` comment still holds. A reset costs a checkout diff, not a clone. A per-run `issue-<N>` clone remains for booth/sealed runs.
- **Trust:** each slot is pre-trusted once per vendor, so the vendor config gains a fixed number of entries instead of one per run.
  - Write `~/.claude.json` atomically: lock, write a temp file, rename.
  - Add a Gemini `trustedFolders.json` recipe and an agy recipe.
  - When a slot is retired, remove its trust entries.
- **Memory:** the clean-session rule applies to vendor memory too. Vendor auto-memory is off by default in slots (`CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`, as booth already does), and any vendor per-path memory dir is cleared on reset. Cross-session knowledge goes through bashy's own path: `KB.md`/`WEAVE_MEMORY.md` recall at lease time, `kb retro` write-back at release. Memory then works the same across vendors, installations and OSes.
- **Interactive default:** a bashy agent session with no repo leases a scratch slot (`<queue>/slots/scratch-<k>`) instead of using the caller's cwd.
- **Story placement:** this goes into **P2** as a new lane B2. It is a prerequisite for R1, because the pilots run vendor agents in these slots.
- **Verification:**
  - Lease, reset and release time on bashy, against a fresh clone today.
  - No vendor trust prompt on the second lease, for each vendor.
  - `~/.claude.json` entry count bounded after 20 sessions.
  - Concurrent preseed while Claude is running loses no Claude config keys.
  - Two installations on one host share no slots.
  - Content from session N is absent from session N+1, while a retro'd KB fact is recalled.

## Follow-up 3: user-app workflow, with classgo as the guinea pig. Split first.

**Sequencing (operator, 2026-11-11):** all classgo work comes **last**. It starts only after bashy shaping is stable: R4 at minimum, and the operator decides when that is reached. It is not part of Sprint 617's waves.

**Target workflow, for most users:**
- (a) Register the app: `bashy app add --type shaped`.
- (b) Shape it, or bashy itself, from your favourite TUI/GUI agent. There is no boundary between bashy and user code beyond **core vs non-core**, and the user's apps are non-core.
- (c) A web app shows a shaping (Genie) button on any page that opts in.

**What already exists:**
- Registration with kinds web, cli and service.
- The protected Genie button with live, protected, preview and draft modes (`yoke/pkg/webconsole/genie.go`).
- `shape wish --from WORKSPACE` for changes made by hand in your own agent.

**Gaps:**
- **Proxied apps get no button.** Genie is injected only into apps the console serves. `genie.go:27` already marks proxied external apps as "later", and outpost has no hook for it.
- **Headless only.** The shaping agent is one global `--shape-agent` and runs headless. A TUI session comes in through `--from` (the session slots from Follow-up 2).
- **bashy is still special-cased** in `shaped.go:150`. That's acceptable as the protected-runtime rule.

**classgo today** (single Go binary; one private adopter runs it in production):
- One `handlers.App`, about 152 methods.
- One SQLite file, with no WAL, no busy_timeout and no PRAGMAs.
- The startup path runs migrations, a synchronous spreadsheet import, a file watcher and six cron jobs. All of them touch the check-in tables.
- There is no process supervisor: `make start` runs it in the background.
- Data covers children and families: student and parent PII, PINs, attendance.

**Two pre-existing product defects, verified:**
- **D1 — re-import wipes PIN settings.** Re-import does `INSERT OR REPLACE INTO students` without `require_pin`, `personal_pin` or `pin_generated_date` (`internal/datastore/importer.go:88`). It has no row-hash skip, so it runs at every startup and on every watched file change. An admin's "require PIN" setting is silently cleared. `internal/handlers/api.go:575` does the same.
- **D2 — an empty Students sheet deletes the roster.** It runs `DELETE FROM students` (`importer.go:195-198`). The guard in `main.go:260` only checks that all five sheets together are non-empty.

**Decisions (operator, 2026-11-11):**
- Check-in (A) **owns its own DB**.
- A and B run on **separate ports**.
- **Two repos.** Check-in needs little shaping. The rest (B) gets most of the bug fixes and features, so B is the shaping target.

### Repo model: public example, private adopter

**Verified:** the public `qiangli/classgo` and the private adopter's repo have diverged in both directions since their merge base (2026-11-11). The adopter's repo carries most of the recent work.

**Model (operator, 2026-11-11):**
- **Public `qiangli/classgo` becomes a bashy example app.** It is generic, anyone can register and shape it, and it is the product upstream.
- **The private adopter is one user of it.** It holds its forks plus its own overlay: config, branding and data layout.
- **Flow is one-way by default: the adopter pulls from public.**
  - Pushing back is optional and decided case by case. Over time it may stop altogether, and the adopter may diverge for good. That is a supported state, not a failure.
  - Nothing in the model requires the adopter to upstream anything, and public never pulls from the adopter on its own.
  - In bashy shaping terms, public is the adopter's `upstream` tier, and `shape incoming`/`pull` is the normal path. `shape outgoing`/`push` is an occasional, explicit act.

**Step S0, before the split: backport and sync.** This is a one-time bootstrap so that public starts as a complete, usable example. It is not an ongoing obligation to push.
1. Replay the adopter-only commits onto public, **sanitized**.
   - Strip adopter names, branding, deployment specifics, real outpost and tunnel settings, and anything resembling data.
   - Keep the example data in `data/csv.example`, after checking it holds only synthetic people.
   - Run `script/scrub-gate.sh`-style patterns before each push.
2. Merge the public-only commits. Several overlap the adopter's cloud/prefix fixes, so each one is resolved and never auto-merged.
3. Merge the reconciled public into private. Do **not** rebase: private `main` is published, and its history stays intact. After that, private equals public plus the adopter's own commits.
4. **Proof:** the reconciled public builds, and its 232 Go tests and its e2e suite pass. The re-synced private build passes the same suites, and production behavior is unchanged: the deployed binary from re-synced private is checked in shadow before any restart.

**After S0:**
- **For this split specifically,** D1, D2 and the A/B split land in public first, because they are generic. Private pulls them with a merge, and the production deploy is built from private.
- **Later changes are case by case.** A the adopter-only change stays in private. A change worth sharing *may* be offered to public.
- **Each pull of public into private is a merge resolved in private.** It counts as a candidate: it is tested and previewed before deploy, just like a local change.
- Public ends up as two example repos, `qiangli/classgo` (B) and `qiangli/classgo-checkin` (A). the adopter keeps private forks of both.

### classgo split plan, minimal and with no check-in downtime

**Boundary:**
- **A** (`classgo-checkin`, a new public example repo with a the adopter private fork): `/`, `/kiosk`, student and teacher check-in/checkout/status/search, `/api/pin/check`, `/api/tracker/{due,respond}`, plus `entry.html`, `kiosk.html` and four static assets. The staff login form moves to B; A shows a link to it.
- **B** (`classgo`, keeps its history): everything else, including login and sessions, outpost SSO and provisioning, imports, watcher, cron, reports, admin and the scheduler.

**Data ownership:**
- **A's DB** owns `attendance`, `teacher_attendance`, `attendance_meta`, `checkin_audit` and `tracker_responses`, plus the check-in policy that today lives in process memory and `config.json`: the site-wide PIN, `PinMode`, `require_pin` and personal PINs. It also keeps a last-good copy of the roster: students (check-in fields), teachers, schedules and task_items.
- **B → A roster push:** an idempotent full snapshot, sent on change and every few minutes.
  - A **refuses an empty or shrunken-past-threshold roster**, which closes the D2 class.
  - A keeps serving from its last-good roster when B is down.
- **A → B attendance:** B pulls with a cursor (`since=`) into its reporting copy.
- **Admin operations go through A's admin API:** B's attendance edits, restore and purge, plus PIN admin.
- **Contract:** a small versioned JSON contract, with types duplicated on purpose and contract tests on both sides. A imports nothing from B.
- **Access:** the sync and admin API listen on a **loopback-only** port with a shared token. A's public port serves only the check-in surface, and `RequireLAN` stays.

**Ports, chosen so no device changes:**
- A keeps **:8080**, so kiosk and phone bookmarks are unchanged.
- B moves to a new local port. The outpost tunnel registration is repointed once, by the operator.
- A answers non-A paths with a plain 302 to B. It never proxies them, so a down B cannot affect A.

**Sequence** (each step is reversible, and every production change happens after closing time):

| Step | What | Proof |
|---|---|---|
| 0. Fix D1/D2 in the monolith (after S0) | Upsert that keeps the PIN columns (also `api.go:575`); an empty-sheet guard per entity; enable WAL and busy_timeout. Fix in public, sync to private, deploy from private after hours. Record the root cause on the story as a product defect found by inspection. | New regression tests: `require_pin` survives a re-import; an empty Students sheet is a no-op. All 232 Go tests stay green. |
| 1. Build A in the existing repo | `cmd/classgo-checkin` + `internal/checkin` (own small struct and DB, the sync and admin API). In B, a roster pusher and attendance puller behind a flag, off by default. Move the A tests (`main_test`, `checkin_test`, `teacher_test`, `lan_only_test`, `e2e_test` phases, the tracker blocks-checkout tests) to run against A. | Go tests on the dev box (small app). The 13 A Playwright specs plus the full e2e run on the Linux test host against A and B as separate processes. |
| 2. Shadow on the production host | Run A on a side port, synced from production B, with no devices pointed at it. Use one test student from a spare tablet for a full operating day. | Sync converges. Killing B leaves A checking in. A's attendance reaches B's reports. No `SQLITE_BUSY`. |
| 3. Cutover (one evening) | Seed A's DB from `classgo.db` (roster, open sessions, PIN state). Stop the monolith. Start A on :8080 under a **process supervisor** (restart on crash, start at boot). Start B on its new port. Repoint the tunnel. | The A smoke suite passes on LAN. The tunnel serves admin. **Rollback is rehearsed in step 2:** stop both, back-fill attendance from A's DB into `classgo.db`, start the old monolith binary on :8080. |
| 4. Repo split | Create public `qiangli/classgo-checkin` and the adopter's private fork of it (operator action). Move A with its history (`git filter-repo` on the moved paths) and remove A's code from classgo, in public first, then sync private. Each repo gets its own release workflow. | Both repos build and test on their own, and production runs the binaries built from the adopter's synced forks. |

- **Estimate:** about a week of calendar time, most of it the step-2 soak day and after-hours windows. Steps 0–1 take about 3 days of work.
- **Then shaping** (a later sprint, after Sprint 617 R1):
  - Register B as a shaped app, previewed on `data/csv.example` (`make start-test`) with a separate data dir. Never shape against production data.
  - Register A as **protected**: wishes are filed as requests and nothing is built live.
  - Bring Genie to proxied apps through a one-line script tag in B's `static/js/theme.js`, which every page loads, or an outpost injection hook.
- **Public hygiene:**
  - The generic example plan, stories and evidence live in the public classgo repos.
  - Anything about the adopter (production host, cutover windows, real data, overlay) lives only in the adopter's private repo.
  - This document refers to the adopter only as "a private adopter".
