# Sprint 688 — worker supervision round 2 (master execution plan)

- **Sprint:** `#688` (`b6d0bf82-bf8a-5ba7-bbab-90b24be56deb`)
- **Manager:** `agy-gemini4-carbon` (operator-seated L4, 2026-11-21)
- **Supervising conductor:** `claude+2`
- **Status:** Planning complete; **implementation on HOLD** pending conductor `claude+2` go-ahead (per 2026-11-21 08:24 / 08:26 UTC decisions).
- **Operator-approved rescope (2026-11-21 08:26 UTC):**
  - **MVP:** `80e91377` (`mb --history` fast path) + `6254c3c6` (live session state detection with measured `usage_signals` for `muse` and `agy`) + `309381be` (`agentos.test mcp serve` process leak).
  - **Rescoped P2:** `49cd45d9` cut to **watermark alerts + unknown-account source reporting only**; `--auto-prompt` (`--auto-prompt-message`) moves to backlog.
  - **Stretch:** `26bbbf01` (deterministic story handoff on rate-limit exhaustion).
- **Operator-approved rescope (2026-11-21, quota-exhaustion review):** `26bbbf01` is promoted from Stretch to **MVP**; MVP order G2 → G4 → G5. Rationale and decisions: §2a. No new scheduler, vacation registry or dynamic agent pool stories (§2a, rejected alternatives).
- **Primary goal:** Give sprint managers fast board reads, live TUI session state visibility and wakeups, leak-free `agentos` service tests, and deduplicated subscription/spend watermark alerts (with deterministic rate-limit handoff as stretch) without requiring operator eyes.

## 1. Source-verified baseline and gaps (inspected 2026-11-21)

1. **`bashy mb --history` stalls for minutes (`80e91377127f`, P1, bug).**
   - In `yoke/pkg/bus/messageboard.go`, `readBoard` calls `Posts()` unconditionally whenever `history == true`, ignoring an explicit `-n` / `--limit` flag instead of reading from the tail of `posts.jsonl`.
   - Worse, `nextSteps` (`messageboard.go:677`) calls `p.Directed(who)` (`audienceSnapshot{}` with `state == nil`) on every post, which invokes `AddressedToRole(to)` → `bus.HostRoles()` unmemoized per directed post; `p.Audiences()` (`board.go:156`) likewise calls `RoleLabelFor(p.To)` unmemoized, and `describeFor` scans `Viewers(seq)` / `ClaimHolder(seq)` per post. When `bus.HostRoles` reloads the sprint/weave queue (~18 MB, ~55–150 ms per call) across thousands of directed posts in an ~8.4 MB `posts.jsonl`, a single `mb --history` or `mb --history --peek -n 8` takes 2–33 minutes.

2. **Live session stalls are invisible to managers (`6254c3c64248`, P1, feature).**
   - Observed 2026-11-20: (a) `muse` hit an HTTP 429 short-window limit (`Subscription quota exhausted. Your usage window resets at <RFC3339>.`), then after reset finished its story and sat idle with the stale 429 still in scrollback; (b) `codex` finished a turn at a `/recap` screen proposing `next: <action>` and waited for confirmation; (c) `agy` sat with typed text in its input box waiting for Enter.
   - `yoke/pkg/fleet` declares `usage_signals` only on `codex` and `claude` (and applies them to weave runs, not live `chat` sessions); `bashy chat sessions --json` exposes no live session state; `sprint await` and `bashy inbox --until-count` only watch weave runs and board mail, so all three stalled sessions appeared `"working"`.
   - Vendor wording cannot be taken at face value: `muse` says `"Subscription quota exhausted"` on a short-window rate limit (3% current window, 47% weekly right after reset). Window class (`5h`/short vs `week`) must be derived from reset distance, as `codex` signals do, and `muse`'s measurable current-window % and weekly % source must be investigated rather than guessed.

3. **`agentos.test` leaks `mcp serve --listen loopback:22750` processes (`309381beda57`, P2, bug).**
   - `yoke/pkg/fleet/baseline/services/bashy-mcp.yaml` ships with `enabled: true` on loopback port `22750` (`exec: [bashy, mcp, serve, --transport, http, --listen, "{bind}:{port}", --outpost]`).
   - In `bashy/internal/agentos`, `TestMain` redirects `BASHY_SERVICES_DIR` and `BASHY_SUPERVISORD_SOCKET` to temp dirs and intercepts `BASHY_SUPERVISORD_TEST_CHILD` before `foreignReExec()`, while embedded baseline service seeds remain visible to `fleet.New()` and child processes are not guaranteed process-group termination on test failure/timeout paths. Eight orphaned `agentos.test mcp serve` processes survived 18–24h+.

4. **No deterministic handoff when a worker hits a long rate limit (`26bbbf019492`, P2, feature).**
   - `yoke/pkg/handoff` already provides `CaptureWork` (non-destructive `git diff HEAD` + bounded untracked files) and `secrets.EnvValueRedactor` redaction, and `bashy chat command <id> resume` landed in Sprint 681, but nothing connects a live `rate-limited` session (with reset past a threshold) to a deterministic, model-free handoff note on its story.

5. **`sprint monitor` has no configurable quota/spend watermarks, notifications, or unknown-source reasons (`49cd45d94248`, P2, feature — rescoped to alerts only).**
   - `yoke/pkg/llmbudget` has `SubscriptionHeadroom`, `Forecast`, and `Policy`, and `bashy/internal/agentos/sprint_monitor_alerts.go` already maintains a deduplicated onset/recovery `resources.AlertLedger` and `bus.PostMessageOnce` publisher, but:
     - per-account low-headroom watermarks (across both current-window % and weekly %, plus forecast exhaustion before reset) and API-key spend watermarks (USD/day, USD/month, `%` of budget) are not configurable;
     - alerts do not notify both the conductor seat and operator (`inbox human`) + room status timeline with forecast and suggested action;
     - `"15 unknown"` accounts in `sprint monitor` do not explain which accounts lack a measurement source and why.
   - Per operator rescope (2026-11-21), `--auto-prompt` (`--auto-prompt-message FILE`) is deferred to a standalone backlog story.

## 2. Scope, non-goals, and design principles

- **In scope (rescoped 2026-11-21):**
  - **MVP:** `80e91377` (P1), `6254c3c6` (P1, with measured `muse` and `agy` `usage_signals`), and `309381be` (P2).
  - **Rescoped P2:** `49cd45d9` (subscription window/weekly + API-key spend watermark alerts and unknown-account diagnostics only).
  - **MVP P2 (promoted 2026-11-21):** `26bbbf01` (deterministic story handoff on rate-limit exhaustion; after `6254c3c6`, before `49cd45d9`).
- **KISS / reuse:** Build exclusively on existing stores and transports (`posts.jsonl`, room cards + `log_path` transcripts, `agentpty.ScreenText` + `DialogGuard`, `fleet` tool YAML `usage_signals`, `handoff.CaptureWork` + `secrets.EnvValueRedactor`, `llmbudget` + `resources.AlertLedger`, `sprint await`, `inbox`). No new daemons, databases, or IPC protocols.
- **Non-goals:**
  - Worker `--auto-prompt` / `--auto-prompt-message` on low-watermark crossing (split out of `49cd45d9` to backlog per operator rescope 2026-11-21).
  - Shelved refuel/UPS mid-turn model swap (`9b0e4721`).
  - Guessing unmeasured vendor slash commands, rate-limit phrases, or quota endpoints.
  - Any release tag, binary publication, or scope expansion without explicit operator approval.

## 2a. Quota exhaustion is a general bashy problem (operator rescope 2026-11-21)

Every agent user hits vendor exhaustion mid-task, for subscription plans (5 h / weekly windows) and for prepaid credit / API-key accounts alike. The feature is a product capability for all bashy users, not a fleet-specific fix.

- **The refusal is the authoritative signal.** A 429 / 402 / 403 with its text and reset time is what every vendor emits. Quota readings (statusline, app-server, balance endpoints) are advisory input for admission and watermarks only, never a "safe to run" verdict; several vendor readings are unofficial or known to disagree with enforcement.
- **One vendor-neutral classifier, three outcome classes** (G2), classified by reset distance and status, never by vendor prose:

  | Class | Detected by | Action |
  |---|---|---|
  | transient | short `Retry-After` (< 5 m) | none; the vendor CLI retries |
  | window | reset known (5 h or weekly) | seat cooldown until `reset_at` (existing `tool_cooldowns`); reset ≤ 30 m → wait, then `bashy chat command <id> resume`; reset > 30 m → G4 handoff + reassign |
  | hard / credit | 402, "insufficient balance", or no reset | no reset will come: cooldown until the user tops up, G4 handoff, immediate reassign to a flat-billed seat, alert (G5) |

- **Seed-driven, user-extensible.** Refusal patterns, window hints and balance-source declarations live in the fleet tool seeds (`yoke/pkg/fleet/baseline/tools/*.yaml`), each measured from a real transcript, never guessed. A generic fallback (HTTP 429/402, `Retry-After`/`reset`, quota / insufficient-balance phrasing) covers unknown vendors; users add or override a seed with `bashy shape`, without a release.
- **Works at every scale.** A single user with one agent and no sprint gets live state + `reset_at` in `bashy chat sessions`, the handoff note and resume. Sprint features (seat cooldown, reassign, conductor wakeups) layer on top.
- **Make exhaustion cheap instead of predicting it.** Workers commit and push WIP to the story branch at every green step (playbook rule); G4 writes a model-free handoff, so recovery never depends on the exhausted model.
- **Credit accounts get admission control.** Opt-in per-binding caps through existing `llmbudget` constraints + `Reserve` before dispatch; `seatPool` already hires flat-billed seats first (`billingRank`). Spend caps already exist (`daily_spend_micro_usd`, `weekly_spend_micro_usd`); G5 only wires them to alerts.
- **Point-based budgets (`e868c820`, P2, after G5).** Story envelope = Fibonacci points × per-point rate, sprint = sum of its stories (or an explicit cap), band = approval authority only (budget follows the work, not the worker; a band table caps the overrun an agent may approve, larger ones escalate); the sprint envelope adds a manager-overhead line. The rate is calibrated per project from settled actual usage on accepted stories (trusted sources only). 80 % → checkpoint/STATUS; 100 % on metered lanes → refuse + G4 handoff, manager re-estimates, splits or approves a logged override; subscription lanes soft only. Reuses existing points, `llmbudget` spend constraints (`daily/weekly_spend_micro_usd` already exist) and `Reserve`; adds only the story/sprint/band scope.
- **Experiment (operator, 2026-11-21; review ~2027-02-21):** budgets and min bands ship OBSERVE-ONLY: record envelopes, usage, and `would-refuse` / `would-wait` events; never block, delay or reroute. Enforcement is decided at the review from that evidence (no enforcement code now).
- **Minimum band per story (`e868c820`).** A low band on a complex story wastes tokens. Today the story band is a soft target: `ladder.ScheduleStory` cascades to lower bands when none is free. A story records points (size) and a min band (difficulty); the cascade stops at the floor and waits, with a logged manual override as the escape hatch. Envelope = points × rate(project, band), calibrated from settled usage; the sprint-end report shows a band set too low (rework/overrun) or too high.
- **Safe defaults, opt-in money.** Detection and handoff are on by default (no model call, no spend). Spend caps, balance polling and scheduled `bashy model quota capture` (documented sources only, credentials stay local) are opt-in.
- **User docs.** One KB/runbook page, "When your agent runs out of quota": what bashy detects, what it writes, how to resume or switch, how to add a seed for a new vendor (acceptance of G2/G4).
- **Rejected alternatives (do not re-propose):** a new host quota daemon (the existing cache + scheduler suffice; polled readings go stale, cf. `62b8578356ee`), a vacation registry (= seat cooldown, made visible via session `state`/`reset_at`), a dynamic agent pool (`seatPool` already ranks by headroom and billing).

## 3. Bounded stories, goals, and acceptance criteria

Execution is strictly **priority-first (`P1` before `P2`)**.

### Wave 1 — P1 stories (parallel, file-disjoint)

#### Goal G1 (`80e91377127f`, `#3270`, P1, bug) — `mb --history` tail fast path and snapshot memoization
- **Repositories / files:** `yoke/pkg/bus/{messageboard.go,board.go,board_test.go}` (and `bashy/internal/agentos` if role-memo wiring is needed for `bashy mb`).
- **Root-cause requirement:** Record exact measured before/after timings and call counts (`HostRoles`, file reads) on story `80e91377127f` before landing the fix.
- **Changes:**
  1. When `--history` is combined with an explicit `-n` / `--limit` (`limit > 0`), read only the tail of `posts.jsonl` (`O(tail)` chunked backward read) returning the newest `N` posts in board order; bare `mb --history` (without explicit `-n`) continues to return the full live board.
  2. Thread the single per-read `audienceSnapshot` through `nextSteps`, `Post.Audiences` / role-label resolution, and memoize viewer/claim lookups across the read so `bus.HostRoles()` and directory scans run at most once per `mb` invocation.
- **Acceptance checks:**
  - Focused unit + timing regression test on a synthetic ~8–10 MB board (>10,000 directed posts + counted `HostRoles` hook): `mb --history --peek -n 8` reads `O(tail)` and finishes in `< 200 ms` with `<= 1` `HostRoles` call; full `mb --history` finishes in `< 2 s` with `<= 1` `HostRoles` call.

#### Goal G2 (`6254c3c64248`, `#3272`, P1, feature) — Live session state detection, window classification, and manager wakeups
- **Repositories / files:** `yoke/pkg/fleet/baseline/tools/{muse,agy,codex,claude}.yaml`, `yoke/pkg/fleet/usage_signals*.go`, `yoke/pkg/agentpty/`, `yoke/pkg/chat/`, `yoke/pkg/room/`, `bashy/internal/agentos/{sprint_await.go,inbox_conducted.go}`.
- **Root-cause & measurement requirement:**
  - Measure every tool's prompt / input-pending / recap screen shape and rate-limit phrasing from real transcripts or installed pinned binaries (`codex 0.171.0`, `muse 1.4.4-R5419.1`, `agy 1.5.13`, `claude 2.1.295`); never guess.
  - Investigate where `muse` current-window % and weekly % are measurable (CLI subcommands, local state, or API headers/endpoints) and record exact findings on `6254c3c64248` (and feed into G5).
- **Changes:**
  1. **Window-aware `usage_signals`:** Add measured `muse` 429 signal(s) (RFC3339 reset) and any measured `agy` signals; classify window (`5h` short window vs `week`) from reset distance (`reset_at - now`) rather than trusting vendor `"exhausted"` prose. Map every refusal to the §2a classes (`transient | window | hard`) with a generic seed-free fallback; add measured seeds for the other registered tools (claude, codex, glm, kimi/moonshot, deepseek, opencode) as real transcripts become available — never guessed.
  2. **Time-ordered live session classifier:** Classify each live session from `log_path` + `agentpty.ScreenText` + `DialogGuard.ActiveGate()` + last output timestamp into `working | idle-ready | input-pending | rate-limited | dialog | exited | error`. Order signals and turn boundaries in time so a post-reset turn or fresh idle prompt supersedes older 429 lines in scrollback. Extract proposed next-step text on `/recap`-style `idle-ready` screens (`proposal`).
  3. **Surfaces & wakeups:** Add `state`, `since`, `reason`, `reset_at` (optional), `window` (optional), and `proposal` (optional) to `bashy chat sessions --json`; emit room status events on state transitions; extend `bashy sprint await` and `bashy inbox --until-count` to wake a manager when a session working its sprint enters `idle-ready`, `input-pending`, or `rate-limited`, with deterministic suggested actions (`send next instruction`, `chat steer <id> --enter`, `wait until reset or reassign`).
- **Acceptance checks:**
  - Screen/log fixtures per tool covering `working`, `idle-ready` (including `codex` `/recap` with `next:` proposal), `input-pending` (`agy`), `dialog`, and `rate-limited` (`muse` 429 short-window vs weekly reset horizon, plus post-reset stale-429 recovery to `idle-ready`).
  - Room transition event tests and `sprint await` / `inbox --until-count` wakeup tests.
  - Class fixtures: a 402 / insufficient-balance refusal classifies `hard`; an unknown vendor's 429 with `Retry-After` classifies through the generic fallback.
  - User KB page "When your agent runs out of quota" (shared with G4).

### Wave 2 — MVP P2 + rescoped watermark alerts (after Wave 1 P1 dispatch/completion)

#### Goal G3 (`309381beda57`, `#3271`, P2, bug — MVP) — Stop `agentos.test mcp serve --listen loopback:22750` process leaks
- **Repositories / files:** `bashy/internal/agentos/{main_test.go,supervisord*_test.go,supervisord_process*.go}`.
- **Root-cause requirement:** Reproduce the leaked `mcp serve --transport http --listen loopback:22750` child, identify the exact test(s) and failure/cleanup path, and record the root cause on `309381beda57` before fixing.
- **Changes:**
  1. Isolate `agentos` tests from unintentionally starting embedded baseline `bashy-mcp` (`port: 22750`) unless a test explicitly opts in with an ephemeral port.
  2. Ensure every `supervisord` / service test helper places spawned children in their own process group / job and reaps the group via `t.Cleanup` even when a test fails or times out.
- **Acceptance checks:**
  - Regression test simulating failure/cancellation during unit startup/supervision, asserting zero surviving child PIDs and zero listeners on the unit's loopback port after cleanup.

#### Goal G5 (`49cd45d94248`, `#3276`, P2, feature — rescoped: watermark alerts only) — Subscription & API-key watermarks, alerts, and unknown-source reporting
- **Dependencies:** Coordinates with G2 (window classification + `muse` usage findings).
- **Rescope note (2026-11-21):** `--auto-prompt` (`--auto-prompt-message FILE`) is split out to a standalone backlog todo on go-ahead; `49cd45d94248` delivers watermark alerts and unknown-source diagnostics only.
- **Repositories / files:** `yoke/pkg/llmbudget/`, `bashy/internal/agentos/{sprint_monitor.go,sprint_monitor_alerts.go,sprint_monitor_test.go}`.
- **Changes:**
  1. **Policy watermarks:** Support per-account subscription low-headroom watermarks across both current-window % and weekly % (plus forecast exhaustion before next reset via `llmbudget` forecast), and API-key spend watermarks (`daily_spend_usd`, `monthly_spend_usd`, `budget_used_percent`). Wire any measured `muse` usage source found in G2 (or report exact unavailability reason if vendor exposes none headlessly).
  2. **Unknown-account diagnostics:** In `bashy sprint monitor` (text and `--json`), enumerate which accounts make up the `unknown` count and the specific reason per account (`unresolved_account`, `probe_consent_missing`, `provider_source_unsupported`, `cache_empty`, etc.).
  2a. **Credit admission:** Confirm `llmbudget` constraints can cap spend (USD/credit) per binding, or add that one field; opt-in, enforced by `Reserve` before dispatch. Documented balance sources (to verify at source) are advisory feeds into the same cache.
  3. **Deduplicated alerts:** When an account crosses a watermark, emit one deduplicated alert per crossing (via `resources.AlertLedger`) to the sprint conductor seat (`mb`), operator (`inbox human`), and room status timeline, naming the account, current window/spend level, forecast, and suggested action (`shift to flat-billed agent`, `pause metered work`, `wait for reset`). Never emit API keys or credentials.
- **Acceptance checks:**
  - Fixture tests for current-window + weekly headroom crossings, forecast crossings, API-key spend crossings, cross-tick deduplication, explicit unknown-source reasons, and secret-free alert payloads.

### Wave 3 — G4 (promoted to MVP 2026-11-21; runs right after G2, before G5)

#### Goal G4 (`26bbbf019492`, `#3275`, P2, feature — MVP) — Deterministic story handoff on rate-limit exhaustion
- **Dependencies:** G2 (`6254c3c64248` live `rate-limited` state + parsed `reset_at`).
- **Repositories / files:** `yoke/pkg/handoff/`, `yoke/pkg/weave/`, `yoke/pkg/chat/`, `bashy/internal/agentos/`.
- **Changes:**
  1. When a worker session transitions to `rate-limited` class `window` with `reset_at - now` exceeding a configurable threshold (default `30m`), or to class `hard` (no reset), deterministically append one structured handoff block (deduplicated per rate-limit episode) to its linked story card:
     - branch + commits ahead of base;
     - uncommitted diff summary and untracked file list from `handoff.CaptureWork` (non-destructive);
     - sanitized last screen tail;
     - latest `DESIGN` / `DONE` / `STATUS` board notes from that worker;
     - last instruction delivered to the session;
     - `reset_at` timestamp and window classification, plus exact resume (`bashy chat command <id> resume`) and reassign commands.
  2. Redact all captured fields through `secrets.EnvValueRedactor` and existing shape/path redactors; make zero model calls and incur zero spend.
- **Acceptance checks:**
  - Unit/integration tests driven by a real 429 fixture (`reset > 30m` writes complete redacted handoff once; `reset <= 30m` does not trigger exhaustion handoff; secret env values in diff/screen/notes are masked).
- **Scope:** MVP since 2026-11-21 (§2a). Works without a sprint: a standalone session gets the same handoff block in its session record.

## 4. Staffing, waves, and verification venues

- **Staffing:** Managed by `agy-gemini4-carbon` at L4. Stories are dispatched to isolated per-story `weave` workspaces (`bashy sprint assign` with non-colliding repo/file lanes) or executed in isolated worktrees when a small P1 fix (`80e91377` / `309381be`) is faster direct, preferring flat/subscription bindings (`claude-sonnet5.5`, `muse-spark1.3`, `opencode-glm-5.3`, `codex-gpt6-sol` once free from Sprint 682) over metered API bindings.
- **Build & test rules:**
  - Build and test `bashy` exclusively via `bashy dag` (never `make`).
  - **Dev box:** Focused package unit tests (`go test ./pkg/bus ...`, `go test -run TestX ./internal/agentos`), `script/scrub-gate.sh`, cross-OS vet/build checks (`GOOS=windows`, `GOOS=linux`), and final post-pin-bump `bashy dag install` + installed `~/.local/bin/bashy` CLI smoke only.
  - **Linux WSL gate host:** Heavy `yoke` and `bashy dag test` / `test-bash-gate` suites run **only** on the Linux WSL gate host after coordinating via `bashy mb` with `codex` (current Sprint 682 holder) and acquiring `bashy claim <gate-host-resource> --intent "Sprint 688 gate verification, ETA ..."`. Release the claim immediately upon completion.
- **Integration order:** Commit and push `yoke` producer changes first → repin `bashy` (`bashy mod sync`) → run gate-host verification → commit and push `bashy` → commit umbrella gitlinks and `docs/todo/` records → rebuild, install, and smoke-test the installed `bashy` binary on the dev box → `bashy sprint accept` each story → `bashy sprint end 688`.

## 5. Risks and rollback

- **Stale scrollback false positives in G2:** Mitigated by strict time-ordering over `log_path` events and resetting rate-limit state as soon as a newer prompt/turn boundary appears.
- **Cross-story file overlap in `bashy/internal/agentos` and `yoke`:** Wave 1 keeps G1 (`pkg/bus`) and G2 (`pkg/fleet`, `pkg/agentpty`, `pkg/chat`, `sprint_await`) completely file-disjoint; Wave 2 runs G4 and G5 after G2's session-state types land on `yoke`, while G3 touches only `agentos` supervisord tests.
- **Rollback:** Every story lands as atomic trailer-tagged commits (`Sprint:`, `Story:`, `Story-ID:`, `Agent:`); reverting a story commit and repinning `bashy` cleanly restores prior behavior with no schema migration or persistent store rewrite.
