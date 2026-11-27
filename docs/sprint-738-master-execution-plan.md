# Sprint 738: contained subscription agents (genie in a sandbox over cligw)

*Master execution plan · 2026-11-27 · backlog, operator review before start.*

## 1. The gap

A bashy user who wants an agent to work unattended on something they do not fully trust (a folder from someone else, a contractor's work copy, a lift) has no generic way to contain a **subscription-based** agent (claude, codex, muse, agy, opencode, ...). Found 2026-11-27 trying to run a folder-alone test with two bindings under a macOS sandbox:

- `bashy delegate` refuses an unattended launch with the approval gate off unless it is contained or the risk is accepted (`BASHY_ALLOW_UNSAFE_AGENT_LAUNCH=1`). Correct, but there is no built-in containment to choose.
- Containing the vendor CLI itself breaks per vendor, because each CLI needs its own login on the host:
  - claude: `delegate` requires a vault-projected token (`claude-code-oauth-token`, via `secrets.ResolveAgentKey`); the interactive login that `weave fleet --probe` uses does not count, so this fails with or without a sandbox on a host that never stored the token;
  - muse: `delegate`'s login check runs `muse login` with a 5-second limit inside a worker environment; under a sandbox the launcher's self-update and network calls push it past the limit.
- The workaround used in Sprint 726 (an isolated home per arm with the keychain login copied in, agent-bench `scripts/arm_home.py`) is per vendor and per harness, not something a user can run.

Every subscription tool will meet the same problem: the credential and the agent live in the same process, so containing the agent means either exposing the credential to the sandbox or breaking the login.

## 2. The design: split the model from the tools

Two parts bashy already has fit together:

- **cligw** (`yoke/pkg/cligw`, served by `bashy llm serve`) runs on the host with the user's subscription logins. It already speaks the OpenAI and Anthropic APIs, routes by band, binding or model across the host's CLI seats, and returns completions with **tool calls the caller executes** (`CallerTools`, `translate.go`; tool-call recovery in `xml_tool_recover.go`). Its workers run read-only in temp directories and never act on the user's files. Callers authenticate with a bearer token over loopback or an owner-only unix socket (`server.go`).
- **genie** (`bashy genie`, the ycode engine) is an agent loop that talks to any OpenAI-compatible endpoint (`OPENAI_BASE_URL`, `ycode/examples/genie/agent.yaml`) and executes the tools itself.

So: **run genie inside the sandbox, and point it at cligw on the host.** The model comes from the user's subscription through cligw; every command runs inside the sandbox, through genie; no credential, login file or keychain item ever enters the sandbox. The only thing that crosses is a short-lived cligw session token, scoped to the run. This works the same for every vendor cligw can serve, and it is the "Genie connects to other vendors' tools" line of the 2027 positioning, built.

One verb for users:

```
bashy genie --contained [-m BINDING|BAND] [--dir DIR] "TASK"
```

It (1) makes sure the host's cligw door is up, (2) issues a session token limited to the requested binding or band, an expiry and a request cap, (3) starts genie inside the platform's sandbox with only `DIR` writable and the cligw socket reachable, (4) streams genie's answer and records the run, (5) revokes the token. The sandbox never sees `HOME`, the bashy vault, vendor config directories or the keychain.

## 3. Scope

| Story | What | Repo |
|---|---|---|
| **C1** spike, no product code | Does `bashy genie -m <cligw binding>` finish the Sprint 737 folder-alone task (the `greet` fixture) uncontained, with `claude-opus5.5` and `muse-wonder` through cligw? Record answer quality, tool-call fidelity per vendor, turns, latency and quota per turn. **Go/no-go for C2 to C5.** | none (evidence in this doc) |
| **C2** scoped session tokens | cligw issues per-run tokens: allowed bindings or bands, expiry, request cap, a run label; the run's own unix socket; revoked on exit. The existing host token is unchanged. | yoke `pkg/cligw` |
| **C3** sandbox backends | One interface, two backends: macOS (`sandbox-exec` with a generated profile: writes only to `DIR` and a private temp, reads of `HOME` denied except the genie bundle and bashy itself, network only to the session socket); Linux (`bashy oci`, the `bashy-base` image, `DIR` and the socket bind-mounted, network none). Windows **fails closed** with a named reason until its backend lands (cross-OS parity: fail, do not degrade). | yoke (sandbox), bashy (wiring) |
| **C4** `bashy genie --contained` | The verb above, wiring C2 and C3; the genie bundle available inside the sandbox; the run recorded (binding, band, token scope, sandbox, exit). | bashy, ycode if the bundle needs it |
| **C5** e2e with fakes | A fake cligw backend that returns scripted completions with tool calls. Contained genie writes the expected file in `DIR`; cannot read a canary file outside `DIR`; sees no credential in its environment or files; an expired or out-of-scope token is refused. Finishes in minutes, on the gate host. | bashy `tests/` |
| **C6** acceptance drill | The Sprint 737 folder-alone test through `bashy genie --contained`, with `claude-opus5.5` and `muse-wonder`: each names the surface and the repository, reaches a passing **Check** from the folder alone, and describes a change as a work copy of the implementation. Unblocks the Sprint 737 owner choice. | evidence |

### Non-goals (not in this sprint)
- No change to `bashy delegate` or `weave` unattended launches of vendor CLIs; their containment stays as it is.
- No vendor CLI running inside the sandbox, and none of their native tools: inside, every tool is genie's.
- No Windows backend (fails closed); no cloud; no paid services.
- The two `delegate` defects found on the way (claude needs a vault token the interactive login does not provide; muse's 5-second login check) are filed as todos, fixed separately.

## 4. Compatibility and security

- **Credentials never cross.** Inside the sandbox: `DIR`, a private temp, the genie bundle and bashy (read-only), and one socket. No `HOME`, vault, vendor config or keychain.
- **The session token is the only secret inside,** and it can do only what the run was given: its bindings or band, until its expiry, up to its request cap.
- **cligw's per-principal in-flight cap** (4 today) applies per session token.
- **Guards need an escape hatch:** `--contained` is the safe path, so it has none of its own; refusals (no door, no backend, out-of-scope model) are explicit and name the fix.
- **Quota:** every genie turn is one cligw request, so a contained run spends subscription quota per turn. C1 measures it; the run record reports it.
- **Terms of use:** cligw already serves CLI seats as models. Whether a vendor's terms allow that use stays the operator's decision, as it is today.

## 5. Order, owners, dependencies

C1 first and alone. If it fails for a vendor (genie cannot work through cligw's completion API at a useful quality), the plan is revised before any product code. Then C2 and C3 in parallel, C4 on both, C5 with C4, C6 last. Proposed owners after C1: C2 and C3 to agents of two vendors; C4 and C5 to one; C1 and C6 run by the conductor. Stories start from current heads, record "Code inspected", and carry the provenance trailers.

## 6. Acceptance and venues

- Per story: targeted unit tests on the touched packages; the gate host for anything that builds (or the secondary gate host when its lanes are claimed).
- C5 green twice on the gate host in the official image, raw logs kept, a few minutes per run.
- C6 on the dev box: contained sessions are the point, and the vendor logins live there. Logged transcripts, folder-alone verdict per binding.
- Sprint done when C1 to C6 pass and `bashy genie --contained` is documented in its command doc.

## 7. Budget, risks, rollback

**Budget:** included subscriptions only; C1 and C6 spend a few dozen turns each per binding.

**Risks:**
- *Quality through cligw is lower than the vendor's own agent* (one-shot workers, no native tools, tool calls through translation). C1 measures it before any code; a vendor that falls short is left out, not forced.
- *Tool-call fidelity differs by vendor.* cligw's recovery code exists for this; C1 records per-vendor failures.
- *Latency and quota per turn.* Warm pools exist; C1 measures.
- *The genie bundle is not released yet* (`genie pull` notes it). C4 uses `genie build` from the source or the builtin source.
- *Sandbox profile gaps on macOS* (a profile that allows too much). C5's canary check is the guard.

**Rollback:** `--contained` is a new path; removing the flag and the session-token routes restores today's behaviour. Baseline tag `baseline/pre-surgery-2026-11-27`.

## 8. Code inspected (2026-11-27)

- yoke `pkg/cligw`: `cmd.go` (pool, routing, read-only workers), `worker.go` (temp dirs, read-only options), `server.go` (routes, token auth, loopback and unix-socket binds), `translate.go` (`CallerTools`), `xml_tool_recover.go`, `backend.go`.
- yoke `pkg/chat/delegate_guard.go` (`delegateAuth`: `PrepareWorkerEnv`, the 5-second login check), `pkg/fleet/workers.go` (`PrepareWorkerEnv`), `pkg/secrets/resolve.go`, `projection.go`, `grant.go` (token resolution), `pkg/fleet/baseline/tools/claude.yaml` (`token_ref`), `pkg/weave/weave_fleet.go` (the probe and its cache).
- bashy `internal/agentos/door.go` (the per-host door), `cobra_schema.go` (cligw mount); `bashy genie --help`, `bashy llm --help`, `bashy oci --help`.
- ycode `examples/genie/agent.yaml` (openai-compatible endpoint), `README.md`.
- agent-bench `packs/spec2src/venue/` (`env.sh`, `guard.sb.template`) and `scripts/arm_home.py` (the per-arm home workaround).
