# Sprint 740: SGI (bashy commands as a service for credits, with verified delivery and a store)

*Master execution plan · 2026-11-27 · backlog, operator review before start. Planning only. Revised the same day: verified delivery, the store, and a per-account append-only credit records kept by cloudbox in a transparency log.*

## 1. The gap

**SGI** ("super general intelligence, the dhnt way") is a recommended opt-in feature
for every user:
- A member offers **bashy commands** as a service to the people they have a
  relationship with. Others' agents buy calls or deliveries with **credits**.
- Sharing earns credits. People who own no satellite, outpost or tools buy credits
  and spend them on commands that cloudbox itself offers.
- A **store** lists what kinds of service exist and who offers them now.

Sprint 739 (`docs/sprint-739-master-execution-plan.md`) builds the sharing mechanism:
- offers and folders as gated apps;
- the member stamp;
- `bashy remote`;
- artifacts by `bashy://` reference.

SGI is the economy, verification and discovery layer on top. Sprint 740 depends on
Sprint 739 K1–K4 and does not reopen it.

### Operator rulings (2026-11-27)

1. **Trusted relationships only.** Anyone may invite anyone, which creates a mutual
   buyer/seller relationship. There is no anonymous public market.
2. **Credits only.** No crypto, stablecoin or Lightning payment rail.
3. **Command as a service, not task hiring.** The unit is a named bashy command:
   built-in, standard, example (shaped) or registered, custom or not.
4. **The source must be available**, so takers can verify what runs.
5. **Cloudbox offers commands too.** Purchased credits are spent only on those.
6. **Verify the product, not the hardware.** A bashy-provided verifier checks the
   delivered result. If the verifier accepts, the deal is done.
7. **SGI has a store** that lists offerings.
8. **Cloudbox keeps the credit ledger and the listing.** The ledger records totals
   only, never transaction details.
9. **Crypto technology is welcome for the ledger itself.** The ledger uses
   cryptographic techniques (signatures, hash chains, a Merkle transparency log),
   not a token or a blockchain (section 3.3).

## 2. State of the art (what to copy, what to avoid)

| Approach | Lesson for SGI |
|---|---|
| Nostr NIP-90 data vending machines (job request, result and feedback, with a `bid`) | Copy the request/result shape and the one-round bid. Upstream marks the spec "unrecommended" because it sprawled, and open markets show **no demand**. So keep the scope narrow and serve relationships, not strangers. |
| x402 / L402 (HTTP 402 pay-per-call) | Copy the wire shape: refuse with **402** and a machine-readable counter. 429 stays for rate limits. The payment rails are **not used**. |
| Agent-hiring markets (NEAR AI Agent Market, TaskMarket, Wuselverse, OpenTask; IETF PACT draft) | Whole tasks, crypto escrow, buyer accept or reject. SGI instead uses typed commands, credit holds, and a **pinned verifier** that decides. One round of sealed bids with ranges matches what PACT recommends. |
| Blockchains, ecash mints, DePIN tokens | A blockchain buys consensus among *mutually distrusting operators*, but SGI has one operator (cloudbox), so it isn't needed. Tokens bring value transfer and subsidy problems. **No token and no chain.** |
| Transparency logs (Certificate Transparency, Sigstore Rekor, Trillian) | **Copy.** An append-only Merkle log run by one operator. Clients get inclusion and consistency proofs, so the operator cannot rewrite or fork history without detection. This is the useful crypto for a single-operator ledger. |
| Mutual credit / time banking | Credits are bilateral and net to zero. Fits relationships. It needs a per-account limit once relationships are open (the Sybil problem), hence the cloudbox position ledger. |
| Closed-loop prepaid rules | Tessaro sells credit for its own offers only. Earned credits never cash out. |
| LLM vendor terms | Subscription-backed offers stay owner-only. |
| Remote attestation (TPM, SEV-SNP/TDX, sealed images) | It can't stop an owner with root on consumer machines, and it doesn't exist on macOS. **Not pursued.** Results are checked instead. |
| conform (this workspace) | The model to follow: one invariant judge that builders and graders both run. |

## 3. Design

### 3.1 What can be offered

- **Eligible:** any named bashy command whose **source is published**. These are
  the commands Sprint 739 K2 makes offerable. Mutating and `confirm` commands stay
  refused remotely (`Admit`).
- **Command opt-in:** `bashy offer NAME --sgi [--ask MIN..MAX] [--verifier V@DIGEST
  --spec-format F --redeliver N]`.
- **Each offer declares its backing:** `local`, `api-own-key` or `subscription`.
  `subscription` is refused for anyone but the owner unless the owner passes
  `--force --reason R`, which is logged.
- **Source digest per kind.** The digest is the command's identity: in the offer,
  in the listing and in every receipt.

| Command kind | Source digest |
|---|---|
| Built-in or standard verb | bashy `vcs.revision` (the public commit) plus the verb; a dirty or unknown build is refused |
| Example (`.bsh`) | sha256 of the file |
| Registered `script` | sha256 of the canonical record plus the script |
| Registered `exec` / `download` wrapping a tool | the record must declare `source: {url, rev}` and the installed binary's sha256; otherwise refused |

- **The offer app serves its source** read-only to the offer's audience.
  - `bashy offer source HOST NAME` fetches the source and recomputes the digest.
  - `bashy remote --verify` checks it before the first call and again whenever it
    changes.

### 3.2 Two kinds of deal

| Deal | For | Settlement |
|---|---|---|
| **Per call** | cheap, interactive commands (`llm`, lookups) | the price is cleared by the bid before the run; the receipt is final at once |
| **Verified delivery** | spec → artifact work (video, spec→source, dubbing, …) | the price is **held**, the artifact is delivered, the pinned verifier runs, and the verdict settles the deal |

**Bidding (both kinds).**
- The offerer sets an ask range, and the current ask moves inside it with load. The
  taker sends a take range: `--bid MIN..MAX`, sent as header `X-Bashy-Bid`.
- When the ranges overlap, the price is `max(ask, take MIN)`, capped at
  `min(offer MAX, take MAX)`.
- When they don't, the door answers 402 with a counter, `{ask, range}`.
- `--any` picks the lowest ask among the offerers of the same command; a tie goes
  to the lowest latency.
- There is no order book.

**Verified delivery: the deal.**
1. The offer pins a **verifier**. It is a bashy-provided command with published
   source, never seller-written. The offer also pins the thresholds, the accepted
   spec format and the redelivery limit.
2. The buyer orders: `bashy remote C -- video --spec film.md --bid 40..60`. The
   cleared price is held as a signed `hold` receipt.
3. The seller runs the verifier itself, then delivers the artifact URI plus its own
   report.
4. The buyer's bashy runs **the same pinned verifier** automatically on the
   artifact plus the spec.
5. The verdict decides:
   - **Pass → done deal.** A `final` receipt is written, and the buyer cannot reject
     the delivery.
   - **Fail → no charge.** A `release` receipt is written, and the seller may
     redeliver up to N times.
   - **Waiver.** The buyer accepts a failure anyway; this is logged.
   - **Buyer silent.** The seller's passing report settles the deal after a timeout.
     Either side can rerun the verifier later.
6. **Determinism is the dispute rule.** Both sides run the same verifier on the same
   inputs. A different verdict is a verifier defect: it is filed and fixed in the
   method, not in the deal.
7. **Subjective quality.** In the MVP only objective checks bind. An LLM or vision
   judge is advisory unless the offer opts in to a pinned model with a majority of 3.
   Taste is judged before ordering, from the listing's sample deliveries.

**Verifiers are conform contracts per artifact kind.** They are named bashy commands
built on `conform`, with ffprobe, transcription and OCR checks as their own
commands. The first verifier is **video**:
- duration, resolution, fps and codec;
- EBU R128 loudness;
- no black frames or silent gaps;
- captions present and in sync;
- the transcribed speech matches the script (word error rate at or under the
  threshold);
- every spec scene is covered.

### 3.3 Credits and the cloudbox ledger (totals only, transparency log)

- **Receipts are the detail, and they stay peer-to-peer.**
  - Each receipt is `hold`, `final` or `release`, with the command, source digest,
    verifier digest, price, parties, time and `prev`.
  - Receipts are signed with the door host's ed25519 key under the tag
    `dhnt-receipt-v1`, using the `yoke/pkg/feed/sign.go` encoding, and chained per
    door.
  - Both parties keep their receipts. **Cloudbox never sees them.**
- **Cloudbox keeps one append-only credit record per account (operator,
  2026-11-27).** A member's credits are a list of entries that only grows:
  `{account, seq, delta, counterparty, type: earned|spent|purchased|redeemed,
  period, settled count, failed count, receipt-chain head hash, prev}`.
  - **Balance = sum of the entries.** Nothing is ever edited. A correction is a new
    entry.
  - **Double entry.** A settlement between A and C writes two mirrored entries, a
    debit in A's record and a credit in C's, from one **netting checkpoint** signed
    by both parties. A one-sided checkpoint is recorded as disputed and is not
    applied.
  - **Totals, not transactions.** Entries are netted per counterparty per period
    (default daily, settable by the owner). They hold no command, artifact, spec or
    per-call times, and the timing of individual deals stays hidden. The chain-head
    hash commits to the private receipts without revealing them, so a party can
    later prove a disputed receipt was included.
  - **Each record is hash-chained** (`prev`), so a member can verify their own
    record end to end with `bashy credits record`.
- **All account records sit in one append-only Merkle transparency log.** This is the
  crypto part.
  It is modeled on Certificate Transparency and Sigstore Rekor, and Go has Trillian
  and `transparency-dev` libraries. Each record entry is a log leaf.
  - Cloudbox signs a tree head after each batch.
  - Clients keep the last tree head they saw and check:
    - an **inclusion proof** for their own record entries;
    - a **consistency proof** between tree heads.
  - So cloudbox cannot alter, drop or reorder history, or show two members
    different histories, without detection.
  - Members gossip tree heads with their counterparties, and `bashy credits audit`
    checks them.
  - Balances are recomputable: a member's position is the sum of their own record,
    which they can check against cloudbox's reported number.
  - What this gives: integrity and auditability of one trusted operator, without a
    blockchain, a token or consensus.
- **Why a central position ledger at all.** Anyone can invite anyone. Without a
  global view, a new account could run up debt with many sellers and leave. The
  rules:
  - A new account starts with a position limit of 0. It earns first, or the seller
    extends a per-relationship credit line.
  - The door checks the buyer's cloudbox position, served with the relationship
    stamp, and the seller's own line.
- **Purchased credits are a separate balance type.** Tessaro credit is closed-loop,
  spendable only on cloudbox offers, never transferable and never cashed out.
  Earned credits never convert into it.
- **It is still relationship data.** A netted balance per relationship is a property
  of the relationship, like its circle. The hosted plane stores strings, totals and
  log hashes; the nodes and receipts hold the meaning. This repo documents only the
  public wire: checkpoint submit, tree head, inclusion and consistency proofs,
  position query and listing publish.
- **Observe-only first.** Limits and lines record `would-refuse` before any
  enforcement is switched on.

### 3.4 The store

- **Catalog (public, static, git):** the existing `dhnt/appstore` repository gains
  `caas/<kind>/` entries. Each entry holds:
  - the spec format and an example spec;
  - the pinned verifier and its thresholds;
  - source references;
  - sample deliveries with verifier reports;
  - a price guide in credits.

  The first entries are listed in 3.5. The catalog needs no hosted change.
- **Listing (live, cloudbox):** an SGI offer is published to the cloudbox listing
  with its command, kind, seller, ask range, verifier digest, source digest, deal
  type and audience. Cloudbox's own offers are listed the same way.
  - A member sees only listings from people they have a relationship with, plus
    cloudbox's offers.
  - Each row shows the **track record** from the logged checkpoints (settled,
    verifier pass share, redeliveries, distinct counterparties). There are **no
    written reviews**, so nothing can be faked by typing.
- **Surfaces:**
  - CLI: `bashy store list [--kind K]`, `bashy store show ID`, and
    `bashy store order ID --spec F --bid R` (the verified-delivery flow).
  - Web: a store page, a thin UI over the same CLI operations.
  - With no tools, a member sees cloudbox offers and pays with purchased credits.

### 3.5 Catalog roadmap (operator, 2026-11-27)

Entries are ranked by value: how scarce the capability is (GPU, paid model,
installed tooling) times how objectively a verifier can check the result.
"verified" means verified delivery and "call" means a per-call deal. Every entry
must use a named bashy command with published source.

**Tier 1: high value, strongly verifiable**

| # | Kind | Spec in → artifact out | Deal | Binding verifier checks |
|---|---|---|---|---|
| 1 | `video` | video spec (script, scenes, style, length) → MP4 + captions | verified | duration, resolution, fps, codec; EBU R128 loudness; no black frames or silent gaps; captions in sync; transcribed speech matches the script (WER ≤ t); every spec scene covered |
| 2 | `spec2src` | shapeware spec → app source | verified | conform contract plus hidden cases; build passes; license scan |
| 3 | `transcribe` | audio/video → transcript + SRT/VTT | call or verified | valid SRT/VTT; timestamps monotonic and covering the audio; WER on a known-answer slice |
| 4 | `dub` | script + voice (+ video) → audio track or dubbed video | verified | duration window; loudness; transcribe-back matches the script; a/v offset ≤ t |
| 5 | `build` | repo@commit + recipe → artifacts + test report | verified | reproducible artifact digest (anyone can rebuild); signed report; pass/fail counts |
| 6 | `llm` | prompt → completion (route declared) | call | none binding: price, source digest and declared backing only |

**Tier 2: high demand, verifiable with structure**

| # | Kind | Spec in → artifact out | Deal | Binding verifier checks |
|---|---|---|---|---|
| 7 | `translate` | file + target language + glossary → localized file | verified | placeholders and markup preserved; glossary used; length limits; back-translation ≥ t |
| 8 | `subtitle-translate` | SRT + target language → SRT | verified | cue count and timing kept; line length and reading speed; back-translation ≥ t |
| 9 | `extract` | documents + JSON schema → JSON records | verified | schema-valid; known-answer fields; every document accounted for |
| 10 | `ocr` | scans/PDF → searchable PDF + text | call or verified | text layer present; CER on a known-answer page; page count kept |
| 11 | `image-set` | image spec (count, sizes, elements, text) → images | verified | count, size, format; OCR'd text matches the spec; vision checks advisory |
| 12 | `doc` | outline spec → PDF/DOCX/PPTX report or deck | verified | required sections or slides; links resolve; file valid; page/word limits; citations resolve |

**Tier 3: taste matters more (advisory judges)**

| # | Kind | Spec in → artifact out | Deal | Binding verifier checks |
|---|---|---|---|---|
| 13 | `song` | lyrics + style + length → audio | verified | duration; loudness; sung lyrics transcribe back to the spec; no clipping |
| 14 | `podcast-edit` | recordings + edit spec → mastered episode | verified | loudness target; silence trimmed; chapters; transcript coverage |
| 15 | `site` | page spec → static site | verified | conform DOM walker: inventory, links, accessibility basics |
| 16 | `dataviz` | data + chart spec → charts or page | verified | every series plotted from the data (values match); axes and labels per spec |

**Not catalog entries:**
- raw compute or GPU rental (sphere tier);
- open-ended work with nothing objective to verify;
- anything backed by a personal subscription (owner-only).

**Shared checks.** About ten reusable check commands cover all 16 kinds:
- ffprobe;
- loudness;
- black and silence detection;
- caption timing;
- transcribe-back WER;
- OCR / CER;
- JSON-schema validation;
- link checking;
- reproducible digest;
- conform.

V2 builds this library, and each new kind is then mostly a contract file plus its
catalog entry.

**Order.**
- In this sprint (S1): `video` (V2's first verifier), `transcribe`, `dub` and
  `spec2src`. The first three share the transcription and loudness checks;
  `spec2src` reuses conform.
- Next: `extract` and `translate` (the broadest everyday demand), then the rest of
  Tier 2, then Tier 3.
- Each later entry is a small story on its own, filed when the previous one has
  settled real deals.

## 4. Reuse (code inspected 2026-11-27)

| Piece | Where | Reused as |
|---|---|---|
| Door run record (principal, tokens, wall time, `cost_usd`/`unpriced`) | `yoke/pkg/broker/audit.go` | receipt body |
| Peer meter, limits, refusals | `yoke/pkg/broker/peerlimit.go` | line and position checks; 402 next to 429 |
| ed25519 canonical signing | `yoke/pkg/feed/sign.go`, `key.go` | receipts and checkpoints |
| Registered command records | `yoke/pkg/fleet/commands.go`, `command_schema.go` | eligibility, source digest |
| Sigstore verification, including transparency-log inclusion against an embedded trusted root | `yoke/pkg/binmgr/sigstore.go` | wrapped-tool provenance; the pattern for verifying ledger proofs offline |
| conform contract runner | `conform/` | verifier framework |
| App catalog | `appstore/` (`categories.yaml`, `apps/<id>/`) | CaaS kind catalog |
| Hosted-plane fake | `yoke/pkg/fleet/cloudboxfake` | ledger, log and listing in e2e |
| Offers, stamp, `bashy remote`, `bashy://` artifacts | Sprint 739 K1–K4 | transport, identity, delivery |

## 5. Stories

| Story | What | Repo |
|---|---|---|
| **G1** SGI opt-in | `--sgi`, ask range, backing guard, verifiable source per kind, the source route, `bashy offer source` | yoke `pkg/fleet`, bashy |
| **G2** receipts | `hold` / `final` / `release` receipts, signed and chained; receipt header; caller store; `--verify` | yoke `pkg/broker` |
| **G3** credits and per-call bidding | `bashy credits` (balance, history, verify, export); per-relationship lines; bid clearing; 402 counter; `--any`; observe-only default | yoke `pkg/broker`, bashy |
| **V1** verified delivery | offer `verifier`, `spec-format`, `redeliver`; hold → deliver → buyer verify → final/release; waiver; timeout settle | yoke, bashy |
| **V2** verifier framework and the video verifier | conform-based verifier commands; the shared check library of section 3.5 (ffprobe, loudness, black/silence, caption timing, transcribe-back WER, scene coverage first); deterministic verdict | conform, bashy examples |
| **L1** ledger wire and client | public wire for checkpoint submit (both-signed), per-account append-only record (double entry, hash-chained), signed tree head, inclusion and consistency proofs, position query, track record; `bashy credits checkpoint`, `record` and `audit` (proof checks, tree-head gossip); door position check; cloudboxfake with a Merkle log. The hosted implementation is tracked privately. | yoke `pkg/fleet`, bashy |
| **S1** CaaS catalog | `appstore` `caas/<kind>/` format; the first four roadmap entries (`video`, `transcribe`, `dub`, `spec2src`, section 3.5), each with an example spec and a passing sample delivery | appstore |
| **S2** listing and store CLI | publish offers to the listing wire; `bashy store list/show/order`; track record per row; cloudboxfake support | yoke, bashy |
| **S3** store web page | thin UI over the store CLI operations | bashy |
| **G5** cloudbox offers and Tessaro credit (spike, doc only) | public wire for cloudbox-offered commands and the purchased-credit balance type | umbrella docs |
| **G4** A/O/C sandbox e2e (acceptance) | see section 7 | bashy (`test-group-shaping-e2e`) |

Order:
1. G1, then G2 and G3 (per call working end to end).
2. V1 and V2 (verified delivery).
3. L1 (ledger).
4. S1 and S2, then S3 (store).
5. G4.

G5 is a parallel planning output.

## 6. Non-goals

- An anonymous public market. Every party is in a relationship by invitation.
- Tokens, blockchains, crypto or Lightning payment rails, cash-out, payouts.
- Transaction details in the hosted plane.
- Hardware attestation or sealed runtimes.
- Written reviews or ratings.
- Binding subjective judges by default.
- Whole-task hiring outside a named command.
- Shape contributions flowing back through the store; the catalog stays DIY starters.
- Hosted deploys; live checks are release-train items.

## 7. Acceptance (G4) and venues

The run uses the sandbox, `cloudboxfake` with the ledger log and listing, fake
providers, and fake accounts. Neither A nor O has an LLM.

1. C offers the registered `transcribe` (per call) and the example `video`
   (verified delivery, video verifier). C also offers the built-in `llm`.
2. O finds `video` with `bashy store list --kind video`. The row shows the ask,
   the verifier and the track record.
3. O orders with a spec:
   - A passing delivery settles, and O cannot reject it.
   - A failing delivery is released without charge. The redelivery passes and
     settles.
   - A waiver is logged.
   - Both sides reproduce the same verdict.
4. Per call: a bid below the ask gets a 402 counter, and a re-bid runs at the
   clearing price. With two offerers, `--any` picks the lower ask.
5. Ledger:
   - The netting checkpoint is signed by both sides and appears as mirrored entries
     in A's and C's records. The fake log holds only totals, and each balance equals
     the sum of its record.
   - Inclusion and consistency proofs verify.
   - A fake that rewrites a leaf, or shows A and C different tree heads, is caught
     by `bashy credits audit`.
   - A new invitee with a position limit of 0 is refused past its line
     (would-refuse when observing, 402 when enforcing).
   - A one-sided checkpoint is marked disputed.
6. Refusals:
   - `--sgi` on an ad-hoc name, or on an opaque exec record;
   - a subscription-backed offer to a member;
   - a tampered receipt;
   - a changed script, which `--verify` refuses.
7. A, with purchased fake credits, orders a cloudbox-offered command.

Venue: the gate host, within the e2e minutes budget. Unit tests run per story. No
paid provider runs and no live hosted-plane change.

## 8. Risks and rollback

- **The verifier's quality becomes the market's quality.** A weak verifier lets bad
  deliveries settle. Mitigations:
  - verifiers are pinned, open and versioned;
  - conform's mutation harness measures their strength;
  - verifiers are fixed generically, in the method (shapeware rule).
- **Verifier non-determinism** (transcription-based checks). Pin the model, seed and
  thresholds. A disagreement is treated as a defect, not a dispute.
- **Collusion to inflate a track record.** Fake mutual deals between colluding
  accounts. The record counts only checkpoints signed by both sides, and the store
  shows counts per distinct counterparty.
- **Ledger operator misbehaviour.** The transparency log makes rewriting or forking
  detectable, not impossible. Detection relies on members keeping and gossiping tree
  heads, which bashy does automatically.
- **Hosted-plane scope.** The ledger and listing are new hosted data. They are
  limited to per-account totals records, log hashes and listings, ship on a release train, and are
  public only as a wire contract.
- **Regulatory.** Earned credits never cash out, and purchased credit buys only
  cloudbox offers. Legal review happens before purchased credits go live (G5).
- **Rollback.** SGI is opt-in, and the ledger and store start observe-only.
  Disabling SGI leaves Sprint 739 offers unchanged.
