---
id: 01a217a1-8b7b-708c-a724-998769844dfd
seq: 27
form: page
type: lesson
title: 'Retro: the first shapeware spec-to-source drills (Sprints 722 to 725)'
description: 'WHEN you plan, run or review a shapeware drill, a spec revision or an agent qualification and want the reasons behind the drill rules: what was shown and its scope, what worked, each thing that went wrong with the rule it produced, and what is still open'
tags:
    - shapeware
    - conform
    - spec2src
    - retro
    - drill
status: candidate
evidence: Sprint 722 protocol and results; Sprint 723 protocol v2 with amendments 1-4; Sprint 725 bashy 64d3381a
source:
    tool: claude
created: "2026-11-26T11:33:12Z"
---

Retro of the first shapeware drills: Sprint 722 (spec v1, cheapest models), Sprint 723 (spec v2, judge in the loop, model ladder), Sprint 725 (verb split). Procedure: [[spec-to-source-drill]].

## What was shown
- With spec v1 and each vendor's cheapest model, 1 of 15 runs passed. With spec v2 and the judge in the loop, start tiers of three vendors passed 3 of 3, and so did the tiers one step down that were measured. The spec changes and the in-loop judge moved the result, not the model tier alone.
- Every failure in Sprint 722 could be traced to one of seven spec gaps or a named agent defect. Classifying failures by cause is what produced spec v2.
- Scope of the claim: one app (`form`), a conductor-written spec, hidden cases and classification, chosen models. Not yet shown: a second app, agent-written specs and cases, building a single feature from a todo.

## What worked (keep)
- Protocol before runs, with numbered amendments. Every awkward result had a rule to apply.
- A reference control and an empty-workspace control before any subject. They exposed two venue faults in the grader within minutes.
- A smoke with a non-subject binding, then a probe of every subject in a real arm. The probe caught a fault that would have failed every run of one vendor.
- Independent hidden cases. One format gap now costs one case, not the layer.
- Per-phase isolation in the grader (own network and process namespace, fresh HOME). No leaked server can affect a later case.
- Regrading a failed snapshot with one variable changed. It separated "the source is wrong" from "the delivery is wrong" at no agent cost.
- A static checker written from measured gaps, with the before and after spec as fixtures.
- Delegating bounded code stories with exact rules, fixtures and acceptance: both worker stories were delivered in about 10 minutes and passed the lane gate unchanged.

## What went wrong, and the rule it produced
- **Cascading hidden cases** (722): one YAML gap removed seven checks. Rule: each case independent.
- **Subjects could read the whole host** (722 batch 1). Rule: sandbox guard from the first run; verify it.
- **Signed-out arms** (722). Rule: keychain opt-ins; probe before the batch.
- **Self-update mid-session** (722). Rule: updates off.
- **Agent shell shadowed the judge** (723). Rule: plain system shell in every arm.
- **Cached host binary shipped** (723). Rule: the grader drops native executables; the builder's guide says to deliver source.
- **Unstated runner cutoff** (723) ended long planning turns. Rule: state every runner limit in the protocol; cutoff equals the cap.
- **Quota ran out for two vendors** in one night (723), partly from probes and a worker session on a subject binding. Rule: budget quota per binding; keep subjects out of worker stories; a refusal is a venue fault.
- **A refusal logged as a candidate fail** (723). Rule: read the screen log of any short empty run.
- **Conditions changed while batches ran** (723). Rule: change between batches only.
- **A wrong root cause recorded** (723): the judge was said to be unreachable in a bashy shell, when the installed build was simply older than source. Rule: check the installed version against source before blaming the design; correct the record where it was written.

## Open, for the next drills
- The judge runs on the session host in the loop and on the venue at grading. Parity is not built.
- The page interaction is scripted outside the judge.
- Tokens are recorded for two tools only; cost for none.
- Results are not yet written as qualification records or fed into bands.
- The judge role and the spec-author role have not been filled by an agent (planned: Sprint 726).
