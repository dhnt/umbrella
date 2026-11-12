# Sprint 626 master execution plan — vendor services through one generic service door

Status: planning only. The sprint is filed in the backlog and has not started.
Sprint 627 (the music-video showcase) depends on it.

## Outcome

Any agent can call a vendor's native feature through one consistent bashy verb:
plan, search, image, draw, pdf, video, transcribe, narrate, email, drive. Every verb has the same
`--provider` / `--route` selection, the same `bashy-svc-v1` JSON envelope and
the same three doors (shell, MCP, llm API). Vendor agent CLIs (claude, codex,
agy, muse), local open-source models, browser automation and paid APIs are all
**providers** behind those verbs. opencode, genie and ycode are **clients
only**: they test the services but offer none.

## Source-verified baseline

- **Tool commands (Sprint 324).** These already expose vendor features as
  `bashy tool cmd run TOOL:NAME`:
  - Commands are declared under `commands:` in
    `yoke/pkg/fleet/baseline/tools/<tool>.yaml` (`fleet.ToolCommand`). The
    modes are `print`, `tui` and `http`.
  - The runner is `yoke/pkg/toolcmd`.
  - The llm API filter `slash=<name>` is in `yoke/pkg/cligw/slash.go`.
  - The canonical vocabulary is in `yoke/pkg/fleet/toolcommand.go`.
  - Only two commands are seeded: `claude:plan` (tui) and `codex:review`
    (print). Seeds must be measured on the wire (`# MEASURED <date>`).
- **Provider selection already exists for transcription.** `bashy transcribe`
  selects registered commands by `provides:` role, `accepts` (JSON-pointer /
  RE2), `requires` and `effects`. The `--provider NAME` override wins, and
  ambiguity or no match is reported
  (`bashy/docs/transcribe-contract.md`; record fields in
  `yoke/pkg/fleet/cli_commands.go`). This sprint generalizes that selector
  instead of adding a second one.
- **`bashy search`** has a backend ladder: `--backend tavily|brave|serper`.
- **`bashy mcp serve`** exposes atlas verbs and registered commands as MCP
  tools (`bashy/internal/agentos/mcp_verbs.go`).
- **Default commands** are registered at bootstrap by
  `bashy/examples/defaults/bashy-defaults.bsh` (`DEFAULT_COMMANDS`).
- **Name check.** `plan`, `image`, `draw`, `pdf`, `video`, `film`, `song`,
  `animate`, `narrate`, `email`, `drive` and `providers` are free. `mail` is
  classic Unix mail and stays that way. `service` is the supervisord unit verb
  and stays that way.

### Vendor surfaces checked locally

Checked on 2026-11-12 with `--help` only. claude 2.1.284, codex-cli 0.157.1,
agy 1.5.7, muse 1.4.3.

| Feature | claude | codex | agy | muse |
|---|---|---|---|---|
| Headless plan | `--permission-mode plan` (print, unmeasured); `/plan` TUI seeded | no plan mode | `--mode plan -p` | bundled `/plan` skill (interactive; print unmeasured) |
| Search | WebSearch/WebFetch tools | `--search` (exec support unmeasured) | Gemini grounding (unmeasured) | web tools on by default |
| Image | input only | image generation feature (headless unmeasured) | — | input only |
| Voice | — | realtime/dictation (TUI only) | `/voice live` (TUI only), `mic-serve` | `muse voice transcribe FILE` |
| Gmail/Drive | claude.ai connectors (print reported, unmeasured) | apps feature (unclear) | explore | — |
| Driven by agents | `-p --output-format json`, `mcp serve` | `exec --json`, `app-server` (`mcp-server` removed) | `-p --output-format json`, `acp` | `exec --json`, `serve` |

None of the four CLIs produces spoken audio headlessly. Narration through
codex `/realtime` or agy `/voice live` is a TUI-steering spike (S4).

## Design

1. **Roles.** A role is an open dotted value, not an enum: `plan`, `search`,
   `image.generate`, `image.edit`, `draw`, `pdf.read`, `video.understand`,
   `transcribe.*`, `narrate`, `email.read`, `email.send`, `drive.read`,
   `drive.write`. Sprint 627 adds `song`, `animate` and `film`.
2. **Providers.** One candidate set is built from two sources:
   - registered commands that declare `provides:`;
   - vendor tool commands, projected automatically (`claude:plan` provides
     `plan`).

   An optional `route` field (`oss | vendor | browser | api`) is added to the
   command record. Tool commands are implicitly `vendor`.
3. **Selector.** The transcribe selector is lifted into a shared package with
   two front ends:
   - `bashy providers [ROLE] [--json]` lists candidates and why each was
     rejected.
   - `bashy providers select ROLE [--provider N] [--route R] [REQUEST.json]`
     prints exactly one provider.

   The automatic order is **oss → vendor → browser → api**: draft cheaply, pay
   last. A provider whose effects spend money or send messages is only
   selected with `--yes`. `transcribe select` stays as an alias.
4. **One door body.** `service-door.bsh ROLE` selects a provider, invokes it
   (`bashy <cmd>` or `bashy tool cmd run TOOL:NAME`) and emits `bashy-svc-v1`:
   `{role, provider, route, outcome, outputs, text, cost_class, elapsed}`.
5. **Common flags.** Every service verb takes `--provider`, `--route`,
   `--json`, `--dry-run`, `--out DIR`, `--yes`, `--async` and `--providers`.
   On `search`, `--backend` becomes a deprecated alias of `--provider`.
6. **Shipped as default custom commands.** Each verb is a registered command
   record that points at the door body with its role. Records are registered at
   bootstrap through `bashy-defaults.bsh`, and users can edit, shadow, retire
   or shape them. Core Go is limited to three pieces: the selector and
   `providers` verb, the `route` field, and the tool-command projection.

## Stories and vendor lanes

| ID | Story | Lane | Depends |
|---|---|---|---|
| F | Generic service door framework | codex-gpt6-sol (implement), claude-opus5.5 (review) | — |
| S0 | Vocabulary, capability tags, design doc catalog | claude-opus5.5 | F |
| S1 | `plan`: measure and seed claude print, agy, muse | claude-opus5.5 | F, S0 |
| S2 | `search`: measure and seed codex, claude, agy, muse | codex-gpt6-sol | F, S0 |
| S3 | `image` / `draw` / `pdf`: measure and seed | codex-gpt6-sol (image), claude-opus5.5 (draw, pdf) | F, S0 |
| S4 | Voice: `muse:transcribe` seed; `narrate` TUI audio-capture spike | muse-spark1.3 (transcribe), codex-gpt6-sol (narrate spike) | F, S0 |
| S5 | `email` / `drive`: claude connectors, `bashy google` provider, agy exploration | claude-opus5.5, agy-gemini3.8-flash (explore) | F, S0 |
| S6 | `video`: measure agy video understanding | agy-gemini3.8-flash | F, S0 |
| S7 | Client acceptance: opencode, genie, ycode through shell, MCP and llm API | claude-opus5.5 (conductor) | S1–S6 |

## Verification

- Unit tests are targeted only: `cd yoke && go test ./pkg/fleet/
  ./pkg/toolcmd/ ./pkg/capability/ ./pkg/cligw/` plus the selector and the
  transcribe/search packages. Full gates are deferred to QA.
- Each seed gets one live smoke through `bashy <verb> --json`, checking the
  outcome and the artifact. Its `# MEASURED` comment records the date, CLI
  version and elapsed time.
- `--dry-run` and refusal of paid or sending providers without `--yes` are
  unit-tested.
- Email and drive smokes are read-only: search and list only.
- S7 records a client × door × service pass/fail matrix.
