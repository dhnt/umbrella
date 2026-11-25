# Sprint 712 recommendation: the agentic build/release paradigm (shapeware)

Status: **operator-approved 2026-11-25**, then amended the same day with the cross-vendor review (D20) and the lifecycle (D21); the spec is now v0.1 (Sprint 712, story b35b89620f88). Plan only: no product code, release train or live-user behaviour changed under this story.

This is the story's deliverable. It answers the question with definitions, a lifecycle map, three schemas, three tabletop cases, a comparison with the current process, risks and dissent, what stays frozen, a recommendation and a follow-on split. It reuses the existing records rather than repeating them:
- `docs/sprint-712-shapeware-exploration-2026-11-25.md`: the discussion, experiments and decisions D1–D19
- `docs/shapeware-spec-v0.md`: the operator-reviewed on-disk spec, with validation
- `docs/sprint-712-master-plan.md`: the plan this document completes

## 1. The question and the answer

**Question.** Should software increasingly ship as shapeable source, executable Bash# specs and skills, tests and runtime-agent instructions, with acceptance continuing during real use, instead of only finished code frozen before release? If so, which parts, under what safety, evidence and versioning rules, and what stays conventionally built and frozen?

**Answer: yes, for a bounded class of software, starting with a narrow pilot.**
- An app that ships as **shapeware** (a skill folder with its source, feature specs, checks and known issues) can be run, checked, fixed around and finished by agents in the field.
- That works only under hard rules:
  - checks are the only evidence
  - field changes go through the shaping lifecycle and never edit the installed copy
  - effect caps cannot be raised by a field change
  - critical features are never field-built
  - known issues are explicit, bounded and expiring
- The trusted core, the `sh` engine, the release train and the conformance gates stay conventionally built and frozen (§8).
- **Go for the pilot (§9). No-go for scale until trust (signing and provenance, Section D) exists.**

## 2. Definitions

| Term | Meaning |
|---|---|
| **Shapeware** | A category word (like firmware), not a brand. It means software that ships as Bash# source with its specs, skill and known issues, and that agents finish or fix in use. On disk it is a superset of an Agent Skill folder (D15). Any repo is potential shapeware; one root `SKILL.md` makes it actual (D18). |
| **Field shaping loop** | Was "HUAT". Acceptance continues in real use, and the tester and first responder is the user's agent, not a human test gate. The release gate stays the automated acceptance run, with fakes where needed. |
| **Feature status** | `tbd` (specified, not built) or `verified` (its checks pass). |
| **Known issue** | A symptom → action entry in `SKILL.md`: `open`, `workaround`, `fixed` or `expired`. It records the cause (proven or suspected), the bounds, forbidden workarounds, an expiry and a todo. |
| **Release class** | Computed, never declared: requirements release, verified with tbd, verified with known issues, verified, or blocked (spec §12). |
| **Critical feature** | Auth, payments, sandboxing, destructive or irreversible actions, regulated data. Never `tbd`, never field-built, and it blocks the release while a known issue is open. |
| **Band floor** | `min-band` on the unified L1–L5 ladder. Using an app is L1; building a tbd feature is L2; with no declared floor there is none. |
| **Trusted core** | Prebuilt, digest-pinned binaries for critical features, referenced from `shaped.json`. |

## 3. Lifecycle map

Authoring → verification → freeze → deploy → real use → shaping or workaround → upstreaming → retirement. It was walked end to end with hello (record §4.2, spec §15):

| Stage | Classic SDLC | Shapeware | Evidence that it works |
|---|---|---|---|
| Author | code + tests | `features.yaml` entry first (`tbd`, intent, acceptance), then code | hello `greet-lang` spec |
| Verify | test suite | `checks/acceptance.bsh` prints PASS/FAIL/TBD; only a PASS makes a feature `verified` | 2 PASS / 1 TBD |
| Freeze/release | tag a fully built binary | tag at any point on the spectrum; the class is computed | v0.1.0 "verified with tbd"; v0.2.0 "verified" |
| Deploy | install | `bashy skill add` or `export --repo`: the skill channel, with no new format | record round trip byte-identical |
| Real use | bug report, then wait | the agent reads `SKILL.md`: known issues first, then act | unaware agent run 1 matched KI-1 at once |
| Shape/workaround | patch release | build the tbd on a copy or a `bashy shape` candidate; keep it only on PASS; record a known issue on failure | unaware run 2 built `greet-lang` on a copy (3 PASS) without touching the installed copy |
| Upstream | PR | the variant is offered; the owner adopts; acceptance travels with it | v0.2.0 made `greet-lang` verified |
| Upgrade | reinstall | drop variants whose feature is now verified upstream; adopt the rest (fast-forward or 3-way merge; on conflict a review ref, live version unchanged) | upgrade leg: variant dropped, 3 PASS; undo restored v0.1.0 |
| Retire | delete | a known issue `fixed` or `expired`; the variant is retired with it | KI-1 removed in v0.2.0 |

## 4. The three schemas

1. **Artifact manifest = the spec** (`docs/shapeware-spec-v0.md` §2–§3, §5): the folder layout, the frontmatter and `metadata` keys, `features.yaml`, the checks contract, and the defaults (§11).
2. **Known issue + runtime instruction** (spec §4.2): `- KI-<n> [status] <symptom> → <action>` plus `cause`, `bounds`, `forbidden`, `expires` and `todo`. It lives in `SKILL.md`, so every agent reads it before improvising.
3. **Field-session record.** This is new here and deliberately minimal. It is the report the standard run block already asks for (step 7), in a fixed shape, so it can be pasted into a todo or sent upstream. No new store:

```
- session: <date> <agent>@<band|unknown> on <app>@<version>
  trigger: symptom "<text>" | tbd request <feature-id>
  matched: KI-<n> | none
  budget: <time/tokens set by the owner>
  outcome: workaround-applied KI-<n> | built <feature-id> (PASS) | known-issue-recorded KI-<n> | escalated
  evidence: <the PASS/FAIL/TBD lines>
  variant: <version>+shaped.<sha> | none
```

The unaware agent's run 2 report contained every field without being given this shape (spec §15). The shape only fixes the order.

## 5. Tabletop simulations

### (i) The Sprint 708 timing defect, #3230
**Facts (public):** On Windows Chrome-for-Testing, a fresh profile's first navigation can fail before commit with `net::ERR_ABORTED`. The suspected cause, traced but not proven, is that network-service crash recovery resets the URLLoader factory. The workaround is to retry the same navigation once after startup settles, or to use an installed Chrome or an ACL-clean profile. The code deliberately does not retry every `ERR_ABORTED`. It shipped as a source comment (yoke c78fb76d), and the story was closed as wontfix.

**As shapeware:** the same knowledge becomes an entry an agent acts on.

```
- KI-1 [workaround] first navigation in a fresh Chrome-for-Testing profile on Windows
  fails before commit with net::ERR_ABORTED → retry that navigation once after
  browser startup settles; if it fails again, stop and report.
  cause: suspected (network-service crash recovery resets the URLLoader factory)
  bounds: first navigation, fresh profile, not committed; one retry only
  forbidden: retrying every ERR_ABORTED; looping until green
  expires: next release (review the sandbox-launch trigger)
  todo: f43b87c31cf6
```

**Simulated outcome:**
- The agent hits the symptom, matches KI-1 and retries once.
  - Success: the outcome is "workaround-applied KI-1".
  - A second failure is outside the bounds: it records a session and escalates.
- Release class: "verified with known issues". This is honest, where wontfix hid the issue.
- The difference from today is not the knowledge, which c78fb76d already had. It is that the knowledge is **actionable by any agent in use**: it sits in a source comment no field agent reads versus in the skill every agent reads first. It is also bounded and forbidden-move-aware, and it expires instead of staying closed.
- Gap: `bashy todo` has no known-issue status, so #3230 stays wontfix until the follow-on (Q6, §10).

### (ii) A shaping-enabled example app used by a real user
**Case: hello, used by agents that had never heard of shapeware** (spec §15):
- **Run 1** followed `SKILL.md` exactly and correctly refused to build. The spec text itself was wrong (a missing floor meant "don't build"), and the agent reported five precise gaps in the text.
- **Run 2**, with the text fixed, built the feature on a copy, kept it on PASS and reported it.

**Finding:** the field shaping loop works with a generic agent and no advertisement. The text of the standard run block is load-bearing, and it is QA'd by running fresh agents (D13). The low-end evaluation pack (§10) turns this into a repeatable gate.

### (iii) A Bash# skill or spec delivered without a new binary: the form pilot
**Case:** `form` (pilot 9643d77f). Today's baseline for "show the human a form", measured 11-25 (addendum e):
- about 20 tool calls to the first shown form
- 11 of them probes
- 4 product defects: flags rejected; the source rebuild fails; the owner key is not resolved; the wait timeout is undocumented
- 1 agent miss: the URL was printed, never opened

**As shapeware:**
- The run block names one command that creates and opens the form.
- The server is the digest-pinned trusted core, never rebuilt on use.
- Each defect is a KI with its action, so recovery takes one step.
- Waiting is one documented step.
- **Target:** 1 call to show the form and 1 to read it, measured on the same task.

The pilot delivers a feature through specs and checks with no new binary: one of `shaped.json`'s wishes becomes a `tbd` entry in `features.yaml` (a wish alone is never a feature), and an agent builds it in a work copy graded by the installed checks.

## 6. Comparison with the current build/release process

| Concern | Current (release train, no-HUAT, fake e2e) | Shapeware (for the bounded class) |
|---|---|---|
| Feature delivery | built and gated before the train | any point on the spectrum; tbd features built on demand under checks |
| Hard, environment-specific bugs | fix before shipping, or wontfix plus a source comment | known issue with a bounded action, used immediately ("fix then use") |
| MVP bloat | features built whether used or not | unbuilt features ship as specs; cost moves to first use |
| Acceptance | automated fakes at the gate; real failures surface later as tickets | same gate, plus the field loop: the user's agent acts within the KI rules and reports in a fixed shape |
| Release identity | one tag, one binary | one tag; local variants as `+shaped.<sha>`; the class computed |
| Undo | reinstall the previous release | `bashy shape` undo to the last known good, or the previous tag |
| Upgrade | replace | adopt (fast-forward or merge, review ref on conflict); drop variants made redundant upstream |
| Trust | signed releases, gates | the same for the core; field changes capped (effects cannot rise) and checked; **signing of shapeware itself not yet in place** |

## 7. Risks and dissent

| Risk | Mitigation now | Residual / follow-on |
|---|---|---|
| **Safety:** a field change does harm | critical features never field-built; effect cap cannot be raised by a candidate (verifier refuses); never edit the installed copy; keep only on PASS; undo | depends on check quality; weak checks let weak changes through |
| **Security:** a malicious or poisoned shapeware folder (it is a skill, so prompt and code injection apply) | only trusted sources, as with any skill; the effect cap; bashy's packing refuses host identity | **signing and provenance are not in the MVP**: blocks scale (Section D) |
| **Determinism and support:** every user runs a different variant | `+shaped.<sha>` identifies each; stable feature and KI ids; upgrade drops redundant variants | many variants to debug in the field; the KI feed is later work |
| **Quality and consistency** across agents | band floor (D12); restricted HTML/kit tokens; checks | the L1–L5 ladder is agreed but the doc is not updated; the low-end pack is not built |
| **Cost:** tokens at first use | tbd features are built only when the user asks; budgets on root-causing | the cost model is open (Q8) |
| **"Fix then use" normalizes shipping bugs** | critical features block the release; KIs expire; "verified with known issues" is visible in the class | needs the KI todo status to keep expiry honest |
| **Name** | category word only, no registration | Q9 sanity check on the 1992–95 filings before public use |

**Dissent (the status quo case), recorded honestly:**
- Shipping finished, gated code is deterministic, supportable and cheap per user.
- #3230's knowledge already shipped as a comment.
- Fake e2e plus the release train already closed most issues.
- Shapeware adds a second, softer acceptance channel that can erode discipline.

The counter-evidence is in this sprint:
- the 11-24/25 defects passed the fakes and failed for real
- the comment-only KI is invisible to field agents
- today's form needed about 20 calls and 4 defect detours where a shapeware form targets 2

The dissent is answered by scoping, not by dismissal. The pilot is narrow, critical paths stay conventional, and scale waits for trust.

## 8. What remains conventionally built and frozen

- **The `sh` engine and the Bash# grammar:** frozen to bug fixes. Shapeware needs no engine change (Q3: runners).
- **The release train** (todo 76eac0ea) and its gates: the 86/86 sealed Bash gate, POSIX, and release e2e. Shapeware does not alter them.
- **Critical features and the trusted core:** prebuilt, verified, digest-pinned, and never field-built at any band.
- **bashy itself** (the runtime) ships through the train. Only apps built on it are shapeware.
- **Live hosted services:** unchanged. Deploys stay on the train.

## 9. Recommendation

1. **Adopt `docs/shapeware-spec-v0.md`** (operator-reviewed, D19) as the v0 draft standard.
2. **Go: the narrow pilot on `form`** (P1 below). Success means one call to show a form and one to read the answer, measured against the 11-25 baseline. The unaware-agent test should pass on the first try, and checks should pass on the gate host.
3. **No-go for scale** (third-party shapeware, the KI feed, the field network) until all of these hold: signing and provenance; verifier immutability (protected checks, lifecycle, effect cap, critical flags and core pins, enforced by the tools and not only by `candidate.bsh`); a sandbox for the agent's own tools when it acts on known issues or form inputs; and the low-end pack gating the standard run block. Signing proves where a bundle came from, not that field-shaped code is safe (vendor review n3).
4. **Metrics to track:**
   - calls and probes to the first success
   - unaware-agent pass rate (by model and band)
   - share of field outcomes per class (workaround, built, KI recorded, escalated)
   - KIs past expiry
   - regressions in low-end success

## 10. Proposed follow-on split

Each sprint is reviewed with the operator before it starts. Owners are proposals.

| Pri | Follow-on | Contents | Owner (proposed) | Venue | Decision owner |
|---|---|---|---|---|---|
| P1 | **Sprint 721: shapeware pilot on `form`** | **Gates first:** yoke cb1a95c4 (`metadata.type`) and bashy 117bbf2c (`bashy dag` on a fresh HOME). Then fix 64ef2626 and its addendum defects, including the shared-address store bleed (root cause first). Lay out `form` per spec v0.1: type line and run block, KIs, `dag.md` lifecycle, `features.yaml` with one wish turned into a `tbd` feature, `checks/acceptance.bsh` and `candidate.bsh`, core digest in `shaped.json`, `min-band: L2`. Add create-and-open in one command. Not in the pilot: the `bashy-ui-v1` envelope and the allowlist (vendor review m5). **Acceptance** (m12, n2): three arms on the same tasks (today's form, a bug-fixed plain form, the shapeware form, with a seeded known issue and a field-built tbd); 3 cold runs per arm (two vendors and one small local model, the last on the gate host); forbidden-action tests (edit in place, critical build, retry until green, tampered checks); owner approval and rollback; report latency, calls and failures. Shapeware must beat the bug-fixed plain form on the known-issue and tbd tasks | an agy worker; the conductor reviews and gates | dev box for unit work; gate host for browser acceptance and the small model | operator |
| P1 | Story: known-issue status in `bashy todo` (Q6) | a status for known/workaround/expires; move #3230 into it as KI-1 (§5 i) | bashy worker | unit tests | operator |
| P1 | Todo yoke cb1a95c4 (filed) | the skill parser reads `metadata.type` | yoke worker | unit tests | — (approved) |
| P2 | **Sprint: low-end evaluation pack** (Q11, Q13) | agent-bench task pack: hello unaware-agent task (run, KI, build tbd, report), the form task, scoring (success, calls, forbidden moves, correct escalation); runs with small local models (`bashy ollama`); sets band floors | worker | gate host only | operator |
| P2 | **Per-category pilots after `form`** (operator) | one shapeware pilot per bashy command category once the form pilot reports: a toolchain verb (e.g. `uv` or `go`), an optional/external bin-managed tool, and a whole repo (D18). Each is planned as its own story with the form pilot's acceptance | to be planned | gate host | operator |
| P2 | **Dogfood: convert all bashy examples to shapeware** (operator, D22) | Starts once the spec is a v1.0 draft and the `form` proof of concept is done. Every example under `bashy/examples/` is converted to a shapeware folder in two steps with two different vendors: (a) one model converts it per the spec (the lint must pass); (b) a model from another vendor runs it cold, with no hints (build, test, use, a known issue, a tbd built in a work copy graded by `candidate.bsh`), listing every guess. Pairs rotate across codex, agy/Gemini, muse, GLM and Claude, and nobody runs its own conversion. Every point where a converting model had to guess becomes a spec issue: the spec improves from v1.0 draft to v1.0. It includes the per-category pilots above | conductor plans; vendor agents convert | gate host | operator |
| P2 | Story: publish the shapeware skill (Q1, Q9) | the trademark sanity check, then the spec, the agent card, and the lint and release-class skill-scripts as a shapeware folder in the `shapeware` org (dogfood D18) | conductor | — | operator |
| P3 | Backlog | signed KI feed and field network (Q6b, Q7); cost model (Q8); MCP elicitation (Q5); repo-enable generator; sub-shapeware composition; `band-ladder.md` to L1–L5; quote bashy's `SKILL.md` description (strict YAML); skill-format name warnings in `bashy skill add` | — | — | operator |

Unrelated bugs found in the session stay independent todos: 9ab67520, c28b0669 and f571c624.

## 11. Non-goals

No product code, engine change, new verbs or formats, release-train change, or live-user behaviour change in 712. No third-party shapeware, KI feed or field network before trust exists.

## 12. Story acceptance cross-check

| Acceptance item | Where |
|---|---|
| Written plan: definitions, options, recommendation, risks/dissent, non-goals | §1, §2, §6, §7, §9, §11 |
| Lifecycle map | §3 |
| Three schemas | §4 |
| Three case simulations | §5 (i)–(iii) |
| Comparison with the current build/release process | §6 |
| Follow-on sprints/stories with priorities and decision owners | §10 |
| What remains conventionally frozen | §8 |
| No product code under this story | held. Commits under 712 are docs and todos only |
