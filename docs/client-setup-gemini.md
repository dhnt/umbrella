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
│                    (https://ai.dhnt.io/mcp)            │
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
- **Client Surface**: Added as a **Custom Connected App** in `gemini.google.com` (Consumer Web).
- **Mobile Auto-Sync**: Custom Connected Apps cannot be added directly from within the Gemini mobile app. However, once connected in `gemini.google.com`, the app **automatically syncs** to both Android and iOS Gemini apps under the same Google account.
- **Invocation Ergonomics**: In chat, tools can be invoked contextually or explicitly targeted using the `@<CustomAppName>` mention syntax.
- **Transport**: Strict Streamable HTTP over public HTTPS (`https://ai.dhnt.io/mcp`). Legacy Server-Sent Events (SSE) is deprecated and causes handshake failure in multi-turn sessions.

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
- **Authorization Server Discovery**: `https://ai.dhnt.io/.well-known/oauth-authorization-server`
- **Protected Resource Metadata**: `https://ai.dhnt.io/.well-known/oauth-protected-resource`

### DCR & GAL Sandbox Handshake
- Gemini initiates Dynamic Client Registration via `POST https://ai.dhnt.io/api/v1/oauth/register`.
- The Google Authorization Layer (GAL) completes authentication in a sandboxed iframe. The Cloudbox master returns a clean `auth_complete` response to avoid circular sandbox redirect loops.
- PKCE S256 code challenge is verified on token exchange.
- Tokens carry rotating refresh credentials.

---

## 4. Redirect Allowlist Entries

The Cloudbox master authorization server enforces the following redirect allowlist for Google clients:

| Client Surface | Allowed Redirect URI | Description |
|---|---|---|
| Gemini Web & Mobile | `https://vertexaisearch.cloud.google.com/oauth-redirect` | Primary OAuth redirect URI for Gemini Custom Connected Apps |
| Gemini Fallback | `https://vertexaisearch.cloud.google.com/` | Alternate Google redirect target |
| Antigravity CLI (`agy`) | `https://antigravity.google/oauth-callback` | Callback for interactive Antigravity CLI onboarding |
| Gemini CLI Local | `http://localhost:8085/oauth/callback` | Local loopback callback for developer CLI sessions |
| Gemini CLI Loopback IPv4 | `http://127.0.0.1:8085/oauth/callback` | Alternate local loopback callback |

Registrations requesting any redirect URI outside this list are rejected with `invalid_request`.

---

## 5. Scopes & Permissions

Scopes map directly to Cloudbox principal authorizations and gate the seven MVP tools:

| Scope | Category | Granted Tools & Capabilities |
|---|---|---|
| `mcp:read` | Read | `hosts` (discover reachable outposts and workers)<br>`task` (check task status, logs, verified outcomes)<br>`run` with read-only commands (e.g. `sprint show`, `todo list`) |
| `mcp:write` | Write (Audited) | `delegate` (dispatch agent tasks to outposts)<br>`reply` (send steering inputs)<br>`cancel` (abort active tasks)<br>`run` with standard writes |
| `mcp:approve` | Sensitive-write | `approve` (settle digest-bound approvals for gated actions: destroy, spend, credentials, privilege elevation, software shaping activation) |
| `mcp:host` | Internal Routing | Short-lived token minted by master for satellite forwarding |

Tokens are strictly bound to the authenticated Cloudbox identity and enforce tenant isolation across all outposts.

---

## 6. Revocation & Session Lifecycle

Revocation can be initiated from the Gemini interface, Google Account settings, or the Cloudbox gateway:

### Client-Side Disconnection (gemini.google.com)
1. In `gemini.google.com`, click **Menu** > **Settings** > **Connected Apps**.
2. Locate the Cloudbox Gateway app.
3. Toggle the connection **OFF** or click **Disconnect**.
4. Gemini clears stored access tokens immediately.

### Google Account Third-Party Revocation
1. Visit `https://myaccount.google.com/connections`.
2. Locate `Cloudbox Gateway` under third-party apps with account access.
3. Click **Delete all connections that you have with Cloudbox Gateway**.

### Gateway-Side Revocation (Cloudbox Master)
- **Revocation Endpoint**: `POST https://ai.dhnt.io/api/v1/oauth/revoke` (RFC 7009).
- Revoking the refresh token invalidates the entire token chain and terminates the session.
- Subsequent tool invocations from Gemini fail with HTTP `401 Unauthorized`.

---

## 7. Step-by-Step Setup Guide

### Step 1: Verify Account Gates
1. Sign in to your personal Google Account (`@gmail.com`).
2. Verify that language is set to English (US) and region is US.
3. Visit `https://myactivity.google.com/product/gemini` and verify that **Gemini Apps Activity** is **ON**.

### Step 2: Add Custom Connected App in Web Chat
1. Open a browser and navigate to `https://gemini.google.com`.
2. Click the gear icon (**Settings**) in the left sidebar and select **Connected Apps**.
3. Click **Add Custom App** (or **Connect an App**).
4. Enter the connection parameters:
   - **App Name**: `CloudboxGateway`
   - **Server URL**: `https://ai.dhnt.io/mcp`
5. Click **Connect**.

### Step 3: Complete OAuth 2.1 Consent
1. A consent window opens to `https://ai.dhnt.io/oauth/authorize`.
2. Log in with your Cloudbox account.
3. Review and approve the requested scopes (`mcp:read`, `mcp:write`, `mcp:approve`).
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
  Every weekday at 9:00 AM, ask @CloudboxGateway to run bashy status and report any degraded workers.
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
