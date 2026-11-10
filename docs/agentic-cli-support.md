# Agentic CLI Support in `bashy`

`bashy` and `yoke` support agentic command-line harnesses across four architectural layers:

1. **Built-in Fleet Catalog (`yoke/pkg/fleet/baseline/tools/`)** — compiled-in tool definitions for `bashy agent run`, `bashy chat`, `bashy meet`, `bashy weave`, and `cligw`.
2. **Host Shell, MCP, and Hook Wiring (`bashy install-agent`)** — configures external agent CLIs to use `bashy` as their shell, registers `bashy mcp` as an MCP tool server, and installs turn-boundary inbox hooks.
3. **Ambient Harness Detection & Launch Runtime (`yoke/pkg/fleet/detect.go`, `yoke/pkg/agentlaunch`, `yoke/pkg/agentctl`)** — detects which agent harness is currently calling `bashy`, pre-seeds workspace trust, isolates per-binding state in `{state_dir}`, and drives headless, steered PTY, or ACP stdio turns.
4. **Ready-Made Custom Fleet Recipes (`bashy/examples/fleet/tools/`)** — data-only YAML definitions for additional third-party agent CLIs (including **DeepSeek Harness (`dsh`)**) that operators import on demand with `bashy tool add`.

---

## 1. Built-in Fleet Catalog (`yoke/pkg/fleet/baseline/tools/`)

The embedded baseline ring ships active first-party and third-party CLI harnesses alongside retired/stub entries retained for self-identification and explicit `tool:model` overrides.

### Active Built-in Harnesses

| Tool Name | Aliases | Binary | Managed Version | Headless `exec` | Interactive `steer_exec` | ACP `acp_exec` | Integration (`skills` / `instructions` / `mcp`) |
|---|---|---|---|---|---|---|---|
| **`ycode`** *(first-party builtin)* | `genie` | `bashy` | Compiled-in | `bashy genie -m {model} {prompt}` | `bashy ycode -m {model}` | `bashy ycode acp` | `~/.bashy/skills`, `.agents/skills` / `~/.bashy/AGENTS.md`, `AGENTS.md` |
| **`zero-ycode`** | — | `bashy` | Compiled-in | `bashy genie --provider zero -m {model} {prompt}` | `bashy ycode --provider zero -m {model}` | — | Hidden overlay forcing the Zero transport |
| **`claude`** | `claude-code` | `claude` | `2.1.295` | `claude -p --output-format text --dangerously-skip-permissions --model {model} {prompt}` | `claude --dangerously-skip-permissions --model {model}` | `claude-agent-acp` (`0.29.2`) | `~/.claude/skills`, `.claude/skills` / `~/.claude/CLAUDE.md`, `CLAUDE.md` / `~/.claude.json` (`mcpServers`) |
| **`codex`** | `openai-codex` | `codex` | `0.162.0` | `codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check -m {model} {prompt}` | `codex --no-alt-screen --dangerously-bypass-approvals-and-sandbox -m {model}` | `codex-acp` (`0.11.0`) | `~/.codex/skills`, `~/.agents/skills` / `~/.codex/AGENTS.md`, `AGENTS.md` / `~/.codex/config.toml` (`mcp_servers`) |
| **`agy`** | `antigravity` | `agy` | `1.3.2` | `agy chat -m --mode agent --model {model} {prompt}` | — | — | `~/.gemini/antigravity/skills`, `.Shared/skills` / `~/.gemini/GEMINI.md` / `~/.gemini/antigravity/mcp_config.json` |
| **`opencode`** | — | `opencode` | `1.18.35` | `opencode run -m {model} {prompt}` | `opencode -m {model}` | `opencode acp` | `~/.config/opencode/skills`, `.opencode/skills` / `~/.config/opencode/AGENTS.md` / `~/.config/opencode/opencode.json` (`mcp`) |
| **`kimi-cli`** | `kimi-code` | `kimi` | `2.1.1` | `kimi --print --final-message-only -m {model} -p {prompt}` | `kimi --yolo -m {model}` | `kimi acp` | `~/.config/agents/skills`, `.kimi/skills` / `KIMI.md`, `AGENTS.md` / `~/.kimi/mcp.json` (`mcpServers`) |
| **`muse`** | `muse-code` | `muse` | `1.4.4-R5419.1` | `muse -p --yolo --model {model} {prompt}` | `muse --yolo --model {model}` | — | `~/.muse/skills`, `.muse/skills` / `~/.muse/AGENTS.md`, `MUSE.md` / `~/.muse/settings.json` (`mcpServers`) |
| **`zcode`** | — | `zcode` | Host-installed | `zcode --mode yolo -p {prompt}` | — | — | `~/.zcode/skills`, `~/.agents/skills` / `~/.zcode/AGENTS.md`, `AGENTS.md` / `~/.zcode/cli/config.json` (`mcp.servers`) |
| **`herald`** | — | `bashy` | Compiled-in | `bashy a2a send --peer herald --wait {prompt}` | — | — | A2A peer bridge |

### Retired / Stub Built-in Entries

Six additional YAML entries remain in `yoke/pkg/fleet/baseline/tools/` with `exec` cleared so they do not auto-select during capability routing, while still supporting ambient `DetectTool()` self-identification, pinned ACP adapter metadata, and explicit `tool:model` invocation once configured:

- **`aider`** (`~/.aider.conf.yml`)
- **`cline`** (`~/.cline/skills`, `~/.cline/data/settings/cline_mcp_settings.json`, ACP adapter `cline@2.16.1`)
- **`gemini`** (`~/.gemini/skills`, `GEMINI.md`, `~/.gemini/settings.json`, `gemini --acp`)
- **`goose`** (`~/.config/goose/skills`, `.goosehints`, `~/.config/goose/config.yaml`, `goose acp`)
- **`hermes`** (`~/.hermes/skills`, `~/.hermes/config.yaml`, `hermes acp`)
- **`openclaw`** (`${OPENCLAW_STATE_DIR:-~/.openclaw}/openclaw.json`)

Full runnable recipes for these tools live in `bashy/examples/fleet/tools/`.

### Disabling Third-Party Seeds (`BASHY_FLEET_SEEDS=off`)

Setting `BASHY_FLEET_SEEDS=off` drops all seeded models, seeded agents, and third-party tool definitions from the baseline catalog, leaving only first-party `ycode` (and its `genie` alias) active (`yoke/pkg/fleet/seeds_test.go`).

---

## 2. Host Shell, MCP, and Hook Wiring (`bashy install-agent`)

`bashy install-agent` (`bashy/internal/agentos/installagent.go`) configures host-installed agent CLIs to execute commands through `bashy`, discover `bashy` tools over MCP, and receive turn-boundary inbox notifications:

| Target Agent | Shell Wiring (`bashy install-agent <agent>`) | `--mcp` Wiring | `--hooks` Wiring |
|---|---|---|---|
| **`claude`** | Sets `"env": {"CLAUDE_CODE_SHELL": "<bashy-path>"}` in `~/.claude/settings.json` | Runs `claude mcp add --scope user bashy -- <bashy> mcp` | Installs `SessionStart` + `UserPromptSubmit` hooks in `~/.claude/settings.json` calling `bashy inbox-hook` |
| **`opencode`** | Sets `"shell": {"command": ["<bashy-path>", "-l"]}` in `~/.config/opencode/opencode.json` | Writes `mcp.bashy` entry in `~/.config/opencode/opencode.json` | — |
| **`codex`** | Creates `~/.bashy/shims/bash` and registers `<bashy>` in `/etc/shells` + `chsh` | Appends `[mcp_servers.bashy]` to `~/.codex/config.toml` | Sets `features.codex_hooks = true` in `~/.codex/config.toml` and writes `~/.codex/hooks.json` (`SessionStart` + `UserPromptSubmit` -> `bashy inbox-hook`) |
| **`gemini`** | Creates `~/.bashy/shims/{bash,sh,zsh}` -> `<bashy>` and prepends `~/.bashy/shims` to `PATH` | Supported via `bashy skill export --mcp --tool gemini` | — |
| **`copilot`** | Creates `~/.bashy/shims/{bash,sh,zsh}` -> `<bashy>` and prepends `~/.bashy/shims` to `PATH` | — | — |
| **`agy`** (`antigravity`) | Creates `~/.bashy/shims/{bash,sh,zsh}` -> `<bashy>` and prepends `~/.bashy/shims` to `PATH` | Supported via `bashy skill export --mcp --tool agy` | — |
| **`muse`** | Creates `~/.bashy/shims/{bash,sh,zsh}` -> `<bashy>` and prepends `~/.bashy/shims` to `PATH` | Supported via `bashy skill export --mcp --tool muse` | — |
| **`aider`** | Prints guidance to export `SHELL=<bashy>` before launching `aider` | — | — |

In addition, any tool whose fleet YAML declares an `integration:` block (`skills`, `instructions`, `mcp`) works with `bashy skill export --tool <name>` (`yoke/pkg/fleet/integration.go` and `yoke/pkg/skills/export.go`).

---

## 3. Ambient Detection, State Isolation & Workspace Trust

### Ambient Harness Detection (`yoke/pkg/fleet/detect.go`)

When an agent invokes `bashy` inside a subshell, `fleet.DetectTool()` identifies the calling harness using environment markers in priority order:

1. Explicit `AGENT` or `AI_AGENT` environment variables (matched against known tool names/aliases).
2. Vendor-specific environment markers:
   - `CLAUDECODE` or `CLAUDE_CODE_ENTRYPOINT` -> `claude`
   - `CODEX_SANDBOX` or `CODEX_THREAD_ID` -> `codex`
   - `GEMINI_CLI` -> `gemini`
   - `GOOSE_TERMINAL` -> `goose`
   - `OPENCODE_CLIENT` -> `opencode`
   - `CLINE_ACTIVE` -> `cline`
   - `HERMES_AGENT` -> `hermes`
   - `KIMI_CODE` -> `kimi-cli`
   - `OPENCLAW` -> `openclaw`

### Per-Binding `{state_dir}` Isolation & `setup` Hooks (`yoke/pkg/agentlaunch/launch.go`)

When a tool's `cli.launch.env` or `cli.launch.setup` references `{state_dir}`, `bashy` allocates a private directory (`<fleet-root>/tool-state/<tool>/<model>`) and wraps the launch in `bashy --bashsharp -c '<setup>; exec "$@"'`. Placeholders (`{model}`, `{base_url}`, `{base_url_origin}`, `{base_url_path}`, `{state_dir}`) are shell-quoted before substitution so a `setup:` snippet can safely write tool-local configuration files without mutating the operator's personal `~/.<tool>` directory.

### Workspace Trust Pre-Seeding (`yoke/pkg/agentctl/trust.go`)

Before spawning an interactive or autonomous session, `agentctl.TrustWorkspace` pre-seeds workspace trust so the CLI does not block on a first-run confirmation prompt:

- **`claude`**: sets `projects[dir].hasTrustDialogAccepted = true` in `~/.claude.json`.
- **`gemini`**: sets `cwd = "TRUST_FOLDER"` in `~/.gemini/trustedFolders.json`.
- **`codex`**: appends `[projects."<dir>"] trust_level = "trusted"` to `~/.codex/config.toml`.

---

## 4. Ready-Made Custom Fleet Recipes (`bashy/examples/fleet/tools/`)

`bashy/examples/fleet/tools/` ships 17 ready-made custom tool definitions for operators who want to register additional open-source or commercial agent CLIs without adding them to the compiled-in baseline catalog:

```sh
bashy tool add examples/fleet/tools/<tool>.yaml
bashy tool verify <tool>
```

| File | Tool Name | Binary | License | Runtime | Key Capabilities & Launch Contract |
|---|---|---|---|---|---|
| `dsh.yaml` | `dsh` | `dsh` | MIT | Node.js `>=24.9.0` | **DeepSeek Harness** (`https://github.com/deepseek-ai/deepseek-harness.git`) — `dsh --profile headless {prompt}` one-shot & `dsh --profile acp` stdio ACP server; `DSH_HOME={state_dir}` isolation; `cordis.patch.yml` setup for OpenAI-compatible gateways (`llm-pi-ai`) and native `deepseek-official` |
| `mini-swe-agent.yaml` | `mini-swe-agent` | `mini` | MIT | Python | `mini -y -m {model} -t {prompt}` |
| `openhands.yaml` | `openhands` | `openhands` | MIT | Python | `openhands --headless --override-with-envs -t {prompt}` |
| `cline.yaml` | `cline` | `cline` | Apache-2.0 | Node.js | `cline -y -m {model} {prompt}` |
| `qwen-code.yaml` | `qwen-code` | `qwen` | Apache-2.0 | Node.js `>=20` | `qwen -y -o text -m {model} -p {prompt}` |
| `goose.yaml` | `goose` | `goose` | Apache-2.0 | Rust binary | `goose run --no-session -q -t {prompt}` |
| `crush.yaml` | `crush` | `crush` | FSL-1.1-MIT | Go binary | `crush run -q -m {model} {prompt}` (with `{state_dir}/crush/crush.json` setup) |
| `forge.yaml` | `forge` | `forge` | Apache-2.0 | Rust binary | `forge -p {prompt}` |
| `hermes.yaml` | `hermes` | `hermes` | MIT | Python | `hermes chat -Q --yolo -m {model} -q {prompt}` |
| `aider.yaml` | `aider` | `aider` | Apache-2.0 | Python | `aider --yes-always --no-auto-commits --no-git --no-pretty --no-stream --no-check-update --model openai/{model} --message {prompt}` |
| `openclaw.yaml` | `openclaw` | `openclaw` | MIT | Node.js `>=24.16` | `openclaw agent --local --agent main --json --model bashy/{model} -m {prompt}` + `send`/`approve` tool commands |
| `copilot.yaml` | `copilot` | `copilot` | Proprietary | Node.js / native | `copilot --yolo -s -p {prompt}` |
| `droid.yaml` | `droid` | `droid` | Proprietary | Native binary | `droid exec --auto high -m {model} {prompt}` |
| `gemini.yaml` | `gemini` | `gemini` | Apache-2.0 | Node.js `>=20` | `gemini --yolo -m {model} -p {prompt}` |
| `grok.yaml` | `grok` | `grok` | MIT | Bun / Node.js | `grok -m {model} -p {prompt}` |
| `junie.yaml` | `junie` | `junie` | Proprietary | Native binary | `junie --auth=$JUNIE_API_KEY --model={model} --output-format=text {prompt}` |
| `codync.yaml` | `codync` | `codync-host` | Apache-2.0 | Loopback host | Loopback HTTP tool commands (`codync:bots`, `codync:send`, `codync:approve`, `codync:usage`) |
