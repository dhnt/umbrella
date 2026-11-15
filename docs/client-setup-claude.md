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
│                    (https://ai.dhnt.io/mcp)            │
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
- **Client Surface**: Added as a **Custom Connector** on `claude.ai` web or desktop. All plans including Free, Pro, Team, and Enterprise are supported (Free supports 1 custom connector; Team additions are Owner-only; Enterprise requires the libraries permission).
- **Mobile Reuse**: Connectors added and authenticated on web or desktop automatically sync to the Claude mobile apps (iOS and Android). Mobile users reuse the connector immediately without re-authentication or mobile setup friction.
- **MCP Apps Rendering**: Custom connectors render MCP Apps cards inline (`ui://` resource with MIME `text/html;profile=mcp-app`) on web, desktop, and mobile without requiring directory listing.
- **Transport**: Remote MCP over Streamable HTTP. Anthropic cloud connects directly to the public HTTPS master gateway (`https://ai.dhnt.io/mcp`).
- **Workstation Independence**: Once a durable task or agent delegation is initiated, the originating client workstation may disconnect or sleep. The outpost conductor executes the task and writes results back to the Cloudbox master.

---

## 2. OAuth 2.1 Configuration

The Cloudbox master serves as an RFC 6749 / RFC 8414 OAuth 2.1 authorization server with RFC 9728 Protected Resource Metadata.

### Metadata Endpoints
- **Authorization Server Metadata**: `https://ai.dhnt.io/.well-known/oauth-authorization-server`
- **Protected Resource Metadata**: `https://ai.dhnt.io/.well-known/oauth-protected-resource`

### Authentication Flow
1. **Initiation**: `claude.ai` queries the gateway URL, discovers the authorization server metadata, and initiates an Authorization Code Grant with PKCE S256 (`code_challenge` and `code_challenge_method=S256`).
2. **Resource Parameter**: Includes `resource=https://ai.dhnt.io/mcp` (RFC 8707) bound to the token audience.
3. **Consent & Verification**: The user authenticates against Cloudbox with their existing credentials and approves the requested scopes.
4. **Token Issuance**: The authorization server issues an access token and a rotating refresh token. Refresh tokens are single-use; token rotation is enforced on every exchange. Replay of an invalidated refresh token revokes the entire token chain.

---

## 3. Redirect Allowlist Entries

The master authorization server enforces a strict redirect URI allowlist. For Claude clients, the following entries are registered:

| Client Surface | Allowed Redirect URI | Description |
|---|---|---|
| `claude.ai` Web & Mobile | `https://claude.ai/api/mcp/auth_callback` | Anthropic cloud callback for web chat and synced mobile clients |
| Claude Desktop / Cowork | `http://localhost:3000/callback` | Local loopback callback for desktop client authentication |
| Claude Local Fallback | `http://127.0.0.1:3000/callback` | Alternative IPv4 loopback callback |

Any authorization request with a `redirect_uri` not matching this allowlist is rejected immediately with `invalid_request`.

---

## 4. Scopes & Permissions

Gateway scopes map to the caller's Cloudbox account principal and enforce least-privilege tool execution:

| Scope | Category | Granted Tools & Capabilities |
|---|---|---|
| `mcp:read` | Read | `hosts` (list reachable outposts, workers, credential state)<br>`task` (query task status, event tail, results, recent tasks)<br>`run` with read-only verbs (e.g. `sprint show`, `todo list`) |
| `mcp:write` | Write (Audited) | `delegate` (dispatch tasks to outpost workers: claude, codex, agy, muse)<br>`reply` (steer or clarify running tasks)<br>`cancel` (cancel active tasks)<br>`run` with standard write verbs (audited in execution log) |
| `mcp:approve` | Sensitive-write | `approve` (settle digest-bound approvals for gated actions: destroy, spend, credentials, privilege elevation, software shaping activation) |
| `mcp:host` | Internal (Satellite) | Short-lived token minted by master for satellite-forwarded sync calls over outpost tunnels |

### Identity Mapping
- Every issued token is bound to a single stable, opaque Cloudbox profile ID.
- The profile ID determines host reachability, satellite membership, and execution grants across all outposts.

---

## 5. Revocation & Session Lifecycle

Revocation can be triggered from either the client or the gateway:

### Client-Side Revocation (claude.ai)
1. In `claude.ai`, open **Settings** > **Connectors** (or **Integrations**).
2. Locate the Cloudbox Gateway custom connector.
3. Click **Disconnect** or **Delete**.
4. `claude.ai` terminates its stored tokens and ceases sending requests to the gateway.

### Gateway-Side Revocation (Cloudbox Master)
- **RFC 7009 Token Revocation Endpoint**: `POST https://ai.dhnt.io/api/v1/oauth/revoke`
- Passing `token=<token>` with `token_type_hint=refresh_token` or `access_token` immediately invalidates the token and its associated grant family.
- **Account Dashboard Revocation**: The operator can revoke client access from the Cloudbox security dashboard (`Connected Applications` > `Revoke Claude Access`). All active access and refresh tokens for that client registration are purged, causing subsequent requests to fail with HTTP `401 Unauthorized` (`WWW-Authenticate: Bearer error="invalid_token"`).

---

## 6. Step-by-Step Setup Guide

### Step 1: Add Custom Connector on Web
1. Open a browser and sign in to `claude.ai`.
2. Click your profile avatar in the bottom-left corner and select **Settings**.
3. Select **Connectors** from the navigation menu.
4. Click **Add Custom Connector** (or **Add Connector**).
5. Fill in the connector details:
   - **Name**: `Cloudbox Gateway`
   - **Server URL**: `https://ai.dhnt.io/mcp`
6. Click **Add**.

### Step 2: Complete OAuth 2.1 Consent
1. A popup window or redirect opens to `https://ai.dhnt.io/oauth/authorize`.
2. Sign in with your Cloudbox account credentials.
3. Review the requested scopes (`mcp:read`, `mcp:write`, `mcp:approve`).
4. Click **Authorize**.
5. The window closes, returning you to `claude.ai` with a "Connected" status indicator.

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
   Delegate a task to claude on outpost-01: "Review and fix test failures in issue-78"
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
