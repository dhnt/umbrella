# Sprint 641: MVP phase A — voice input + dhnt.io cosmetic

Sprint UUID: `d8aa925c-ba20-5705-ba28-33bc35700909`. Epic: software-shaping.
Status: **done** (updated 2026-11-24: all stories done); rewritten 2026-11-15 after the operator
lifted the hold on the hosted surface. Design of record:
**`docs/dhnt-journey-design.md`**. Boundary table: `docs/sprint-641-feature-matrix.md`.

## What this card is

**Phase A of the MVP.** The MVP is the journey, delivered in phases — **A**
voice + cosmetic, **B** outpost, **C** app, **D** satellite — each shipping end
to end before the next begins. A person arrives at dhnt.io, signs in with their
email, and shapes their own desktop (layout, tiles, look, settings) by hand, by
speaking, by typing, **or through a third-party agent over MCP**, with undo and a
configured allowance. Once they have done it, they are invited to attach their
own machine. No machine, no install, no repository is required from the person.

## Where it stands (reviewed 2026-11-15)

Most of phase A is already built; the stories were not reconciled with it.

- **Hosted half shipped** in the cloudbox release v0.18.73: the declared
  schema, the per-account property document with numbered revisions and undo,
  wish → validated patch over the pooled route, a daily allowance, the
  `/api/v1/desktop/*` wire, live page actions, and the voice module vendored
  into the desktop's wish box. Tracked privately as `fada4758`.
- **CLI half exists**: bashy `93d21df1` — `bashy desktop schema|get|set|wish|undo|history`
  (yoke `pkg/fleet/desktop_cmd.go`) and `examples/desktop/desktop.bsh`.
- **T0 `d871ac00b808`** (operatorSession privilege bug) is fixed in yoke
  `b7fe0439` and shipped in bashy rc.34.
- **Gaps found:** the vendored voice copy is stale against yoke `genie.js` and
  nothing gates the drift; the outpost `Operators` wiring follow-up is unfiled;
  Sprint 646's gateway routes `run` to an attached host, so a person with no
  machine cannot reach their desktop from a third-party agent (→ J7).
- The bounded Outpost/Bashy page-action refactor (R1–R3) of 2026-11-15 is
  accepted history, kept below.

## Stories

| Story | What it delivers | State |
|---|---|---|
| `d871ac00b808` **T0** operatorSession | the privilege blocker | fixed (yoke `b7fe0439`) — link and close |
| `fd88e341de41` **J0** badge | the entry; a taste that is not kept | reconcile |
| `badd3f9c73de` **J1** voice in the wish box | the one voice module in the hosted SPA | built; add drift gate |
| `9d7adcb33d61` **J2** schema + property document | settings with no model; revisions, undo, history | built; reconcile + trove-ready format |
| `f89b5f3095bb` **J3** wish → validated patch | refused in the schema's terms, nothing partial | built; reconcile refusal texts |
| `c7b35d798b12` **J4** CLI parity | `bashy desktop … --json` + skill-script | built; parity rows |
| `928fb2c3584e` **M4** boundary | which sections each audience may change | reconcile |
| `ccab603b5e2e` **M6** allowance | bounded, visible, refuses rather than degrades | built (daily); make it policy |
| `3db3e946cb84` **J5** journey state | competence events, invitation table as data | reconcile |
| **J7** (new) agent-first desktop | desktop + page actions as MCP tools | new |
| `7c7b5501492f` **J6** the record | the whole walk, by a new person | last |

## Order

```
Step 0  restore card (done when this file is committed)
Step 1  reconcile J0–J5, M4, M6 against shipped code: pass → evidence + close; fail → gap slice
Step 2  J7 MCP tools          (needs Sprint 646 G1/G2 in the same cloudbox release)
Step 3  trove seams           (no trove code in A)
Step 4  voice drift gate + tier record
Step 5  one cloudbox release (operator approval) → J6 record → close
```

## M6 — the allowance is policy, not a constant (operator 2026-11-15)

The number itself is deferred. What is decided is who sets it:

- **People without an outpost** (dhnt.io master users): the **superadmin**
  configures a master default and per-account overrides, by a `--json` verb;
  it is declared configuration, so it is shapeable like any other property.
- **Satellite or outpost members**: the **owner** of that satellite or outpost
  configures the allowance for their members, with the same schema and verb shape.
- **People with their own satellite or outpost**: a wish is routed through the
  Sprint 646 gateway (sync to their host, pull fallback) and runs on **their own
  subscription** worker — never an API-key fallback — so the pooled allowance
  does not apply. The pooled route serves only when no own route exists, and the
  reply reports which route served the wish.

## J7 — the desktop as an MCP service (agent-first)

The website's operations are exposed to third-party agentic tools (Claude,
ChatGPT, Gemini connectors and coding agents) through the **master's** MCP
endpoint from Sprint 646 (Streamable HTTP, OAuth 2.1). The tools are
master-native — no host route — because a phase-A person owns no machine. They
call the same handlers as `/api/v1/desktop/*`; there is no second implementation.

| Tool | Effect |
|---|---|
| `desktop_schema`, `desktop_get`, `desktop_history` | read |
| `desktop_set`, `desktop_undo` | write, own document only, reversible |
| `desktop_wish` | write; routed by the M6 policy (own subscription when a host exists, otherwise the configured allowance); no approval round-trip |
| `page_list`, `page_invoke` | the caller's own pages only (R1's principal isolation), named actions only, never script |

Rules: input schemas are generated from the declared schema; refusals and their
texts are identical on UI, CLI and MCP; every call is audited with the OAuth
principal; a `desktop` token scope splits read from write. The local twin,
`bashy mcp serve`, already reaches `desktop` and `page` through the atlas; todo
`1d91d26edc7c` (per-subcommand atlas effects) is fixed in the same pass so read
subcommands stop inheriting `write`. Sprint 646's client guides gain a desktop
section. Done when handler tests prove each tool, the scope refusal, cross-account
isolation, the allowance or own-route decision, and identical refusal text — and
a real connector sets then undoes a property on an account with no machine (in J6).

## Trove: seams in A, the space in B

The trove (Sprint 639) needs something to mount, so it arrives in phase B.
Phase A leaves the seams so nothing is converted later (law 3):

- the property document has a stable, versioned format, exportable by
  `bashy desktop get --json` and `desktop_get`, which a phase-B trove mounts as
  an `app:` entry (639 S5);
- the J5 invitation table names rung 2's gains as data, so "your own files in
  reach" can lead without code;
- phase B pulls 639 `S1`, `S4b`, `S15` and `S13`/`S14` (relationship stamping,
  the share-wire bug); they stay on 639 until B starts.

## Voice: one module, three surfaces

- yoke's genie (bashy console) — the source; the hosted desktop — a vendored
  copy, now gated against drift (regenerate, fail on difference, run the desktop
  DOM test when the voice body changed); the outpost Shape dialog — dictation
  hint today, the module plus host transcription in phase B (624 V3, V4, V7).
- J6 records tier 1 (on-device, desktop Chrome/Edge), tier 0 (OS dictation,
  Safari and phones) and typed input. MCP tools take text; voice is a UI concern.
- Open: the V2 mic-badge taste call (Sprint 624). `TestDOMGenieReviewBar`
  (`871401e0`) remains a tracked pre-existing failure, not counted green.

## After phase A — what an end user can use

- **Everyone, no install:** property shaping of their own desktop — by hand,
  by voice, in words, or through an agent over MCP.
- **Not yet:** code shaping (candidates, Red → Green, preview, a per-person
  version). The engine exists for an owner's own bashy apps, but it builds on a
  machine, so it becomes an end-user feature at the exit of **phase C**, after B.
- Owners who install bashy can already shape their own apps on their own host in
  the rc channel; that is not a supported release (no v1.0.0 before POSIX
  certification and operator approval).

## Gates and venues

- Per story: its own acceptance plus relevant regression; `--json` parity rows
  for every verb and tool; the scrub gate always.
- Dev box: unit, headless Chrome, verifier, oss routes. The live-connector run
  is on the fleet-mirror venue with operator authorization. No hosted CI.
- One cloudbox release carries the gaps, J7 and Sprint 646 G1/G2; gated locally
  on the frozen commit; tagging needs operator approval. No release is
  authorized by this card.

## Closure

J6 recorded by a person who is not the operator, on an account that owns no
machine: badge seen, signed in, a wish spoken where the browser recognizes speech
locally and typed where it does not, properties set by hand, by CLI and by an MCP
client, a wish applied and undone, a wish outside the schema refused in the
schema's terms, the allowance visible and decremented, the change surviving a
reload, a second account unaffected, the pool-down path showing settings still
work, and the rung-2 invitation appearing only after a first shape and undo.

## J0 and M4, rescoped to the desktop (operator 2026-11-16)

Both were first written against Sprint 638's website and app designs. For
the hosted desktop they are the same ideas with a different mechanism,
because the desktop is shaped by settings, not by code:

- **J0, the badge**, is a plain `Shape this page` link on the public dhnt.io
  page, present without JavaScript and needing no CSP change. Its contract
  is `/?shape=open`, which opens the Shape panel. The taste that is not kept
  already exists: a signed-out visitor's changes live only in the page.
  The vendorable badge snippet for other people's sites stays on Sprint 638.
- **M4, the boundary**, is a `sections` list in the desktop schema (version
  2): Look, Tiles, Launcher sections, Recent activity, Shape-only mode. Each
  section names the audiences that may change it. Phase A writes only the
  person's own layer; `owner` (a satellite's default layer) and `superadmin`
  (the master default) are reserved for later phases. A refused change names
  the section, and the Shape panel discloses what the person may change. The
  feature list for code-shaped apps (`shaped.json` features) stays on Sprint
  638 for phase C, using the same vocabulary.

## Decisions reserved for the operator

1. ~~The allowance's number~~ — deferred; who sets it is decided (M6 above).
2. Which rung-2 gain leads the invitation (recommended: your own files in reach).
3. ~~How much of the desktop's chrome is in the schema~~ — the five sections above (M4).
4. The V2 mic badge (taste).
5. Tagging the cloudbox release that carries J7 and Sprint 646 G1/G2.

## History

### Active delivery override — operator instruction 2026-11-15 (superseded the same day)

The operator explicitly directed this session to take Sprint 641 and deliver
Outpost and Bashy app UI refactoring first. Cloudbox and satellite UI work is
on hold until the operator gives the next instruction. The earlier hosted
journey scope above is preserved as deferred context, not acceptance for this
bounded delivery. No hosted deployment or public release is authorized.

Deliver a private page/server action contract for the two local surfaces:
- Reusable framework-independent browser registration and websocket action
  transport, with explicit handler input validation and asynchronous outcomes.
- Authenticated, principal-isolated live page discovery and commands; bounded
  queues, expiry, disconnect failure, no automatic replay or arbitrary script.
- Bashy integration using existing console principal authorization and existing
  Shape workflow, plus CLI parity for added live-page operations.
- Outpost integration reusing admincore, existing session/bearer authentication,
  and existing CLI/API mutations. Presentation actions must not turn an admin
  browser into a privilege escalation path for a narrower credential.
- Shape-only toggle and named form/field handlers for representative settings
  flows; UI and agents invoke the same functions. Keep Shape reachable and
  protected sign-in/pairing/approval behavior intact.

Acceptance: focused unit/HTTP/browser tests prove action validation, shared
handler use, CLI parity, principal isolation, reconnect/unmount behavior and
proxied mount paths on both surfaces. Inventory existing CLI equivalents rather
than recreating business logic. Preserve unrelated edits. Verify integrated
producer/consumer sources with temporary local module wiring if publication is
not authorized. Report exact delivered scope and residual limits; do not label
all historical Sprint 641 stories done.

#### Local source delivery — 2026-11-15

The three refactoring stories are accepted for the bounded source delivery:

| Story | Source commit | Delivered behavior |
| --- | --- | --- |
| R1 `46d76276772e` | yoke `2b74a473` | Named-action registry, authenticated page transport, isolated discovery/results, bounded expiry and no replay |
| R2 `0b1b0346e78e` | yoke `47f221c3`, bashy `15fa90c0` | Shared Shape handlers, reversible Shape-only, operator/session gates, page CLI |
| R3 `96be6ef5a8a5` | outpost `bdd2faa9` | Networking draft/get/submit, five-tab navigation, Shape-only and page CLI |

The approved Flow master is bashy `c6d6db1b`; its embedded copy is included in
the R2 yoke commit. Assessment and icon stories were also accepted. Internal
collaboration workers implemented the three slices; the interactive manager
reviewed changes and independently ran each acceptance gate.

Independent `bashy gate` results all passed:

- yoke: `GOWORK=off go test -race ./pkg/pagecontrol` and
  `node --test pkg/pagecontrol/page_test.cjs`.
- yoke: `GOWORK=off go test -tags verifydom ./pkg/webconsole -run
  'Test(DOMPageActions|DOMGenieButton|DOMGenieEditSession|PageControl)' -count=1`.
- bashy: `go test ./internal/agentos -run TestShapePage -count=1`, with temporary
  module wiring to the delivered yoke source and `GOWORK=off`.
- outpost: `go test -tags fb_archives ./internal/agent/adminui ./cmd/outpost
  -run 'Test(Page|IndexCarries|NoRootRelative)' -count=1`, using the same local
  producer wiring; Node handler fixture and actual Chrome DOM fixture also pass.

Review corrected inert handling for custom controls, prompt cookie revocation,
and CLI redirect replay. An interim Bashy Pick regression was traced to an
extra form row; preserving the original row layout restored the existing test.
The separately reproduced baseline `TestDOMGenieReviewBar` missing-link failure
remains open; it is not counted as passing. No broad full-suite claim is made.

Usage and exact parity inventories live in yoke `docs/page-actions.md` and
outpost `docs/page-shaping.md`. Outpost supports Host-preserving proxy prefixes;
rewritten-Host proxies need an authenticated proxy contract. Outpost has a
dictation hint, not newly implemented speech recognition; Bashy retains its
existing capability-detected voice input. Legacy forms are not all migrated.

The operator subsequently approved publication and required pin updates.
Yoke `47f221c3` is published; both consumers now require
`v0.0.0-20261115081128-47f221c3b21b`. Fresh focused consumer gates pass with
`GOWORK=off`, using the published module and committed checksums, without local
replacement files. Outpost's Node and Chrome checks also pass. Publication and
the matching forward-only umbrella gitlinks are tracked by story `2bdea548ec75`.
Bashy's Outpost tool pin also advances to `be5ed146` so its tool build includes
the new admin UI. This does not link Outpost into the Bashy binary.
No new refactoring binaries were installed. Other UI surfaces remain on hold
for the operator's next instruction. Historical sprint scope remains open.

#### Dropoff — 2026-11-15

Operator requested all changes committed, cleanup and clean exit. The selected
Outpost/Bashy refactoring is delivered and published; do not resume the hosted
or satellite UI work until the operator instructs it.

- Delivered source: yoke `47f221c3`, Outpost `be5ed146`, Bashy `1ae6834e`.
  Umbrella publication and acceptance: `665c3635`, `33181191`. Later work by
  other sessions is preserved; these are delivery references, not reset targets.
- Verification: focused Go/race, CLI, authentication/WebSocket, Node and Chrome
  gates passed. Consumer gates were rerun with published module pins and
  `GOWORK=off`; no temporary local replacements are needed.
- Installation: the earlier approved icon-only development build was installed.
  The new page-action refactoring binaries have not been installed. No production
  deployment or official release was performed.
- Known limitation: the pre-existing `TestDOMGenieReviewBar` missing-link failure
  remains separately tracked. Outpost supports Host-preserving proxy prefixes;
  its Shape dialog has a dictation hint, not a new speech-recognition service.
- Remaining original MVP stories: T0 operator authorization, M4 feature boundary,
  M6 allowance, J0 badge, J1 voice, J2 schema/settings, J3 wish-to-patch, J4 desktop
  CLI parity, J5 journey state, J6 end-to-end recording, and hosted implementation
  `fada4758`. Some implementation exists: reconcile acceptance evidence before
  treating those open cards as wholly unimplemented. The full sprint is not done.
- Cleanup: closed both session test browsers, stopped the session Vite preview,
  and removed temporary integration module files and the baseline overlay.
  Normal application services, installed binaries and backup artifacts remain.
- The only pre-existing dirty file was Sprint 630 story `eea4f787fdba` completion
  metadata. Under the operator's explicit commit-all instruction, preserve and
  commit that metadata unchanged, including its original assignee and closer.
  Its owner was notified via the collaboration protocol; receipt was unverified.

Resume from the published sources and this plan, read the live sprint card, and
obtain the next scope instruction. Do not reinstall, deploy, or begin another UI
refactor merely because this session has exited.
