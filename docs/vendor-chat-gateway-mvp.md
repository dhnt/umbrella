# Vendor chat UIs and subscription agents on the full stack (Sprint 646 MVP)

Sprint 646 replaces four planning sprints:
- 642: OpenAI clients and Codex
- 643: Claude clients and Claude Code
- 644: Google clients and agy
- 645: Meta Muse clients and Muse Code

They share two goals:

- **A. The vendor's own chat is the UI.** The vendor's web, mobile and chatbox clients drive Cloudbox, Satellites,
  Outposts and Bashy. That includes software shaping.
- **B. The vendor's CLI on the owner's subscription is the agent.** It runs on the outpost through the vendor's
  official CLI.

The research in the stories of those four sprints stays as reference. The disputed points are settled here.

## Decisions

1. **One vendor-neutral gateway on the Cloudbox master.**
   - It speaks remote MCP over Streamable HTTP.
   - It authenticates with OAuth 2.1:
     - Protected-resource metadata (RFC 9728) and AS metadata (RFC 8414).
     - Dynamic client registration (RFC 7591), with a redirect allowlist made of the vendors' documented callbacks.
     - PKCE S256 and the `resource` parameter (RFC 8707).
     - Refresh tokens that rotate.
   - The authorization server is minimal and lives in Cloudbox, on the existing sign-in and scoped-token model. There
     is no external auth vendor in this path.
   - Headless clients use the existing scoped bearer.
2. **Dynamic routing, chosen per call.**
   - **Sync** is used when all of the following hold:
     - the target outpost is attached to a satellite the caller is authorized on;
     - that satellite admits the caller;
     - the host is live there.
   - On the sync route:
     1. The master exchanges the caller's token for a short-lived satellite token with the `mcp:host` scope.
     2. The satellite forwards the call over its existing outpost tunnel.
     3. The call reaches a loopback `bashy mcp serve` app on the outpost.
   - **Pull** is used otherwise. The master records a durable task with a directive, and the outpost's conductor
     pulls it over its existing session.
   - A failed sync call falls back to pull with the same idempotency key, so the work runs exactly once.
     A gated sync call is likewise re-dispatched over pull with the same key: a gated call always
     settles on the pull route (decision 3).
   - Every reply reports `route: sync|pull`.
   - Every delegation or gated action is a master task. A gated sync call claims the same task before the
     pull route settles it, so any client can resume it by task id, including another vendor's client.
3. **Seven tools, text first, the same for every vendor.**

   | Tool | What it does |
   |---|---|
   | `hosts` | Lists reachable outposts with their workers and credential state. |
   | `run` | Runs any bashy verb through the MCP verb atlas, gated by the verb's effects: `read` runs, writes are audited, `destroy`/`spend`/`cred`/`priv` gate to a pull-route approval (decision 3: one approval path, always on the pull route). |
   | `delegate` | Starts a worker on a host (claude, codex, agy or muse; default: the host's preference) with an idempotency key, and returns a task id. |
   | `task` | Shows a task's status, result or event tail; lists recent tasks. |
   | `reply` | Steers or clarifies a running task. |
   | `approve` | Settles an approval, bound to its digest. The owning host decides, and a remote decision fails closed. |
   | `cancel` | Cancels a task and records the outcome. |

   - Shaping is `run shape wish …` → candidate → `approve` → activate/undo.
   - A new bashy verb becomes reachable from chat with no change to the gateway.
4. **Direct verbs first; agents only when asked.**
   - A deterministic operation never needs a reasoning agent.
   - `delegate` picks a worker through a vendor-neutral adapter: the Sprint 584 tool YAML plus `auth.check_exec`
     and `config_dir_env`.
5. **Subscription credentials use each vendor's documented headless method only. There is never an API-key
   fallback.**

   | Worker | Credential |
   |---|---|
   | claude | `CLAUDE_CODE_OAUTH_TOKEN` from the vault, with a per-worker `CLAUDE_CONFIG_DIR` |
   | codex | ChatGPT device-code login, cached in the worker's config dir |
   | agy | One interactive sign-in, then persisted for headless use |
   | muse | Subscription-connected credential, with Contributor mode pinned off |

   - Worker states are reported honestly: ok, missing, expired, plan-limit, offline.
   - A daily probe sends Sprint 620 alerts.
   - Credentials never pass through the gateway.
6. **No push.** The model is poll plus task id. MCP Apps cards (approval, diff) are a follow-up, and the text
   fallback carries the same facts.

## Task wire contract (the pull route, and the record kept on both routes)

G2 writes this contract and O1 reads it. Both build against it independently.

**Directive.** Written as a task event of kind `directive` on `/api/v1/tasks/:id/events`, with this payload:
```json
{"verb":"run|delegate|approve|cancel|say","task_id":"…","idempotency_key":"…",
 "host":"<host name>","caller":"<opaque profile id>",
 "args":{"argv":["sprint","show","646"]}}
```

| Verb | `args` |
|---|---|
| `run` | `{argv}` |
| `delegate` | `{worker, prompt}`, where worker is `claude`, `codex`, `agy`, `muse` or empty for the host default |
| `approve` | `{approval_id, digest, decision: "approve"\|"deny"}` |
| `cancel` | `{reason}` |
| `say` | `{text}` |

**Outpost replies.** The outpost answers with events of these kinds:

| Kind | Payload |
|---|---|
| `ack` | `{directive_seq}` |
| `state` | `{state: queued\|running\|needs-approval\|done\|failed\|cancelled, reason}`. When a worker cannot run, `reason` is `missing`, `expired`, `plan-limit` or `offline`. |
| `approval` | `{approval_id, digest, summary, effects}` |
| `result` | `{text, exit, verified: bool}`. Asserted success is kept distinct from verified success. |

**Idempotency.**
- A second directive with the same `idempotency_key` returns the existing `task_id`. It never starts new work.
- A sync call records the same task with `route: sync`, so a fallback to pull can find it and skip it.

## Shaping walkthrough: wish → candidate → approve → activate → undo

Shaping runs entirely through the `run` and `approve` tools. The atlas entry
for `shape` carries `read, write, destroy, net, exec, spend, persist,
remote`, so every `run shape …` gates on `destroy` (versions activate and
roll back irreversibly) and `spend` (generation burns metered inference);
`write` is audited. The gate is per verb, not per subverb: even read-only
inspection (`show`, `diff`) gates, with its own digest. There is ONE
approval path: a gated call always settles on the pull route. The sync
route (`bashy mcp serve --outpost`) answers `{state: "gated",
effects: [...]}` (exit 126), executes nothing and raises nothing; the
master's router re-dispatches the same call over the pull route with the
same idempotency key, and the pull conductor raises the task-bound
digest-bound approval there.

1. **Wish.** The caller sends `run` with
   `argv: ["shape", "wish", "hello-world", "Change the greeting to Hello, Shaping!"]`.
   On the sync route the outpost answers `gated` with
   `effects: ["destroy", "spend"]` and stops. On the pull route the gateway
   resolves `shape` in the atlas, sees `destroy`/`spend`, and raises an
   `ask` approval (`source: gateway`) with
   `digest = sha256(argv, host, task_id)`. The task moves to
   `state: needs-approval` and the outpost emits
   `approval: {approval_id, digest, summary, effects: ["destroy", "spend"]}`.
   Nothing executes on either route until the approval settles.
2. **Candidate.** A second client resumes by task id (`task` shows the
   `needs-approval` state and the approval event) and settles it with
   `approve: {approval_id, digest, decision: "approve"}`. The owning host
   applies the decision through `ask.ApplyRemote`, which fails closed: a
   stale digest (the candidate changed, or the answer names another host
   or task), an unknown or expired approval, and an unallowed author are
   all refused, and the candidate never runs. On allow the conductor runs
   the wish; the candidate id comes back in `result`.
3. **Inspect.** `run shape show/diff/verify/preview hello-world CANDIDATE`
   each gate again under their own digests, then report the candidate,
   the patch, the verifier verdict, or the preview URL.
4. **Activate.** `run shape approve hello-world CANDIDATE` (shape's own
   approve verb, the sealed activation gate) gates on `destroy`, settles
   through `approve(digest)` a second time, and activates the candidate.
5. **Undo.** `run shape undo hello-world` gates the same way and restores
   the previous version through the trusted gate.
6. **Refusals.** `decision: "deny"` ends the task as `cancelled` with
   reason `denied`. An approval nobody answers is denied after the bounded
   wait (`DenyUnanswered`) and the task ends as `cancelled` with reason
   `approval-unanswered`. Either way the candidate never executes.

## Clients in the MVP

| Vendor | A: UI | B: outpost worker |
|---|---|---|
| Anthropic | claude.ai web and desktop (custom connector); mobile reuses it (pilot) | Claude Code `-p` |
| OpenAI | ChatGPT Work plugin; iOS/Android as qualified | Codex `exec` |
| Google | Gemini web Custom Connected App; mobile auto-syncs | agy `-p` stream-json |
| Meta | Muse Connector Platform submission pack only. Live use waits on Meta's review. | Muse Code `exec` |

## Open live checks

These are moved to stories C1 and E1. Each needs operator authorization before it runs.

- **Anthropic:** Claude Duet reuse of custom connectors; whether the Agent SDK may run on a subscription (policy).
- **OpenAI:** the Android Cloud UI; the mobile browser; per-plan gates; headless device-code login.
- **Google:**
  - Whether Gemini accepts the DCR redirect, and the `auth_complete` loop.
  - The Keep Activity and Workspace gates.
  - How agy refreshes its subscription login when running headless.
- **Meta:** token lifetimes and callbacks; how long the connector review takes; how Contributor mode behaves on each
  host.

## Stories

| Story | Scope |
|---|---|
| G1 | OAuth 2.1 authorization server on the master |
| G2 | `/mcp` endpoint, the seven tools, the pull route |
| G3 | Sync route and dynamic router, master and satellite |
| O0 | Loopback `bashy-mcp` outpost app trusting the forwarded identity |
| O1 | Conductor directives `run`, `delegate`, `approve` and `cancel`; idempotency; result write-back; conductor as a service |
| O2 | Worker adapter fields, vault credential projection, worker-state JSON |
| O3 | Effect gating to digest-bound approval on both routes; shaping walkthrough |
| C1 | Client setup guides; Muse submission pack |
| E1 | End-to-end acceptance on the fleet-mirror venue |

G1 to G3 live in the hosted repository. Their public contract is the OAuth and MCP standards above, plus
`/api/v1/tasks`.
