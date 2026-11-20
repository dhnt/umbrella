# Plan — Sprint 679: `bashy genie` ("One Agent") unified TUI and multi-protocol agent/`cligw` hub

Sprint 679 (`7ab2fc0a-5df9-588a-a77a-8c851fe7ce74`). Planning-only record established 2026-11-20; no code implementation is authorized by this document alone. The sprint card and its stories in `docs/todo/` are authoritative.

## Context & Four-Pillar Positioning

`dhnt` unifies four layers under one self-hostable stack:

1. **One System** *(unifies OSes and shells)* — **`bashy`** (conformant pure-Go Bash 5.3 + POSIX Coreutils across Linux, macOS, and Windows).
2. **One Language** *(unifies shell, Go, and polyglot blocks)* — **`Bash#` (`bsh`)**.
3. **One App** *(unifies commands, apps, and shapeable tools)* — **`yoke` / `bashy app`**.
4. **One Agent** *(unifies agentic tools, models, and human/agent protocols)* — **`bashy genie`**.

### Protocol Roles in the Stack

| Protocol | Direction | Role |
|---|---|---|
| **HTTP** | Transport | Request/response + streaming (`SSE` / `NDJSON` / `WebSocket`) carrier beneath Web UI, REST, remote MCP, and A2A. |
| **ACP** *(Agent Client Protocol)* | Client/IDE ↔ Agent | NDJSON-RPC over `stdio` (`coder/acp-go-sdk`) letting editors and bots drive an agent with explicit turn boundaries and permission relays. |
| **MCP** *(Model Context Protocol)* | Agent ↔ Tools & Context | JSON-RPC 2.0 over `stdio` or Streamable HTTP (`modelcontextprotocol/go-sdk`) exposing typed tools and session controls. |
| **A2A** *(Agent2Agent Protocol)* | Agent ↔ Agent | HTTP + JSON-RPC/REST (`a2aproject/a2a-go/v2`, A2A v1.0) for peer discovery (`/.well-known/agent-card.json`), task delegation, streaming updates, and verification gates. |

### Baseline Audit & Gaps Established in Design Review

Inspecting `bashy`, `yoke`, `outpost`, and `ycode` established what already exists and where the unified experience breaks down:

- **Fragmented front doors:**
  - `bashy genie` / `bashy ycode` (`bashy/internal/agentos/genie.go`) drives `ycode`'s BubbleTea TUI (`ycode/internal/harness/frontend/tui/tui.go`) and minimal web chat (`ycode/internal/harness/frontend/webchat/index.html`) for its own harness, but cannot directly front external vendor CLIs (`claude`, `codex`, `opencode`, `agy`, `muse`, `zcode`, `kimi`, `dsh`) or launch an on-demand per-tool `cligw` instance.
  - `bashy <tool>` (`bashy/internal/agentos/toolshortcut.go`) opens each vendor's separate TUI in isolation on a local TTY with no shared Web UI, A2A, MCP, or REST surface.
  - `bashy chat` (`yoke/pkg/chat`) and `bashy meet` (`yoke/pkg/meet`, `:8637` SPA + `console.go` read-only PTY mirror) manage host-room PTY/ACP sessions and multi-agent rooms, while `bashy llm` (`yoke/pkg/broker` + `yoke/pkg/cligw`) runs a host-wide daemon on fixed port `24556`.
- **Protocol asymmetries & concrete code findings:**
  1. **MCP (`bashy mcp serve`):** Production server over `stdio` and loopback `/mcp` exposing userland commands, scripts, and `shell_*` sessions, but not conversational/steerable agent sessions. (`ycode` deliberately removed all MCP server/client code per `ycode/docs/plan-remove-mcp.md`, enforced by `TestGeneratedDocsAdvertiseNoMCPServer` in `ycode/internal/selfinit/manifest_test.go`.)
  2. **ACP (`bashy acp` / `herald acp` + `chat` Rung 1):** `bashy acp` serves `stdio` only without co-serving HTTP/A2A/MCP/REST; outbound `chat` Rung 1 (`BASHY_ACP=1`) supports 7 tools (`gemini`, `opencode`, `kimi`, `dsh`, `ycode`, plus SHA256-pinned `claude-agent-acp` and `codex-acp`).
  3. **A2A (`bashy herald` / `bashy a2a`):** Outbound A2A v1.0 client only (`a2aclient`); no inbound A2A v1.0 server (`a2asrv`) exists on `bashy` (`ycode/internal/a2a` is an unwired pre-v1.0 stub). In addition, `herald.Credential(p)` (`yoke/pkg/herald/client.go`) is defined and unit-tested but not wired onto outgoing HTTP headers, and comments in `bashy/internal/agentos/agentos.go` and `yoke/pkg/fleet/baseline/tools/herald.yaml` still cite stale exit code `2` for ungated completions (`Result.ExitCode()` returns `0` with `UNVERIFIED` gate metadata).
  4. **`cligw` (`yoke/pkg/cligw`):** Pre-warmed one-shot/sticky CLI worker pools exist behind `bashy llm` (`:24556`), but there is no disposable single-tool `127.0.0.1:0` mode for wrapping one chosen CLI (`--cligw <tool> [--model M] [-- extra-args...]`) as both a raw OpenAI/Anthropic proxy and the LLM backend of a unified `genie` session.

## Design Summary

Make **`bashy genie`** the unified **"One Agent"** front door, backed by a transport-agnostic `yoke/pkg/agenthub` package and `ycode`'s presentation-only BubbleTea `tui.Host` interface (`ycode` itself stays 100% free of MCP and fleet-roster dependencies):

1. **First-class Agentic TUI + Co-Served Protocols in One Process:**
   - Invoking `bashy genie` on an interactive TTY opens the **unified Genie TUI** (`tui` surface: input history, `/help`, `/model`, `/plan`, `/clear`, `/resume`, `/save`, `/hub`, `/quit`, `!cmd` shell ladder, `ESC` interrupt, mid-turn steering, inline HITL approvals)—giving humans one consistent TUI across local models, API models, and every official fleet CLI (`--tui=native` remains available in `--agent` mode when raw vendor TUI passthrough is desired, and `bashy <tool>` continues unchanged).
   - When network `--protocol` flags (`http`, `rest`, `a2a`, `mcp`) are supplied alongside an interactive TTY, the TUI runs in the foreground while the loopback HTTP server co-serves those protocols in the background over the **same live `SessionHub`** (suppressing raw `stderr` logs into the structured hub log so terminal rendering never corrupts).
   - `bashy genie serve ...` (or `--no-tui`, non-TTY `stdin`, or `--protocol acp`) runs headlessly. Because `tui` and `acp` both own `stdin/stdout`, `--protocol acp` automatically disables `tui` (and explicit `--protocol tui,acp` exits `2`), while still co-serving `http`, `rest`, `a2a`, and `mcp` on loopback HTTP with strict `stdout` isolation.

2. **Two Mutually Exclusive Execution Modes (`--agent` vs `--cligw`):**
   - **Mode (a) — Direct Agent Delegation (`--agent <tool[:model]>`):** Delegates turns, streaming events, mid-turn `Steer`, `Interrupt`, and `pkg/ask` approvals directly to any official `bashy` tool (`claude`, `codex`, `opencode`, `agy`, `muse`, `zcode`, `kimi`, `dsh`, or `genie`/`ycode`), passing `--model <model>` and literal `-- <extra args>` (`agentlaunch.Options.ExtraArgs`, never shell-split).
   - **Mode (b) — Ephemeral `cligw` Service + `genie` Harness (`--cligw <tool>`):** Starts an isolated `cligw.Server` scoped to `<tool>` (`--model`, `-- <extra args>`) on `127.0.0.1:0` without touching host port `24556` or `<bashy-home>/cligw/endpoint.json`. It **both** reverse-proxies `/v1/chat/completions`, `/v1/responses`, `/v1/models`, and `/anthropic/v1/messages` to that ephemeral port **and** runs `genie`'s own agent harness (for TUI, Web UI, A2A, ACP, MCP, and REST turns) against that ephemeral `cligw` endpoint.

3. **Shared HTTP Mux & Security Floor:**
   - Loopback-only listener by default (`--listen 127.0.0.1:0`), auto-minted 256-bit bearer token (or `--token-env VAR`), `#token=<tok>` URL fragment handoff for the embedded zero-CDN Human Web UI (`/`), unauthenticated `GET /.well-known/agent-card.json` + `/healthz`, and bearer-gated `/a2a`, `/a2a/rest/*`, `/mcp`, `/api/v1/*`, `/v1/*`, and `/anthropic/*`.

### CLI Synopsis

```text
bashy genie [--agent TOOL[:MODEL] | --cligw TOOL]
            [--model MODEL]
            [--protocol tui|http|rest|a2a|mcp|acp,...]
            [--tui unified|native | --no-tui]
            [--listen 127.0.0.1:0] [--token-env VAR]
            [--cwd DIR] [--read-only | --sandbox workspace-write | --yolo]
            [--allow-effects destroy,spend,cred,priv]
            [--gate CMD] [--timeout DUR] [--dry-run] [--json]
            [-- EXTRA_TOOL_ARGS...]

bashy genie serve [same flags...]   # explicit headless multi-protocol server
```

All existing `bashy genie` forms (`"MESSAGE"`, piped stdin, bare TUI, `web`, `acp`, `resume`, `session`, `solve`, `smoke`, `build`, `doctor`) remain backward compatible.

## Bounded Stories & Owners

| Story | Repo(s) | Summary | Depends On |
|---|---|---|---|
| **S1** | `yoke` | `agentlaunch.Options.ExtraArgs` argv passthrough + `yoke/pkg/agenthub` core `SessionHub`, event fan-out, loopback auth mux, and Mode (a) `--agent` delegation (`chat` + `room` + `ask` + `gate`). | — |
| **S2** | `yoke` | Mode (b) `--cligw <tool>`: isolated ephemeral `cligw.Server` (`127.0.0.1:0`, no host `endpoint.json` mutation), `/v1/*` + `/anthropic/*` reverse proxy, and `HarnessTurnFunc` seam. | S1 |
| **S3** | `yoke` | Inbound A2A v1.0 adapter (`proto_a2a.go` via `a2a-go/v2/a2asrv`: AgentCard, JSON-RPC, REST, streaming, `https://dhnt.io/ext/gate/v1`) + outbound `herald.Credential(p)` Bearer header fix & comment alignment. | S1 |
| **S4** | `yoke` | Inbound MCP (`proto_mcp.go`), headless ACP `stdio` (`proto_acp.go` with `stdout` fd isolation), REST/SSE (`proto_rest.go`), and embedded Human Web UI (`proto_http.go` + `ui/index.html`). | S1 |
| **S5** | `ycode` | Export presentation-only `tui.Host` entry point (`pkg/ycodecli` / `tui`) + `/hub` slash command for live co-served endpoint inspection, keeping `ycode` 100% MCP-free. | — |
| **S6** | `bashy`, `umbrella` | Wire `bashy genie` & `bashy genie serve` (`genie.go` + `genie_hub_tui.go` `tui.Host` adapter + Mode (b) `genie` harness callback + atlas/help/dry-run), bump `yoke` + `ycode` pins, and run TUI + multi-protocol e2e tests. | S2, S3, S4, S5 |

## Non-Goals

- No MCP or fleet-roster imports inside `ycode` (`TestGeneratedDocsAdvertiseNoMCPServer` and `TestCoreImportBoundary` remain fail-closed).
- No new third-party Go modules (`bubbletea/v2`, `a2a-go/v2`, `coder/acp-go-sdk`, and `modelcontextprotocol/go-sdk` are already in `go.mod`) and no Node/pnpm frontend build step.
- No changes to the host-wide `bashy llm` daemon on port `24556` or existing `bashy <tool>` native TUI shortcuts.
- No non-loopback network listener without Outpost `coopauth` / `service_sso`.

## Acceptance Checks & Test Venue

- **Venue:** Dev host, `GOWORK=off`, deterministic fake CLI fixtures in `t.TempDir()` (zero vendor API tokens required for automated gates):
  - `cd yoke && GOWORK=off go test -race ./pkg/agentlaunch/... ./pkg/herald/... ./pkg/cligw/... ./pkg/agenthub/... && scripts/fmtcheck.sh`
  - `cd ycode && GOWORK=off go test -race ./internal/harness/frontend/tui/... ./internal/selfinit/... ./pkg/ycodecli/...`
  - `cd bashy && GOWORK=off go test -race ./internal/agentos/... -run 'TestGenie|TestACPFrontDoor|TestMCP' && GOWORK=off go test ./cmd/bashy/... -run TestCoreImportBoundary`
- **Required e2e proofs (`genie_hub_test.go`):**
  1. Interactive PTY TUI + background `http,a2a,mcp,rest` co-serving over one shared session (turns from TUI, `herald send`, and `/mcp` appear in both TUI scrollback and `/api/v1/sessions/{id}`).
  2. Mode (b) `--cligw` serves both raw `/v1/chat/completions` + `/anthropic/v1/messages` proxy requests and `genie` harness turns over the ephemeral port while leaving `:24556` untouched.
  3. `--protocol tui,acp` fails closed with exit `2`, while `bashy genie serve --protocol acp,http,a2a,mcp,rest` preserves strict `stdout` JSON-RPC framing.

## Risks & Rollback

- **TUI vs background server logging:** Background HTTP handlers must write diagnostics to the hub ring buffer/log file rather than `os.Stderr` whenever BubbleTea owns the terminal.
- **ACP `stdout` purity:** Duplicate raw `stdout` fd exclusively for `acp.NewAgent` and redirect process `os.Stdout` to `os.Stderr` before starting co-served handlers.
- **Rollback:** One commit per story inside `yoke`, `ycode`, and `bashy`, followed by submodule pin bumps; `git revert` cleanly backs out any story with zero persistent schema impact.
