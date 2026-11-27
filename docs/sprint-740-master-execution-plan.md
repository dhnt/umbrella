# Sprint 740: SGI (bashy commands as a service, per call, for credits)

*Master execution plan · 2026-11-27 · backlog, operator review before start. Planning only.*

## 1. The gap

**SGI** ("super general intelligence, the dhnt way") is a recommended opt-in feature
for every user. A member chooses which agentic tools and models to share with their
trusted group. They share **commands**, never raw RAM or GPU (pooling those belongs
to the sphere tier). Sharing earns **credits**. People who own no satellite, outpost
or tools can **buy** credits.

**The differentiator is command as a service, not a task marketplace (operator,
2026-11-27).**
- Agent-hiring platforms trade whole tasks: post a job, agents bid, escrow, accept.
  SGI trades a much smaller unit, **one call of a named bashy command**.
- **SGI-eligible:** any named bashy command, built-in or standard (shipped with
  bashy, e.g. `llm`), example (a shaped `.bsh` command), or registered
  (`bashy commands add`, custom or not). These are exactly what Sprint 739 K2 makes
  offerable. Each has a name, a typed argument schema, declared effects and a
  timeout, so a call is well-defined, bounded and comparable across offerers.
  Mutating and `confirm` commands stay refused remotely (`Admit`).
- **The source must be available, so the call can be verified (operator,
  2026-11-27).** An SGI command is eligible only if a taker can fetch its source and
  check that the source digest is the one that runs (section 3, Verifiable source).
- Ad-hoc shell lines and whole tasks are not SGI offers.
- **Cloudbox offers too (operator, 2026-11-27).** The hosted plane is an offerer like
  any member. It offers named commands on hosted capacity (Tessaro). Purchased
  credits are spent there, which is how a person with no satellite, outpost or tools
  gets service.
- **Credits only.** No crypto, stablecoin or Lightning rail. The price of a call is
  in credits.

Sprint 739 (`docs/sprint-739-master-execution-plan.md`) already builds the sharing
mechanism:
- offers and designated folders as gated apps;
- the member stamp at the door;
- `bashy remote HOST -- NAME`;
- per-peer limits.

Its non-goals exclude billing. SGI is the **economy layer** on top: who used whose
tool, how much, and what the group owes. Sprint 740 depends on Sprint 739 K4 and
does not reopen it.

Operator decisions (2026-11-27):
- The first version covers the **trusted group only**. A public pool comes later.
- Purchased credits buy **Tessaro capacity only**.
- The ledger design considered p2p and crypto technologies (section 2). The result
  is credits only, kept p2p with signed receipts.
- The unit is one call of a named bashy command (built-in, standard, example or
  registered).
- Cloudbox can offer commands too; purchased credits are spent on its offers.

## 2. State of the art (what to copy, what to avoid)

| Approach | What it is | Lesson for SGI |
|---|---|---|
| Nostr NIP-90 "data vending machines" | Signed job request, result and feedback events, paid by Lightning invoice | The job and receipt shape is good. Upstream now marks the spec "unrecommended" because it sprawled, and operators report idle machines with **no demand**. Keep the scope narrow; demand comes from trusted groups, not an open market. |
| x402 (HTTP 402 + stablecoin; MCP `_meta` binding) | Per-call pay-on-402 for APIs and MCP tools | **Adopt the wire shape.** When credit runs out the door answers `402 Payment Required` with a machine-readable requirement body. 429 stays for rate limits. A later rail plugs in without changing callers. |
| L402 (Lightning macaroon + invoice) | Per-call Lightning payment | Same 402 pattern. A candidate rail for a later public pool only. |
| Cashu / Fedimint ecash (federated mints) | Blind-signed bearer tokens issued by a mint or a guardian federation | The closest crypto match to a family or team federation. But bearer tokens that move between people are value transfer, and they are custodial. **Not used.** |
| Agent-hiring marketplaces (NEAR AI Agent Market, TaskMarket, Wuselverse, OpenTask; IETF PACT draft) | Whole tasks posted with a budget; agents bid; crypto escrow; accept or reject | Confirms a one-round sealed bid with ranges. SGI differs on purpose: the unit is one typed command call, not a task, so there is no escrow and no acceptance step. |
| DePIN GPU networks | Token-incentivized compute markets | Token emissions subsidize supply that is often not real. **No own token or chain.** |
| p2p inference swarms (Petals, exo) | Model sharding over a DHT | That is the sphere tier, not this feature. |
| NIP-90 bids; DVM price replies | The job request carries a `bid` (max amount); the service answers with its price or declines | **Adopt a one-round bid:** a range on each side and a single match, no order book or auction engine. |
| Mutual credit / time banking | Bilateral balances that sum to zero; nothing is issued | **Fits the trusted group:** p2p, no money, no mint, no central ledger. |
| Closed-loop prepaid rules | Credit sold by the issuer for its own services is generally outside money-transmission rules. An operator moving funds between third parties can still be a money transmitter. | Tessaro sells only its own capacity. Earned credits never cash out and never pay members. |
| LLM vendor terms | Subscriptions are personal; reselling access needs vendor approval | An offer declares what backs it. **Subscription-backed offers are refused for non-owners.** Local or open-weight models, open-source tools and the member's own API keys used within the vendor's terms are fine. |

## 3. Design: credits, priced per command call

### Rail 0: group mutual credit (MVP; p2p, no money)

- **Signed receipts.** Every served run of an SGI offer produces one receipt:
  `{command, source digest, caller principal, price, time, cost_usd|unpriced, prev}`. `prev` is the
  sha256 of the door's previous receipt, so each door keeps a hash-chained log.
  - The receipt is signed with the door host's ed25519 key under a new canonical tag,
    `dhnt-receipt-v1` (the same length-prefixed encoding as `yoke/pkg/feed/sign.go`).
  - It is returned to the caller in a response header. The caller's bashy stores it.
- **Balances are local.** Each member computes balances from the receipts they hold
  (served and consumed). Members cross-check by exchanging chain heads; a mismatch or
  a bad signature is reported, never silently merged. There is no central ledger, and
  no hosted-plane change: the hosted plane keeps holding relationship data only.
- **Credit lines.** The owner sets a credit line per circle or per member (credits
  owed). Past the line, the door answers 402 with
  `{schema_version: "bashy-credit-402-v1", offer, owed, line, accepts: ["group-credit"]}`.
  The `accepts` list is where later rails appear.
- **Observe-only first.** Like the budget/band experiment, the default mode records
  `would-refuse` events and never blocks. The owner turns on enforcement per offer.

### Verifiable source

Every SGI offer publishes the source of the command it runs. The **source digest**
(sha256) is the command's identity: in the offer, in the ask (HEAD), and in every
receipt.

| Command kind | Source that must be available | Digest |
|---|---|---|
| Built-in or standard verb (e.g. `llm`) | bashy itself (open source); the running binary's VCS revision (Go build info) pins the public commit | bashy `vcs.revision` plus the verb |
| Example (a shaped `.bsh` command) | the `.bsh` file | sha256 of the file |
| Registered `script` record | the record and its script | sha256 of the canonical record plus script |
| Registered `exec` / `download` record that wraps a tool (ffmpeg, whisper, …) | the record, **plus** a declared `source: {url, rev}` for the wrapped tool and the sha256 of the installed binary | sha256 of the record, which includes both |

- **Refused for SGI:** a registered `exec` or `download` record with no `source`
  declaration (an opaque binary), and a dirty or unknown-revision bashy build. Each
  refusal names the missing field.
- **The offer serves its source.** The `offer-NAME` app gets a read-only `source`
  route (the record, the script or `.bsh`, the declared source reference) with the
  same audience as the offer.
- **Taker verification.** `bashy offer source HOST NAME` fetches the source, recomputes
  the digest and compares it with the ask. `bashy credits verify` checks every
  receipt's digest against the fetched source.
  - A mismatch is refused before the call, and flagged after it.
  - `bashy remote --verify` does the source check before the first call to an
    offerer, and again whenever the digest changes.
- **Not in MVP:** reproducible-build proof that a binary was built from its declared
  source. The MVP verifies the declaration and the digests, not the build.

### Simple bidding: offer range and take range

Credits are priced **per call** of the named command.

- **Offer range.** The offerer sets `--ask MIN..MAX` credits per call.
  - The door's current ask moves inside that range with load: MIN when idle, rising
    toward MAX as in-flight runs approach the offer's concurrency limit.
  - With no range set, the price is a fixed 1 credit per call.
- **Take range.** The taker sends `--bid MIN..MAX` on `bashy remote` (header
  `X-Bashy-Bid: min=…,max=…`). MIN is the opening bid; MAX is the most the taker
  will pay. With no bid, the taker accepts any price within the offer range.
- **Match.** The run is admitted when the two ranges overlap and the current ask is
  at or below the taker's MAX. The clearing price is `max(current ask, take MIN)`,
  capped at `min(offer MAX, take MAX)`. That price is recorded in the receipt
  (`price`; one call is charged `price`).
- **No match.** The door answers 402 with a counter, `{ask: current, range: [MIN, MAX]}`.
  The taker may bid again or try another offerer. There is no queue, no order book
  and no auction state.
- **Several offerers.** When several members (or cloudbox) offer the same command
  (the same name, with a compatible argument schema),
  `bashy remote --any NAME --bid …` asks each candidate's door for its current ask
  (a cheap `HEAD`). It takes the lowest ask in range, and a tie goes to the lowest
  latency. This is one-shot first-price selection, not continuous trading.
- **Known before the run.** One call has one price, so the taker always knows the
  charge before the command runs. There is no metering of tokens or seconds and no
  after-the-fact bill. A command that does very different amounts of work should be
  split into separate commands, or its owner sets a wider ask range.

### Rail 1: Tessaro purchased credits (after the MVP, on a release train)

- Closed-loop prepaid account credit, sold by Tessaro and redeemed only for
  commands that cloudbox itself offers on Tessaro capacity. To a taker, those offers
  look like any other offerer's (same ask range, same 402 counter), with an
  `accepts` entry for Tessaro credit.
- It is non-transferable, never paid out, and never spendable on member offers.
- This repo documents only the public wire contract: a 402 `accepts` entry plus a
  redemption header. The implementation lives outside this public workspace.

### No external payment rails

Credits only (operator, 2026-11-27). x402, L402 and ecash are not pursued. The 402
body keeps the `accepts` list only so that Tessaro credits (Rail 1) can be added.

### Opt-in and offer metadata

- `bashy offer NAME --sgi` adds SGI pricing to a Sprint 739 offer. `NAME` must
  resolve to a named bashy command (built-in, standard, example or registered; the
  739 K2 set). Otherwise `--sgi` is refused, with a hint to register the command
  (`bashy commands add`). `bashy offer` recommends
  SGI in its consumer line and help.
- The offer record gains:
  - `backing: local | api-own-key | subscription`;
  - `ask: {min, max}` credits per call (optional; default fixed 1);
  - the command's source digest (Verifiable source), so a receipt names exactly what
    ran.
- `--sgi` is also refused when the source cannot be published (an opaque `exec` or
  `download` record, or an unknown-revision bashy build).
- **Guard with an escape hatch.** A `subscription` backing is refused for any
  audience beyond the owner unless the owner passes `--force --reason R`. The forced
  share is logged in the record.

## 4. Reuse (code inspected 2026-11-27)

| Piece | Where | Reused as |
|---|---|---|
| Door run record: principal, tokens, wall time, `cost_usd`/`unpriced` | `yoke/pkg/broker/audit.go` (`Record`, `auditLog`) | receipt body |
| Peer meter, limits and refusals (tokens/day, USD/month, RPM → 429) | `yoke/pkg/broker/peerlimit.go` (`peerMeter.admit/observe`, `seedPeerMeter`, `admitPeer`) | credit-line check; adds 402 next to 429 |
| Pricer | `yoke/pkg/broker/broker.go` `Pricer`, `llmprice` | `cost_usd` on the receipt, informational only (lets an owner set a sensible ask) |
| Registered command records (typed schema, effects, timeout); the 739 K2 offerable set (registered commands and bashy verbs) | `yoke/pkg/fleet/commands.go`, `command_schema.go`; Sprint 739 K2 | SGI eligibility check and identity digest |
| ed25519 canonical signing and keys | `yoke/pkg/feed/sign.go`, `key.go` | receipt signature |
| Offers, member stamp, `member:` principal, `bashy remote` | Sprint 739 K1–K4 | transport and identity, unchanged |
| A/O/C sandbox lane with `cloudboxfake` | bashy `test-group-shaping-e2e` | acceptance |

## 5. Stories

| Story | What | Repo |
|---|---|---|
| **G1** SGI opt-in and offer metadata | `--sgi` and `--ask MIN..MAX` on `bashy offer`, refused unless NAME is a named bashy command (built-in, standard, example or registered) whose source can be published; source digest per kind; the read-only `source` route on the offer app; `bashy offer source HOST NAME`; `backing`, `ask` and the command record digest in the offer record; the subscription guard with `--force --reason` | yoke `pkg/fleet`, bashy (needs 739 K4) |
| **G2** signed receipts | `dhnt-receipt-v1` signing over the audit record, carrying the source digest; `bashy remote --verify` and the receipt-digest check against fetched source; per-door hash chain; receipt header to the caller; caller-side store | yoke `pkg/broker` |
| **G3** credits and lines | `bashy credits` (balance, history, verify, export); owner credit lines per circle or member; simple bidding (price per call; load-moved ask inside the offer range, `--bid MIN..MAX` / `X-Bashy-Bid`, overlap match and clearing price in the receipt, 402 counter on no match, `--any` lowest-ask selection); 402 body; observe-only default with an enforce switch | yoke `pkg/broker`, bashy |
| **G4** A/O/C sandbox e2e (acceptance) | C offers `transcribe --sgi` and O uses it; receipts verify on both sides and the balances agree; past the line, would-refuse in observe mode and 402 when enforced; a subscription-backed offer to a member is refused; `--sgi` on a name that is not a bashy command is refused; a built-in (`llm`) and a registered command are both offered; a tampered receipt fails verify; an opaque `exec` record is refused for `--sgi`; `bashy offer source` matches the digest, and changing C's script makes `--verify` refuse the next call; a bid below the ask gets a 402 counter and a re-bid in range runs at the clearing price; with two offerers, `--any` picks the lower ask | bashy (`test-group-shaping-e2e` lane) |
| **G5** cloudbox as offerer + Rail 1 wire contract (spike, doc only) | The public wire for cloudbox-offered commands (same offer, ask range and 402 counter as a member's) and the 402 `accepts` entry plus redemption header for Tessaro credits; the private design is kept outside this repo | umbrella docs |

Order: G1 → G2 → G3 → G4. G5 is an independent planning output. G6 (an external payment rail study) was dropped on 11-27: credits only. MVP = G1–G4.

## 6. Non-goals

- A public pool, or discovery of offers.
- An own token or blockchain, crypto, stablecoin or Lightning payment rails.
- Whole-task hiring (post a job, bid, escrow, accept). The unit is one command call.
- Offering ad-hoc shell lines; only named bashy commands are SGI-eligible.
- Cash-out or payouts to members.
- Bearer ecash transfer between people.
- Spending purchased credits on member offers.
- Raw RAM or GPU sharing.
- Hosted deploys. Live checks are release-train items.

## 7. Verification and venues

- Unit tests per story on its branch.
- G4 runs on the gate host with fakes, within the e2e minutes budget.
- No paid provider runs and no live hosted-plane change.

## 8. Risks and rollback

- **Disputed balances.** Receipts are signed and chained, and verification reports
  mismatches. A dispute is settled socially within the group; there is no money to
  claw back.
- **Vendor terms.** The backing declaration plus the guard keep personal
  subscriptions owner-only. The escape hatch is logged.
- **Regulatory drift.** Rail 1 stays behind a legal review. Rail 0 issues nothing
  and moves no money, and no external payment rail is used.
- **Price gaming within a group.** The ranges are owner-set, and the ask moves only
  with measured load. Receipts show every clearing price, so overcharging is
  visible. Members are trusted; there is no anonymous market.
- **Source available is not build proven.** A wrapped binary's declared source may
  not be what was compiled. The MVP pins the binary digest and the declared source,
  so a change is visible. Reproducible-build verification is later work.
- **Rollback.** `--sgi` is opt-in and observe-only by default. Removing it leaves
  Sprint 739 offers unchanged.
