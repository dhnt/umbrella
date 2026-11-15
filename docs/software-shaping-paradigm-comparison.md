# Software shaping compared with other software paradigms

Reference summary of a 2026-11-15 review: how bashy software shaping relates
to traditional CI/CD, vibe coding, and the wider family of past and current
software paradigms; what the 2025–2026 evidence says; what has to be true for
shaping to become a mainstream way of building software; and two design
principles carried over from older paradigms into the agentic era.

The definition of record is `bashy/docs/software-shaping.md`; the contract is
`bashy/docs/shape-contract.md`. This page claims only what those documents mark
as shipped. Everything under "Proposals" is unbuilt.

## 1. What shaping is

> Software shaping lets anyone tell an agent, in plain words, how a running
> tool should work, and get their own verified, reversible version, while
> everyone else keeps theirs.

```text
wish → candidate → verify → preview → approve (for me) → undo / restore
                                                  └──→ promote: local → team → upstream
```

What separates it from other paradigms: **trust lives in checks, not in the
model.** The judging core cannot be shaped; a shape adds surface freely but
removes it only through a contract step; every activation is a revision.

Status (from the definition page): the CLI lifecycle and promotion
(remote/outgoing/push/incoming/pull) have shipped since v1.0.0-rc.27. Web
console shaping is an opt-in trial. Test-first shaping (Sprint 621), shaping
bashy itself (Sprints 617–618) and shaping from a free cloud workspace
(Sprint 615) are planned. Catalog evaluations E1 (upgrade survival), E2 (data
safety), E3 (shaping vs a coding agent plus SaaS configuration) and E4
(scorecards) are open (`docs/shapeable-app-catalog.md`).

## 2. The paradigms compared

| Family | Paradigm | Core idea |
|---|---|---|
| Engineering-led | Waterfall / model-driven engineering | Specify fully, then build; models generate code |
| | Agile + CI/CD | Small increments, automated build/test/deploy |
| | GitOps | Git holds desired state; a reconciler converges |
| | Progressive delivery / feature flags | Canary, blue-green, flags; metric-gated rollout |
| | TDD / BDD / design-by-contract | Tests or contracts define correctness first |
| User-led | End-user programming | Spreadsheets, HyperCard, Emacs/Smalltalk live images |
| | Low-code / no-code, SaaS configuration | Visual builders and vendor-exposed settings |
| | Plugins / extensions / userscripts | Third parties extend declared extension points |
| | Open-source forking | Take the source and diverge |
| | Malleable software (Ink & Switch, 2025) | Users reshape tools at the point of use |
| AI-era | Vibe coding | Prompt, accept, ship; informal verification |
| | Agentic PR bots | Agent opens a PR; normal CI and review apply |
| | Spec-driven development (Spec Kit, Kiro, Tessl) | Human-maintained spec is the source of truth |
| | Ephemeral generative UI | Interface generated per query and discarded |
| | **Software shaping** | Plain-words wish → checked, per-person, reversible, promotable version |

### Matrix

| Paradigm | Who changes | Unit of change | What decides "good" | Who is affected | Way back | Diverges? |
|---|---|---|---|---|---|---|
| Waterfall / MDE | Engineers | Release | Spec sign-off + QA | Everyone | Next release | No |
| Agile + CI/CD | Engineers | Merged diff | Tests + review | Everyone | Revert + redeploy | No |
| GitOps | Engineers/ops | Declared state | Reconciler + policy | Everyone (per environment) | git revert | No |
| Progressive delivery | Engineers | Flag / rollout step | Metrics + kill switch | A cohort | Flip the flag | No |
| TDD / contracts | Engineers | Test-first change | Tests / contracts | Everyone | Revert | No |
| End-user programming | Users | Formula / script | The user's eye | Self | Ad hoc | Yes |
| Low-code / SaaS config | Power users | Configuration | Vendor guardrails | Tenant/org | Vendor-dependent | Vendor lock-in |
| Plugins / userscripts | Users + third parties | Add-on | Store review (weak) | Installers | Uninstall | Breaks on API change |
| OSS forking | Developers | Fork | Fork owner | Fork users | git | Yes, drifts |
| Malleable software | Users | In-place edit | User | Self/community | Local history | Research stage |
| Vibe coding | Anyone | Generated code | The model / "looks right" | Whoever deploys it | Usually none | Yes |
| Agentic PR bots | Agent for engineers | PR | CI + human review | Everyone | Revert | No |
| Spec-driven dev | Human spec + agent | Spec → code | Spec conformance + tests | Everyone | Revert / regenerate | No |
| Generative UI | Model per query | Throwaway UI | Nothing persisted | One query | Not applicable | Not applicable |
| **Shaping** | **Anyone, incl. non-owners** | **Running candidate** | **Declared checks, re-run at approval** | **One principal or host** | **undo / restore any revision** | **No: shared history, promotable** |

### Lineage: what shaping inherits

- **TDD / contracts:** judged by commands, not by the model (test-first shaping makes it explicit).
- **Progressive delivery:** a contained blast radius, taken to a single principal, with user-authored changes instead of predefined branches.
- **GitOps:** every activation is a recorded revision; restore converges back to a declared state.
- **End-user programming / malleable software:** user agency and a gentle slope from user to creator, plus the verification and governance the Ink & Switch essay says AI alone does not provide.
- **Spec-driven development:** intent first; but SDD targets one codebase for everyone, shaping targets *your* version and promotes proven changes upstream.
- **Rejected from forking and vibe coding:** divergence with no gate.

Closest relatives: spec-driven development and malleable software. Shaping sits
between them, with SDD's discipline (intent plus checks) and malleable
software's scope (per person, at the point of use).

## 3. Pros and cons

### Pros

1. **Cheap and verified at once.** Vibe coding is cheap but unverified; CI/CD is verified but expensive. Shaping moves the cost into checks written once.
2. **Blast radius of one.** A bad change hurts only the person who approved it and can be undone, which is what makes non-engineer changes acceptable.
3. **Personalization without forking.** Shapes stay on shared history and can be promoted, pulled or reset.
4. **Upstreaming as a filter.** A promotion arrives as a new wish through the same gates: proven user demand, not unreviewed diffs.
5. **Agent-native and vendor-neutral.** Small `--json` verbs with meaningful exit codes; Bash# skill-scripts compose them.
6. **A fixed, portable base.** The pure-Go Bash 5.3 and POSIX userland give checks the same meaning on Linux, macOS and Windows.

### Cons, sorted by kind

Built into the paradigm:

- Shaping is only as good as its checks; a weak check approves confident garbage, and no human reviewer compensates.
- Many personal versions multiply support load: bug reports must name the revision and principal.
- Upgrade drift: personal shapes must be re-applied or regenerated when upstream moves (E1).
- Shared data limits personal scope: schema and protocol changes cannot really be "just for me".
- A public wish needs trustworthy refusals; Sprint 641 names the operatorSession privilege finding as a hard dependency.

Immaturity (testable, not a verdict):

- Only the CLI lifecycle and promotion ship; web shaping is a trial, other rows are planned.
- E2–E4 are open; until E3 runs, "shaping beats vibe coding plus SaaS" is a hypothesis.
- Linux and the web UI only for now; some catalog forks keep inert telemetry code.

### Against specific comparators

- **vs spec-driven development:** shaping adds per-person scope, running previews and undo; SDD leads on spec structure and adoption. A wish could adopt a spec format.
- **vs low-code / SaaS configuration:** no vendor limit and no lock-in; low-code is more predictable and far more mature (E3 tests this).
- **vs plugins:** shapes can change anything the contract allows, not only extension points; plugins are protected by a stable API, shapes must survive upstream change (E1).
- **vs malleable software:** shaping ships for CLI tools and opt-in web apps; the local-first collaboration model there is more developed than satellite sharing.
- **vs progressive delivery:** flags are proven at scale; many personal versions are operationally harder than a small known set of branches.

## 4. Evidence from 2025–2026

| Trend | Evidence | Bearing on shaping |
|---|---|---|
| Demand for custom software is real | February 2026 SaaS selloff (about $285B in 48 hours); Retool survey: 35% of 817 customers replaced a SaaS tool with a custom build, 78% plan more; "home-cooked" personal software | The premise holds: people want their own version |
| Unchecked generation fails | Veracode 2026: AI code security pass rate stalled at 56%; AppSec Santa: about 25% of samples with a confirmed vulnerability; Gartner: 60% of vibe-coded apps retired by 2028, 30% of teams strained maintaining citizen-built apps | Vibe coding has a ceiling; "judged, never trusted" answers it |
| Self-assessment is unreliable | METR 2025: experienced developers 19% slower with AI while believing they were 20% faster; the 2026 follow-up could not form a control group | A verifier must decide, not the model or the user's impression |
| Generate-then-verify is the consensus loop | Karpathy, Software 3.0: partial autonomy, fast generation–verification loop with diffs, previews and tests | Matches candidate → verify → preview |
| The upstream contribution channel is breaking | curl ended its bug bounty (January 2026) as AI slop pushed valid reports below 5%; tldraw auto-closes outside PRs; Jazzband shut down; GitHub added a setting to disable PRs | Maintainers need evidence-carrying contributions; promotion carries verification |
| Generation is not free | Gartner (June 2026): AI coding token costs exceed an average developer salary by 2028 | Reusing verified results (approved shapes, forge-once skill-scripts, local models) is a cost advantage |
| Intent-first is mainstream | Spec Kit above 111k stars; Kiro launched May 2026; Tessl | Intent plus checks is accepted; shaping adds per-person scope |
| Ephemeral UI at scale | Google AI Mode above 1B monthly users, generating HTML/JS per query | Strongest competing bet (see below) |
| Liability follows modification | EU Cyber Resilience Act guidance: a substantial modification placed on the market brings manufacturer obligations for the modified part | Personal unpublished shapes are likely outside; promotion to team or public may not be; provenance and evidence become compliance assets (a reading, not legal advice) |

## 5. Competing bets and risks

Competing bets:

1. **Ephemeral generative UI.** If most personal needs are one-off, durable shapes matter less. Answer: ephemeral serves questions, shaping serves tools people return to; bridge them with a "keep this" action that turns an ephemeral result into a gated wish.
2. **Spec-driven platforms.** They own developer mindshare for intent-first. Answer: treat a wish as a spec fragment and interoperate.
3. **Vibe-coding app builders.** They hold the SaaS-replacement money now. Answer: be where vibe-coded apps go to become maintainable.

Risks that could stop it: weak checks turning "verified" into theater; upgrade
drift; promotion becoming another slop channel for maintainers; most people
never writing checks (so checks must ship with the app or be generated and
themselves verified).

## 6. What has to be true for shaping to win

Research cannot guarantee a paradigm's future. These are the levers, in order
of how much they decide:

1. **Publish evidence.** Run E1 and E3 on real apps; publish E4 scorecards, failures included.
2. **Make the verifier the product.** Test-first by default (red on base, green on candidate); baseline security and egress checks on every shapeable app, so a shape cannot add a network effect without a contract step.
3. **Make "shapeable" an open standard.** Publish the contract, badge checklist and JSON verbs as a protocol any app can implement; adapters for spec tools and for generative UI's "keep this".
4. **Offer the upstream path to maintainers.** Promotions carry red/green evidence, provenance and a narrow diff; a receive side rejects promotions without evidence.
5. **Meet users where they are.** Vendor chat clients (Sprint 646) and free cloud workspaces (Sprint 615); the try-now flow (Sprint 641) after the privilege fix.
6. **Win on cost.** Approved shapes and forged skill-scripts run with no model.
7. **Ship compliance.** Per-shape SBOM, provenance and evidence bundles.

Signals that would falsify the thesis: most shapes break on upgrade and cannot
be regenerated from wish plus checks (E1); a coding agent plus SaaS
configuration matches shaping at lower effort (E3); users approve without
previewing or weaken checks to pass; ephemeral UI covers most requests.

Positioning the evidence supports today: **the verified, per-person,
promotable layer between vibe coding and CI/CD.**

## 7. Principles carried forward from past paradigms

### Principle 1: producers and consumers are many-to-many

No producer can anticipate every consumer, and no consumer is satisfied by one
producer. The past solved this the same way each time: producers publish to a
shared interface and the consumer composes.

| Past feature | Lesson | Agentic-era adaptation |
|---|---|---|
| Unix pipes, small tools | A shared interface beats anticipating consumers | `--json` verbs and declared features (shipped) |
| Package repositories + apt pinning | The consumer sets precedence; a resolver keeps it consistent | Per-person ordered shape stack; conflicts decided by checks |
| Distro patch stacks (quilt, Debian `patches/`) | Personal changes survive by being re-applied, not merged | `shape rebase` on each upstream release: re-apply, re-verify, regenerate from the wish if needed (answers E1) |
| git remotes, kernel lieutenants | Many named sources, chosen per change | Named remotes and gated `pull` (shipped); extend to peer remotes |
| RSS / subscription feeds | The consumer chooses producers; pull, not push | `shape subscribe`; incoming shapes arrive as gated wishes |
| Extension stores, userstyles | Declared extension points make customization safe | Owner-declared feature lists (Sprint 641 `shaped.json`); catalog ranked by verification evidence, not stars |
| Web of trust, signing | Provenance says who, not whether it is good | `Shaped-By:` provenance (shipped) plus the consumer's own checks |

Agents are now both producers and consumers, so producer count grows by orders
of magnitude and historical curation (maintainers, stores, reputation) does not
scale. Consumer-side checks must curate, which is shaping's founding rule.

### Principle 2: decide after seeing, not before

Agentic tools mostly ask before acting: approve a plan, or pick option A, B or
C without seeing any of them. That forces recall and specification, which
people do badly. Past paradigms moved toward recognition and choice.

| Past feature | Lesson | Agentic-era adaptation |
|---|---|---|
| Recognition over recall (Nielsen) | People choose well from what they see | Build the options and show them instead of asking |
| WYSIWYG, REPLs, spreadsheets, immediate feedback | Seeing replaces imagining | Live preview per candidate (shipped) |
| Design comps; image generators' variation grids | Show variations, pick, iterate from the pick | `wish --variants N` |
| Set-based design (Toyota) | Keep options open late, narrow on evidence | Verify every variant; drop failures before anyone looks |
| Undo, non-destructive history | Cheap reversal makes early commitment safe | Unpicked variants kept as revisions; undo/restore (shipped) |
| Suggestion mode in shared docs | Accept or reject in context | Side-by-side compare of diff, preview and checks |
| A/B testing | Use decides, not opinion | Optionally live with two approved variants, keep one |
| Try before you buy | A lower cost of being wrong speeds decisions | Variants are free drafts until approved |

```text
wish → N variants → verify all (failures dropped) → preview side by side
     → pick (or "A's layout + B's colors" → new wish) → approve → undo anytime
```

### Where the principles meet

Many producers times several candidates each, with the consumer selecting and
composing. With consent, approvals flow back to producers as a signal: if most
members kept variant B, the owner learns the right default without having to
anticipate it.

## 8. Proposals (unbuilt)

Today: one candidate per wish (a retry creates a new candidate); named remotes
`org` and `upstream` with `incoming` and gated `pull`; preview, undo, restore;
provenance trailers.

1. `wish --variants N` and `shape compare APP ID…` (side-by-side diff, preview and check results). The smallest slice for principle 2: a Bash# skill-script composing `wish`, `verify` and `preview`, plus one `compare` verb.
2. Peer remotes and `shape subscribe` (principle 1 beyond org and upstream).
3. A per-person ordered shape stack with `shape rebase` on upstream release.
4. Opt-in approval signals back to the owner.

N variants cost N generations; contain it by capping N, dropping failures
before review, and drafting cheaply first.

## Sources

- [Ink & Switch: Malleable software](https://www.inkandswitch.com/essay/malleable-software/)
- [Latent Space: Karpathy, Software 3.0](https://www.latent.space/p/s3)
- [Spec Kit vs Kiro vs Claude Code SDD workflows](https://glukhov.org/ai-devtools/ai-coding-assistants/spec-kit-vs-kiro-vs-claude-code/)
- [Spec-driven development in 2026: future or Waterfall 2.0?](https://alexcloudstar.com/blog/spec-driven-development-2026/)
- [Unleash: canary release vs progressive delivery](https://www.getunleash.io/blog/canary-release-vs-progressive-delivery)
- [Harness: progressive delivery](https://www.harness.io/harness-devops-academy/progressive-delivery)
- [AI and home-cooked software](https://mrkaran.dev/posts/ai-home-cooked-software/)
- [Veracode: Spring 2026 GenAI code security update](https://veracode.com/blog/spring-2026-genai-code-security)
- [AppSec Santa: AI code security study 2026](https://appsecsanta.com/research/ai-code-security-study-2026)
- [METR developer productivity research: 2026 update](https://blog.robbowley.net/2026/04/04/metrs-developer-productivity-research-2026-update/)
- [Gartner: AI coding costs will surpass developer salary by 2028](https://gartner.com/en/newsroom/press-releases/2026-06-24-gartner-predicts-ai-coding-costs-will-surpass-average-developer-salary-by-2028-as-token-consumption-surges)
- [Gartner on governing vibe coding](https://tray.ai/guides/gartner-govern-vibe-coding/)
- [Google Research: Generative UI](https://research.google/blog/generative-ui-a-rich-custom-visual-interactive-user-experience-for-any-prompt/)
- [Google mini-apps and generative UI (May 2026)](https://andrew.ooo/answers/what-is-google-mini-apps-generative-ui-may-2026/)
- [The New Stack: curl's Daniel Stenberg on AI](https://thenewstack.io/curls-daniel-stenberg-ai-is-ddosing-open-source-and-fixing-its-bugs/)
- [LeadDev: open source has a big AI slop problem](https://leaddev.com/software-quality/open-source-has-a-big-ai-slop-problem)
- [CFO Brew: is AI killing SaaS](https://www.cfobrew.com/stories/2026/03/02/is-ai-killing-saas)
- [Why AI won't kill SaaS](https://bdtechtalks.com/2026/03/16/why-ai-wont-kill-saas/)
- [Orrick: CRA guidance clarifies scope](https://www.orrick.com/en/Insights/2026/09/EU-Cyber-Resilience-Act-New-Guidance-Clarifies-Scope-Reporting)
