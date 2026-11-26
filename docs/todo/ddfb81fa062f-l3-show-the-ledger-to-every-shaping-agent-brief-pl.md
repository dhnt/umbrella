---
id: ddfb81fa062f
kind: feature
title: 'L3 Show the ledger to every shaping agent: brief plus a file in the work clone'
seq: 805
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T19:45:25.408128Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: the brief gives the next agent only the active revision (plus one 'previous attempt failed' line for repairs), so an agent from another vendor inherits code without its reasons.
Behavior: add the ledger view for the candidate's base revision to the wish brief and the incident-repair brief, and write it as a file into the candidate's work clone, excluded from the commit. Present entries as prior experience, not instructions. Bound the size for small-context local models: open problems in full, closed ones as one line, newest first.
Code inspected (2026-11-26): yoke/pkg/shape/delegate.go:77-113 (the single entry point for every agent call); helpers.go:94-116; bashy web console shaped_repair.go:141-155,250 (repair brief); shaped_candidate.go:463,530 and shaped_draft.go:384 (other callers of the same delegate).
Verification: unit tests that both briefs contain the bounded ledger and that the file never enters the candidate commit.

Triage (2026-11-26): p1, depends on L1. Smaller than first filed: BriefWithExtra(app, wish, extra) at yoke/pkg/shape/helpers.go:94 already takes extra text (one console caller at yoke/pkg/webconsole/shaped_candidate.go:358), so the CLI wish path and the repair brief pass the ledger view through it. Planning only until Sprints 726 and 730 are done.

Review (2026-11-26, code re-read at yoke 0bc70d51): medium, not small. delegate.go:77-113 is one implementation of the Delegator interface, not a single entry point, and BriefWithExtra covers two of six brief paths.
- Paths that build a brief: service wish for native apps and the CLI (service.go:670, GenerationBrief to Brief, no extra); console wish (shaped_candidate.go:530, BriefWithExtra); draft step (shaped_draft.go:384-385, BriefWithExtra); protected-page intent (shaped_candidate.go:463, intentTaskFor); incident repair (shaped_repair.go:250, repairBrief :141-155); core repair (yoke/pkg/src/repair.go:107-125,167, runs bashy delegate directly).
- In scope: service wish, console wish, draft step, incident repair. Out of scope, stated on purpose: protected-page intent and core repair of bashy itself.
- The file in the work clone: CommitCandidate stages everything (helpers.go:154,181) and nothing uses an exclude today. Write the file's path to .git/info/exclude in the work clone; go-git's status honours it, a .gitignore would itself be committed. Pull, diff and push work from commit trees, so an uncommitted file cannot leak through them.
- Agent self-commits bypass the exclude. Add a guard: verification refuses a candidate whose tree contains the ledger file.
- The view passed in is the viewer-filtered one for the candidate's principal, never the owner view.
- Depends on L1, and on L0 6a8709362f55.
No coding until Sprint 730 completes (operator, 2026-11-26).
