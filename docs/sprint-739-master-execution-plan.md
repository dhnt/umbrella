# Sprint 739: tools as a service (TaaS): offer a model, tool, agent or designated folder to your trusted group as a metered, typed tool call

*Master execution plan · 2026-11-27 · backlog, operator review before start. Planning only; revised the same day after a code review for minimum change. Revised again at the operator review: every offer is a typed tool call, every call is metered, and Sprint 740 adds only the payment layer (section 3.1). Revised a third time (operator, 2026-11-27 night): a folder is a tool call too, so everything an agent reaches is a tool call; the name is TaaS (section 1).*

## 1. The gap

In teamwork, one member has what another lacks: an LLM subscription, a video or
transcription provider, a GPU, an installed tool, a big artifact. Today each member
installs, configures and copies everything locally. In A/O/C:
- O is the owner and approver.
- A is an account member with no machine in the mesh.
- C is a contractor with a machine in the mesh.

C usually holds the LLM and the tools, while O's host runs the shaping and has none.

The goal: a member **offers** a model, a tool, an agent or a **designated
folder** to their trusted group, each as a typed tool call. Other members' agents
call it on the offerer's machine on demand, and read a folder in place. Nobody needs a local install, config or copy.
It works in every direction (C to O, O to C, any member to any member).

Example cases:
- (a) A or O have no LLM and use C's offered `llm`.
- (b) C offers `video` or `transcribe`, and the team uses them without the
  provider.
- (c) Any registered command (`bashy commands add`) can be offered.
- (d) C generates a video and the team gets a link, not a copy.

**Why: software shaping (operator, 2026-11-27).** Software shaping is the primary
theme. Tools as a service (TaaS) exists to benefit the agents that do the shaping:
a shaping agent on O's host gets the LLM, the providers and the files it lacks
from C, without an install. bashy is for agents, and cloudbox, the satellite and
outpost exist for bashy. The name is **TaaS**, not CaaS: everything an agent
reaches is a tool call (the MCP word), "command" is only one of the three
backings, and CaaS already means containers as a service, which would be
confused with bashy's own sandbox tier.

**One sharing model for humans and agents (operator, 2026-11-27).** bashy is for
agents. The existing app sharing was designed for humans using UI apps. This sprint
generalizes that one model rather than adding a second one:
- A shared thing is an **app** with a human surface (UI), an agent surface (bashy
  commands, HTTP, MCP), or both.
- Offers and folders are apps. The same audience rules
  (`outpost apps share APP --circle/--group/--email`), the same relationship
  stamps, the same member tokens and the same revoke apply to all of them.
- An agent acting for a member gets exactly that member's rights
  (`docs/access-tiers.md`).

**Everything offered is a tool call, and every call is metered (operator review,
2026-11-27).**
- A model, a tool and an agent are all offered the same way: as a **typed tool
  call**. There is one definition format, one call path and one usage record.
- **Every call is metered**, on both sides, whether it is free, shared or (later)
  paid. The owner's own calls are metered too. Payment is not what turns the
  meter on.
- This sprint is the whole base of Sprint 740
  (`docs/sprint-740-master-execution-plan.md`). Sprint 740 adds only the payment
  layer on top: a price on the metered unit, credits, signed receipts,
  settlement and the priced listing. It adds no second offer format, call path
  or meter.

## 2. What already exists (code inspected 2026-11-27)

| Piece | Where | Reused as |
|---|---|---|
| Per-app audience gate: the owner always passes; anyone else must be a member matching circles AND (groups OR emails). It is enforced per app id by outpost before forwarding, for any app name. | `outpost/internal/agent/apps.go:1196-1209` (`ProxyTo` → `grants.AllowFresh`), `grants.go:47-101`; rules via `outpost apps share` (`outpost/cmd/outpost/apps_share.go`, `portal.CreateHostShare`) | the one authority for offers and folders |
| Signed identity stamp to the app (`Remote-Email`, `X-Outpost-Relationship`, circle, groups, HMAC signature with the per-app SSO secret) when `trust_cloud_identity` is on | `apps.go:238-252, 633-728`; verify `yoke/pkg/coopauth/coopauth.go:234,271` | member identity at the door |
| A member's CLI or agent reaches an owner's app through the satellite with a member token (exchange `host:proxy`) | `yoke/pkg/fleet/satellite_invite.go:70-136`, `satellite_exchange.go`, `yoke/pkg/broker/keycmd.go:113-141`, `bashy/internal/agentos/mcp_connect.go` (Sprint 709) | transport for every member call (A needs no outpost) |
| Door auth: owner token, per-peer credential (`peer:NAME`, deny by default, email/circle binding, caps) | `yoke/pkg/broker/broker.go:299-326`, `peershare.go:282-341`, `peerlimit.go` | unchanged for owned hosts; caps reused for members |
| **A named command run on a door already works:** `X-Bashy-Filter: slash=NAME[,tool=TOOL]`. Shared peers are admitted. Mutating or `confirm` commands are refused remotely (`Admit`). | `yoke/pkg/cligw/server.go:631-714`, `slash.go:339-480`, `yoke/pkg/toolcmd/toolcmd.go:185-191` | the remote run; only the caller refuses names (`toolcmd/cmd.go:280-291`) |
| Registered commands: YAML record (exec, download or script) with a typed argument schema bound by bashy itself | `yoke/pkg/fleet/commands.go`, `command_schema.go`; `bashy/internal/agentos/registered.go:390` | offerable as a ToolCommand `exec: bashy NAME {args}` (tool binary `bashy`, as `herald.yaml` does); no new runner kind |
| Results carry `Artifacts []string` (absolute paths on the door host) via `output: file:<glob>` | `toolcmd/toolcmd.go:72-104`, `print.go:276-311` | the artifact list, published by reference instead |
| LLM through a shared door with no config: `MODEL@DOOR` | `broker.ResolveDoorModel`, genie (`bashy/internal/agentos/genie_external.go:50`) | case (a) |
| `files` app: the embedded File Browser over HOME (or `settings.scope`), **for the owner only**. Single instance per process, one root, no ETag, no identity pass-through. | `outpost/cmd/outpost/capability_files.go`, fork `fbembed/embed.go:20-104` | **kept as is**, owner only; never exposed to members, and not the base for member folders |
| Door run record per request (principal, class, path, model, tokens, wall time, `cost_usd`); rollup per principal with `usage`; peer limits count tokens and cost | `yoke/pkg/broker/audit.go:22-62`, `usage.go:22-44`, `usagecmd.go`, `peerlimit.go:213-240` | the meter (T1 adds the tool name, class and units) |
| A registered command with a typed `args` schema becomes a typed MCP tool, refreshed live; tool-definition SHA-256 | `yoke/mcp/direct.go:56-64,179-309`, `yoke/pkg/fleet/command_schema.go:40-63`, `yoke/mcp/policy.go` (`ToolsSHA256`) | the typed tool definition and its digest (K2); mounting an offered tool (T2) |
| App registry accepts any app name; one in-memory listener can serve many apps | `apps.go:466-486` (`RegisterWithMetaDialer`), `outpost/cmd/outpost/capability_support.go:150-155` | per-folder and per-offer apps |

**Truly missing:**
1. The caller cannot ask a peer for a named command.
2. A shared peer can run *any* declared command; there is no per-command allow-list.
   This is a **pre-existing** exposure, fixed in K1.
3. A peer-supplied path argument (`json-file`, path-shaped `{args}`) is read from the
   door host's filesystem. This is a **pre-existing** hazard, fixed in K3.
4. Artifacts are door-host paths the caller cannot fetch.
5. The door ignores the member stamp. The `llm` app is registered without
   `require_login`, so its audience rule has no effect. Also, `llm share`
   re-registers it without login if the owner turns login on (`share.go:249`).
6. There are no per-folder apps and no agent-friendly file surface (JSON listing,
   Range, ETag).
7. A model-less command tool (binary `bashy`) may not route: the door only lists
   agent rows with a model binding (`cligw/catalog.go:280-315`). K2 verifies this
   first.
8. An offer has no typed tool definition. Nothing says what class it is, what it
   takes and returns, or what unit it is counted in. Any declared name can be
   offered, including verbs every agent already has.
9. The run record does not name the tool or count its units, so usage cannot be
   read per tool. It counts tokens only (a command run counts as nothing), and the
   caller keeps no record at all.
10. An offered tool cannot be put in an agent's own tool list. The agent has to be
    told the `bashy remote` line.

## 3. Design

### 3.1 One form: a metered, typed tool call

**Three classes, one form.** The class comes from the fleet record, not from a flag.

| Class | What is offered | Call | Unit |
|---|---|---|---|
| **Model** | a fleet model binding (`llm`) | the typed call `llm`, and the inference routes for an agent that uses it as its model | token |
| **Tool** | a fleet tool, or a registered command (`bashy commands add`) | `slash=NAME` with schema-bound arguments | call, or an output unit the offer names (second of audio, image) |
| **Agent** | a fleet agent bound to a model: "a smart tool" | the typed call `{task, …}`, under a token cap | token |

A **designated folder** is offered in the same form, as a tool (operator,
2026-11-27 night: everything is a tool call as far as agents are concerned). It
is a Tool-class offer `files-NAME` whose typed definition bashy ships, so the
owner types nothing: input `{op: ls|stat|read|link, path, offset, length}`,
output a JSON listing, a stat, inline bytes (up to a small cap) or a
`bashy://HOST/files-NAME/PATH` link; effects read-only; unit bytes, plus the
call. A link streams from the same offer (Range, HEAD, ETag), and that stream is
a metered call as well.

- **What can be offered is one test: the name is in the fleet.** That means a
  fleet model, a fleet tool or agent, or a registered command. bash, Bash#,
  coreutils and bashy's internal verbs (read, write, edit, search, `ast`, `kb`,
  `todo` and the like) are refused, because every agent already has them. This
  is the test Sprint 740 planned for paid offers; it now applies to every offer.
- **Every offer carries a typed tool definition:** the name, the class, a
  description written for a model, the typed input schema (the record's
  `args`), the output shape, the effects and the unit. An offer with only an
  untyped argument list is refused, and the refusal names what is missing.
- **Tags.** A definition carries an optional list of free words
  (`bashy offer NAME --tag media,video,generate`), like todo labels. There is no
  fixed list and no hierarchy.
  - The fleet record's existing `capability` word is always included, so an
    offer is findable with nothing typed.
  - Tags are part of the definition and covered by its digest.
  - `bashy offer tags` shows the words in use. `bashy offer list`,
    `bashy remote list` and the usage rollups filter with `--tag`.
  - Tags are for finding and grouping only. Access and refusal stay on effects,
    because a tag is the offerer's own label. Choosing between equivalent
    offers matches on the name or capability, never on a tag.
- **The definition has a digest** (the existing tool-definition SHA-256). The
  offer app serves the definition and its digest read-only to the offer's
  audience.
- **An agent offer declares a token cap.** A call that reaches the cap stops and
  is counted for what it used. An agent is never offered as an open-ended task.
- **Metering.** The door's run record already exists for every request. It gains
  the tool name, the class, the unit, the units used and the definition digest.
  - A call counts 1. Tokens come from the usage the door already parses. An
    output unit comes from the result, as the offer declares it.
  - The door returns the record's usage to the caller, and the caller keeps its
    own copy. Both sides can then show the same numbers.
  - `bashy offer usage` (by member and tool) and `bashy remote usage` (by host
    and tool) roll the records up, with `--json`.
  - Offer limits (`--limit`) count in the offer's unit.
  - The record carries **no price**. Sprint 740 puts a price on the unit and
    signs the record as a receipt.
- **Mounting.** `bashy remote add HOST NAME [--as LOCAL]` reads the definition
  and writes a local registered command record whose exec is
  `bashy remote HOST -- NAME {args}`, with the offered schema and the pinned
  definition digest. Registered records already become typed MCP tools and
  refresh live, so the tool appears in the agent's tool list with no new
  mechanism. A changed digest makes the mounted tool refuse until it is added
  again. `bashy remote remove NAME` unmounts it.
- **Folders are tools too.** A folder share is the `files-NAME` offer above: it
  is gated, defined, digested, metered and mountable like any other offer. Only
  the byte route behind its `link` is special, and it is served by the door.

### 3.2 Offers and folders as gated apps

**Each offer and each folder is its own gated app.** That gives each one its own
audience with zero new audience code.

- `bashy offer NAME [--circle C] [--group G] [--email E] [--limit …] [--for 2h]
  [--token-cap N]` does three things, after the eligibility and typed-definition
  checks of section 3.1:
  - registers app `offer-NAME` on the door's port with `require_login` and
    `trust_cloud_identity`;
  - adds the command to the door's offered set;
  - adds the audience with the existing `outpost apps share offer-NAME …`.

  `bashy offer llm` registers `offer-llm` for the inference routes. The existing
  `llm` app (`/k/` peers) is untouched. `bashy offer stop NAME` unregisters the
  app; `bashy offer list` lists them.
- **Door, one new admission branch:**
  - It applies when there is no presented credential, the request arrived via the
    cloud, the stamp verifies with that app's SSO secret, and the relationship is
    member or owner.
  - It reads the app name from `X-Forwarded-Prefix`. The call must be that
    offer's tool, by class: `offer-llm` admits only inference, a tool offer only
    its `slash=NAME`, an agent offer only its agent run under the token cap.
  - The principal becomes `member:EMAIL`. That principal gets the peer route limits
    and caps.
- **Consumer:** `bashy remote HOST -- NAME args…` is `tool cmd run NAME --peer`
  over the member path. `llm env --from HOST --member` serves the LLM case. Both
  use `SatelliteTokenSource` and relax the URL checks that today allow only
  `/app/llm` and `/app/NAME/mcp`.
- **Owned hosts:** keep `peer:NAME` credentials, now with the K1 per-command
  allow-list.
- **Inputs and outputs are references, never host paths:**
  - A peer caller's path arguments must be `bashy://` URIs. The offerer fetches
    each one into the run's scratch directory with its own member token, since the
    consumer shares the input folder with the offerer's circle. Small text stays
    inline.
  - Artifacts move into the offerer's output share (`<bashy-home>/shared/offers/`,
    app `files-offers`, with the same audience as the offer). They return as URIs
    with size and sha256. Consumers stream or `get` them on demand.
- **Folders: owner versus members (operator, 2026-11-27).**
  - HOME is for the owner only, through File Browser as today.
  - Members only ever see **designated folders**. The default is an empty
    bashy-managed folder, `~/.bashy/shared/NAME/` (`<bashy-home>/shared/`). The
    owner may also designate a folder at any other path. Members never get HOME
    as a whole.
  - **Record: one JSON file per share**, `~/.bashy/shared/NAME.json`. It holds the
    metadata of what is shared with the team:

    ```json
    {"name": "renders", "path": "/data/renders", "mode": "ro",
     "audience": {"circles": ["support"], "groups": [], "emails": []},
     "created": "2026-11-27T20:00:00Z", "note": "video outputs"}
    ```

    A missing `path` means `~/.bashy/shared/NAME/`, created empty. The file is the
    local list of what is shared. The audience it records is applied with the
    existing `outpost apps share files-NAME` and enforced by outpost, as for any
    app. There is no outpost unit setting and no second store.
  - **Guard with an escape hatch:** a `path` that is HOME itself, an ancestor of
    HOME, or anything containing `~/.bashy` (vault, tokens) is refused unless
    `--force` is given. A forced share is logged in the record (`"forced": true`,
    with a reason).
  - **The door serves folders, not outpost.** Every door request already gets
    an authenticated principal and a run record (`broker.go:335`), so a folder
    served there is gated, metered and logged with no new mechanism, and outpost
    needs no change. The door reads `~/.bashy/shared/*.json` (and reloads when
    the directory changes). Each record becomes the offer `files-NAME`
    (registered as app `offer-files-NAME` by the K4 code path, read-only;
    `mode: rw` is out of MVP). Its tool call runs in-process, and its byte route
    `/files/NAME/PATH` serves:
  - `os.OpenInRoot` on the record's path, so a symlink or `..` cannot escape the
    folder;
  - `http.ServeContent`, giving Range, HEAD and Last-Modified;
  - a weak ETag from size and mtime;
  - a JSON listing for directories.

  The URI is `bashy://HOST/files-NAME/PATH`. It resolves through the satellite for
  members and through the mesh for owned hosts. The run record names the tool
  `files-NAME`, the op and the bytes served.
- **Folder CLI:**
  - owner: `bashy files share NAME [--path DIR] [--circle|--group|--email]
    [--force --reason R]` writes `NAME.json` (and creates the empty default
    folder when no `--path` is given), then offers `files-NAME` with that
    audience (`outpost apps share offer-files-NAME`).
    `unshare NAME` removes the record, the app and the rule, and keeps the
    files. `shares` lists the records;
  - member: `bashy files ls|stat|cat|get|link HOST:NAME/PATH`, a thin CLI over
    the `files-NAME` tool call, for agents and humans with a shell. An agent can
    also mount the folder as a typed tool with `bashy remote add HOST files-NAME`
    (T2), so it shows in `bashy mcp tools` and needs no CLI line.
- **Humans:** offers and folders are apps, so they show in the member's app list.
  The UI for a folder is a later addition. The owner keeps File Browser over HOME.

## 4. Stories

| Story | What | Repo |
|---|---|---|
| **K1** named peer runs + per-command allow-list | Caller only for the run: `runPeer` accepts `TOOL:NAME`/`NAME`, and a `DispatchPeerCommand` sends `slash=NAME[,tool=TOOL]` without the measured-selection checks. Door: `PeerShare.Commands` allow-list, checked from the parsed slash name; empty = no named commands, so nothing widens (fixes missing item 2). | yoke `pkg/toolcmd`, `pkg/broker` |
| **K2** the offerable set and the typed tool definition | Eligibility by the fleet partition (model, tool, agent, registered command; internal verbs refused). One typed tool definition per offer (name, class, description, input schema, output shape, effects, unit, optional tags) and its digest; an untyped offer is refused. For a registered command, generate a ToolCommand overlay (tool binary `bashy`, `mode: print`, `exec: bashy NAME {args}`, effects and timeout from the record). Verify first that the door can route a model-less `bashy` tool row; if not, the catalog change for it is part of the story (item 7). | yoke `pkg/fleet`, `pkg/cligw` |
| **F1** the folder tool on the door | The door reads one record per share, `~/.bashy/shared/NAME.json` (path, default the empty `~/.bashy/shared/NAME/`; mode; audience; created), and reloads on change. Each record is the Tool-class offer `files-NAME` with the typed definition bashy ships (`op: ls\|stat\|read\|link`, read-only, unit bytes). In-process tool call plus the byte route `/files/NAME/PATH` (`os.OpenInRoot` + `ServeContent` + weak ETag + JSON listing), both through the door's existing auth and run record. Owner and `peer:` callers in this story; members arrive with K4. File Browser over HOME unchanged and owner only; no outpost change. | yoke `pkg/broker` |
| **F2** folder CLI and URIs | `bashy files share NAME [--path DIR] [--force --reason]` writes `NAME.json` (default folder created empty; refuses HOME, its ancestors and `~/.bashy` without `--force`) and offers `files-NAME` with that audience; `unshare` / `shares` (owner); `ls/stat/cat/get/link` as a thin CLI over the `files-NAME` call (member, satellite token, mesh for owned hosts), `bashy://` resolution; relax the satellite URL check for `offer-*` apps | yoke `pkg/fleet`, bashy |
| **K3** inputs and outputs by reference | Refuse host paths from peer callers (fixes the pre-existing item 3); fetch URI inputs into scratch; publish artifacts into the offerer's output share and return URIs with size and sha256 | yoke `pkg/toolcmd`, `pkg/cligw` |
| **K4** offers as gated apps | `bashy offer`/`offer stop`/`offer list` for all three classes and folder offers (`files-NAME`); register `offer-NAME` (`require_login` + `trust_cloud_identity`); the offer app serves the typed definition and its digest; the door stamp branch with the prefix-to-offer check per class; an agent offer's token cap; `member:` limits and caps; consumer `bashy remote`, `llm env --from HOST --member`; fix the `share.go:249` login flip-back for gated apps | yoke `pkg/broker`, `pkg/fleet`, bashy |
| **T1** meter every offered call | The door run record gains tool name, class, unit, units and definition digest, for every caller (owner, peer, member) and every class; usage returned to the caller, who keeps a copy; `bashy offer usage` and `bashy remote usage` with `--json` and `--tag`; limits count in the offer's unit (call, token, seconds, bytes); folder calls and link streams counted like any other; no price | yoke `pkg/broker`, `pkg/toolcmd`, bashy |
| **T2** mount an offered tool | `bashy remote add HOST NAME [--as LOCAL]` writes a local registered record wrapping `bashy remote`, with the offered schema and pinned definition digest, so the tool shows in `bashy mcp tools`; a changed digest refuses until re-added; `bashy remote remove` | yoke `pkg/fleet`, bashy |
| **K5** A/O/C e2e (acceptance) | Sandbox, fake accounts (`cloudboxfake`), fake transcribe provider. No LLM for A or O. Checks: C offers one of each class (`llm`, `transcribe`, one fleet agent with a token cap); `bashy remote add` mounts `transcribe` and it shows in `bashy mcp tools` with a typed schema; the agent call stops at its cap; after the runs, `bashy offer usage` on C and `bashy remote usage` on O show the same units per tool for owner, peer and member calls, with no price anywhere; an internal verb and an untyped offer are refused; a changed definition digest refuses the mounted tool; O shapes and A's wish runs on C's LLM; O puts `in.wav` in `<bashy-home>/shared/in/` (shared with C's circle) and runs `bashy remote C -- transcribe bashy://O/files-in/in.wav`, then streams the result URI (`files-offers`) with Range; A's agent reads a folder C shared, in place, and O's agent mounts it (`bashy remote add C files-NAME`) and lists it through the typed tool; folder reads show in both usage rollups in bytes; O also shares an outside path (`--path`) that A reads; sharing HOME without `--force` is refused; a non-member, a path escape (`..`, a symlink out of the folder) and a non-offered command are refused; unshare gives 403, a limit gives 429; O offers to C; the same audience rule admits a member's UI app use and their agent's runs. | bashy (`test-group-shaping-e2e` lane) |

Order: F1 and K1 first (independent, both yoke), then F2 and K2, then K3 (needs F2), then K4,
then T1 and T2 (both need K4), then K5. Each story is delivered in its module first; then consumer pins and the
umbrella pin are bumped.

## 5. Non-goals (not in MVP)

- Discovery of offers and folders shared with me. No member-side "apps of an
  owner" listing exists, and it would need the hosted plane. The offer and share
  verbs print the one consumer line, which the offerer posts with `bashy mb`.
- Write access to shared folders, sync, caching, locking, versioning, filesystem
  mounts (FUSE, NFS, SMB), quotas.
- An MCP server for folders or offers beyond what bashy already exposes.
- A generated UI form for an offered command, or a member UI for folders.
- Transparent fallback for non-LLM commands, load balancing, container
  sandboxing of offered runs (see Sprint 738).
- Anything about payment: a price, bids, credits, credit lines, budgets in
  credits, signed receipts, verified delivery, the ledger and the priced
  listing. That is Sprint 740, on top of this sprint's offer, definition, meter
  and mount.
- Typed schemas for bashy's untyped built-in verbs. Only an offered tool needs
  one.

## 6. Verification and venues

- Unit tests per story on its branch.
- K5 runs on the gate host with `cloudboxfake`, fake accounts and fake providers,
  within the e2e minutes budget.
- No paid provider runs. No live hosted-plane change: the train rule applies.

## 7. Risks

- **Running commands for others on the offerer's machine.** Offers are explicit and
  per command. Mutating and confirm commands stay refused remotely (`Admit`).
  Arguments are schema-bound, runs use scratch directories, peers cannot pass host
  paths, and caps and audit apply.
- **Real satellite parity.** Member-token access to arbitrary app paths is proven
  against `cloudboxfake`. The hosted satellite must behave the same, which is
  checked on the next release train, not in this sprint.
- **Model-less command rows in the door.** This is unproven (item 7). K2 starts by
  testing it, and the result decides the size of K2.
- **Stopping an agent run at a token cap.** This is unproven. K4 starts by
  checking whether the door can stop a running agent on its served-token count;
  if it cannot, the cap is checked between turns and the story records that.
- **Output units other than call and token.** The count has to come from the
  result in a way the door can read. T1 supports call and token first and one
  declared output unit (seconds) for `transcribe`; other units are added when an
  offer needs them.
