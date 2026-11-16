# Client Setup Guide: ChatGPT Work (Remote MCP Plugin)

Sprint: #646  
Spec: `docs/vendor-chat-gateway-mvp.md` (Clients in the MVP, Open live checks)  
Status: Reference Guide (C1 delivery)

---

## 1. Overview & Architecture

This guide specifies how to configure OpenAI's **ChatGPT Work** as the user interface for the Cloudbox / Satellite / Outpost / Bashy stack through the shared Cloudbox master Remote MCP Gateway.

```
┌────────────────────────────────────────────────────────┐
│               ChatGPT Work Client Surfaces             │
│                                                        │
│   ChatGPT Work Web (chatgpt.com)   ChatGPT iOS / Android
│   (Projects, Files, Plugins)        (Work Workspace App)│
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ Public HTTPS (Streamable HTTP)
                           │ OAuth 2.1 + PKCE S256 + DCR
                           ▼
┌────────────────────────────────────────────────────────┐
│           Cloudbox Master Remote MCP Gateway           │
│               (https://<cloudbox-host>/mcp)            │
│                                                        │
│  - RFC 7591 Dynamic Client - RFC 8414 AS Metadata      │
│    Registration (DCR)      - RFC 9728 Protected Res    │
│  - Rotating Refresh Tokens - Exactly-once Fallback     │
└──────────────────────────┬─────────────────────────────┘
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
      Sync Route (Tunnel)         Pull Route (Durable Tasks)
      via Attached Satellite      via Conductor Session Polling
             │                           │
             └─────────────┬─────────────┘
                           ▼
┌────────────────────────────────────────────────────────┐
│             Target Outpost Execution Host              │
│                                                        │
│  - Loopback bashy-mcp app (yoke/mcp effect gating)     │
│  - Codex CLI (codex exec) on ChatGPT subscription      │
│  - Device-code auth cache in isolated CODEX_HOME       │
└──────────────────────────┴─────────────────────────────┘
```

### Key Characteristics
- **Client Surface**: Packaged as a **Remote MCP Plugin** installed into a **ChatGPT Work** workspace (`chatgpt.com`) per the vendor's current connector settings.
- **Mobile Access**: Once the plugin is enabled in ChatGPT Work on the web, it is accessible to qualified ChatGPT mobile apps on iOS and Android under the same Work workspace.
- **Architectural Boundary**: The user's chat conversation executes within OpenAI's cloud infrastructure. Stack commands and agentic tasks execute on designated outposts via the gateway. The originating workstation does not need to stay online.
- **No-Push Recovery**: Relies on durable task polling via the `task` tool rather than push notification subscriptions (MCP Events), guaranteeing deterministic operation across all OpenAI surfaces.
- **Transport**: Remote MCP over Streamable HTTP (`https://<cloudbox-host>/mcp`).

---

## 2. OAuth 2.1 Configuration

ChatGPT Work plugins require standard OAuth 2.1 with PKCE S256, Dynamic Client Registration (RFC 7591), and Protected Resource Metadata.

### Metadata Endpoints
The spec fixes only the `/mcp` endpoint and the two `/.well-known` documents:
- **Authorization Server Discovery**: `https://<cloudbox-host>/.well-known/oauth-authorization-server`
- **Protected Resource Metadata**: `https://<cloudbox-host>/.well-known/oauth-protected-resource`
- **Gateway MCP Endpoint**: `https://<cloudbox-host>/mcp`

All OAuth interaction endpoints are advertised in the AS metadata (`registration_endpoint`, `authorization_endpoint`, `token_endpoint`, `revocation_endpoint` if offered).

### Dynamic Client Registration (RFC 7591)
When adding the plugin, ChatGPT initiates DCR to obtain client credentials:
- **Registration**: Contacting the `registration_endpoint` advertised in AS metadata.
- **Client Metadata**: ChatGPT provides `client_name`, `redirect_uris`, `grant_types=["authorization_code", "refresh_token"]`, and `response_types=["code"]`.
- Master validates requested redirect URIs against the allowlist before issuing client configuration.

### Authentication & Token Rotation
- Code grant with PKCE S256 (`code_challenge` / `code_verifier`) directed to the `authorization_endpoint` advertised in AS metadata.
- Resource parameter: `resource=https://<cloudbox-host>/mcp` (RFC 8707).
- Refresh tokens are strictly rotating. Each token exchange invalidates the prior refresh token. Replay attempts revoke the entire token lineage.

---

## 3. Redirect Allowlist Entries

The master authorization server enforces a strict redirect allowlist. For OpenAI / ChatGPT clients, the exact web callback is an open live check, while CLIs use RFC 8252 loopbacks:

| Client Surface | Allowed Redirect URI Pattern | Purpose |
|---|---|---|
| CLI Tools (RFC 8252) | Loopback (any port) | Loopback callback (e.g. `http://127.0.0.1:<port>/...` or `http://localhost:<port>/...`) for local CLI authentication per RFC 8252 |
| ChatGPT Work Callback | *Open live check* (see `OAI-LC-05`) | Exact callback URI registered during DCR or in plugin settings is not documented in vendor spec and must be confirmed live |

Registrations requesting redirect URIs outside the verified allowlist are refused with HTTP `400 Bad Request`.

---

## 4. Scopes & Permissions

The same `mcp:read` / `mcp:write` grant also covers the desktop tools
(`desktop_*`, `page_*`): a connector granted read can inspect the person's
desktop but not change it. See "Desktop tools" in
`docs/vendor-chat-gateway-mvp.md`.

Scopes correspond to Cloudbox tenant authorizations and map directly to tool permissions:

| Scope | Type | Granted Tools |
|---|---|---|
| `mcp:read` | Read | `hosts` (discover available outposts and workers)<br>`task` (check task state, inspect execution logs, poll results)<br>`run` with read-only commands (e.g. `sprint show`, `todo list`) |
| `mcp:write` | Write (Audited) | `delegate` (dispatch agent tasks to outposts)<br>`reply` (send steering inputs to waiting tasks)<br>`cancel` (abort active tasks)<br>`approve` (settle digest-bound approvals for gated actions)<br>`run` with standard writes |
| `mcp:host` | Internal Routing | Short-lived token minted by master for satellite forwarding |

> [!NOTE]
> Proposed, not decided: A dedicated `mcp:approve` scope for digest-bound approvals is proposed, but is not decided for the MVP.

Tokens are bound to the user's authenticated Cloudbox identity and enforce tenant isolation.

---

## 5. Revocation & Session Lifecycle

Revocation is handled exclusively through the vendor's disconnect mechanism plus the existing token revocation path:

### Client-Side Disconnection (ChatGPT Work)
1. In ChatGPT Work, navigate to plugin or connected app settings per the vendor's current connector settings.
2. Locate the Cloudbox Gateway plugin.
3. Select disconnect or uninstall.
4. ChatGPT purges stored OAuth tokens and halts tool invocations.

### Gateway-Side Revocation (Cloudbox Master)
- Revocation uses the existing token revocation path via the `revocation_endpoint` advertised in AS metadata (if offered per RFC 7009).
- Invoked with `token=<token>` and `token_type_hint=refresh_token`, the master invalidates the refresh token and terminates the associated grant family.
- Subsequent calls with revoked credentials fail with HTTP `401 Unauthorized` (`WWW-Authenticate: Bearer error="invalid_token"`).

---

## 6. Step-by-Step Setup Guide

### Step 1: Open ChatGPT Work & Install Plugin
1. Open a browser and sign in to `chatgpt.com`.
2. Ensure the active workspace is set to **Work** (or Team / Enterprise).
3. Navigate to plugin or connector settings per the vendor's current connector settings.
4. Provide the gateway endpoint URL:
   ```text
   https://<cloudbox-host>/mcp
   ```
5. ChatGPT fetches the authorization server metadata from `/.well-known/oauth-authorization-server`.

### Step 2: Complete OAuth Consent
1. A consent window redirects to the `authorization_endpoint` advertised in the AS metadata.
2. Log in with your Cloudbox account credentials.
3. Approve the requested scopes (`mcp:read`, `mcp:write`).
4. Click **Authorize**.
5. The browser redirects back to `chatgpt.com`, confirming that the plugin is installed and active.

### Step 3: Enable Plugin in Chat
1. Open a new chat in the ChatGPT Work workspace.
2. In the plugin dropdown or composer tools tray, ensure `Cloudbox Gateway` is active per current workspace settings.
3. Test connectivity by prompting:
   ```text
   Use Cloudbox Gateway to list my available hosts and their worker states.
   ```
4. ChatGPT calls the `hosts` tool and displays reachable outposts and supported workers.

### Step 4: Access from Mobile App
1. Open the **ChatGPT** mobile app on iOS or Android.
2. Verify you are signed into the same ChatGPT Work workspace.
3. Start a new conversation; verify the Cloudbox Gateway plugin is available.
4. Prompt:
   ```text
   Check the status of my most recent tasks on Cloudbox Gateway.
   ```
5. ChatGPT invokes the `task` tool and renders the output directly on the device.

---

## 7. Tool Operations & No-Push Status Recovery

Because ChatGPT Work operates over polling rather than push events, tasks use the following durable interaction pattern:

1. **Initiate Task**:
   User: `"Delegate a refactoring task on <host> to codex"`  
   ChatGPT calls: `delegate(host="<host>", worker="codex", prompt="...", idempotency_key="...")`  
   Gateway replies: `{"task_id": "task-abc123", "state": "queued"}`
2. **Poll Status**:
   ChatGPT calls: `task(task_id="task-abc123")`  
   Gateway replies: `{"task_id": "task-abc123", "state": "running"}`
3. **Handle Gated Approval**:
   If the task attempts a sensitive action, `task` reports `state: "needs-approval"` with an `approval_id` and cryptographic `digest`.  
   ChatGPT informs the user and asks for confirmation.  
   Upon confirmation, ChatGPT calls: `approve(approval_id="appr-...", digest="sha256:...", decision="approve")`.
4. **Retrieve Verified Result**:
   Once complete, `task` returns `state: "done"` with `{"text": "...", "exit": 0, "verified": true}`.

---

## 8. Outpost Executor on Codex Subscription (Goal B)

When a task is delegated with `worker: "codex"`, execution is handled on the target outpost using the official Codex CLI (`codex exec`):

- **Headless Authentication**: Uses ChatGPT device-code login per official Codex documentation, with credentials cached in the worker's dedicated configuration directory defined by `CODEX_HOME`.
- **Independence from UI Account**: The subscription on the outpost executes the code; it is independent of the user's web chat session.
- **Worker States**: Reported honestly as `ok`, `missing`, `expired`, `plan-limit`, or `offline`.
- **No API-Key Fallback**: Only subscription-backed credentials are permitted. If credentials expire, the outpost reports `expired` and triggers an operator alert.

---

## 9. Open Live Checks (OpenAI)

The following live checks moved from the MVP spec require explicit operator authorization before execution:

| Check ID | Description | Target Surface | Test Condition | Status |
|---|---|---|---|---|
| `OAI-LC-01` | **Android Cloud UI Availability** | ChatGPT Android App | Verify exact Android Cloud UI, app build release, and plugin tool rendering parity vs iOS. | Pending Operator Authorization |
| `OAI-LC-02` | **Mobile Browser Plugin Exclusion** | Mobile Safari / Chrome on `chatgpt.com` | Verify whether mobile web browsers admit plugins or enforce dots-style mobile-web exclusion. | Pending Operator Authorization |
| `OAI-LC-03` | **Per-Plan Subscription Gates** | ChatGPT Plus vs Team vs Enterprise / Work | Verify minimum plan tier required to add custom remote MCP plugins. | Pending Operator Authorization |
| `OAI-LC-04` | **Headless Device-Code Token Refresh** | Codex CLI on Outposts | Validate non-interactive token refresh stability of cached device-code credentials under `CODEX_HOME` over extended offline periods per Codex documentation. | Pending Operator Authorization |
| `OAI-LC-05` | **ChatGPT Work UI Click Path & Callback URI** | `chatgpt.com` Work Workspace | Determine current UI click path for adding custom remote MCP plugins in ChatGPT Work settings and discover exact redirect callback URI registered during DCR. | Pending Operator Authorization |
