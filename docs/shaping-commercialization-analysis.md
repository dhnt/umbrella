# Commercializing bashy software shaping — analysis of the 2026-11-13 brainstorm

Status: analysis and recommendation for the operator. Nothing here is a decision of
record; no sprint is created by this document. Prices are hypotheses until a customer
pays one.

## Sources compiled

| Source | Who | What it is |
|---|---|---|
| `meetings/meeting-note-2026-11-13T07-09-commercializing-bashy-software-shaping-product-a.md` | meet room 46: three seeded seats (codex, claude, gemini), two volunteer seats, four live sessions, facilitator, notes-only secretary | minutes, two polls, 25-card board |
| viewer book `shaping-business-assessment-20261113` | codex live session | "honest business assessment": narrow to one managed workflow, founder-led |
| viewer book `shaping-business-findings` | muse live session | "honest assessment": feature-not-product risk, five strategies ranked |
| viewer book `shaping-viability-review` | claude-fable live session | claims-versus-records table, two offers, founder-led retainer |
| viewer book `book-51749a511792` | gemini live session | strategic assessment, three codebase traps, anti-SaaS workbox tiers |
| Sprint 631 / Sprint 632 cards | repo | shapeable-app catalog; evaluation stories E1–E4 |

The viewer books live on the local viewer service (`bashy viewer show <id>`); they are
not committed. Their substance is reproduced here so the analysis stands on its own.

## 1. Where every source agrees

1. **Receivers never pay.** Whoever receives or runs a shaped app pays nothing. bashy,
   outpost, personal shaping and the reference apps stay free and open. Every seat, every
   book.
2. **Charge for operation, governance and evidence, not for generation.** Hosting,
   backups, tested updates, approvals and audit, evidence export, bounded support. LLM
   usage passes through at cost plus a small margin; marking up tokens is a commodity
   race against bring-your-own-model.
3. **Flat units, never per seat or per wish.** Per governed satellite, per governed app
   line, per team circle, per business, per course term. The USD 20/seat figure in the
   deck was withdrawn in-room as a manager's number, not a customer's.
4. **Sprint 632 E1–E3 is the gate.** Upgrade survival (E1), data-safe shaping (E2) and
   the beachhead job against a coding agent plus SaaS configuration (E3) decide whether
   shaping is a product or a demo. Vendor OEM and "long-tail offload" are premature until
   E1 and E2 pass; vendors do not embed an unmeasured promise and already ship their own
   build-it-for-me features.
5. **A catalog of forks is an obligation, not a moat.** Each fork adds drift, security
   patching and no-phone-home audits; upstream archival has already hit once. Keep two or
   three reference apps as the shaping surface. (The gemini book argues a *certified
   shapes registry* could become a moat later; it conditions that on E1–E3 too.)
6. **Founder-direct this quarter.** Free cloud workspaces (Codespaces, Gitpod) are the
   try-before funnel, never the paid home. Agencies and IT providers are a later channel.

## 2. Where they split: the single first bet

| Bet | Backed by | What it proves | Time to first dollar | Blocking work | Main objection |
|---|---|---|---|---|---|
| **A. Classroom satellites** (turnkey hosted satellite per course term on the lern-si pattern) | seated panel 4 of 5; gemini seat strongest | willingness to pay for hosting, pooled LLM and support; continuity sale (term 2) | shortest: the path already ran end to end | none for term 2; a one-click launcher for new educators | monetizes hosting, not shaping, so it proves nothing about the headline product; institutional buyer is slow |
| **B. Founder-led retainer on one data-bearing app** for four or five similar small businesses (setup fee plus monthly with a compute cap) | fable review, codex assessment, muse ("maintenance retainer on one catalog job"), codex-business session | E1–E3 on real wishes; which requests repeat; true support hours per customer | weeks: founder demos on the prospect's own workflow | the shared-data and thin-seam fixes (section 3) before any data-bearing wish | service-heavy; support hours, not model cost, dominate; unlimited changes at subscription prices cannot be sustained |
| **C. Team governance product** (approver-gated shared app line, promotion policy, audit and evidence export, signed catalog) | muse rank 1 "most defensible"; fable product offer; gemini tier 1 circle | the governor is the product; sells where internal-tool money already flows | not this quarter | promotion has never round-tripped on two hosts; team approval policy deferred | nothing to govern until B or A produces a team with approved shapes |

Reading the split honestly: A is cheap and already running, so it is not really in
competition with B. The room's dissent is about *labels*, not about doing it: classroom
revenue is hosting revenue and must not be reported as proof of shaping demand. B is the
only bet that buys the evidence the product needs. C is the destination, not the start.

## 3. Technical blockers the business case depends on

Surfaced by the gemini and fable live sessions from the shipped code, and not disputed in
the room:

1. **Per-principal data siloing.** The Sprint 631 catalog launches each principal's shaped
   app on a private data directory (the table and notes adapters). Two people in one
   business would look at different databases. Team shaping needs a shared canonical store
   with a per-principal code/view/automation overlay, and candidate preview needs a snapshot
   of the live data, not an empty one.
2. **CSS-only seam on heavy forks.** Because rebuilding a large upstream (the table app's
   TypeScript tree) is slow, the adapter only injects a stylesheet over an immutable build.
   The E3 wish (remind customers of orders unpaid for three days and add a statistics page)
   cannot be fulfilled through that seam. Proposed fix: a three-layer seam per catalog app,
   UI sidecar routes, Bash# event and cron hooks with contracts, additive schema migrations
   through the app's own API.
3. **Wish cost and latency.** A wish that explores a large fork and runs a full build takes
   minutes and dollars; shaping the thin adapter layer by default brings it under a minute.
4. **Hollow verification.** The flagship example's checks are three greps; the badge bar is
   "at least one check that can fail". Without a contract-derived default check set per
   app, "verified" is marketing. Containment is process-level guards, not a sandbox.
5. **Promotion unproven.** Local to team to upstream exists in rc.27 but a two-host round
   trip was never recorded; 7 of 24 end-to-end cells passed on the hello-world change.
6. **Data and external effects.** Restoring code does not restore data or unsend an email.
   No shaping on applications holding children's personal data before E2 passes.

## 4. Pricing hypotheses on the table

All are experiments to run with a paying partner, not prices.

| Offer | Unit | Figures proposed |
|---|---|---|
| Classroom satellite | per satellite per course term | USD 200 per term; pooled LLM at cost plus 15% |
| Founder-led retainer | setup fee plus monthly per business, compute cap | USD 1,000–3,000 setup; USD 300–800 per month |
| Team governance | flat per governed app line or satellite per month, receivers free | USD 250 per governed satellite; USD 29–99 per team circle |
| Hosted satellite (convenience tier) | per satellite per month | cost plus a small margin; "not the business" |
| Shaping credits | per verified candidate | charge only when `bashy shape verify` passes; route simple wishes to cheap or local models |
| Evidence export and retention | add-on for audited organizations | unpriced |

Illustrative economics from the codex assessment: 50 customers at USD 500 per month is
USD 25,000 monthly recurring; at five support hours per customer per month that is 250
hours of support, so human time, not model cost, decides contribution per customer.

## 5. Risks, merged

- Pricing aimed at the person doing the shaping misses the real payer, who owns the
  continuity, infrastructure or support burden.
- Selling vendor OEM before E1/E2 sells an unmeasured promise.
- A broad catalog multiplies maintenance faster than revenue.
- Consumer and solo self-hosters have near-zero willingness to pay; developers already use
  their coding agent on the repo directly; enterprise core systems need SLAs and audited
  hosting the company cannot staff.
- Thin moat where it stands: permissive licence plus a copyable lifecycle. The candidate
  moat is the governor plus the evidence trail plus a track record of shapes surviving
  upgrades.
- Scope: six tiers, comms, voice, tray, marks, catalog, one person. E1–E3 are the right
  work; most of the rest is not, yet.
- An unresolved employer IP assignment question blocks any term sheet (fable review).

## 6. Evidence that would justify expansion

Thresholds proposed by the codex assessment and the muse findings, merged:

1. Five paying businesses with substantially the same operational need.
2. Repeated operational use over 8–12 weeks, beyond novelty.
3. Three renewals at the intended ongoing price.
4. A real upstream upgrade preserves customizations or produces an explicit, recoverable
   refusal (E1), per app, with the share surviving untouched / with agent merge / broken.
5. Data-change and recovery exercises succeed, including writes made after activation (E2).
6. Routine support trends below one hour per customer per month after onboarding.
7. The E3 head-to-head (elapsed time, model cost, review minutes, post-approval defects)
   beats an ordinary coding agent plus SaaS configuration. If it does not, say so and
   reposition shaping as bashy's differentiator and dogfood engine while commercial effort
   moves to the hosted and outpost layer.

## 7. Recommendation

Sequence, not a choice between the bets:

1. **Gate first.** Run Sprint 632 E1–E3 on the one beachhead job (unpaid-order reminders
   plus a statistics page on the table app). Add the shared-data and thin-seam work from
   section 3 as a prerequisite story; E3 cannot pass through a stylesheet.
2. **Retainer as the evidence vehicle.** In parallel, sign three to five small businesses
   with the same spreadsheet-shaped operations pain to a founder-led retainer (setup fee,
   monthly with a compute cap, bounded changes). Their real wishes are the E1–E3 corpus.
   Record what each partner actually pays.
3. **Classroom term 2 as paid continuity, labelled as hosting.** Convert the running class
   satellite from free to a small paid term. It is cheap, it tests the continuity sale and
   support load, and it is reported as hosting revenue, never as shaping proof.
4. **Team governance when there is a team.** Build the approver-gated shared app line,
   evidence export and promotion policy once a retainer customer has approved shapes to
   govern and promotion has round-tripped on two hosts.
5. **Vendor kit and certified-shape registry last**, after E1/E2 and after the catalog has
   survived one real upstream upgrade with real data.

Stop or park: catalog expansion beyond two or three reference apps, per-seat and per-wish
pricing, consumer managed outposts, and reseller channels this quarter.

Proposed one-liner from the room, kept for the pitch work: *verified, reversible,
per-person changes to the software your team already runs, written by any agent.*

## 8. Open questions for the operator

- Does classroom satellite revenue count toward the shaping thesis, or is it platform
  revenue kept separate in reporting?
- Which pricing unit to test first with the retainer partners: per business, or per
  governed app line?
- Is the shared-data and thin-seam fix in scope for Sprint 632, or a story before it?
- The employer IP assignment question flagged in the review.

## 9. Process notes from running the session

- `bashy meet poll` choices must be bare keys; a choice carrying a description after a
  colon never matches a reply and every ballot records as invalid (todo `ed3051699fee`).
- A live session seated on the roster gets a headless proxy ballot at poll time, which can
  contradict the session's own stated position. Live seats should answer by `tell`, or the
  poll should skip them.
- The brainstorm board accepts cards through its action route with a stable participant
  cookie; the registered command's `set` verb drops author and column.
