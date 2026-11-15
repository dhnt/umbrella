# Client Setup Guide: Gemini Web & Mobile (Custom Connected App)

Sprint: #646  
Spec: `docs/vendor-chat-gateway-mvp.md` (Clients in the MVP, Open live checks)  
Status: Reference Guide (C1 delivery)

---

## 1. Overview & Architecture

This guide specifies how to configure Google's **Gemini** as the user interface for the Cloudbox / Satellite / Outpost / Bashy stack through the shared Cloudbox master Remote MCP Gateway.

```
┌────────────────────────────────────────────────────────┐
│                Gemini Client Surfaces                  │
│                                                        │
│   gemini.google.com (Consumer Web)  Gemini Mobile App  │
│   (Primary Configuration Surface)   (Android & iOS)    │
│            │                              │            │
│            ▼                              ▼            │
│    Add Connected App ──────────────► Auto-synced       │
│    (@CustomApp mention)              (@CustomApp)      │
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
│  - GAL auth_complete Clean - StreamableHTTP Strict     │
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
│  - Antigravity CLI (agy -p) on Google subscription     │
│  - Persisted headless token in ~/.gemini/config/       │
└──────────────────────────┴─────────────────────────────┘
```

### Key Characteristics
- **Client Surface**: Added as a **Custom Connected App** in `gemini.google.com` (Consumer Web) per the vendor's current connector settings.
- **Mobile Auto-Sync**: Custom Connected Apps cannot be added directly from within the Gemini mobile app. However, once connected in `gemini.google.com`, the app **automatically syncs** to both Android and iOS Gemini apps under the same Google account.
- **Invocation Ergonomics**: In chat, tools can be invoked contextually or explicitly targeted using the `@<CustomAppName>` mention syntax.
- **Transport**: Strict Streamable HTTP over public HTTPS (`https://<cloudbox-host>/mcp`). Legacy Server-Sent Events (SSE) is deprecated and causes handshake failure in multi-turn sessions.

---

## 2. Mandatory Account Gates & Prerequisites

Google enforces four strict prerequisites on consumer accounts before Custom Connected Apps can be added:

| Gate | Requirement | Failure Mode If Violated |
|---|---|---|
| **Account Type** | **Personal Google Account only** (`@gmail.com`) | Google Workspace / Enterprise accounts are blocked by administrative security policy; the Connected Apps menu will not offer custom MCP integration. |
| **Geographic Region** | **United States (US)** | Non-US IP addresses or accounts registered outside the US are gated out of the Custom Connected Apps feature. |
| **Language** | **English (US)** | Account interface language must be set to English. |
| **Activity Retention** | **Keep Activity ON** | The "Gemini Apps Activity" setting must be enabled. Disabling Activity breaks custom app execution and causes disconnect loops on iOS. |
| **Age** | **18+ Years** | Accounts with age restrictions cannot enable developer integrations. |

---

## 3. OAuth 2.1 Configuration

Gemini connects to the Cloudbox master using OAuth 2.1 with PKCE S256 and Dynamic Client Registration (RFC 7591).

### Metadata Endpoints
The spec fixes only the `/mcp` endpoint and the two `/.well-known` documents:
- **Authorization Server Discovery**: `https://<cloudbox-host>/.well-known/oauth-authorization-server`
- **Protected Resource Metadata**: `https://<cloudbox-host>/.well-known/oauth-protected-resource`
- **Gateway MCP Endpoint**: `https://<cloudbox-host>/mcp`

All OAuth interaction endpoints are advertised in the AS metadata (`registration_endpoint`, `authorization_endpoint`, `token_endpoint`, `revocation_endpoint` if offered).

### DCR & GAL Sandbox Handshake
- Gemini initiates Dynamic Client Registration via the `registration_endpoint` advertised in AS metadata.
- The Google Authorization Layer (GAL) completes authentication in a sandboxed iframe. The Cloudbox master returns a clean `auth_complete` response to avoid circular sandbox redirect loops.
- PKCE S256 code challenge is verified on token exchange at the `token_endpoint` advertised in AS metadata.
- Resource parameter: `resource=https://<cloudbox-host>/mcp` (RFC 8707).
- Tokens carry rotating refresh credentials.

---

## 4. Redirect Allowlist Entries

The master authorization server enforces a strict redirect allowlist, keeping only callbacks documented by the vendors and cited in the spec, plus loopback for CLIs:

| Client Surface | Allowed Redirect URI | Description |
|---|---|---|
| Gemini Custom Connected App | `https://vertexaisearch.cloud.google.com/oauth-redirect` | Documented OAuth redirect URI for Gemini Custom Connected Apps (cited in spec) |
| Antigravity CLI (`agy`) | `https://antigravity.google/oauth-callback` | Documented callback for interactive Antigravity CLI onboarding (cited in spec) |
| CLI Tools (RFC 8252) | Loopback (any port) | Loopback redirect (e.g. `http://127.0.0.1:<port>/...` or `http://localhost:<port>/...`) for local CLI sessions per RFC 8252 |

Registrations requesting any redirect URI outside this list are rejected with `invalid_request`.

---

## 5. Scopes & Permissions

Scopes map directly to Cloudbox principal authorizations and gate the seven MVP tools:

| Scope | Category | Granted Tools & Capabilities |
|---|---|---|
| `mcp:read` | Read | `hosts` (discover reachable outposts and workers)<br>`task` (check task status, logs, verified outcomes)<br>`run` with read-only commands (e.g. `sprint show`, `todo list`) |
| `mcp:write` | Write (Audited) | `delegate` (dispatch agent tasks to outposts)<br>`reply` (send steering inputs)<br>`cancel` (abort active tasks)<br>`approve` (settle digest-bound approvals for gated actions)<br>`run` with standard writes |
| `mcp:host` | Internal Routing | Short-lived token minted by master for satellite forwarding |

> [!NOTE]
> Proposed, not decided: A dedicated `mcp:approve` scope for digest-bound approvals is proposed for future hardening, but is not decided for the MVP.

Tokens are strictly bound to the authenticated Cloudbox identity and enforce tenant isolation across all outposts.

---

## 6. Revocation & Session Lifecycle

Revocation is handled exclusively via the vendor's disconnect mechanism plus the existing token revocation path:

### Client-Side Disconnection (gemini.google.com)
1. In `gemini.google.com`, navigate to connector settings per the vendor's current connector settings.
2. Locate the Cloudbox Gateway app.
3. Toggle the connection OFF or click disconnect.
4. Alternatively, remove access in Google Account third-party connections (`https://myaccount.google.com/connections`).
5. Stored access tokens are cleared immediately.

### Gateway-Side Revocation (Cloudbox Master)
- Revocation uses the existing token revocation path via the `revocation_endpoint` advertised in AS metadata (if offered per RFC 7009).
- Revoking the refresh token invalidates the entire token chain and terminates the session.
- Subsequent tool invocations from Gemini fail with HTTP `401 Unauthorized` (`WWW-Authenticate: Bearer error="invalid_token"`).

---

## 7. Step-by-Step Setup Guide

### Step 1: Verify Account Gates
1. Sign in to your personal Google Account (`@gmail.com`).
2. Verify that language is set to English (US) and region is US.
3. Visit `https://myactivity.google.com/product/gemini` and verify that **Gemini Apps Activity** is **ON**.

### Step 2: Add Custom Connected App in Web Chat
1. Open a browser and navigate to `https://gemini.google.com`.
2. Navigate to connected app settings per the vendor's current connector settings.
3. Select add custom connected app.
4. Enter the connection parameters:
   - **App Name**: `CloudboxGateway`
   - **Server URL**: `https://<cloudbox-host>/mcp`
5. Proceed to connect.

### Step 3: Complete OAuth 2.1 Consent
1. A consent window opens to the `authorization_endpoint` advertised in the AS metadata.
2. Log in with your Cloudbox account credentials.
3. Review and approve the requested scopes (`mcp:read`, `mcp:write`).
4. Click **Authorize**. The window completes the GAL handshake and closes.
5. In Gemini, `CloudboxGateway` appears in the list of active connected apps.

### Step 4: Verify in Web Chat
1. Start a new conversation on `gemini.google.com`.
2. In the chat composer, type:
   ```text
   @CloudboxGateway What hosts are currently online?
   ```
3. Gemini routes the query to the `hosts` tool and displays reachable outposts and worker health.

### Step 5: Verify Mobile Auto-Sync
1. Open the **Gemini** app on your Android or iOS device (signed into the same Google account).
2. Start a new chat.
3. Type `@` in the prompt composer; verify that `@CloudboxGateway` appears in the auto-complete mention list.
4. Prompt:
   ```text
   @CloudboxGateway show recent tasks
   ```
5. Gemini executes the `task` tool and displays output directly in the mobile chat view.

---

## 8. Scheduled Actions Integration

Gemini supports **Scheduled Actions** (daily, weekly, or recurring triggers). This allows automated background health monitoring:
- A user can configure a recurring prompt:
  ```text
  Every weekday at 9:00 AM, ask @CloudboxGateway to check hosts and report any degraded workers.
  ```
- Gemini executes the schedule in the cloud, calling `hosts` and `task` over the gateway without requiring an active browser tab.

---

## 9. Outpost Executor on Google Subscription (Goal B)

When a task is delegated with `worker: "agy"`, execution is handled on the target outpost using the official Antigravity CLI (`agy -p --output-format stream-json`):

- **Subscription Authentication**: Initialized via a single interactive login, with credentials persisted in `~/.gemini/config/` for unattended headless execution.
- **Independence from UI Account**: The outpost `agy` worker uses the host owner's subscription quota; it operates independently of the web chat user's Google session.
- **Worker States**: Reported honestly as `ok`, `missing`, `expired`, `plan-limit`, or `offline`.
- **No API-Key Fallback**: Relies exclusively on subscription-backed credentials.

---

## 10. Open Live Checks (Google)

The following live checks moved from the MVP spec require explicit operator authorization before execution:

| Check ID | Description | Target Surface | Test Condition | Status |
|---|---|---|---|---|
| `GOOG-LC-01` | **Gemini DCR & GAL Sandbox Loop** | `gemini.google.com` | Verify whether Gemini dynamically accepts the DCR redirect and confirm avoidance of the `auth_complete` sandbox loop. | Pending Operator Authorization |
| `GOOG-LC-02` | **Keep Activity & Workspace Gates** | Gemini Web / iOS App | Reproduce error behavior when a Google Workspace account attempts connection, and verify the iOS disconnect bug when Keep Activity is disabled. | Pending Operator Authorization |
| `GOOG-LC-03` | **Headless `agy` Token Refresh** | Antigravity CLI on Outposts | Validate unattended token refresh mechanics of persisted subscription logins when running headless in CI/daemon mode. | Pending Operator Authorization |
| `GOOG-LC-04` | **Gemini Web UI Connected App Click Path** | `gemini.google.com` | Verify exact current click path in gemini.google.com settings for adding a Custom Connected App. | Pending Operator Authorization |
