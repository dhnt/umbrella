---
id: b35b89620f88
kind: spike
title: 'Plan: evaluate agentic build/release paradigm — real-use HUAT, runtime workarounds, spec-first delivery (plan only)'
seq: 744
status: todo
priority: p2
labels:
    - software-shaping
    - release
    - agents
    - docs
created: 2026-11-25T07:07:39.446469Z
sprint: 712
sprint_id: fccece26-9d9b-585e-b7cf-bcc320028d1e
sprint_title: 'Explore the agentic build/release paradigm: real-use shaping, live workarounds, spec-first delivery'
---

PLAN ONLY — no product code, release behavior, or live HUAT is in scope for this story. Its deliverable is a reviewed recommendation and a proposed follow-on sprint/story split.

## Operator review 2026-11-25 (form review, all points agreed)

### Thesis: reverse the SDLC
Software shaping lets many traditional SDLC steps run in reverse order, after release, by runtime agents in the field:
1. **Features**: traditionally compiled into a binary after long test cycles and still a poor fit for varied users. New: ship Bash# source plus the user's requirements as specs in Bash# skill-scripts. Explore this especially for UI applications: why ship JS/HTML/CSS/TypeScript when an entry-level LLM agent can take a spec and render the UI?
2. **Bugs** that are hard to catch and occur only under certain conditions: instead of fixing them before shipping, document them in Bash# skills so agents handle them, the same way agents find and handle them during development. "Fix then use" instead of "fix then ship".
3. **MVP**: features not yet designed or built, and features most users do not need, ship as specs, or as TBD with instructions/specs so a runtime agent can implement them on the fly, instead of bloating the release.
4. **Acceptance**: ship after automated tests with fake users; real-user acceptance happens in the field. A failure is handled or fixed by the runtime agent, as long as the error is expected and the instructions/specs are sufficient.
5. Many other SDLC processes can be reversed the same way. Software shaping provides the machinery that helps runtime agents in the field after release.

Rod, not fish: the deliverable is the generic machinery. Cases in the field cannot be enumerated.

### Agreed points
- **Premise.** Issues from 11-24/25 passed the sandbox e2e with fakes and failed somewhere real: #3230 first-navigation timing abort, D1 go.bsh not building on a fresh HOME, H6 `MAILGUN_API_BASE` env binding. Under the no-HUAT rule, every user's daily session is where this class is found. Users "test" while they work and shape/fix on error. Bash# comments, instructions and skill-scripts let the runtime agent run the same implement/fix lifecycle that traditional UAT ran.
- **Step 0: failure-class examples.** Use timing/race, env binding, missing artifact on a fresh install and venue drift as tabletop cases, not as a list to complete.
- **Name.** Section A is the **field shaping loop**. "HUAT" here meant the traditional method; for shaping-enabled apps the tester is an agent, not a human.
- **Layered channels.** Train-frozen code; a signed known-issue data feed (symptom signatures, workarounds, runtime hints) on a faster channel; local shaped variants. Name the new layer: hardware (machine code) → firmware (assembly) → software (C/C++ … bash) → **X-ware (Bash#)**. Candidates: liveware, shapeware, liquidware, others. Reviewer recommendation: **shapeware**, because it ties to software shaping. Liveware already means people in computing slang, and liquidware is an existing vendor name. Trademark check before public use.
- **Field root-cause discipline, bounded and classified.** As during development, an agent's effort is bounded by budget, time or other criteria, and each outcome is classified in one common Bash# skill/script language. Example classes: verified (default), verified with known issues (the shipped feature names its identified bugs so the runtime agent knows where it stands and takes it from there), spec-only/TBD, workaround active, fixed. An agent must not retry until green; errors outside the specs escalate upstream.
- **Safeguard (reviewer).** A spec ships with executable acceptance tests. Code generated or shaped in the field is accepted only when those tests pass locally.
- **Field network.** Opt-in bashy installations form a network/matrix: signatures and workarounds reach other users with the same symptom, and field fixes return upstream as reproduction tests that retire the workaround. No traditional application model matches this.
- **Known-issue state.** Add an explicit state, separate from closed: known, worked around, tracked until it expires. #3230 is the first case. `bashy todo` has no such status today, so #3230 stays wontfix-for-now until the plan defines it.
- **Keep** section D (trust, provenance and undo for field changes, required before scale) and plan-only acceptance.

- **Decisions 2026-11-25 (operator: go with the reviewer's recommendations).**
  - Case (iii), a feature delivered without a new binary, is the `form` desk tool. It runs as follow-on bashy todo 9643d77f, because this story is plan only.
  - Known issues are written INSIDE the `.bsh` body, not in a separate file.
  - The name: the GitHub org github.com/shapeware was taken 2026-11-25. The trademark question is still open.
  - Field defects found during the review: bashy 64ef2626 (form flag schema) and yoke f571c624 (copysheet re-copy).

## Question

Should software increasingly ship as shapeable source, executable Bash# specs/skills, tests/fixtures, and runtime-agent instructions — with acceptance continuing during real use — instead of shipping only finished code frozen before release? If yes, what parts, under what safety/evidence/versioning rules, and what remains conventionally built and frozen?

Current reference points to reconcile:
- The standing operator no-HUAT rule: no release-blocking human acceptance test; automated sandbox/fake-account e2e is acceptance, while operator GO remains a decision.
- Shaping-enabled apps/sites and Bashy skills already let agents inspect, run, and adapt artifacts at the point of use.
- Sprint 708 Story #3230 is the seed example for a hard timing issue: root-cause layers were traced, a source-level "Known issue" comment with possible cause/workaround shipped in Yoke c78fb76d, and the story closed for now without claiming a venue fix.

## A. Field shaping loop (was "HUAT in real time"): real use with shaping; the tester is an agent

Explore redefining HUAT from a pre-release human pass/fail gate into a post-release, consenting real-use learning loop:
- Real users perform real tasks with shaping enabled; agents observe failures, propose local adaptations/workarounds, and capture evidence.
- Separate human usability/product judgement from correctness acceptance. Automated e2e remains the release gate unless the plan recommends a policy change.
- Define consent, privacy, data minimization, account/data classes, recording, retention, and escalation/abort rules.
- Define how every material field discovery becomes a reproducible automated test, a known-issue record, or a product decision; forbid "worked when a human tried it" as durable evidence.
- Define cohorts/canaries, severity response, rollback/undo, and when live shaping is forbidden (payments, auth, destructive data, regulated or irreversible actions).
- Metrics: task success, defect escapes found live, time-to-repro, time-to-automated-regression, shaping intervention rate, rollback rate, user trust signals.

## B. Hard/timing bugs: known issues, workarounds, runtime-agent instructions

Design a first-class known-issue lifecycle instead of ad hoc retries or indefinite wontfix:
- Schema: stable issue/story ID; symptom signature; affected versions/platforms; confidence (suspected vs proven cause); impact and blast radius; detector; safe workaround and bounds; forbidden workarounds; verification signal; owner; review/expiry date; links to evidence/tests.
- Delivery channels: source comments at the fault site, structured runtime error hints, CLI/help or skill guidance, KB runbooks, release notes, and issue trackers. Decide which channel is authoritative and how drift is prevented.
- Runtime-agent policy: what an agent may do automatically (for example, retry one provably pre-dispatch navigation), when it must stop, how it reports uncertainty, and how workarounds are prevented from masking new defects.
- Closure rules: a workaround is not a fix. Define debt limits, expiry/reopen triggers, telemetry thresholds, and when a known issue blocks release despite a workaround.
- Use Story #3230 as a worked example and counter-check against a non-timing defect where retry would be unsafe.

## C. Ship Bash# skill/spec instead of only finished code

Define the artifact taxonomy and lifecycle for spec-first delivery:
- What ships: finished binaries, source mounts, Bash# skills, executable specs, generated-code templates, fixtures/tests, policies, schemas, and examples. What must stay prebuilt/trusted (sandbox, auth, network, package verifier, code generation core).
- When generation/adaptation happens: build time, install time, first use, per-user shaping, or hosted runtime; caching and offline/sealed behavior.
- Determinism and reproducibility: spec/skill/compiler/fixture versions, generated-code provenance, source maps, reproducible outputs, compatibility windows, pin graph, SBOM/signing, and rollback.
- Acceptance: spec conformance suites, generated-code tests, property/golden tests, host matrix, and evidence reuse rules.
- Updates: can a spec-only change ship faster than a binary? Define freeze semantics, channels/canaries, compatibility promises, support burden, and how local shaped variants are upstreamed or retired.
- Compare with conventional releases on lead time, defect risk, auditability, user fit, offline use, and maintenance cost.

## D. Recommended missing pillar (add to the plan)

**Trust, provenance, and reversibility for field-shaped changes.** Shaping and runtime instructions are code-changing attack and failure surfaces. The paradigm needs, before scale:
- Capability/effects declarations, sandboxing, explicit consent for spend/destructive actions, and instruction signing/trust levels.
- Transactional apply/undo/redo, diffs attributable to user/agent/spec version, and recovery to a known-good artifact.
- Field evidence bundles that preserve repro inputs, versions, environment, diffs, test verdicts, and decisions without leaking secrets.
- Upstreaming rules: when a local adaptation becomes product code/spec, who reviews it, and how other users receive or decline it.

Secondary items to assess briefly: known-issue debt budgets/SLAs, accessibility and product research distinct from correctness HUAT, support/ownership economics, and legal/IP treatment of shipped source/specs and user-shaped variants.

## Plan steps

1. Inventory current practice: release trains/freezes/pins, no-HUAT rule, shaping/site/agent-ready channels, skills/source mounts, known reds/workarounds, and the 708/#3230 example.
2. Define terms and a lifecycle map from authoring → verification → freeze → deploy → real use → shaping/workaround → upstreaming → retirement.
3. Draft the three schemas/examples: real-use HUAT session, known issue + runtime instruction, and spec/skill artifact manifest.
4. Run tabletop simulations on three cases: (i) 708 timing defect, (ii) a shaping-enabled example app used by a real user, (iii) a Bash# skill/spec delivered without a new binary.
5. Risk-review safety, security, determinism, release engineering, support, and cost; record dissent and alternatives (including status quo).
6. Recommend go/no-go/pilot scope, success metrics, guardrails, owners, and a follow-on sprint/story split.

## Story acceptance

- A reviewed written plan is recorded (story note or linked doc) answering the question above, with definitions, options, an explicit recommendation, risks/dissent, and non-goals.
- It includes the lifecycle map, the three concrete schemas/examples, all three case simulations, and a comparison with the current build/release process.
- It proposes follow-on sprint(s)/stories with priorities and decision owners; it identifies what explicitly remains conventionally frozen.
- No product code, release train, or live-user behavior changes under this story.
