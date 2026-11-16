# Client Setup Guide: claude.ai Web, Desktop & Mobile (Custom Connector)

Sprint: #646  
Spec: `docs/vendor-chat-gateway-mvp.md` (Clients in the MVP, Open live checks)  
Status: Reference Guide (C1 delivery)

---

## 1. Overview & Architecture

This guide specifies how to configure Anthropic's **claude.ai** as the user interface for the Cloudbox / Satellite / Outpost / Bashy stack through the shared Cloudbox master Remote MCP Gateway.

```
┌────────────────────────────────────────────────────────┐
│               claude.ai Client Surfaces                │
│                                                        │
│   claude.ai Web (Primary)      Claude Desktop / Cowork │
│            │                              │            │
│            ▼                              ▼            │
│    Add Custom Connector ────────► Syncs to Mobile      │
│     (One-time setup)              (iOS & Android)      │
└──────────────────────────┬─────────────────────────────┘
                           │
                           │ Public HTTPS (Streamable HTTP)
                           │ OAuth 2.1 + PKCE S256
                           ▼
┌────────────────────────────────────────────────────────┐
│           Cloudbox Master Remote MCP Gateway           │
│               (https://<cloudbox-host>/mcp)            │
│                                                        │
│  - RFC 8414 AS Metadata    - RFC 9728 Protected Res    │
│  - RFC 7591 DCR            - Dynamic Sync / Pull Route │
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
│  - Claude Code CLI (claude -p) on subscription token   │
│  - CLAUDE_CODE_OAUTH_TOKEN + per-worker config dir     │
└────────────────────────────────────────────────────────┘
```

### Key Characteristics
- **Client Surface**: Added as a **Custom Connector** on `claude.ai` web or desktop per the vendor's current connector settings. All plans including Free, Pro, Team, and Enterprise are supported (Free supports 1 custom connector; Team additions are Owner-only; Enterprise requires the libraries permission).
- **Mobile Reuse**: Connectors added and authenticated on web or desktop automatically sync to the Claude mobile apps (iOS and Android). Mobile users reuse the connector immediately without re-authentication or mobile setup friction.
- **MCP Apps Rendering**: Custom connectors render MCP Apps cards inline (`ui://` resource with MIME `text/html;profile=mcp-app`) on web, desktop, and mobile without requiring directory listing.
- **Transport**: Remote MCP over Streamable HTTP. Anthropic cloud connects directly to the public HTTPS master gateway (`https://<cloudbox-host>/mcp`).
- **Workstation Independence**: Once a durable task or agent delegation is initiated, the originating client workstation may disconnect or sleep. The outpost conductor executes the task and writes results back to the Cloudbox master.

---

## 2. OAuth 2.1 Configuration

The Cloudbox master serves as an RFC 6749 / RFC 8414 OAuth 2.1 authorization server with RFC 9728 Protected Resource Metadata.

### Metadata Endpoints
The spec fixes only the `/mcp` endpoint and the two `/.well-known` documents:
- **Authorization Server Metadata**: `https://<cloudbox-host>/.well-known/oauth-authorization-server`
- **Protected Resource Metadata**: `https://<cloudbox-host>/.well-known/oauth-protected-resource`
- **Gateway MCP Endpoint**: `https://<cloudbox-host>/mcp`

All OAuth interaction endpoints are advertised in the AS metadata (`registration_endpoint`, `authorization_endpoint`, `token_endpoint`, `revocation_endpoint` if offered).

### Authentication Flow
1. **Initiation**: `claude.ai` queries the gateway URL (`https://<cloudbox-host>/mcp`), discovers the authorization server metadata from `/.well-known/oauth-authorization-server`, and initiates an Authorization Code Grant with PKCE S256 (`code_challenge` and `code_challenge_method=S256`) to the `authorization_endpoint` advertised in the AS metadata.
2. **Resource Parameter**: Includes `resource=https://<cloudbox-host>/mcp` (RFC 8707) bound to the token audience.
3. **Consent & Verification**: The user authenticates against Cloudbox with their existing credentials and approves the requested scopes (`mcp:read`, `mcp:write`).
4. **Token Issuance**: The authorization server issues an access token and a rotating refresh token. Refresh tokens are single-use; token rotation is enforced on every exchange. Replay of an invalidated refresh token revokes the entire token chain.

---

## 3. Redirect Allowlist Entries

The master authorization server enforces a strict redirect URI allowlist, keeping only callbacks documented by the vendors and cited in the spec, plus loopback for CLIs:

| Client Surface | Allowed Redirect URI | Description |
|---|---|---|
| `claude.ai` Web & Mobile | `https://claude.ai/api/mcp/auth_callback` | Documented Anthropic cloud callback for web chat and synced mobile clients (cited in spec) |
| CLI Tools (RFC 8252) | Loopback (any port) | Loopback redirect (e.g. `http://127.0.0.1:<port>/...` or `http://localhost:<port>/...`) for local CLI authentication per RFC 8252 |

Any authorization request with a `redirect_uri` not matching this allowlist is rejected immediately with `invalid_request`.

---

## 4. Scopes & Permissions

The same `mcp:read` / `mcp:write` grant also covers the desktop tools
(`desktop_*`, `page_*`): a connector granted read can inspect the person's
desktop but not change it. See "Desktop tools" in
`docs/vendor-chat-gateway-mvp.md`.

Gateway scopes map to the caller's Cloudbox account principal and enforce least-privilege tool execution:

| Scope | Category | Granted Tools & Capabilities |
|---|---|---|
| `mcp:read` | Read | `hosts` (list reachable outposts, workers, credential state)<br>`task` (query task status, event tail, results, recent tasks)<br>`run` with read-only verbs (e.g. `sprint show`, `todo list`) |
| `mcp:write` | Write (Audited) | `delegate` (dispatch tasks to outpost workers: claude, codex, agy, muse)<br>`reply` (steer or clarify running tasks)<br>`cancel` (cancel active tasks)<br>`approve` (settle digest-bound approvals for gated actions)<br>`run` with standard write verbs (audited in execution log) |
| `mcp:host` | Internal (Satellite) | Short-lived token minted by master for satellite-forwarded sync calls over outpost tunnels |

> [!NOTE]
> Proposed, not decided: A dedicated `mcp:approve` scope for digest-bound approvals is proposed for future hardening, but is not decided for the MVP.

### Identity Mapping
- Every issued token is bound to a single stable, opaque Cloudbox profile ID.
- The profile ID determines host reachability, satellite membership, and execution grants across all outposts.

---

## 5. Revocation & Session Lifecycle

Revocation is handled exclusively via the vendor's disconnect mechanism plus the existing token revocation path:

### Client-Side Disconnection (claude.ai)
1. In `claude.ai`, navigate to connector management per the vendor's current connector settings.
2. Locate the Cloudbox Gateway connector.
3. Select disconnect or delete.
4. `claude.ai` terminates its stored tokens and ceases sending requests to the gateway.

### Gateway-Side Revocation (Cloudbox Master)
- Revocation uses the existing token revocation path via the `revocation_endpoint` advertised in the AS metadata (if offered per RFC 7009).
- Passing `token=<token>` with `token_type_hint=refresh_token` or `access_token` invalidates the token and its associated grant family.
- Subsequent requests with revoked or invalidated credentials fail with HTTP `401 Unauthorized` (`WWW-Authenticate: Bearer error="invalid_token"`).

---

## 6. Step-by-Step Setup Guide

### Step 1: Add Custom Connector on Web
1. Open a browser and sign in to `claude.ai`.
2. Navigate to connector settings per the vendor's current connector settings.
3. Select add custom connector.
4. Enter the connector configuration:
   - **Name**: `Cloudbox Gateway`
   - **Server URL**: `https://<cloudbox-host>/mcp`
5. Proceed to connection.

### Step 2: Complete OAuth 2.1 Consent
1. A popup window or redirect opens to the `authorization_endpoint` advertised in the AS metadata.
2. Sign in with your Cloudbox account credentials.
3. Review the requested scopes (`mcp:read`, `mcp:write`).
4. Click **Authorize**.
5. The window closes, returning you to `claude.ai` with a connected status indicator.

### Step 3: Verify Tools in Web Chat
1. Start a new conversation in `claude.ai`.
2. In the chat input, prompt:
   ```text
   What hosts are reachable on my Cloudbox gateway?
   ```
3. Claude invokes the `hosts` tool and displays reachable outposts, active workers, and credential health.

### Step 4: Verify Mobile Reuse
1. Open the **Claude** mobile app on iOS or Android (signed into the same Anthropic account).
2. Start a new chat.
3. Verify that the `Cloudbox Gateway` connector icon is visible in the chat composer tools tray.
4. Prompt:
   ```text
   Check the status of recent tasks on the gateway.
   ```
5. Claude invokes the `task` tool inline and renders the response directly on the phone.

---

## 7. Using the 7 Gateway Tools from Claude

Claude accesses the stack through seven text-first tools:

1. **`hosts`**: Lists reachable outposts, available worker types (`claude`, `codex`, `agy`, `muse`), and credential states.
2. **`run`**: Runs any bashy verb directly. Read effects execute immediately; standard writes are audited; destructive/spend/cred/priv effects trigger an approval requirement.
3. **`delegate`**: Starts an autonomous outpost agent. For example:
   ```text
   Delegate a task to claude on <host>: "Review and fix test failures"
   ```
   Returns a `task_id` and initial state (`queued` or `running`).
4. **`task`**: Retrieves status, output, event tail, or verified results for a given `task_id`.
5. **`reply`**: Provides input or clarification to a waiting task.
6. **`approve`**: Settles an approval request by providing `approval_id`, cryptographic `digest`, and `decision: "approve"|"deny"`.
7. **`cancel`**: Terminates a running task with a specified reason.

### Software Shaping Lifecycle Example
From claude.ai chat:
1. **Wish**: User prompts `"I wish the notes app had tag filtering"`.
   Claude calls: `run(argv=["shape", "wish", "notes app tag filtering"])`.
2. **Candidate**: Gateway returns candidate diff and test results.
3. **Approval**: Gated activation requires approval. Gateway returns `approval_id` and `digest`.
4. **Confirm**: User prompts `"Approve tag filtering candidate"`.
   Claude calls: `approve(approval_id="appr-...", digest="sha256:...", decision="approve")`.
5. **Activation**: Gateway activates the candidate patch on the host.

---

## 8. Outpost Executor on Claude Subscription (Goal B)

When a task is delegated with `worker: "claude"`, execution occurs on the target outpost using the official Claude Code CLI (`claude -p`):

- **Headless Authentication**: Authenticated via `CLAUDE_CODE_OAUTH_TOKEN` (minted via `claude setup-token` on any authorized machine, 1-year lifetime).
- **Isolation**: Stored securely in the host vault and projected to the worker process via `CLAUDE_CONFIG_DIR`, ensuring isolation from interactive terminal sessions.
- **Policy Compliance**: Anthropic Credential Use policy requires subscription tokens to run on official Anthropic clients (`claude` CLI). No API-key fallback is permitted.
- **Worker States**: Reported honestly as `ok`, `missing`, `expired`, `plan-limit`, or `offline`.

---

## 9. Open Live Checks (Anthropic)

The following live checks moved from the MVP spec require explicit operator authorization before execution:

| Check ID | Description | Target Surface | Test Condition | Status |
|---|---|---|---|---|
| `ANTH-LC-01` | **Claude Duet Custom Connector Reuse** | Claude Duet (iOS/Android research preview) | Verify whether Claude Duet reuses custom connectors configured on the account or restricts tool calls to directory apps. | Pending Operator Authorization |
| `ANTH-LC-02` | **Agent SDK Subscription Policy** | Anthropic Agent SDK | Validate whether Anthropic's October 2026 credential policy allows headless Agent SDK execution on subscription OAuth tokens vs CLI requirement. | Pending Operator Authorization |
| `ANTH-LC-03` | **Claude Web UI Connector Registration Path** | `claude.ai` Web Settings | Verify the exact current click path in claude.ai web settings for registering custom remote MCP connectors. | Pending Operator Authorization |
