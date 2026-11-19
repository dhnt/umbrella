# Plan — agentic tool support: official set

Planning record for the sprint "Agentic tool support: official set + latest
models". Planning only; no implementation is authorized by this document
alone.

## Decision (operator, 2026-11-19)

Officially supported agentic tools, all built-in fleet seeds
(`yoke/pkg/fleet/baseline/tools/`):

| Tool | Seed today | Change |
|---|---|---|
| ycode / genie (incl. `zero-ycode` passthrough) | built-in | none |
| claude | built-in | latest models |
| codex | built-in | latest models |
| opencode | built-in | latest models |
| agy | built-in | latest models |
| muse | built-in | latest models |
| zcode | built-in | latest models |
| kimi | built-in as `kimi-cli` | rename to `kimi` (its command name); aliases `kimi-code`, `kimi-cli` |
| dsh | `bashy/examples/fleet/tools/dsh.yaml` | graduate to built-in |

Dropped: Cursor (closed source; agent-adoption doc references only — database
and UI "cursor" stays).

Custom examples only (`bashy/examples/fleet/tools/`): aider, gemini-cli,
copilot, cline, goose (all permissive), plus hermes and openclaw (operator
decision 2026-11-19: stay examples). The gemini *models* stay because agy
routes them. Example tools get no model refresh.

## Gap

- aider, gemini, cline, goose, hermes and openclaw were already retired in
  `yoke/pkg/fleet/baseline/tools/` on 2026-10-09 and have example files. The
  retired stubs stay: retirement deliberately preserves a definition so
  history resolves. What remains is live code and docs that still treat the
  demoted tools as first-class, and a stale README `--force` note.
- `yoke/pkg/agentlaunch/launch.go` seeds an aider launch profile and unsafe
  flag mapping; `yoke/pkg/weave/weave_cooldown.go` lists aider and gemini as
  known fallbacks.
- `bashy/internal/agentos/installagent.go` wires aider, gemini, copilot.
- `bashy/docs/agent-adoption/{matrix,recipes}.md` carry Cline/Cursor rows and
  the demoted agents as first-class.
- dsh is a custom example while its peers are built-in; kimi's seed name
  differs from its command.
- Model seeds need a source-verified refresh per vendor family.

## Stories

1. Drop Cursor (bashy adoption docs).
2. Finish demoting aider, gemini-cli, copilot, cline, goose: remove live
   first-class references; keep the retired stubs (yoke, bashy).
3. Rename `kimi-cli` → `kimi` with aliases (yoke, bashy).
4. Graduate dsh to built-in (yoke, bashy).
5. Research latest models per official vendor family — sourced table, no
   seed edits (web search authorized by the operator 2026-11-19).
6. Seed latest models + agent bindings for the official set (yoke).
7. Docs + pins: adoption docs, examples README, install-agent help, yoke pin
   in bashy, umbrella pins.

Order: 1–4 independent; 5 → 6; 7 last.

## Non-goals

- Env-var tool detection in `yoke/pkg/fleet/detect.go` (hint-only) stays.
- Other example tools (crush, droid, forge, grok, junie, openhands,
  qwen-code, …) unchanged.
- No removal of older model seeds.
- No new `install-agent` shell, `--mcp` or `--hooks` writers for zcode, kimi
  or dsh (each seed declares `shell_env`); a follow-up if wanted.

## Compatibility

- Renamed and moved seeds keep old names as aliases where a binding or local
  overlay may reference them (`kimi-cli`, `kimi-code`).
- Users of demoted tools re-add them with `bashy tool add
  examples/fleet/tools/<name>.yaml`; the examples README states this.

## Acceptance and venue

- Dev box, `GOWORK=off`, targeted unit tests: yoke `./pkg/fleet/...
  ./pkg/agentlaunch/...`; bashy `./internal/agentos/...`; golden and seed-lint
  tests updated, not skipped.
- `bashy tool show`/`verify` for kimi and dsh; `bashy tool add` for each
  demoted example.
- No full gates. An example stays `unverified` until a live agent e2e run.

## Rollback

One commit per story per repo; pin bumps separate. Revert the story commit
and the pin bump.
