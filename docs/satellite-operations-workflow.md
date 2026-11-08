# Composable Satellite Daily Operations and Software-Shaping Workflow

This document describes the supported agent-facing daily operations for satellites in `bashy`, the concise composition workflow across existing primitives, and how to tailor CLI behavior using the existing software-shaping lifecycle.

## Architectural Boundaries and Ground Rules

- **KISS & MVP**: Daily operations reuse existing read and mutation verbs (`account`, `satellite`, `paired-host`, `shape`). No generic HTTP command, workflow engine, context store, provisioning service, membership administration engine, upgrades, or recovery implementation is authorized or required.
- **Client Implementation vs Live Wire**: Client-side command support is not evidence of live service availability. Live service verification remains strictly separated and recorded as unverified unless actually measured against deployed services.
- **Genuine Gaps Preserved**:
  - **Host-to-Satellite Mapping**: The master wire contract does not expose bearer host-to-satellite assignment (`GET /api/v1/satellites/assignment (Bearer)` is absent). Hosts list unattributed with respect to satellites. Agents must not infer host-to-satellite mappings from local client profiles.
  - **Per-Satellite Detail**: There is no dedicated detail/status endpoint (`GET /api/v1/satellites/:id`). All `show` inspections select strictly from the `GET /api/v1/satellites` list response.
  - **Satellite Reconstruction in Reproduce Plans**: While `GET /api/v1/satellites` is supported for list/show discovery, `BuildReproducePlan` does not consume list rows. Available list metadata is not yet used for manual satellite reconstruction. This limitation is honestly reported under `reproduceGaps` without claiming the endpoint is missing.
- **Synthetic Identifiers**: All examples use synthetic identities and endpoints (`https://master.example.internal`, `https://sat-01.example.internal`, `alice@example.internal`). Public documentation must never contain real machine names, OS logins, network addresses, or credentials.

---

## Composed Operations Workflow

The standard daily operations flow composes four sequential steps:

```
[1. Account Discovery] ──> [2. Satellite Discovery] ──> [3. Paired-Host Inspection] ──> [4. Explicit Invite / Transfer]
```

### Step 1: Account Discovery

Inspect configured host-local accounts to identify target endpoints and credential bindings without modifying global profile state:

```bash
bashy account list --json
```

Output provides the available accounts, categories, and connection identities. Invocation-scoped selection (`--account <alias>`) allows commands to route explicitly without ambient credential leakage or environment mutation.
The examples below use `owner` for a Cloudbox account and `satellite-owner` for a satellite account; substitute aliases from your own inventory.

### Step 2: Satellite Discovery (`list` and `show`)

Discover available satellites visible to the authenticated account:

```bash
# List all visible satellites
bashy satellite list --account owner --json
```

Example JSON response:
```json
{
  "satellites": [
    {
      "id": "sat-a1b2c3d4",
      "name": "sat-alpha",
      "endpoint": "https://sat-01.example.internal",
      "state": "active"
    }
  ]
}
```

Inspect one specific satellite by exact ID or unique exact name:

```bash
bashy satellite show sat-alpha --account owner --json
```

Example JSON response:
```json
{
  "satellite": {
    "id": "sat-a1b2c3d4",
    "name": "sat-alpha",
    "endpoint": "https://sat-01.example.internal",
    "state": "active"
  }
}
```

Resolution rules:
- An exact ID match always takes precedence.
- If no exact ID matches, the key must match exactly one satellite name.
- Ambiguous names (duplicate names) or missing keys fail explicitly with an inspectable error (`not found or not yours` or ambiguity warning).
- Empty lists succeed and emit `{"satellites":[]}` (or `no satellites` in human output).
- Reads never issue mutations.

### Step 3: Paired-Host Inspection

Inspect hosts that have joined the mesh or master:

```bash
bashy paired-host ls --account owner --json
```

Output joins hosts and peers by host name.

> [!IMPORTANT]
> The master wire API does not provide a Bearer host-to-satellite assignment endpoint. As a result, hosts appear unattributed to specific satellites. Do not invent or guess assignments from local profiles; `--satellite` filters on `paired-host ls` are explicitly refused.

### Step 4: Explicit Invite or Transfer

Mutations are strictly separated from discovery and require explicit target specification.

#### Minting a Pairing Invite (`satellite invite`)

Mint an owner-scoped, single-use pairing code for a host joining the satellite:

```bash
bashy satellite invite --account satellite-owner --name host-alpha --json
```

Writing to a local file:
```bash
bashy satellite invite --account satellite-owner --name host-alpha --to-file ./host-alpha.invite --json
```

Key semantics:
- **Invite Code JSON Compatibility**: The JSON output envelope always contains the pairing code (`"code": "..."`), even when `--to-file` is specified and a file is written. This guarantees programmatic callers can capture the code directly from stdout while retaining the 0600 file on disk.
- **Owner-Controlled Pairing vs Ordinary Membership**: Owner-issued pairing invites establish owner-controlled pairing (the host joins the satellite under the satellite owner's account and control). Ordinary members join satellites and share machines using their **own** account (`satellite-member` flow); they do not use owner-issued pairing invites.

#### Transferring Satellite Ownership (`satellite transfer`)

Transfer a satellite and all associated resources to another account:

```bash
# Noninteractive invocation with explicit confirmation
bashy satellite transfer sat-alpha --to recipient@example.internal --account owner --yes --json
```

Key semantics:
- Target resolution resolves exact ID first, then unique exact name. Ambiguous or missing targets fail before any mutation.
- When `--no-input` is passed or stdin is non-interactive, absence of `--yes` fails before issuing `POST /api/v1/satellites/:id/transfer`.
- Zero network mutation requests are sent if target resolution or confirmation fails.
- Mutation failures (e.g. HTTP 409 conflict or 404) are preserved verbatim.

---

## Tailored CLI Behavior via the Software-Shaping Lifecycle

When specialized CLI behavior, argument defaulting, or output transformation is required for an agent workflow, agents do not invent ad-hoc wrappers, workflow engines, or new commands. Instead, use the standard **software-shaping** lifecycle (`bashy shape`):

1. **Wish**: Formulate the requested behavior change against the app:
   ```bash
   bashy shape wish bashy "Add customized flag defaults for satellite list formatting" --user <principal> --agent <tool:model>
   ```
2. **Diff**: Inspect the candidate diff:
   ```bash
   bashy shape diff bashy <candidate-id> --user <principal>
   ```
3. **Verify**: Run trusted verification outside candidate source:
   ```bash
   bashy shape verify bashy <candidate-id> --user <principal>
   ```
   Trusted verification executes outside the unvetted candidate tree to guarantee safety.
4. **Preview**: Execute the isolated candidate executable without modifying system PATH:
   ```bash
   bashy shape preview bashy <candidate-id> --user <principal> -- satellite list --help
   ```
5. **Approve**: Activate the verified shape for the host/principal:
   ```bash
   bashy shape approve bashy <candidate-id> --user <principal>
   ```
6. **Undo**: Instantly reverse the change if anomalies occur:
   ```bash
   bashy shape undo bashy --user <principal>
   ```

---

## Verification Status

| Verification Scope | Status | Notes |
|---|---|---|
| Contract & MCP Schema Alignment | Verified | Help flags and schemas match dispatch across `list`, `show`, `invite`, `transfer`. |
| Fixture-Based Composed Workflow | Verified | Simulated loopback covering discovery -> list/show -> paired-host -> invite/transfer. |
| Reproduce Gap Guidance | Verified | `satellite-record` updated to state `BuildReproducePlan` does not consume list rows (available list metadata not yet used for manual reconstruction) without claiming endpoint missing; `satellite-detail` and `host-satellite-mapping` retained. |
| Live Deployed Cloudbox / Satellites | **Unverified** | A read-only list/show smoke could not authenticate with the available host context. No deployed field-shape or mutation claim is made. |
