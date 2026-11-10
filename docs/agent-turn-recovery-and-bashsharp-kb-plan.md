# Third-Party Agent Turn Error-Recovery OTel Spans, `Bash#` KB Wiki Auto-Composition, and KB/Shaping Tidy

## 1. Executive Summary

When a third-party coding agent (`claude`, `codex`, `opencode`, `gemini`, `agy`, `aider`, `copilot`) receives a user prompt/instruction, executes a sequence of `bashy` commands, encounters one or more command errors, self-corrects, and responds with a solution:

1. **Delineate & Record the Turn Trace Span (`gen_ai.turn`)**:
   - Capture the prompt-to-solution boundary via deterministic CLI hooks (`UserPromptSubmit` $\rightarrow$ `Stop`) for standalone agents, W3C `TRACEPARENT` propagation for orchestrated launches (`bashy chat` / `invoke` / `weave` / `acp`), and an idle-window fallback for unhooked agents.
   - Parent all child `exec <cmd>` spans under `gen_ai.turn`, distinguish benign exit-1 probes (`grep`, `rg`, `diff`, `cmp`, `test`, `[`, `pgrep`) from real command errors, and record turn-level recovery attributes (`turn.had_error=true`, `turn.recovered=true`, `turn.outcome="recovered_success"`), queryable via `bashy otel recovered`.
2. **Auto-Compose & Evolve Wiki-Versioned KB Runbooks with Executable `Bash#` Drafts**:
   - Whenever a turn completes with `turn.recovered == true`, automatically reconcile against `bashy kb` (`kb.NearDuplicate` + deterministic recovery key): create a new candidate `runbook` (`op = "add"`) if none exists, or evolve the existing wiki page (`op = "update"` / `"supersede"`) while preserving edition history in `journal.jsonl`, pure-Go `.git` snapshots (`Store.gitSnapshot`), bitemporal intervals (`kblife.Supersede`), and an inline `## Editions` section.
   - Embed a top-level executable `Bash#` (```` ```bsh ````) script/skill draft (`@guard`, `@effects`, `@require`, `@ensure`) where the succeeded `bashy` command sequence forms the body and comments are derived from the user instruction, failed command pitfalls, and LLM solution response, stamped with filterable tags (`auto-composed`, `turn-recovered`, `user-instructed` / `implicit-turn`, `bashsharp`).
3. **Lifecycle Hygiene (`prune` · `compact` · `tidy`) for `bashy kb` and Software Shaping**:
   - Provide `bashy kb {prune,compact,tidy}` and Software Shaping (`yoke/pkg/shape` and `yoke/pkg/skills`) `prune`/`compact`/`tidy` actions (with `--dry-run` and `--json`) to reclaim stale unopened auto-composed candidates, merge near-duplicate candidates, cap inline edition lists, and garbage-collect unreferenced shaping side-slot binaries, stale `.evidence` records, and superseded `Bash#` skill overlays/attestations.

---

## 2. Codebase Inspection & 5 Architectural Gaps

### 2.1 Existing Primitives
- **Per-Command OTel Spans (`yoke/pkg/telemetry/exec.go`)**: `ExecMiddleware` wraps every front-door verb (`agentos.Dispatch`) and shell subcommand (`agentos.WireExec`) in an `exec <cmd>` span (`cmd.name`, `cmd.argv`, `cmd.cwd`, `agent.principal`, `cmd.duration_ms`, `cmd.exit_code`), spooling by default to `~/.agents/otel/spool/spans.jsonl`.
- **GenAI Turn & Call Spans (`yoke/pkg/telemetry/genai.go`)**: Implements OpenTelemetry GenAI Semantic Conventions v1.42.0 (`StartGenAITurn` emitting `gen_ai.turn`, `StartGenAICall` emitting `chat <model>`).
- **TIME Execution Plane (`yoke/pkg/execlog`)**: `execHistHandler` writes per-command records (`~/.bashy/exec/<day>/<episode>.jsonl`), `Transitions` counts adjacent `(src -> dst)` recovery bigrams, and `PromoteToKB` writes `exec-observed` candidate `gotcha` pages.
- **Agent Wiring & Hooks (`bashy/internal/agentos/installagent.go`, `nudge.go`)**: Wires `bashy` as the execution shell for third-party agents and installs `SessionStart` + `UserPromptSubmit` hooks for Claude Code and Codex.
- **Executable Text-Outer Skills & KB Wiki (`yoke/pkg/unit`, `yoke/pkg/skills/bashsharp.go`, `yoke/pkg/kb`)**: `unit.BashSharpBody` extracts top-level `bsh` fences from markdown documents, `unit.ReadContract` parses `@require`/`@ensure`/`@effects`/`@guard` decorators, and `kb.Store.Write` maintains `journal.jsonl` + pure-Go `.git` commits per page edition.

### 2.2 The 5 Gaps
1. **Gap 1 — Missing `TRACEPARENT` Extraction in `bashy`**: `telemetry.Init` registers `propagation.TraceContext{}`, but `cmd/bashy/main.go` and `ExecMiddleware` never extract `TRACEPARENT` from `os.Environ()`. Every `bashy -c` invocation starts a fresh root `trace_id`.
2. **Gap 2 — Missing `TRACEPARENT` Injection in `chat` Launches**: `agentChildEnv(ctx)` in `yoke/pkg/chat/chat.go` does not inject `TRACEPARENT` from `callCtx` into child agent processes, and `chat.Session` does not wrap interactive prompt-to-idle turns in `StartGenAITurn`.
3. **Gap 3 — Standalone Third-Party Agent Turn Boundaries (`Start` / `Stop`)**: Standalone agents run each command in a separate `bashy -c` OS process. `install-agent --hooks` wires `UserPromptSubmit` but not `Stop`, and no cross-process turn state (`~/.bashy/turns/<episode>.json`) links those commands under a shared `gen_ai.turn` span.
4. **Gap 4 — Cross-Process Episode Identity & `execlog.Transitions` Same-PID Filter**: `coord.Self().Episode` only checks `CLAUDE_CODE_SESSION_ID` in `harnessSessionEnv`, minting random episodes for other agents. Worse, `execlog.Transitions` skips pairs where `prev.PID != cur.PID`, dropping all cross-tool-call recoveries in third-party agents that spawn a new `bashy` PID per tool call.
5. **Gap 5 — Benign Exit-1 Noise in OTel & Multi-Step Recovery Classification**: `ExecMiddleware` marks every non-zero exit as `codes.Error` (even when `grep`, `rg`, `diff`, or `test` returns `1` for a normal negative answer, ~40% of exit-1s), and no turn-level classifier summarizes `turn.had_error` + `turn.recovered` or auto-composes a reusable `Bash#` KB runbook from the recovered turn.

---

## 3. SOTA Alignment (2025–2026)

1. **OpenTelemetry GenAI Semantic Conventions (v1.37–v1.42+)**:
   - Models an agent prompt-to-response cycle as a parent `gen_ai.turn` / `invoke_agent` span correlated by `gen_ai.conversation.id` (`episode`), with child `exec <cmd>` tool spans linked via W3C `TRACEPARENT`.
2. **CLI Lifecycle Hooks (`UserPromptSubmit` & `Stop`)**:
   - Modern coding CLIs (Claude Code, Codex, Gemini CLI) emit deterministic hook events over `stdin` JSON (`session_id`, `prompt`, `transcript_path`, `last_assistant_message`). Opening cross-process turn state on `UserPromptSubmit` and closing/exporting the parent `gen_ai.turn` span on `Stop` (with an idle-window fallback for hookless agents) gives exact start/stop delineation.
3. **Trajectory Self-Correction & Procedural Memory Distillation**:
   - SOTA observability frameworks (OpenInference / Arize Phoenix, Langfuse) classify agent trajectories into `clean_success`, `recovered_success`, `unrecovered_failure`, and `doomed_loop`. Converting a `recovered_success` trajectory into a contracted, human-reviewable candidate runbook (`Bash#` script + wiki edition history) closes the loop between observability and procedural memory.

---

## 4. Architecture & Story Specifications

### Story S1 — W3C `TRACEPARENT` Env Propagation & Cross-Process Episode Identity
- **`yoke/pkg/telemetry/telemetry.go` & `bashy/cmd/bashy/main.go`**:
  - Add `ExtractEnvContext(ctx)` and `InjectEnv(ctx, env)` to read/write `TRACEPARENT` and `TRACESTATE`.
  - Extract `TRACEPARENT` into the root `ctx` in `cmd/bashy/main.go`.
- **`yoke/pkg/chat/chat.go` & `session.go`**:
  - Inject `TRACEPARENT` in `agentChildEnv(ctx)` and wrap `Session` prompt turns (`Say` $\rightarrow$ `WaitIdle`) in `StartGenAITurn`.
- **`yoke/pkg/policy/coord/identity.go`**:
  - Extend `harnessSessionEnv` (`CLAUDE_CODE_SESSION_ID`, `CODEX_SESSION_ID`, `GEMINI_SESSION_ID`, `OPENCODE_SESSION_ID`, `AGY_SESSION_ID`) and fall back to a deterministic parent-agent PID key (`ep-ppid-<agent>-<ppid>`).

### Story S2 — Third-Party Agent Turn Start/Stop Delineation via CLI Hooks & Turn State
- **`yoke/pkg/telemetry/turn.go`**:
  - Manage `~/.bashy/turns/<episode>.json` storing `TraceID`, `TurnSpanID`, `StartTimeUnix`, `LastActiveNano`, scrubbed `PromptSummary`, and ordered `Commands`.
  - Provide `StartTurn`, `RecordTurnCommand`, `EndTurn`, and automatic idle-window closure (`implicit_idle`) when a turn has been inactive past the idle threshold.
- **`bashy/internal/agentos/installagent.go` & `nudge.go`**:
  - Add `Stop` hook entries to `claudeHookEntries` and `installCodexHooks`.
  - In `runNudgeHook`, handle `UserPromptSubmit` (start turn with scrubbed prompt) and `Stop` (extract scrubbed assistant solution summary, close `gen_ai.turn` span, and trigger KB/`Bash#` auto-composition on `recovered_success`).

### Story S3 — Error-to-Recovery Trajectory Classification, Cross-PID `Transitions`, & `bashy otel recovered`
- **`yoke/pkg/telemetry/exec.go`**:
  - Share `IsBenignExit` (`grep`, `rg`, `diff`, `cmp`, `test`, `[`, `[[`, `pgrep` exit 1) so `ExecMiddleware` stamps `cmd.benign = true` and leaves status as `codes.Unset`.
  - Stamp `gen_ai.turn` on `EndTurn` with `turn.commands.total`, `turn.commands.failed`, `turn.commands.benign`, `turn.had_error`, `turn.recovered`, `turn.recovery_kind` (`same_command` | `same_dimension` | `subsequent_command`), and `turn.outcome` (`clean_success` | `recovered_success` | `unrecovered_failure` | `doomed_loop`).
- **`yoke/pkg/execlog/transitions.go`**:
  - Chain sequential commands across distinct `bashy -c` PIDs within the same `(Episode, TurnID)`.
- **`yoke/pkg/otelquery`**:
  - Add `bashy otel recovered` querying the OTel trace store when available and falling back to scanning `~/.agents/otel/spool/spans.jsonl` offline.

### Story S4 — Auto-Compose & Evolve Wiki-Versioned KB Runbooks with `Bash#` Script/Skill Drafts
- **`yoke/pkg/execlog/turnkb.go`**:
  - Reconcile recovered turns against `kb.Store` by deterministic `turn-recovery-key` (`<first_failed_tpl> -> <final_resolved_tpl>`) and `kb.NearDuplicate`:
    - **Create (`add`)** edition `v1` when no matching KB page exists.
    - **Update / Supersede (`update` / `supersede`)** when a candidate exists, incrementing recovery/episode counts, refining the `Bash#` script body, appending to the in-page `## Editions` section, and recording the mutation in `journal.jsonl` and `.git` via `Store.Write`.
  - Generate a top-level ```` ```bsh ```` block with `@guard`, `@effects`, `@require`, and `@ensure('<final_verifying_cmd>')`, where:
    - Header and step comments are synthesized from the scrubbed user instruction and LLM solution response.
    - Failed commands are documented as `# Avoid pitfall: ...` comments.
    - Succeeded commands form the `main() { ... }` body.
  - Stamp filterable tags: `auto-composed`, `turn-recovered`, `user-instructed` (or `implicit-turn`), `bashsharp`, `<cmd>`, `<dimension>`, and `source.tool: "bashy:turn-composer"`.

### Story S5 — `prune`, `compact`, and `tidy` Actions for `bashy kb` and Software Shaping
- **`yoke/pkg/kb/tidy.go` & `kb.go`**:
  - `bashy kb prune`: Tombstone and archive stale unvalidated `auto-composed` / `turn-recovered` candidates older than `--older-than` (default `30d`) with zero opens in `store.UseHistory()`.
  - `bashy kb compact`: Merge near-duplicate `auto-composed` candidates via `kblife.Supersede`, cap inline `## Editions` lists to the latest $N$ entries (full history remains in `journal.jsonl` and `.git`), and deduplicate redundant journal `observe` lines.
  - `bashy kb tidy`: Execute `compact` + `prune` + `RebuildIndex()` + `gitSnapshot("kb: tidy")` (with `--dry-run` and `--json`).
- **`yoke/pkg/shape/tidy.go`, `yoke/pkg/shape/slot`, `yoke/pkg/shape/evidence`, & `yoke/pkg/skills/bashsharp.go`**:
  - Reclaim unreferenced side-slot artifact directories under `$BASHY_HOME/shape-host/<app>/artifacts/<digest>` not pointed to by `Release`, `Active`, or `Previous`.
  - Prune stale/superseded `.evidence` records under `$BASHY_HOME/src/.evidence`.
  - Remove orphaned/unverified `bashsharp/*.bsh` skill overlays and compact `attest/*.jsonl` logs to the latest passing/failing receipt per `(Identity, ContextKey)`.
