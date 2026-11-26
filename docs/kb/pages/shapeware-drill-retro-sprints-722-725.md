---
id: 01a217a1-8b7b-708c-a724-998769844dfd
seq: 27
form: page
type: lesson
title: 'Retro: the first shapeware sprints (722 to 731): spec to source, instructions to spec, the linter, the lifecycle'
description: WHEN you plan, run or review shapeware work (a drill, a spec conversion, a spec revision, an agent qualification, conducting such a sprint) and want what was shown with its scope, what worked, each thing that went wrong with the rule it produced, the conductor's own errors to check for, and what is still open
tags:
    - shapeware
    - conform
    - spec2src
    - retro
    - drill
    - conductor
status: candidate
evidence: Sprints 722, 723, 725, 727, 729, 731 (umbrella docs/sprint-723-report.md, docs/spec2src-protocol-v2.md amendments 1-6, docs/shapeware-workflow-findings-2026-11-26.md)
source:
    tool: claude
created: "2026-11-26T11:33:12Z"
updated: "2026-11-26T13:52:50Z"
---

Retro of the first shapeware work: Sprint 722 (spec v1, cheapest models), Sprint 723 (spec v2, judge in the loop, model ladder), and the side sprints of the same session on 2026-11-26: 725 (verb split), 727 (instructions to spec), 729 (spec linter rule), 731 (lifecycle in the spec; handed off). Procedures: [[spec-to-source-drill]], [[shapeware-spec-from-app]], [[shapeware-spec-from-plan]], [[shapeware-source-from-spec]].

## What was shown
- **Spec to source works on one app for chosen models.** With spec v1 and each vendor's cheapest model, 1 of 15 runs passed. With spec v2 and the judge in the loop, the start tiers of four vendors rebuilt `form` 3 of 3 (two of them on a rerun after harness fixes), and for three vendors the tier one step down passed too.
- **The spec decides the outcome more than the model tier.** No failure in Sprint 723 traced to a builder's code: each came from the spec, the harness or quota.
- **Instructions to spec is fast and sound in form, but not deterministic.** Three top-tier bindings each turned four sprint stories into a checker-clean spec in 3 to 7 minutes; the three specs named the same things differently.
- **Scope of the claims:** one app, a conductor-written spec, hidden cases and classification, n = 3 per binding, one session per converter.

## What worked (keep)
- Protocol before runs, with numbered amendments. Every awkward result had a rule to apply and a place to record the exception.
- A reference control and an empty-workspace control before any subject.
- A smoke with a non-subject binding, then a probe of every subject in a real arm.
- Independent hidden cases, and a grader that isolates every phase.
- Regrading a failed snapshot with one variable changed, to separate "the source is wrong" from "the delivery is wrong" at no agent cost.
- **Turning each measured gap into a lint rule** with the before and after spec as fixtures. The linter then caught the next mistake, including the conductor's own, within minutes.
- **Bounded worker stories:** exact rules, fixtures, acceptance and constraints in the story; committed and pushed before assigning; gated on the lane at the worker's commit; fast-forwarded. Four stories, 3 to 12 minutes each, all merged unchanged.
- Asking "what is the general solution?" of a one-line failure. It produced the rule "a rule that names a set defines the set", the lint, and the idea of shipping critical rules as data.

## What went wrong, and the rule it produced
- **Cascading checks** (722 hidden cases; 727 contracts): one mismatch removed everything after it. Rule: independent cases; fixed ids; open values where the instructions are silent.
- **Subjects could read the whole host** (722). Rule: sandbox guard from the first run; verify it.
- **Signed-out arms, self-updates mid-session** (722). Rule: keychain opt-ins, updates off, probe first.
- **The agent shell hid the judge** (723). Rule: plain system shell in every arm.
- **A cached host binary shipped** (723). Rule: the grader drops native executables.
- **An unstated runner cutoff** ended long planning turns (723). Rule: state every runner limit; cutoff equals the cap.
- **Quota ran out for two vendors**, partly from probes and a worker session on a subject binding (723). Rule: budget quota per binding; keep subjects out of worker stories; a refusal is a venue fault; read the screen log of any short empty run.
- **Conditions changed while batches ran** (723). Rule: change between batches only, amendment first.
- **Servers left running on the session host** (723, found at cleanup): 63 processes from 28 runs. Rule: reap per batch, by workspace path; bug filed against the runner.
- **A rule given by example** in the spec failed one run (723). Rule: define the set, add a boundary pair; lint for it.

## The conductor's own errors (so the next one checks for them)
- **A wrong root cause, recorded:** the judge was said to be unreachable in a bashy shell; the installed build was only older than source. Check the installed version against source before blaming the design, and correct the record where it was written.
- **A failure classified as an agent defect that was a spec gap.** The spec's own wording was not re-read before classifying. Read the rule the failed case tests, every time.
- **A hidden case that tested undocumented behaviour,** against the soundness rule the same conductor had written.
- **A subject binding given a drill-related worker story.** Disclosed, not undone.
- **A rule rewritten from reading the code, one case missed;** the certification run found it. Only the run is evidence.
- **Seven sprints filed in one night.** Two were merged the same day at the operator's request. File fewer, larger-grained sprints; put ideas in the planning material, not on the board.
- **Sprint commands run without the lease token** were logged as bypasses three times. Export it at the top of every command block.
- **The report book was not rendered** because no viewer instance was running and none was built on the development machine; the report exists as a document only.

## Open, for the next work
- The judge runs on the session host in the loop and on the venue at grading; parity is not built.
- The page interaction is scripted outside the judge.
- Results are not yet written as qualification records or fed into bands; the lifecycle bands in `form` are marked unmeasured.
- The spec-author and judge roles have not been filled by an agent on a full trip.
- Ideas recorded and not built: a dry run of a spec, a consent gate on the user's machine, a vault-backed secret check with no elevation, critical rules shipped as data.
