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
   - Every reply reports `route: sync|pull` (Sprint 691 adds `hosted`; see
    "Hosted route" below, so the full set is `route: sync|pull|hosted`).
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

   **Desktop tools (Sprint 641 J7).** A person with no machine has no host for
   `run`, so the master also serves eleven desktop tools directly, with no
   route. They act on the caller's own desktop only, use the same rules and
   refusal texts as the Shape button, the settings panel and `bashy desktop`,
   and are audited as `mcp-<tool>`, without patches, wishes or page input.

   | Tool | Scope | What it does |
   |---|---|---|
   | `desktop_schema`, `desktop_get`, `desktop_catalog`, `desktop_history`, `desktop_allowance` | `mcp:read` | What can change, the current look and where each value came from, the tiles, the numbered revisions, today's wish allowance or why wishes are unavailable |
   | `desktop_set` | `mcp:write` | `{patch, dry_run?, expected_revision?}`. The patch is validated against the schema and applies whole or not at all. |
   | `desktop_undo` | `mcp:write` | Steps back one change; repeat to keep stepping back. |
   | `desktop_wish` | `mcp:write` | `{wish}`. Words become a validated patch; a refusal says why and whether it counted against the allowance. |
   | `page_list`, `page_result` | `mcp:read` | Open pages and their named actions; a command's outcome, never replayed. |
   | `page_invoke` | `mcp:write` | `{page_id, action, input}` on one of your own pages; returns a command id. |

   Refusals carry a `code`: `invalid_change`, `revision_conflict`,
   `allowance_exhausted`, `not_configured`, `allowance_off`,
   `pool_unreachable` or `pool_error`.
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

## Hosted route (Sprint 691 H3)

> **Status: reviewed and approved by the cloudbox owner (2026-11-24).** The master-side
> implementation is tracked as cloudbox todo `eed85934`, referenced here by
> id only (never quoted).

The gateway's route set is `sync | pull | hosted`. Every reply reports
`route: sync|pull|hosted`. The hosted route runs the call on a
dhnt-provisioned, on-demand `bashy mcp serve --hosted` runner acting as the
caller; it is the fallback for cloudbox-registered users who have no live
paired outpost.

**Routing rule (chosen per call, in order).**

1. **Live paired outpost → `sync`.** If the caller has a paired outpost that
   is live (attached to an authorized satellite that admits the caller), the
   call takes the sync route exactly as in decision 2. A live outpost always
   wins.
2. **Registered caller with no host, or host offline → `hosted`.** If the
   caller is cloudbox-registered and has no paired outpost, or the paired
   outpost is not live, the master dispatches the call to a hosted runner.
3. **Owner-host-bound verbs → `pull` as today.** A verb bound to an app that
   lives on someone's outpost (the owning host must execute it) never takes
   the hosted route; it follows the pull route and its durable task exactly
   as before, even when the caller would otherwise qualify for `hosted`.
   A failed sync call still falls back to pull with the same idempotency
   key (decision 2); the hosted route does not change that fallback.

**Per-call identity and secrets token.** For each hosted call the master
mints a versioned identity and a caller-scoped `secrets:read` token, sent
as one header (H1, `bashy docs/mcp-server.md` "Hosted runner", bashy
`5d160655`):

```
X-Bashy-Hosted-Identity: v1.<base64url payload>.<HMAC-SHA256>
```

The payload fields are `schema`, `caller`, `task_id`, `idempotency_key`,
`secrets_token`, `issued_at` and `expires_at`; the TTL is at most 5 minutes.
`caller` is the opaque profile id of the registered caller and is the
principal for the call. `task_id`/`idempotency_key` are the master task's
ids, so a retry with the same key never starts new work. `secrets_token`
is scoped to `secrets:read` for that caller only; the runner pulls the
caller's vault secrets itself (for example under `bashy secret exec`), no
credential passes through the gateway, and nothing persists after the call.
The signature is HMAC-SHA256 over the payload with a **shared symmetric
runner key** (not public-key material), provisioned at registration and
held `0600` on the runner. The runner verifies per request and fails
closed: an unsigned, expired or replayed identity is refused and nothing
runs.

**Gated calls settle by the caller on the master.** The effect policy is
unchanged: `read` runs, writes are audited, and
`destroy`/`spend`/`cred`/`priv` gate. On the hosted route there is no owning
host, so the runner executes nothing for a gated call and answers `gated`
with its effects; the caller settles the approval on the master through the
existing `approve` tool, bound to its digest (`approval_id`, `digest`,
`decision: "approve"|"deny"`). This is the one exception to decision 2's
"owning host decides": with no owning host the caller is the settler, and a
remote or stale-digest decision still fails closed. A denial, or an
approval nobody answers within the bounded wait, ends the task as
`cancelled` and the gated call never executes.

**Approved re-dispatch.** After the caller approves on the master, the
master re-dispatches the call with a fresh identity carrying a **new
idempotency key** and an approval block `{approval_id, digest, effects}`.
The runner allows exactly those `effects` for that call and no others; a
digest mismatch answers `gated` again and nothing executes (runner side:
H1b `94c3aa2293c4`).

**Audit.** The master logs `mcp-hosted`; the runner logs `mcp:<tool>` with
the caller as principal.

**Runner registration.** A hosted runner is registered with the master
before it may receive calls. At registration the master provisions the
shared symmetric runner key (see above); the runner holds it as a `0600`
key file re-read per request, loopback only, failing closed on any
verification error. An unregistered runner, or one whose key does not
match, receives no hosted calls. Provisioning and key rotation are
master-side operations tracked by the cloudbox ticket referenced above;
this document specifies only the public wire: the identity header in,
`route: hosted` on every reply.

**Connected accounts.** A hosted user connects a Google account through a
portal consent step on the master. The step completes the user's own
bring-your-own-project OAuth client — there is no dhnt-owned Google OAuth
client — using a web redirect to the master (no browser loopback callback
on a host, since there is no host). On consent the master writes the
resulting refresh token to the user's vault under
`google/<acct>/credentials`, where `<acct>` names the connected account.
Hosted calls then project that vault entry into the call for its duration
only; the account list is derived from the vault names (`google/*`), with
no second inventory. A user who also has a laptop may instead run
`bashy google auth-login` there and push the credential with
`bashy google auth-export --to-vault`.

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
