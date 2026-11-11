# strands-agents/shell vs bashy — gap analysis

Date: 2026-11-11. Sources were read at strands-agents/shell `286ac41` and at bashy/yoke `main`, as pinned in the umbrella. No code was changed. The follow-ups are filed as standalone todos.

## What strands-agents/shell is

It is a Bourne-compatible shell written in Rust and licensed Apache-2.0. It runs inside the calling process: no fork, no exec and no syscalls. Every effect goes through a `Kernel` trait, and the default kernel sits on an in-memory VFS. It ships as:

- a CLI
- a Rust library
- Python (PyO3) and Node (napi-rs) bindings
- WASM
- an MCP server over stdio with `shell` (`command`, `timeout_ms`), `read_file`, `write_file` and `list_dir`

It provides 25 builtins and 33 commands, including `curl` and `jq` built on jaq. It also embeds Lua 5.4, and tools from MCP servers it consumes are exposed to Lua as modules.

Its security model is default-deny. Files exist only when bound in, either by copy or direct, and either read-only or read-write. Network calls go through a resolver that refuses private and metadata addresses. Credentials are injected per URL prefix. The README calls it "a mediation layer, not a security sandbox".

## Different design centres

Strands *mediates*. It starts in under 1 ms, is meant to be embedded in an agent framework, and runs nothing real.

bashy *is the real shell*. It is a Bash 5.3 drop-in on real processes that passes the 86/86 gate on both modes. It has:

- PTY support
- Windows Job Objects
- OTel
- a hash-chained audit log
- `--dry-run`
- effect-derived confirmation
- `contain` and `limit`
- an MCP server with stateful `shell_open`/`shell_exec`/`shell_close` sessions and `--max-output` spill files
- agent-CLI adapters

bashy already exceeds strands on most dimensions. The question is which strands ideas fit bashy without changing what bashy is.

## Comparison

| Dimension | strands-agents/shell | bashy |
|---|---|---|
| Execution | in-process, VFS, no exec | real processes, Bash 5.3 conformant |
| OS | Linux, macOS, WASM | Linux, macOS, Windows |
| MCP server | 4 tools, stateless per call, state lives in the stdio session | typed tool per command, `bashy` script tool, stateful sessions |
| Per-call timeout | `timeout_ms`, 30 s default | **none** in MCP tools |
| Output cap | 1 MiB hard cap, exit 1 | 64 KiB spill to file with preview; opt-in reducer |
| Filesystem confinement | default-deny binds | container route only (`oci`, `contain` fallback) |
| Network policy | SSRF-safe resolver, URL allow prefixes | `contain --net deny|model` |
| Credentials | injected per URL prefix, never visible to the agent | vault and `bashy ask`; the secret reaches the agent's env/argv |
| Command approval | `check_command` after expansion; covers eval/source/trap/find -exec/xargs/Lua | effect `@guard`, MCP `--allow`, `@confirm`; indirect-exec coverage unverified |
| Dry-run / preview | none | `--dry-run`, `--what-if`, `--explain` |
| Audit / OTel | Kernel callbacks only; no OTel | hash-chained audit, OTel traces/logs/metrics |
| SDK bindings | Python, Node, Rust, WASM | none by design (MCP, ACP, CLI) |
| Conformance tests | ~120 differential cases against bash | Bash 5.3 suite, 86/86 |
| Agent-wrapper compatibility | Claude Code Bash-tool preamble test | none pinned |

## Gaps adopted (filed as todos)

1. **Per-call timeout on MCP tools.**
   - Code: `bashy/internal/agentos/mcp_session.go` uses only `context.WithCancel`, so a hung call blocks the agent indefinitely.
   - Change:
     - Add `timeout_ms` to each call and a serve-level default.
     - On expiry, kill the process tree (Job Object on Windows) and return exit 124 with partial output.
     - Record the timeout in the audit log.
2. **SSRF-safe egress mode.**
   - Add `contain --net public` on the existing egress proxy (`contain_egress.go`).
   - The proxy refuses at dial time:
     - loopback, RFC1918, link-local, CGNAT and metadata addresses
     - IPv4-mapped, 6to4, Teredo and NAT64 encodings of those addresses
   - It re-checks every redirect hop. `--allow-url PREFIX` is the escape.
   - Cross-OS, because the proxy already runs everywhere.
3. **Credential injection by URL prefix.**
   - The egress proxy adds a bearer header or query parameter from the vault for matching prefixes.
   - It never re-injects on redirects and never exposes the secret to the agent.
4. **Expansion-time check covering indirect exec.**
   - First, a test establishing whether `eval`, `source`, traps, `xargs` and `find -exec` children pass through the effect guard.
   - Then route any gap through the existing atlas/policy check rather than a new name-list engine.
5. **Agent Bash-tool wrapper regression test.**
   - Pin the Claude Code Bash-tool wrapper: snapshot `source`, `shopt -u extglob`, `eval '…' < /dev/null`, and `pwd -P >| cwdfile`.
   - Pin other agent CLIs' wrappers as fixtures too, since bashy is the shell those tools run on.
6. **(Optional) MCP `read_file`.** Line-numbered paging, image content and resource blobs, wrapping `lens`. Deferred until an agent needs it.

A discussion todo also records path-bind filesystem confinement without a container: Landlock on Linux, Seatbelt profiles on macOS, and the existing container fallback on Windows. This is a larger change and is not committed scope.

## Not adopted, and why

- **In-memory VFS and no-exec execution.** These contradict bashy's role as a real drop-in. Isolation already comes from `oci` and `contain`.
- **Python/Node/WASM bindings.** bashy integrates through MCP and ACP, not an SDK (`bashy/docs/why-bashy.md`). A Strands or LangChain agent can consume `bashy mcp serve` today.
- **Embedded Lua and MCP tools as Lua modules.** Bash# skill-scripts fill this role.
- **Differential tests against bash.** The Bash 5.3 gate is the stronger check.
