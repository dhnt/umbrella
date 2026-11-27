# Sprint 740: SGI (opt-in shared agentic tools for credits)

*Master execution plan · 2026-11-27 · backlog, operator review before start. Planning only.*

## 1. The gap

**SGI** ("super general intelligence, the dhnt way") is a recommended opt-in feature
for every user. A member chooses which agentic tools and models to share with their
trusted group: a transcriber, a video generator, `llm`, or any registered command.
They share the **tools**, never raw RAM or GPU (pooling those belongs to the sphere
tier). Sharing earns **credits**. People who own no satellite, outpost or tools can
**buy** credits.

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
- The ledger design **considers p2p and crypto technologies** (section 2).

## 2. State of the art (what to copy, what to avoid)

| Approach | What it is | Lesson for SGI |
|---|---|---|
| Nostr NIP-90 "data vending machines" | Signed job request, result and feedback events, paid by Lightning invoice | The job and receipt shape is good. Upstream now marks the spec "unrecommended" because it sprawled, and operators report idle machines with **no demand**. Keep the scope narrow; demand comes from trusted groups, not an open market. |
| x402 (HTTP 402 + stablecoin; MCP `_meta` binding) | Per-call pay-on-402 for APIs and MCP tools | **Adopt the wire shape.** When credit runs out the door answers `402 Payment Required` with a machine-readable requirement body. 429 stays for rate limits. A later rail plugs in without changing callers. |
| L402 (Lightning macaroon + invoice) | Per-call Lightning payment | Same 402 pattern. A candidate rail for a later public pool only. |
| Cashu / Fedimint ecash (federated mints) | Blind-signed bearer tokens issued by a mint or a guardian federation | The closest crypto match to a family or team federation. But bearer tokens that move between people are value transfer, and they are custodial. **Study only** (G6). |
| DePIN GPU networks | Token-incentivized compute markets | Token emissions subsidize supply that is often not real. **No own token or chain.** |
| p2p inference swarms (Petals, exo) | Model sharding over a DHT | That is the sphere tier, not this feature. |
| NIP-90 bids; DVM price replies | The job request carries a `bid` (max amount); the service answers with its price or declines | **Adopt a one-round bid:** a range on each side and a single match, no order book or auction engine. |
| Mutual credit / time banking | Bilateral balances that sum to zero; nothing is issued | **Fits the trusted group:** p2p, no money, no mint, no central ledger. |
| Closed-loop prepaid rules | Credit sold by the issuer for its own services is generally outside money-transmission rules. An operator moving funds between third parties can still be a money transmitter. | Tessaro sells only its own capacity. Earned credits never cash out and never pay members. |
| LLM vendor terms | Subscriptions are personal; reselling access needs vendor approval | An offer declares what backs it. **Subscription-backed offers are refused for non-owners.** Local or open-weight models, open-source tools and the member's own API keys used within the vendor's terms are fine. |

## 3. Design: three rails, one wire

### Rail 0: group mutual credit (MVP; p2p, no money)

- **Signed receipts.** Every served run of an SGI offer produces one receipt:
  `{offer, caller principal, units, cost_usd|unpriced, time, prev}`. `prev` is the
  sha256 of the door's previous receipt, so each door keeps a hash-chained log.
  - The receipt is signed with the door host's ed25519 key under a new canonical tag,
    `dhnt-receipt-v1` (the same length-prefixed encoding as `yoke/pkg/feed/sign.go`).
  - It is returned to the caller in a response header. The caller's bashy stores it.
- **Balances are local.** Each member computes balances from the receipts they hold
  (served and consumed). Members cross-check by exchanging chain heads; a mismatch or
  a bad signature is reported, never silently merged. There is no central ledger, and
  no hosted-plane change: the hosted plane keeps holding relationship data only.
- **Credit lines.** The owner sets a credit line per circle or per member (units
  owed). Past the line, the door answers 402 with
  `{schema_version: "bashy-credit-402-v1", offer, owed, line, accepts: ["group-credit"]}`.
  The `accepts` list is where later rails appear.
- **Observe-only first.** Like the budget/band experiment, the default mode records
  `would-refuse` events and never blocks. The owner turns on enforcement per offer.

### Simple bidding: offer range and take range

Credits are priced **per unit**. The offer's `units` setting picks the unit (G1).

- **Offer range.** The offerer sets `--ask MIN..MAX` credits per unit.
  - The door's current ask moves inside that range with load: MIN when idle, rising
    toward MAX as in-flight runs approach the offer's concurrency limit.
  - With no range set, the price is a fixed 1 credit per unit.
- **Take range.** The taker sends `--bid MIN..MAX` on `bashy remote` (header
  `X-Bashy-Bid: min=…,max=…`). MIN is the opening bid; MAX is the most the taker
  will pay. With no bid, the taker accepts any price within the offer range.
- **Match.** The run is admitted when the two ranges overlap and the current ask is
  at or below the taker's MAX. The clearing price is `max(current ask, take MIN)`,
  capped at `min(offer MAX, take MAX)`. That price is recorded in the receipt
  (`price`, `units`, `charged = price × units`).
- **No match.** The door answers 402 with a counter, `{ask: current, range: [MIN, MAX]}`.
  The taker may bid again or try another offerer. There is no queue, no order book
  and no auction state.
- **Several offerers.** When several members offer the same tool,
  `bashy remote --any NAME --bid …` asks each candidate's door for its current ask
  (a cheap `HEAD`). It takes the lowest ask in range, and a tie goes to the lowest
  latency. This is one-shot first-price selection, not continuous trading.
- **The pre-run charge is an estimate.** For `token` and `wall-second` units the
  door checks the take MAX against an estimate (the request's max tokens, or the
  offer timeout). The receipt charges the actual units, so a taker is never charged
  more than MAX × the actual units.

### Rail 1: Tessaro purchased credits (after the MVP, on a release train)

- Closed-loop prepaid account credit, sold and redeemed by Tessaro for Tessaro
  capacity only.
- It is non-transferable, never paid out, and never spendable on member offers.
- This repo documents only the public wire contract: a 402 `accepts` entry plus a
  redemption header. The implementation lives outside this public workspace.

### Rail 2: external agent-payment rails (study, no code)

- x402, L402 and federated ecash are evaluated against the same 402 body for a future
  public pool.
- Any code needs a recorded legal review first: money transmission, KYC, sales tax
  and vendor terms.

### Opt-in and offer metadata

- `bashy offer NAME --sgi` adds SGI metering to a Sprint 739 offer. `bashy offer`
  recommends SGI in its consumer line and help.
- The offer record gains:
  - `backing: local | api-own-key | subscription`;
  - `units: call | wall-second | token`. Tokens come from the door's existing usage
    and pricer.
  - `ask: {min, max}` credits per unit (optional; default fixed 1).
- **Guard with an escape hatch.** A `subscription` backing is refused for any
  audience beyond the owner unless the owner passes `--force --reason R`. The forced
  share is logged in the record.

## 4. Reuse (code inspected 2026-11-27)

| Piece | Where | Reused as |
|---|---|---|
| Door run record: principal, tokens, wall time, `cost_usd`/`unpriced` | `yoke/pkg/broker/audit.go` (`Record`, `auditLog`) | receipt body |
| Peer meter, limits and refusals (tokens/day, USD/month, RPM → 429) | `yoke/pkg/broker/peerlimit.go` (`peerMeter.admit/observe`, `seedPeerMeter`, `admitPeer`) | credit-line check; adds 402 next to 429 |
| Pricer | `yoke/pkg/broker/broker.go` `Pricer`, `llmprice` | `token` units |
| ed25519 canonical signing and keys | `yoke/pkg/feed/sign.go`, `key.go` | receipt signature |
| Offers, member stamp, `member:` principal, `bashy remote` | Sprint 739 K1–K4 | transport and identity, unchanged |
| A/O/C sandbox lane with `cloudboxfake` | bashy `test-group-shaping-e2e` | acceptance |

## 5. Stories

| Story | What | Repo |
|---|---|---|
| **G1** SGI opt-in and offer metadata | `--sgi` and `--ask MIN..MAX` on `bashy offer`; `backing`, `units` and `ask` in the offer record; the subscription guard with `--force --reason` | yoke `pkg/fleet`, bashy (needs 739 K4) |
| **G2** signed receipts | `dhnt-receipt-v1` signing over the audit record; per-door hash chain; receipt header to the caller; caller-side store | yoke `pkg/broker` |
| **G3** credits and lines | `bashy credits` (balance, history, verify, export); owner credit lines per circle or member; simple bidding (load-moved ask inside the offer range, `--bid MIN..MAX` / `X-Bashy-Bid`, overlap match and clearing price in the receipt, 402 counter on no match, `--any` lowest-ask selection); 402 body; observe-only default with an enforce switch | yoke `pkg/broker`, bashy |
| **G4** A/O/C sandbox e2e (acceptance) | C offers `transcribe --sgi` and O uses it; receipts verify on both sides and the balances agree; past the line, would-refuse in observe mode and 402 when enforced; a subscription-backed offer to a member is refused; a tampered receipt fails verify; a bid below the ask gets a 402 counter and a re-bid in range runs at the clearing price; with two offerers, `--any` picks the lower ask | bashy (`test-group-shaping-e2e` lane) |
| **G5** Rail 1 wire contract (spike, doc only) | The public 402 `accepts` entry and redemption header for Tessaro credits; the private design is kept outside this repo | umbrella docs |
| **G6** Rail 2 study (spike, doc only) | x402, L402 and federated-ecash evaluation with a legal checklist; a recorded decision | umbrella docs |

Order: G1 → G2 → G3 → G4. G5 and G6 are independent planning outputs. MVP = G1–G4.

## 6. Non-goals

- A public pool, or discovery of offers.
- An own token or blockchain.
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
- **Regulatory drift.** Rails 1 and 2 stay behind a legal review. Rail 0 issues
  nothing and moves no money.
- **Price gaming within a group.** The ranges are owner-set, and the ask moves only
  with measured load. Receipts show every clearing price, so overcharging is
  visible. Members are trusted; there is no anonymous market.
- **Rollback.** `--sgi` is opt-in and observe-only by default. Removing it leaves
  Sprint 739 offers unchanged.
