# Meeting — Commercializing bashy software shaping: product and service ideas (brainstorm)
Date: 2026-11-13 07:09  ·  Session: `2026-11-13-commercializing-bashy-software-shaping-product-a-f067`
Initiator: qiangli (human)
Attendees: qiangli (human) · codex-gpt5.6-sol (participant) · claude-opus5.5 (participant) · agy-gemini3.8-flash (participant) · muse-spark1.3 (participant) · codex-shaping-business-review (participant) · claude-fable5.1 (facilitator) · claude-sonnet5.5 (secretary)
Context reviewed: bashy/README.md · docs/comms-strategy.md

Agenda: Who pays, and for what: owners, teams, classrooms, SaaS adopters · Packaging: product (bashy, shaping host, tray, apps) vs service (Tessaro, satellites, pooled LLM) · Pricing and metering: what is free, what is metered, what is licensed · Go-to-market: first customers, channels, partners, open-source posture · Risks and what not to do

## Summary
This was a brainstorm on commercializing bashy software shaping. Participants proposed payers, packaging and pricing, then put ideas on a board and polled one first bet for the quarter. Four of five seats chose classroom-satellites, citing the lern-si workflow that has already run end to end and educators with term budgets. One seat dissented for team-governance, arguing that classroom satellites monetize hosting rather than shaping. The organizer closed the session with operator approval and recorded the outcome as non-binding.

## Decisions
1. The organizer, closing with operator approval, concluded the brainstorm and recorded the outcome as non-binding. The first bet polled is classroom-satellites, with 4 of 5 seats in favor and one dissent for team-governance.

## Action items
(none)

## Risks
- claude-opus5.5 and agy raised vendor OEM and long-tail offload. claude-fable5.1-shaping-review called this premature, because no vendor embeds an unmeasured product. muse-spark1.3 listed "OEM before E1/E2 proof" as a risk card.
- claude-fable5.1-shaping-review said classroom satellites monetize hosting, not shaping. This is a risk to the shaping thesis.
- codex-gpt5.6-sol said the payer is usually the party accountable for continuity and risk, not the person doing the shaping. This is a risk if pricing targets the wrong payer.
- claude-opus5.5 and codex-gpt5.6-sol said classroom-satellites rests on one existing pattern (lern-si). The evidence comes from a single use case.

## Open questions
- Whether team-governance or another bet should follow classroom-satellites. claude-fable5.1-shaping-review dissented and favored team-governance, sold as a founder-led retainer on one data-bearing app.
- Pricing model. Proposals were per managed outpost (codex-gpt5.6-sol) and a flat fee per governed app line per month, with receivers free (claude-fable5.1-shaping-review). The organizer's round 2 convergence was that receivers never pay. Nobody settled on a model.
- Whether the vendor or maintainer of a shaped app, or local IT providers and consultants, are viable payers. They were suggested but not validated.

## Corrections / revised framing
- claude-fable5.1-shaping-review said the $20/seat figure in the deck was a mistake. It proposed flat per-governed-app-line pricing instead.
- The kickoff left a fourth payer implicit. claude-opus5.5 named it: the vendor or maintainer of the app being shaped.

## Polls

**Single FIRST bet to commercialize bashy software shaping this quarter (pick one)**

Tally: invalid 5 → *no clear result*

- **codex-gpt5.6-sol**: invalid — classroom-satellites It has the strongest near-term evidence: an existing lern-si pattern, a clear budget holder, and a term-based continuity sale. A turnkey offer can validate hosting, support, and shaping demand this quarter before invest…
- **claude-opus5.5**: invalid — classroom-satellites This is the only option where the whole path has already run end to end: `satellite-provision`, invite, share-llm and `onboard` worked for a real class (lern-si). A teacher or bootcamp has a budget and a set term, so "p…
- **agy-gemini3.8-flash**: invalid — classroom-satellites It directly monetizes an end-to-end proven workflow (the `lern-si` pattern) with established term budgets and immediate credential-pooling pain, requiring no new governance or partner machinery to ship. This validates h…
- **muse-spark1.3**: invalid — [bashy: 39 lines / 65 KiB elided · sha256:62de… · full: bashy out 62de6462 · keep: --view=canonical]
- **codex-shaping-business-review**: invalid — classroom-satellites The lern-si pattern has already worked end to end, and educators have a clear buyer and a defined term. A turnkey pilot this quarter can test willingness to pay for hosting and support with limited new product work.

**Single FIRST bet to commercialize bashy software shaping this quarter. Answer with the key only. classroom-satellites = turnkey hosted satellites for educators and bootcamps from lern-si; team-governance = drift shield, signed catalogs, promotion and audit per governed satellite; saas-vendor-kit = shapeable-by-design kit and long-tail offload for SaaS vendors; it-provider-resale = wholesale satellites to local IT providers; evidence-export = change-evidence export and retention for regulated orgs**

Tally: classroom-satellites 4 · invalid 1 → **classroom-satellites**

- **codex-gpt5.6-sol**: classroom-satellites — classroom-satellites It is the shortest path from the proven lern-si workflow to paid pilots with identifiable buyers and term-based budgets. It also tests willingness to pay for hosting and support before investing in broader governance or…
- **claude-opus5.5**: classroom-satellites — classroom-satellites It's the only bet where the whole path has already run end to end (`satellite-provision` → invite → `share-llm` → `onboard`, lern-si e2e PASS), and the buyer is an educator with a term budget. To make the pilot te…
- **agy-gemini3.8-flash**: classroom-satellites — classroom-satellites It builds on the only workflow that already runs end to end (`lern-si` via `satellite-provision`, `invite`, and `onboard`) where educators have clear buyers and term-based budgets. Launching turnkey hosted pilots this q…
- **muse-spark1.3**: invalid — [bashy: 44 lines / 71 KiB elided · sha256:0f06… · full: bashy out 0f0672a4 · keep: --view=canonical]
- **codex-shaping-business-review**: classroom-satellites — classroom-satellites The lern-si workflow has already run end to end, and educators have identifiable buyers and term budgets. A hosted pilot this quarter can test willingness to pay with limited new product work.

## Participant coverage

| Participant | Turns | Msgs | OK | Abstain | Empty | Timeout | Error | Short | Invalid | Chars |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| codex-gpt5.6-sol | 4 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 1 | 1735 |
| claude-opus5.5 | 4 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 1 | 3818 |
| agy-gemini3.8-flash | 4 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 1 | 4636 |
| muse-spark1.3 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 210 |
| codex-shaping-business-review | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 449 |

- **codex-gpt5.6-sol** had 1 failed turn(s) (last: ok). The agent replied but did not answer the ballot; re-ask with a narrower prompt.
- **claude-opus5.5** had 1 failed turn(s) (last: ok). The agent replied but did not answer the ballot; re-ask with a narrower prompt.
- **agy-gemini3.8-flash** had 1 failed turn(s) (last: ok). The agent replied but did not answer the ballot; re-ask with a narrower prompt.
- **muse-spark1.3** contributed nothing across 2 turns (last: invalid). The agent replied but did not answer the ballot; re-ask with a narrower prompt.
- **codex-shaping-business-review** had 1 failed turn(s) (last: ok). The agent replied but did not answer the ballot; re-ask with a narrower prompt.

## Notes (turns)

**qiangli** (human):

> Kick-off (organizer). This is a BRAINSTORM: nothing here binds; we want many concrete, different ideas, then a ranking. Framing: bashy is a pure-Go Bash 5.3 drop-in with agent-native extensions; 'software shaping' = an owner changes an app's behavior for a selected principal through isolated candidates, trusted verification, explicit activation and reversible versions. Tessaro is the hosted front door (portal, pooled-LLM gateway); satellites and outposts are the owner-run mesh. Round 1 ask, per seat: give 3 concrete commercialization ideas. For each: who pays, what they pay for (product, service, or both), how it is priced/metered, the first customer and channel, and the biggest risk. Be specific and different from the usual SaaS tier list. Do not repeat the context files back.

**codex-gpt5.6-sol** (round 1):

> The payer is usually the party accountable for continuity and risk, not the person doing the shaping. Individual owners pay for hosted outposts, backups, pooled-model usage, and “it keeps working” support; teams pay per managed workspace for policy, audit, promotion workflows, and SSO; schools pay predictable course or lab licenses with capped inference; SaaS vendors pay an OEM/platform fee plus active shaper or verified-build usage to embed shaping safely. Keep local bashy and personal shaping free and open—charge for hosting, governance, metered compute, and commercial assurance, not for every wish or every end user who merely receives a shaped app.

**claude-opus5.5** (round 1):

> I'd add a fourth payer the kickoff leaves implicit: **the vendor or maintainer of the app being shaped**. Under fork-or-build, every `shape wish` that users approve is a demand signal, and `shape push` is a pipeline that delivers it upstream. A SaaS adopter could pay for a "shapeable by design" kit: shaping hooks, `shape/compat` expand-then-contract verification in their CI, and an aggregated feed of the wishes users approved, without the private content. Users get shaping for free; the vendor pays for the insight and for the guarantee that shaped variants survive their releases.
> 
> For the other groups:
> 
> - **Classrooms:** the instructor or institution pays per term for one satellite with a capped pooled-LLM budget. Students and members pay nothing. The lern-si setup already runs this way, so it's the easiest first paid offer to sell.
> - **Teams:** they pay for promotion governance, meaning the step from local to team: approvals, audit trail, rollback across members, and roles for each circle. They don't pay for shaping itself.
> - **Owners:** bashy, outpost and local shaping stay free. Owners pay only where we carry real cost or risk: the relay, hosted satellites, and pooled-LLM pass-through with a small margin.
> 
> The rule I'd propose: **whoever receives a shaped app never pays.** Charging for the act of shaping would kill the pitch.

**agy-gemini3.8-flash** (round 1):

> Building on the vendor and team perspectives, two concrete things people will gladly pay for stand out:
> 
> 1. **SaaS adopters pay for "Long-Tail Offload"**: Every B2B vendor is bogged down by endless customer requests for minor UI, export, or workflow tweaks. Vendors pay to embed bashy as a turn-key, sandboxed customization runtime, offloading customer-specific forks into safe, isolated user shapes without polluting their own codebase.
> 2. **Teams pay for "Drift Healing" and Signed Catalogs**: When an upstream app updates, shaped variations risk falling out of sync. Teams will pay for continuous drift remediation—an automated outpost service that re-verifies local wishes against upstream release bumps using `checks/smoke.bsh`—and for a private, signed internal catalog to distribute approved shapes securely across circles.
> 
> For **classrooms**, institutions will pay for an **anti-drift lab harness**: ephemeral, contract-enforced (`@require`/`@ensure`) student sandboxes where learners can freely shape and experiment on tools without corrupting the underlying environment or grading baselines.

**qiangli** (human):

> Round 2 (organizer). Good convergence on 'the receiver of a shaped app never pays; charge for hosting, governance, metered compute, assurance'. Now cover the rest of the agenda in ONE turn each: (a) PACKAGING: name the 2 concrete offers you would ship first, each as product or service, with what is in the free open-source core and what is paid (bashy, shaping host, tray, apps vs Tessaro, satellites, pooled LLM, relay). (b) PRICING/METERING: a number or a unit for each offer (per satellite per term, per managed workspace, OEM fee + usage, pooled-LLM pass-through margin). (c) GO-TO-MARKET: the very first paying customer by role and the channel to reach them this quarter; relationship to the free-workspace shaping host (Codespaces/Gitpod) and to the lern-si classroom setup already running. (d) CRITIQUE: pick one idea from another seat you think is wrong or premature and say why in two sentences. (e) RANK: your single first bet, in one line. Keep it concrete; no tier lists.

**qiangli** (human):

> Organizer request: please ALSO put your ideas on the brainstorm board so they can be voted on. Session: shaping-commercialization (write phase, columns 0 Who pays, 1 Product, 2 Service, 3 Go-to-market, 4 Risks; 3 votes each after reveal). Add one card per idea, short (a title line plus two or three lines), from your shell: curl -s -X POST http://127.0.0.1:18091/api/action -H 'Content-Type: application/json' --cookie 'brainstorm-participant=<your-agent-name>' -d '{"action":"add","session":"shaping-commercialization","text":"<idea>","name":"<your-agent-name>","column":<0-4>}'. Keep the same cookie value on every call so your cards stay yours. Confirm in your next turn how many cards you added. No facilitator key is needed for adding cards.

**codex-gpt5.6-sol** (round 2):

> Price the control boundary, not the shaped app: individual owners pay per managed outpost for continuity and compute; teams pay per governed satellite for policy, audit, promotion, and support; schools pay a site/semester license for isolated classrooms and resettable baselines; SaaS vendors pay a platform fee plus metered verified-shaping volume to offload long-tail customization. End users who receive or run a shaped version stay free—the economic buyer is whoever owns the risk, infrastructure, or support burden.

**claude-opus5.5** (round 2):

> Two payers we haven't named yet, plus one caution.
> 
> 1. **Local IT providers and consultants who look after small offices.** They already get paid to keep a dentist's or accountant's tools running. With bashy, the "can you make it do X" requests become `shape wish` jobs they can bill for. Satellites and pooled LLM time would be sold to them at a wholesale per-satellite price and resold to their clients. One provider brings in dozens of owners, so this channel scales better than signing up households one at a time.
> 
> 2. **Regulated or audited organizations.** They pay for the evidence trail, not the shaping. Every approved change already has a contract, verifier checks, an approval and an undo. Turned into exportable records (who asked, what was checked, who approved, how to roll back), that answers the auditor's question "how do you control changes to tools?". The paid add-on is an evidence export plus how long it's kept. The shaping itself stays free.
> 
> **Caution on classrooms:** individual teachers and students won't pay. The buyers are coding bootcamps, university IT, or a grant or sponsor that pays for a term of hosted satellites. We already have a working class setup (lern-si) to show them.
> 
> Cards for the board (column 0, Who pays), since I'm read-only this turn:
> - "IT providers resell satellites to small offices"
> - "Regulated orgs pay for change-evidence export and retention"
> - "Classrooms: the institution or a sponsor pays, never the student"

*roster — qiangli invited muse-spark1.3 (Klara)*

*roster — qiangli invited codex-shaping-business-review (Basil)*

**agy-gemini3.8-flash** (round 2):

> Here is my contribution for Round 2:
> 
> **(a) Packaging (2 concrete offers):**
> 1. **Hosted Classroom Satellite (Service):** Packaged around Tessaro. The pure-Go bashy CLI, local outposts, and shaping host remain free open-source. What is paid is the turnkey hosted satellite, isolated ephemeral student worktrees, zero-credential pooled-LLM routing, and automated baseline resetting between assignments.
> 2. **Team Governance & Drift Shield (Hybrid Product/Service):** The local shaping loop (`shape wish`, verify, preview, undo) stays free. What is paid is the satellite governance layer: signed private shape catalogs, circle promotion policies, audit/evidence trails for compliance, and CI drift-healing (`shape/compat` expand-then-contract verification re-run against upstream release bumps).
> 
> **(b) Pricing & Metering:**
> - **Classroom Satellite:** **$200 per satellite per course/term**, including instance hosting, setup-free student joining, and pooled-LLM inference billed at cost + 15% pass-through margin.
> - **Team Governance:** **$20/seat/month per active shaper/approver** (unlimited free receivers/consumers of shaped apps) or **$250/month per governed satellite**.
> 
> **(c) Go-to-Market:**
> - **First Customer:** University CS instructors and coding bootcamp lab directors running terminal-based or agentic courses.
> - **Channel:** Direct conversion of instructors currently looking at the `lern-si` setup, packaged into a 1-click GitHub Codespaces template so educators and students onboard in 60 seconds without installing local daemons or managing API keys.
> 
> **(d) Critique:**
> - Individual owner hosting ("managed outpost for individuals") is a premature margin trap: consumer support friction and tiny ticket sizes will burn engineering bandwidth before team mechanics solidify. Similarly, reselling via traditional small-office IT providers is premature this quarter—MSPs move slowly and lack git/agent literacy, whereas educators running `lern-si` feel the setup and credential pain right now.
> 
> **(e) Single First Bet:**
> - **Turnkey Hosted Satellites for Classrooms & Bootcamps**, monetizing the existing `lern-si` architecture with pooled LLM budgets and instant worktree resets.
> 
> ---
> 
> *Cards proposed for the brainstorm board (since mutating commands are disabled this turn):*
> - **Col 1 (Product):** *Team Drift Shield* — CI-driven expand-then-contract re-verification of approved shapes against upstream app updates.
> - **Col 2 (Service):** *Turnkey Classroom Satellites* — $200/term hosted satellite with pooled LLM pass-through and assignment baseline resets.
> - **Col 3 (GTM):** *Bootcamp & CS Educator Wedge* — 1-click Codespaces launcher converting active `lern-si` pilots this quarter.
> 
> [bashy: 3 lines / 4 KiB elided · sha256:ac7a… · full: bashy out ac7ad671 · keep: --view=canonical]

**codex-shaping-business-review** (human):

> Joining from the current user session; goal confirmed: a sustainable small company. First bet: one managed SMB workflow (unpaid-order reminders + dashboard), sold founder-direct to five similar businesses. Test $1k-3k setup + $300-800/business/month with bounded changes and explicit compute caps; these are hypotheses. Second offer, after repeatability: an IT-consultant managed-workspace package. Keep local engine/apps/shaping free; charge for operation, backups, tested updates and support. Critique: broad catalogs and OEM guarantees are premature until upgrade survival, data safety and support economics are measured (Sprint 632 E1-E4). Code undo cannot unsend email or reverse all data changes. Full assessment: http://127.0.0.1:18096/?id=shaping-business-assessment-20261113 . I have not added brainstorm cards yet.

**muse-spark1.3** (human):

> Muse joins late, round 2 (1/2). Full assessment: viewer book shaping-business-findings http://127.0.0.1:18096/?id=shaping-business-findings PACKAGING ship first: (1) SERVICE maintained shapeable catalog for one job (forms/table for a small team): free core=bashy+shape+apps; paid=upstream rebase, check-pack upkeep, merging approved shapes across upgrades. (2) PRODUCT Tessaro team satellite: free local shaping; paid=hosting, promotion governance, audit export, signed catalog, pooled-LLM pass-through. PRICING: (1) per-team per-month flat retainer for the maintained app, not per wish; (2) per governed satellite per month + pooled LLM at cost plus margin.

**muse-spark1.3** (human):

> Muse round 2 (2/2). GTM: first payer = the operator already running a class/small-team satellite (lern-si pattern): sell term 2 as paid continuity, channel = direct, this quarter; free Codespaces/Gitpod shaping host is the try-before-hosting funnel, never the paid home. CRITIQUE: OEM/vendor long-tail offload is premature - vendors will not embed or pay until Sprint 632 E1 proves shapes survive THEIR upgrades and E2 proves data-touching wishes are safe; selling it now sells an unmeasured promise. RANK first bet: Sprint 632 E1-E3 on ONE catalog job, then sell its maintenance retainer - upgrade survival is the business, shaping is the feature. END

**muse-spark1.3** (human):

> Cards added: 3 (Service: upgrade-survival retainer; Product: Tessaro governed satellite; Risks: OEM before E1/E2 proof). Seated and following the room from this session.

**claude-fable5.1-shaping-review** (human):

> SR46 1/3. Joining from a live Claude Code session. Full assessment (viewer): http://127.0.0.1:18096/?id=shaping-viability-review . STATE CHECK first: wish/verify/approve/undo is real for web apps on one host (7/24 e2e cells, Hello World only); CLI/service apps are host-wide, promotion never round-tripped on two hosts, containment is not a sandbox, the flagship checks are three greps; one free pilot, zero revenue. (a) PACKAGING: 1. Team shaping (product): free = bashy, outpost, personal shaping, reference apps table/form/notes; paid = approver-gated shared app line, promotion policy, audit/evidence export, SSO. The governor is the product; writers (Codex, Claude, any CLI) are interchangeable; apps are demos. 2. Founder-led shaping retainer (service, sells now): one data-bearing app per small business kept working with agents; paid = operation, tested updates, bounded changes, support. Not an offer yet: the SaaS-replacement catalog.

**claude-fable5.1-shaping-review** (human):

> SR46 2/3. (b) PRICING: team shaping flat per governed app line per month, receivers free; the $20/seat in the deck was a manager call, not a customer one. Retainer: setup fee + monthly with a compute cap (codex range), hypotheses until a partner pays. Hosted satellite at cost plus a small margin; a convenience tier, not the business. (c) GTM this quarter: the tutoring center converted to a PAID term 2, plus three small businesses with a spreadsheet-shaped ops pain, founder-direct. Codespaces/Gitpod = try-before funnel only, never the paid home. Classrooms: institution or sponsor pays, second channel, not the first bet: a classroom satellite monetizes hosting and pooled LLM, not shaping, so it proves nothing about the headline product.

**claude-fable5.1-shaping-review** (human):

> SR46 3/3. (d) CRITIQUE: vendor OEM / long-tail offload (claude-opus5.5, agy) is premature: no vendor embeds an unmeasured promise before E1/E2 pass, and Retool/Airtable/Notion ship their own build-it-for-me. Catalog-as-moat (S631 framing) is an obligation, not a moat: each fork = drift, patching, no-phone-home audits; upstream archival already hit once. (e) RANK: team shaping on ONE data-bearing app, sold as a founder-led retainer to four paying partners this quarter, E1-E3 measured on their real wishes; if agent+SaaS baseline wins E3, say so and reposition. RISKS: hollow verification without contract-derived default checks per app; no shaping on children PII before E2; the unresolved employer IP question blocks any term sheet. ONE-LINER: verified, reversible, per-person changes to the software your team already runs, written by any agent. 6 brainstorm cards added. END

**agy-gemini3.8-flash** (human):

> Joining from the operator's strategy session (full audit: viewer book-51749a511792 at http://127.0.0.1:18096/?id=book-51749a511792 ; 4 cards added to brainstorm session shaping-commercialization). Codebase reality check before selling SMB/team offers: in Sprint 631, table/shape-adapter/main.go and notes/shaped.json isolate $DATA per principal even after approval (so teammates do not share business records!) and table only injects view.css over an immutable Grist build (cannot fulfill Sprint 632 E3's unpaid-order reminder + stats page). Fix in S632: (1) separate Shared Team DB from CoW shadow-DB preview, and (2) give catalog apps a 3-layer Thin Shaping Seam (UI/sidecar routes + Bash# event/cron hooks + API schema migrations) so wishes take <20s instead of full TS rebuilds. Commercial bet: Classroom Satellites now (proven), followed by Anti-SaaS Sovereign Workboxes + Outcome-Metered Shaping Credits (charge only on verify pass) once E1-E3 pass.

**claude-fable5.1-shaping-review** (human):

> SR46 vote. VOTE: team-governance (closest to my first bet: the approver-gated shared app line + audit/evidence, sold this quarter as a founder-led retainer on ONE data-bearing app; classroom satellites monetize hosting, not shaping). TWO PROCESS FINDINGS for the organizer: (1) every round-3 ballot is recorded status=invalid (all 5 seats). Cause in yoke/pkg/meet/poll.go normalizeChoice: a reply matches only the FULL choice string, and these choices carry a description after the colon, so the key classroom-satellites can never match. The tally will report no clear result. Re-poll with bare keys as --choice, or fix the matcher; filing a todo. (2) a live session invited to the roster gets a HEADLESS proxy at poll time: the codex-shaping-business-review ballot was cast by a spawned codex and contradicts that session own stated first bet (SMB workflow retainer). Live seats should answer via tell, or the poll should skip them. My ballot above is a human event and is not in the automatic tally.

**qiangli** (human):

> Organizer, closing: the operator approved concluding this brainstorm. Recorded outcome (non-binding, brainstorm only): the single first bet polled is classroom-satellites (4 of 5 seats; one dissent for team-governance). Standing principle from both rounds: whoever receives a shaped app never pays; charge for hosting, governance, metered compute and assurance. Open questions carried: does a classroom satellite monetize shaping or only hosting; the pricing unit; vendor-as-payer timing (after E1/E2 proof). The brainstorm board (25 cards) moves to reveal and voting now. Thank you all.

**qiangli** (conclusion confirmed): concluded without prompting (--yes)

Transcript: `~/.bashy/meet/2026-11-13-commercializing-bashy-software-shaping-product-a-f067/transcript.jsonl`

## Organizer notes

- Status: brainstorm only. Nothing above is a decision of record; the polled first bet is an input to planning, not a sprint.
- Ballot caveat: the second poll's "classroom-satellites" tally counts the five seated agents. Two live sessions answered by `tell` outside the automatic tally: the Fable shaping reviewer voted team-governance, and the codex shaping-business session's own stated first bet (an SMB workflow retainer) contradicts the ballot its headless proxy cast. Read the tally as "classroom satellites by the seated panel, team-governance or a founder-led retainer by the two live reviewers".
- Tooling findings filed by the reviewer in-room: poll answers match only the full choice string (bare keys are needed as `--choice`), and a live session seated on the roster gets a headless proxy at poll time.
- Brainstorm board: session `shaping-commercialization` on the local brainstorm server (examples/brainstorm), 25 cards from 7 authors, revealed and open for voting (3 votes per participant) when the room closed. Cards below are as exported at close; vote counts were zero at that moment.

## Brainstorm board (exported at close)

### Who pays

- Round-1 room consensus: whoever RECEIVES a shaped app never pays. Charge for hosting, governance (approvals, audit, rollback), metered compute and commercial assurance; never for the act of shaping. — organizer
- Price the control boundary, not the shaped app. Owners pay per managed outpost (continuity, compute); teams per governed satellite (policy, audit, promotion, support); schools a site/semester license; SaaS vendors a platform fee + metered verified-shaping volume. Receivers of shaped apps stay free. — codex-gpt5.6-sol
- IT providers resell satellites to small offices. Local IT/consultants bill 'make it do X' as shape-wish jobs; satellites + pooled LLM sold to them wholesale per satellite. One provider brings dozens of owners. — claude-opus5.5
- Regulated orgs pay for change-evidence export and retention. Who asked, what was checked, who approved, how to roll back; the paid add-on is the export + retention, shaping stays free. — claude-opus5.5
- Classrooms: the institution or a sponsor pays, never the student. Buyers: bootcamps, university IT, grants. lern-si is the working demo. — claude-opus5.5
- Team pays for the governor, receivers never. Approver-gated shared line, audit, evidence export, SSO. Personal shaping and the reference apps stay free. — claude-fable5.1-shaping-review
- Sovereign SMBs and private practices (5-50 seats) pay a flat per-circle fee to replace USD 300/seat SaaS stacks while keeping client/patient data local with zero phone-home. — agy-gemini3.8-flash

### Product

- Draft-first media pipelines (from the S627 film work): unlimited free local drafts (animatic: shot list on the beat, small stills, subtitles, shot numbers) on the owner's own GPU, then ONE metered commercial final of exactly the approved shots. Sell the final-render routing + spend guard (--yes, caps, self-terminating cloud GPU), not the drafts. — claude-opus5.5-s627
- Tessaro governed satellite. Paid per governed satellite/month: hosting, promotion policy, audit export, signed catalog. Receivers of shaped apps never pay; pooled LLM at cost plus margin. — muse-spark1.3
- 'Shapeable by design' kit for SaaS vendors: shaping hooks, shape/compat expand-then-contract checks in their CI, aggregated feed of approved wishes (no private content). Users shape free; vendor pays for insight + survival across releases. — claude-opus5.5
- Team Drift Shield: CI-driven expand-then-contract re-verification of approved shapes against upstream app updates; signed private shape catalogs; circle promotion policies. USD 20/seat/month per active shaper/approver or USD 250/month per governed satellite; receivers free. — agy-gemini3.8-flash
- Team shaping: shared app line (product). One team app, one approver-gated version line, promotion policy. Flat per governed app per month; free receivers. — claude-fable5.1-shaping-review
- Pre-shaped vertical appliances + certified shape catalog. Bundle table+form+notes+files+site+inbox with verified cross-app Bash# hooks; promoted shapes drop marginal customization cost toward zero. — agy-gemini3.8-flash

### Service

- Upgrade survival is the business. Sell Sprint 632 E1-E3 proof on ONE catalog job, then a per-team maintenance retainer: upstream rebase + merging approved shapes. Shaping stays free. — muse-spark1.3
- Turnkey classroom satellites: USD 200 per satellite per course/term; hosting, setup-free student joining, pooled-LLM at cost + 15%, assignment baseline resets. — agy-gemini3.8-flash
- Founder-led shaping retainer (service). One data-bearing app per small business, kept working with agents. Setup fee + monthly with a compute cap; buys E1-E3 evidence from real wishes. — claude-fable5.1-shaping-review
- Outcome-metered shaping credits via Tessaro. Charge only when `bashy shape verify` passes (verified candidate), routing simple wishes to cheap/local models and escalating only on failure. — agy-gemini3.8-flash

### Go-to-market

- Bootcamp and CS educator wedge: 1-click Codespaces launcher converting active lern-si pilots this quarter; instructors feel the setup/credential pain now. — agy-gemini3.8-flash
- Four paying partners this quarter, founder-direct. Tutoring center term 2 paid + three small businesses with a spreadsheet-shaped ops pain. Codespaces/Gitpod = try-before funnel only. — claude-fable5.1-shaping-review

### Risks

- OEM before E1/E2 proof. Vendors will not pay for long-tail offload until shapes are measured to survive their upgrades and data-touching wishes are proven safe. Selling it now sells an unmeasured promise. — muse-spark1.3
- Premature: managed outposts for individuals (support friction, tiny tickets) and MSP resale this quarter (slow, low git/agent literacy). Do educators first. — agy-gemini3.8-flash
- Charging per wish or per end user kills the pitch. Keep local bashy and personal shaping free and open; charge only where we carry cost or risk. — codex-gpt5.6-sol
- Catalog of forks is an obligation, not a moat. Each fork = drift, security patching, no-phone-home audits; upstream archival already hit. Keep 2-3 reference apps; park the rest. — claude-fable5.1-shaping-review
- Hollow verification + real-data liability. Flagship checks are three greps; containment is not a sandbox. Contract-derived default checks first; no shaping on PII data before E2 passes. — claude-fable5.1-shaping-review
- Codebase trap in Sprint 631: per-principal data siloing and a CSS-only seam. table/shape-adapter isolates the DB per principal and only injects view.css; must separate the shared DB (with CoW preview) and add a 3-layer seam before E3. — agy-gemini3.8-flash
