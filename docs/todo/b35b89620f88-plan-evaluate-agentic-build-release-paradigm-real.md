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

## Question

Should software increasingly ship as shapeable source, executable Bash# specs/skills, tests/fixtures, and runtime-agent instructions — with acceptance continuing during real use — instead of shipping only finished code frozen before release? If yes, what parts, under what safety/evidence/versioning rules, and what remains conventionally built and frozen?

Current reference points to reconcile:
- The standing operator no-HUAT rule: no release-blocking human acceptance test; automated sandbox/fake-account e2e is acceptance, while operator GO remains a decision.
- Shaping-enabled apps/sites and Bashy skills already let agents inspect, run, and adapt artifacts at the point of use.
- Sprint 708 Story #3230 is the seed example for a hard timing issue: root-cause layers were traced, a source-level "Known issue" comment with possible cause/workaround shipped in Yoke c78fb76d, and the story closed for now without claiming a venue fix.

## A. HUAT in real time during actual use, with shaping

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
