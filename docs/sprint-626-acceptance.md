# Sprint 626 S7 acceptance — clients × doors × services

Story #180 (`c2aa9fafc615`). Spec: `docs/sprint-626-master-execution-plan.md`.
Run on 2026-11-12 (UTC 2026-11-13) on the dev host by claude-opus5.5. These
are fresh runs, not reuse of earlier evidence. Raw evidence (envelopes, HTTP
headers and bodies, MCP JSON-RPC logs, client transcripts) is kept on the
dev host under the run's temp directory, `/tmp/s7-180/raw/`. It is not
committed because it holds mailbox and Drive identifiers.

## Candidate and venue

| Item | Value |
|---|---|
| bashy | origin/main `be7118e6` (yoke `9885bb5b`), `GOWORK=off go build ./cmd/bashy`, used by path; the installed bashy was not replaced |
| Defaults | `bashy-defaults.bsh apply` from a `git archive be7118e6 examples kb` copy, registered into an isolated `BASHY_COMMANDS_DIR`, with `BASHY_HOME` isolated too |
| Host tool overlays | isolated `BASHY_TOOLS_DIR` (empty), from 17:53 local time onward; see finding F6 |
| llm API door | a private `bashy llm serve --port 24599 --no-engine` (cligw only) in the isolated home; the host's own door was not touched |
| Vendor CLIs | claude 2.1.284 on the shell and MCP paths (2.1.295 from the bashy cache when the door spawns `claude-fable5.1`), agy 1.5.7, muse 1.4.3, codex-cli 0.157.1 (selection only) |
| Clients | opencode 2.2.6; genie and ycode = `bashy genie` / `bashy ycode … prompt` (the ycode engine running the builtin genie harness) |
| Client model | all three clients use the private door's band `L4` (cligw → a claude seat) through its OpenAI-compatible endpoint. No local model and no ollama ran (operator venue rule mb:13538). No paid API key was used. |

Fixtures: `invoice.pdf` (agent-bench `t6-pdf-fact`), `speech-video.webm` and
`spanish-proverb.wav` (bashy `examples/transcribe/fixtures`).

### Service per category and the exact call

| Category | Provider | Shell door | MCP door (`bashy mcp serve --tools plan,search,image,draw,pdf,video,email,drive,providers,tool`) | llm API (`X-Bashy-Filter`) |
|---|---|---|---|---|
| plan | claude:plan | `bashy plan --provider claude:plan --json TEXT` | `plan` | `slash=plan,tool=claude`, model `L4` |
| search | search-claude | `bashy search --provider search-claude --json Q` | `search` | `slash=search` |
| image | codex:image (SPEND) | `bashy image --dry-run --yes --json P` (selection only) | `image` same args | `GET /v1/models?slash=image` (listing only) |
| draw | claude:draw | `bashy draw --yes --json P` | `draw` | `slash=draw,tool=claude` |
| pdf | claude:pdf | `bashy pdf --provider claude:pdf --yes --json FILE` | `pdf` | `slash=pdf,tool=claude` |
| video | agy:video | `bashy video --json TEXT` | `video` | `slash=video,tool=agy`, model `agy-gemini3.8-flash` |
| transcribe | muse:transcribe | `bashy tool cmd run muse:transcribe --json -- WAV` | `tool` with the same argv | `slash=transcribe,tool=muse` |
| email | claude:email.read | `bashy email --json "count newer_than:7d, ids only"` | `email` | `slash=email.read,tool=claude` |
| drive | claude:drive.read | `bashy drive --json "3 most recent, ids only"` | `drive` | `slash=drive.read,tool=claude` |

`--yes` was passed only to draw and pdf, whose sole gated effect is the local
`write` of the artifact into the door's out dir. Neither declares `spend` or
`send`. For image, `--yes` appears only together with `--dry-run`: the door
stops after selection, before any rod runs. codex `generated_images` held 11
files before and 11 after. No bypass flag was used: no
`--dangerously-skip-permissions`, no MCP `--allow`, no `--yolo` flag. genie
and ycode ran their default unattended profile (`BASHY_UNATTENDED_AGENT=1` →
`agent-yolo.yaml`). Email and Drive were read-only (count and ids). Nothing
was sent, shared or spent.

## Matrix

PASS means the client made the call through the door and the raw outcome is
the service's real success: `outcome: success` and, for draw and pdf, a
non-empty artifact. For image, PASS means `outcome: dry-run` with codex:image
selected. Each cell shows the raw outcome first, then any condition.

| Service | opencode · shell | opencode · MCP | opencode · llm API | genie · shell | genie · llm API | ycode · shell | ycode · llm API | genie / ycode · MCP |
|---|---|---|---|---|---|---|---|---|
| plan | PASS exit 0 success | PASS exit 0 success | PASS† 200 success | PASS‡ exit 0 success | PASS†‡ 200 success | PASS‡ exit 0 success | PASS†‡ 200 success | N/A (F8) |
| search | PASS exit 0 success, 8 results | PASS exit 0 success, 8 results | FAIL 400 (F4) | PASS‡ success, 8 results | FAIL 400 (F4) | PASS‡ success, 8 results | FAIL 400 (F4) | N/A |
| image (selection) | PASS dry-run codex:image | PASS dry-run codex:image | PASS listing 59 models | PASS‡ dry-run | PASS‡ listing 59 | PASS‡ dry-run | PASS‡ listing 59 | N/A |
| draw | PASS success, SVG | PASS success, SVG | FAIL 502 refused (confirm) (F5) | PASS‡ success, SVG | FAIL 502 (F5) | PASS‡ success, SVG | FAIL 502 (F5) | N/A |
| pdf | PASS success, TXT | PASS success, TXT | FAIL 502 refused (confirm) (F5) | PASS‡ success, TXT | FAIL 502 (F5) | PASS‡ success, TXT | FAIL 502 (F5) | N/A |
| video | PASS success | PASS success | PASS† 200 success | PASS‡ success | FAIL client timeout 60 s (F9) | PASS‡ success | PASS†‡ 200 success | N/A |
| transcribe | PASS success | FAIL exit 126 denied: effect destroy (F3) | PASS 200 success | PASS‡ success | PASS‡ 200 success | PASS‡ success | PASS‡ 200 success | N/A |
| email.read | PASS success (count 172) | PASS success | PASS† 200 success (count 173) | PASS‡ success (count 174) | PASS†‡ 200 (count 175) | PASS‡ success (count 174) | PASS†‡ 200 (count 175) | N/A |
| drive.read | PASS success (3 ids) | PASS success | PASS† 200 success | PASS‡ success | PASS†‡ 200 | PASS‡ success | PASS†‡ 200 | N/A |

† Only when the chat message is wrapped in double quotes, which works around
defect F1. With a plain message the door runs the command on the first word
only (F1).
‡ Only on the genie harness variant. Its sole change adds `USER`, `LOGNAME`
and the isolation variables to the env allowlist (F7, venue V2). Each call
was first denied by the harness preflight and then run inside the
harness-prescribed `@effects`/`@guard` envelope (F2).

Sessions (all exit 0): opencode shell 164 s, MCP 138 s, llm API 154 s;
genie shell 209 s, llm API 320 s; ycode shell 204 s, llm API 280 s.
opencode also reached the slash door natively: with its own model provider
configured with the header `X-Bashy-Filter: slash=transcribe,tool=muse`, one
chat turn returned the muse transcript (the expected proverb ×3).

### Direct baseline (no client)

The same calls were made directly before any client ran: shell through
`bash`, MCP through a minimal stdio JSON-RPC client, and the llm API through
curl. The results match the opencode columns cell for cell, with two
exceptions: the first llm API plan run used a plain message and failed (F1), and
llm API video with model `L4` returned 404 until the agy agent was named (F10).
Elapsed times: shell plan 15 s, search 20 s, draw 5 s, pdf 8 s, video 15 s,
transcribe about 5 s, email 16 s, drive 9 s. llm API video 59 s.

## Findings and root causes

Every failure was investigated before any fix, and none were fixed in this
story. Classification follows CLAUDE.md "Root cause before any fix".

| ID | Class | Finding | Root cause (source) | Proposed fix / owner |
|---|---|---|---|---|
| F1 | product defect (security-relevant) | llm API slash= splits the user message into argv words. A plain plan request containing `--version` ran `claude … --version`: the door returned claude's version string as `outcome: success`. A plain multi-word request reached claude as the first word only ("Plan"). | `yoke/pkg/cligw/slash.go:360` passes `lastUserText(req)` as the args string and never sets `toolcmd.Options.Argv`. `toolcmd` then shell-splits it (`SplitArgs`), and `{args}` in every seed (`claude:plan`, `agy:video`, `claude:email.read`, …) expands to many tokens. The seeds were measured on the shell door, where `{args}` is ONE operand. A message can therefore inject vendor CLI flags. | Set `Argv: []string{args}` (the message as one operand) in the slash path, with a unit test that has a leading-dash message. yoke follow-up. |
| F2 | product gap | genie/ycode harness preflight denies every `bashy <service>` and `curl` call ("command is missing a complete Command Atlas classification"; `search` and `tool`: "front-door command requires a trusted digest-pinned executable resolver"). The calls run only inside a declared-effects envelope. | ycode harness preflight (`incomplete-preflight` rule). Registered door commands and the `search`/`tool` front doors carry no complete Atlas classification for the harness. | Classify the service-door commands (or the door body) for the harness preflight. ycode/bashy follow-up. |
| F3 | product gap | transcribe has no MCP-reachable door. The registered door verbs exclude transcribe (`bashy transcribe` is the S503 pipeline verb), and the generic `tool` verb is denied: `effect destroy requires --allow destroy`. | `bashy mcp serve` authorizes a tool by its verb's atlas effects. `tool` aggregates every subcommand's effects (cancel/rm → `destroy`), so read-only `tool cmd run` is denied too. | A transcribe service door verb, or per-subcommand effects for `tool cmd run`. bashy follow-up. Not worked around: granting `--allow destroy` would be a bypass. |
| F4 | design scope | llm API slash=search → 400 "no tool declares command search". | Search providers are registered rods (`search-*` commands), not tool commands. slash= only reaches tool commands (`cligw/slash.go`). | Decide whether slash= should reach registered rods or the service door. Spec question for the sprint owner. |
| F5 | design (safe) | llm API slash=draw and slash=pdf → 502 `refused (confirm): … declares mutating effect write`. | `toolcmd.Run` → `Admit` with `Options{Agent}` only. The API has no consent channel, so any command that `NeedsConfirmation` is refused. This is also why slash=image cannot spend. | A consent mechanism for the API (if wanted), or keep refusing. Spec question. |
| F6 | environment (another lane's change) | From 17:53, `bashy providers select` exited 2 for every role on this host: `tool replicate-media: command song: http.url "https://api.replicate.com" must be an absolute http URL without userinfo`. | A new host overlay, `$HOME/.config/bashy/tools/replicate-media.yaml` (S627 M5 lane, unclaimed), fails fleet validation. The provider catalog rejects the whole catalog for one bad tool. | Overlay: its owner was notified (mb announce + family codex-gpt6-sol); the file was not touched. Catalog all-or-nothing: bashy/yoke follow-up. The S7 venue isolated `BASHY_TOOLS_DIR` to restore the baseline. |
| F7 | product gap (realistic env) | Through genie/ycode, every claude-backed provider returned `Not logged in · Please run /login`. | The genie harness env allowlist (`ycode/examples/genie/agent.yaml` and `agent-yolo.yaml`, line 431) omits `USER`, and claude on macOS reads its Keychain credential by user. Proven A/B: `env -i HOME PATH claude -p` → "Not logged in"; adding `USER` → answers. | Add `USER` (and `LOGNAME`) to both genie profiles. ycode follow-up. Proven by the variant: 9/9 on the shell door. |
| F8 | design (client) | genie and ycode have no MCP client, so the MCP door is not applicable to them. | ycode removed MCP in both directions in 2026-07 (`ycode/docs/agent-os-reference.md:40`, `ycode/docs/features.md:418`). | None; opencode covers the MCP door. |
| F9 | environment (client limit) | genie llm API video: curl killed at the harness limit. ycode's identical call succeeded. | genie per-command wall time `timeoutMs: 60000` (`agent-yolo.yaml:443`) versus agy:video over the door (59 s direct; S6 measured 117–123 s). | Use the shell door (15 s here) or `--async` for long roles; or raise the per-command ceiling for service calls. |
| F10 | product (minor) | `GET /v1/models?slash=video` lists every band (L1…L5+), but `POST` with `model: L4, slash=video` → 404 (agy sits in band L3). | The catalog's slash listing keeps band ids without checking a capable agent per band. | Filter band rows by capable agents. cligw follow-up. |
| F11 | product (minor) | MCP registered service tools have description `" — "`. | The door records carry no synopsis, so clients see no description. | Give the service-door records a description. bashy follow-up. |

### Test and venue issues (fixed in the test or venue, not in product code)

| ID | Class | What happened | Fix |
|---|---|---|---|
| T1 | test defect | genie and ycode, first prompt: the model answered with the requested report template ("exit=none outcome=none") and made zero tool calls (transcript shows none). | Prompt reworded: execute every command and never report an unobserved value. |
| V1 | environment | The isolated `BASHY_COMMANDS_DIR` / `BASHY_TOOLS_DIR` / `BASHY_LLM_PORT` did not reach genie/ycode tool calls (`bashy: plan: command not found`). video worked only through the host's own `video` record. | Caused by the env allowlist (F7). Venue variant V2. |
| V2 | venue | genie variant: built with `bashy genie build --from` a copy of the builtin source `d74d5972`, used through `GENIE_SOURCE`. Its only diff is line 431 of `agent.yaml`/`agent-yolo.yaml`: `+USER, LOGNAME, BASHY_COMMANDS_DIR, BASHY_TOOLS_DIR, BASHY_LLM_PORT`. | — |
| V3 | environment (unconfirmed) | One genie session started in the same second as a ycode session on the same `BASHY_HOME` failed at once: `profile-model: set GENIE_PROFILE and GENIE_MODEL_ID`. It did not reproduce when sessions were staggered by 30 s. | Not bisected. Suspected concurrent-start race on shared genie state. Recorded, not claimed fixed. |
| V4 | venue mistake, reverted | The first `bashy-defaults apply` ran without `BASHY_COMMANDS_DIR`. The registry follows XDG, not `BASHY_HOME`, so 23 records pointing at the temp copy landed in the host registry. | All 23 (each referencing the temp path, created by this run) were removed at once. The host registry is back to its prior 21 records; `record` and `video` were untouched. |

## Verdict

- **opencode:** shell 9/9; MCP 8/9 (transcribe F3); llm API 6/9 (search F4, draw and pdf F5 by design; plan, video, email and drive need the F1 quote workaround).
- **genie and ycode:** shell 9/9; llm API 6/9 (ycode) and 5/9 (genie, which also hits F9), but only on the variant (F7) and through the preflight envelope (F2). With the shipped harness, the shell door gives genie and ycode 0/9 when commands are sent as written (F2 denies each). With the envelope it gives 3/9: image dry-run, video and transcribe. The claude-backed six fail with "Not logged in" (F7). MCP is N/A (F8).
- **Story acceptance:** the matrix is recorded and every failure has a root cause. Product defects F1, F2, F3, F7 (and minors F6 catalog, F10, F11) are open follow-ups; none are fixed here. F1 is the priority: it is an argument-injection path on the llm API door.
- **Follow-up todos:** F1 `c9f0a2d5`, F7 `2b89b64e`, F2 `5f878447`, F3 `eb02f440`. F6 overlay: reported to its owner. F4, F5 and F10–F11: open spec or minor items for the sprint owner.
