# Sprint 621 master execution plan: Software Shaping TDD (`Red → Green → Refactor`)

Sprint 621 `12e0ca54-4941-5b64-bc6c-4eb80ac71a59`, epic `software-shaping`. Reviewed 2026-11-12.

## Primary goal (one sentence)

Deliver a **KISS/MVP, Unix-composable Test-Driven Development (`Red → Green → Refactor`)** workflow for software shaping where every operation is a small `bashy shape ... --json` CLI verb (100% UI-to-CLI parity across `web`, `cli`, and `service`), composed by a shapeable **Bash# skill-script** (`examples/shaping/tdd/shape-tdd.bsh` + `shape-tdd.json`), gated by a portable **`bashy dag` recipe** (`examples/shaping/tdd/dag.md`), and driven by an iterative **sprint retro (`triage → replan → repeat`)** loop.

## Authorization and source of truth

This is a planning document only (`conductor` §Orientation step 3). Sprint #621 stays in **`backlog`**, unclaimed, with no active lease (`bashy sprint take` / `bashy sprint start` not run), and all six stories (`T1`–`T6`) stay in `todo` until the operator authorizes execution. Planned workers are not assignments. The sprint card (`bashy sprint show 621`) and the story cards (`bashy todo show <id>`) in `docs/todo/` are authoritative.

---

## Design Principles (`kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`)

1. **KISS / MVP:** Reuse existing `bashy shape` verbs and flags (`--contract`, `--repair`, `--from`, `--json`). Add zero new Go packages and zero new top-level commands; add only the missing `--phase=red|green|refactor` and `--contract` flags on `bashy shape verify` and `--repair` on `bashy shape incident`.
2. **Rod, Not Fish (Unix Philosophy & Composable Pipelines):** Every `bashy shape` subcommand does **one thing**, reads plain arguments/files, emits a deterministic JSON object (`--json`) on `stdout`, and returns a meaningful exit code (`0` pass, non-zero fail) so standard Unix pipelines (`| jq`) and scripts compose them without stateful glue:
   ```sh
   cid=$(bashy shape wish "$app" "$req" --json | jq -r '.id')
   bashy shape verify "$app" "$cid" --phase red --json
   bashy shape verify "$app" "$cid" --phase green --json
   bashy shape verify "$app" "$cid" --phase refactor --json
   bashy shape approve "$app" "$cid" --json
   ```
3. **Compose in a Shapeable Bash# Skill-Script:** High-level `Red → Green → Refactor` orchestration lives in one `<100`-line `.bsh` file (`bashy/examples/shaping/tdd/shape-tdd.bsh`) with an embedded `~~~skill as guide` fence and a JSON **shaping hook** (`bashy/examples/shaping/tdd/shape-tdd.json`, following `examples/collab-save/collab-save.bsh` + `collab-save.json`), so `shape-tdd` can itself be shaped via `bashy shape`.
4. **100% Agent-First CLI Parity:** Every operation available in the Genie web UI (`/shape/<app>/...`) has a 1-to-1 `bashy shape` CLI operation on the same entities, with identical principal/actor permissions, approval rules, and `--json` output across `kind: web`, `kind: cli`, and `kind: service`.

### UI-to-CLI Action Parity Matrix

| User / Agent Operation | Web UI Surface (`/shape/<app>/...`) | Composable CLI Verb (`bashy shape ... --json`) |
| --- | --- | --- |
| Inspect active version & candidates | Genie Drawer Status Bar | `bashy shape status APP --json` |
| Propose change / import workspace | Genie Wish Input | `bashy shape wish APP [REQ] [--from DIR] --json` |
| Inspect candidate & TDD phase badges | Candidate Card (`Red` / `Green` / `Refactor`) | `bashy shape show APP ID --json` / `bashy shape diff APP ID --json` |
| Verify **Red** phase (fails on `BaseSHA`) | Candidate Verify (`Red` badge) | `bashy shape verify APP ID --phase red --json` |
| Verify **Green** phase (passes on `CandidateSHA`) | Candidate Verify (`Green` badge) | `bashy shape verify APP ID --phase green --json` |
| Verify **Refactor** phase (zero surface/effect drift) | Candidate Verify (`Refactor` badge) | `bashy shape verify APP ID --phase refactor [--contract ID...] --json` |
| Isolated preview (`web` URL / `cli` argv / `service` healthz) | Preview Frame / Try Button | `bashy shape preview APP ID [-- ARGS...] --json` |
| Activate verified candidate | Approve Button | `bashy shape approve APP ID --json` |
| Discard candidate | Reject Button | `bashy shape reject APP ID --json` |
| Report incident or trigger TDD self-repair | Incident Banner / Auto-Repair | `bashy shape incident APP [MSG] [--id ID] [--kind K] [--repair] --json` |
| One-step rollback / version restore | Undo / History Restore Button | `bashy shape undo APP --json` / `bashy shape restore APP REV --json` |
| Name release / offer / adopt / submit upstream | Share & Submit Controls | `bashy shape release|offer|adopt|submit APP REV --json` |

---

## Pillar A — `bashy sprint` / `bashy todo` Planning & Master Execution Plan

### Baseline (2026-11-12)

| Item | Value |
| --- | --- |
| Submodule HEADs | `bashy` `2b886cb5`, `yoke` `9be7b5b5` |
| Tracked Todo Store | `docs/todo/` (mounted on Sprint #621 via `bashy sprint track 621`) |
| Sprint Card | `#621` (`12e0ca54-4941-5b64-bc6c-4eb80ac71a59`), column `backlog`, epic `software-shaping` |
| KB Context Traps (`bashy kb context`) | `kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th`, `kb:native-shaping-needs-ancestor-refs-and-completed-container-stops`, `kb:compose-examples-bash-commands-so-they-run-the-same-on-windows`, `kb:a-bash-go-fence-with-its-own-go-mod-fails-inside-the-umbrella-un`, `kb:in-bashy-bsh-the-background-job-marker-is-a-job-handle-not-an-os`, `kb:windows-go-sdk-junction-resolution` |

### Story Review & Triage: Verified at Source (`conductor` §Orientation 1–5)

| Story | Pri | Triage Class | What Was Verified at Source | KISS / MVP Scope ("Rod, Not Fish") |
| --- | --- | --- | --- | --- |
| **T1** Red-on-Base verifier primitive (`227e29b78d35`) | p1 | Design gap → Feature | `yoke/pkg/shape/verify/verify.go:280-399` tags candidate-added scripts in `checks/` as `From: "candidate"`, but `verify.Run` only executes checks after detaching to `CandidateSHA`. A tautological `exit 0` check passes today. | Extend `verify.Run` (`verify.go`) and `evidence.Record` (`evidence.go`) with `Phase: "red"\|"green"\|"refactor"`: stage `From == "candidate"` checks onto `BaseSHA` first (`RedOnBase: true` iff non-zero exit), then run all checks on `CandidateSHA` (`GreenOnCandidate: true` iff exit 0). |
| **T2** Native Go/CLI/service TDD (`54d9c175bfd4`) | p1 | Design gap → Feature | `yoke/pkg/shape/verify/program.go:220-244` (`guardProgramTree`) freezes all `*_test.go` files and `program_go.go:202-320` only lists baseline tests. Agents cannot add unit tests in `kind: cli` or `kind: service` candidates. | Update `program.go` and `program_go.go` so baseline `*_test.go` files remain frozen (`From: "baseline"`), while net-new candidate `*_test.go` files or `Test*` functions are admitted (`From: "candidate"`) and verified with Red-on-Base + Green-on-Candidate accounting. |
| **T3** Refactor-phase & `--contract` primitive (`350c3c3b5ddb`) | p1 | Design gap → Feature | `yoke/pkg/shape/verify/surface.go:135-196` enforces expand-then-contract on routes/units/flags/args/JSON keys, and `bashy/internal/agentos/shape.go:108` already defines `--contract` on `release`, but `verify` has no `--phase refactor` or `--contract` flag. | Reuse the existing `--contract` vocabulary in `surface.go` and `service.go`: `verify --phase refactor [--contract ID...]` checks 100% green tests + zero uncontracted surface removals + zero effect escalation (no new failing-on-base check required, no extra Go files). |
| **T4** Composable CLI flags & shapeable `shape-tdd.bsh` (`700a039a4994`) | p1 | Design gap → Feature | `bashy/internal/agentos/shape.go` lacks `--phase` and `--contract` on `verify`, and there is no `.bsh` composition for the 3-step TDD loop. | Wire `--phase=red\|green\|refactor` and `--contract` on `bashy shape verify` (`shape.go`, `delegate.go`, `shaped_candidate.go`), and build **`bashy/examples/shaping/tdd/shape-tdd.bsh`** + **`shape-tdd.json`** (shaping hook) composing `bashy shape ... --json`. |
| **T5** CLI + Web incident self-repair parity (`2521421b6ed0`) | p2 | Defect + Feature | `bashy/internal/agentos/shape_local.go:114-115` refuses `bashy shape incident` for `cli`/`service` apps and `offer`/`adopt` in `116-117`; `yoke/pkg/webconsole/shaped_repair.go:149` only asks for red-then-green in prose. | Remove the CLI refusal in `shape_local.go:114-117`, add `--repair` to `bashy shape incident APP --id ID --repair --json`, and enforce `RedOnBase && GreenOnCandidate` in `shaped_repair.go` across `web`, `cli`, and `service`. |
| **T6** `dag.md` + Bash# 3-OS E2E & CLI parity gate (`25910e1ade83`) | p2 | Test Gate | `examples/desk/dag.md` and `examples/dag/gh/dag.md` establish the portable `bashy dag` + ` ```bsh ` testing pattern. | Author **`bashy/examples/shaping/tdd/dag.md`** (`type: dag`) testing all CLI verbs, UI-to-CLI parity, `shape-tdd.bsh` contracts (`@require`/`@guard`/`@ensure`), and shaping `shape-tdd.json` itself across Linux, macOS, and Windows. |

### Disjoint File Carving & Delegation Plan (`conductor` §Scheduling 1–2)

| Wave | Lane | Story | Repo · Disjoint File Scope | Planned Worker |
| --- | --- | --- | --- | --- |
| **Wave 1** | A | **T1** (`227e29b78d35`) | `yoke`: `pkg/shape/verify/verify.go`, `pkg/shape/verify/verify_test.go`, `pkg/shape/evidence/evidence.go` | `codex-gpt6-sol` |
| **Wave 1** | B | **T2** (`54d9c175bfd4`) | `yoke`: `pkg/shape/verify/program.go`, `pkg/shape/verify/program_go.go`, `pkg/shape/verify/program_test.go`, `docs/shape-programs.md` | `claude-opus5.5` |
| **Wave 1** | C | **T3** (`350c3c3b5ddb`) | `yoke`: `pkg/shape/verify/surface.go`, `pkg/shape/verify/surface_test.go`, `pkg/shape/service.go` | `claude-sonnet5.5` |
| **Wave 2** | D | **T4** (`700a039a4994`) | `yoke`: `pkg/shape/delegate.go`, `pkg/webconsole/shaped_candidate.go`; `bashy`: `internal/agentos/shape.go`, `examples/shaping/tdd/shape-tdd.bsh`, `examples/shaping/tdd/shape-tdd.json`, `skills/bashy/commands/shape.md` | `opencode-glm-5.3` |
| **Wave 2** | E | **T5** (`2521421b6ed0`) | `yoke`: `pkg/webconsole/shaped_repair.go`, `pkg/webconsole/shaped_repair_test.go`; `bashy`: `internal/agentos/shape_local.go` | `muse-spark1.3` |
| **Wave 3** | F | **T6** (`25910e1ade83`) | `bashy`: `examples/shaping/tdd/dag.md`, `internal/agentos/shape_tdd_e2e_test.go` | `agy-gemini3.8-flash` |

---

## Pillar B — `bash#` Skill / Script / `dag.md` for Testing & Verification

### 1. Shapeable Bash# Skill-Script (`shape-tdd.bsh` + `shape-tdd.json`)

Following `examples/collab-save/collab-save.bsh` + `collab-save.json` and `examples/desk/notepad/notepad.bsh`:
- **Single `.bsh` body with two faces:** `bashy/examples/shaping/tdd/shape-tdd.bsh` is both the executable command (`bashy commands add shape-tdd ...`) and its embedded skill (`~~~skill as guide`).
- **Declared Shaping Hook (`shape-tdd.json`):** Variable policy (default phases `["red","green","refactor"]`, required Red-on-Base kinds `["web","cli","service"]`, auto-approve on green `false`) lives in `shape-tdd.json` (`SHAPE_TDD_CONFIG`), so users and agents can shape the TDD workflow itself without editing Go code.
- **Composable CLI Sub-verbs (each usable standalone in pipelines):**
  - `bashy shape-tdd red APP ID [--json]` → wraps `bashy shape verify APP ID --phase red --json`
  - `bashy shape-tdd green APP ID [--json]` → wraps `bashy shape verify APP ID --phase green --json`
  - `bashy shape-tdd refactor APP ID [--contract UNIT...] [--json]` → wraps `bashy shape verify APP ID --phase refactor --json`
  - `bashy shape-tdd cycle APP ID [--approve] [--json]` → composes `red && green && refactor` under `@guard(effects: "read,write,exec")`, `@require`, and `@ensure`, recording an attestation receipt in `bashy craft history`.

### 2. Portable `dag.md` Task Graph (`bashy/examples/shaping/tdd/dag.md`)

All unit, contract, CLI-parity, and 3-OS round-trip tests live in `bashy/examples/shaping/tdd/dag.md` (`type: dag`) and run via `bashy gate --command 'bashy dag -f examples/shaping/tdd/dag.md <target>' --json`:

| `dag.md` Target | Fence / Runner | Requires | Effects | What It Verifies |
| --- | --- | --- | --- | --- |
| `### unit-yoke` | ```` ```bash ```` | — | `read, write, exec` | `"$BASHY" awd "$root/yoke" -- env GOWORK=off go test ./pkg/shape/... ./pkg/webconsole/...` |
| `### unit-bashy` | ```` ```bash ```` | — | `read, write, exec` | `"$BASHY" awd "$root/bashy" -- env GOWORK=off go test ./internal/agentos -run 'TestShape'` |
| `### build` | ```` ```bash ```` | `unit-yoke, unit-bashy` | `read, write, exec` | Builds scratch `bashy`, verifies `shape-tdd.bsh --skill` and `--contract`, and runs `bashy dag --check`. |
| `### smoke-contract` | ```` ```bsh ```` (`~~~go` + `~~~sh`) | `build` | `read, write, exec` | Exercises `shape-tdd.bsh` agentic functions across `@require` (`exit 3`), `@guard` (`exit 126`), and `@ensure` (`exit 0` on valid Red→Green, `exit 3` on tautological check) and verifies receipts via `bashy craft history`. |
| `### roundtrip` | ```` ```bsh ```` | `smoke-contract` | `read, write, exec, net` | Runs full CLI-driven `Red → Green → Refactor` pipelines (`wish \| verify --phase red \| verify --phase green \| verify --phase refactor \| preview \| approve \| undo`) across `web`, `cli`, `service`, incident `--repair`, and shaping `shape-tdd.json` itself; emits `./shape-tdd-roundtrip.json` (`schema_version: "bashy-shape-tdd-v1"`). |
| `### mesh-linux` / `### mesh-darwin` / `### mesh-windows` | ```` ```bash ```` (`Host:`) | — | `read, write, exec, net` | Dispatched via `bashy dag --mesh -f examples/shaping/tdd/dag.md` on claimed OS test hosts. |

---

## Pillar C — Sprint Retro: Triage, Replan, and Repeat (`conductor` Loop)

### 1. The Per-Turn Conductor Tick (`bashy sprint tick 621`)

1. **MAIL FIRST:** Human instructions first, then `bashy inbox --as <owner>` and `bashy sprint inbox-ack <id> --as <owner>`.
2. **RE-PRIORITIZE & TRIAGE:** Update the board *before* staffing. Classify every new or red item as **defect** (`--blame agent`), **environment** (`--blame environment`), **design gap** (`--blame spec`), or **out of scope** (`sprint yield`).
3. **STAFF:** Check `bashy weave fleet --auth`, claim shared test hosts (`bashy claim host:<name>`), and dispatch ready independent stories (`bashy sprint assign 621 <story>`).
4. **MONITOR PROGRESS:** Read incremental evidence via `bashy lens -t listing run:ID --since=@cursor --cursor-out=cursor` and unblock gates via `bashy weave wait --issue N --broker`.
5. **INTEGRATE & VERIFY INDEPENDENTLY:** Run `bashy gate --command 'bashy dag -f examples/shaping/tdd/dag.md <target>' --json` yourself, then `bashy sprint review`, `bashy sprint grade`, and `bashy sprint merge`.
6. **CHECKPOINT:** `bashy sprint checkpoint 621 -m '<wave state, merged SHAs, open blockers>'`.
7. **REPEAT** until the 3-OS `roundtrip` gate passes on the frozen candidate.

### 2. Iteration Retro, KB Promotion, and Replanning (`conductor` §6 & §10)

At the end of each wave (Wave 1 → Wave 2 → Wave 3):
1. **Freeze** the integrated candidate SHAs (`yoke` + `bashy`).
2. **Batch Gate** via `bashy gate --command 'bashy dag -f examples/shaping/tdd/dag.md roundtrip' --json`.
3. **Score & Classify Blame:** `bashy sprint accept 621 <story> --agent <tool:model> --points <p> --rework <r>` or `bashy sprint fail 621 <story> --blame agent|environment|spec --evidence gate:<ref>`.
4. **Replan the Reds by Root Cause:** Group failures by root cause, embed bisect findings into story `KNOWN TRAPS` (`bashy todo edit <id>`), and re-run only the affected target.
5. **Gate-Validated KB Retro:**
   - `bashy kb note add --candidate --ring agent --episode "sprint-621" --title "<lesson>" --body "<guardrail>"`
   - `bashy kb observe --ring agent --episode "sprint-621" --kind gate --ref "shape-tdd-roundtrip" --ran --passed --command "bashy dag -f examples/shaping/tdd/dag.md roundtrip" --exit-code 0 --where "<merged-sha>" --json`
   - `bashy kb validate <slug> --ring agent --from-gate <event-id>`
   - `bashy kb retro shaping tdd verify dag`

---

## Open Decisions for the Operator

1. **Green-only changes uses `--phase refactor` (KISS):** Rather than adding a separate `--allow-green-only` flag, any pure cleanup or config change that adds no new failing-on-base test uses `bashy shape verify APP ID --phase refactor --json` (which enforces 100% green checks + zero uncontracted surface drift + zero effect escalation).
2. **Single `yoke` pin bump:** Merge all `yoke` changes (`T1`, `T2`, `T3`, and the `yoke` halves of `T4` and `T5`) before performing one `yoke` pin bump in `bashy`.

No release is authorized by this sprint.
