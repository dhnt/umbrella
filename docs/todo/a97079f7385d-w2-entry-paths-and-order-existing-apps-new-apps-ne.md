---
id: a97079f7385d
kind: doc
title: 'W2 entry paths and order: existing apps, new apps, new tools and models'
seq: 789
status: done
priority: p2
labels:
    - shapeware
created: 2026-11-26T12:02:29.813275Z
weave: 280
assignee: claude-opus5.5
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
closed: 2026-11-26T14:04:50.830748Z
closed_by: claude-fable5.2
---

Answer questions 6 and 7: how an existing bashy app enters (reverse step) and how a new one enters (instructions step); the dogfood order over bashy's desk apps and examples in small waves, each its own sprint; the intake drill for a new tool or model and its quota cost. Decide what happens to Sprint 726 (confirm, reshape or fold in) and to the open stories: the forward test of the three notepad specs, the judge study, the Sprint 723 carry-overs. Material: umbrella docs/shapeware-workflow-findings-2026-11-26.md (findings F1-F12, implications, the eight questions) and docs/plan-reverse-sdlc-workflow.md. Planning only; KISS: describe the smallest workflow that runs end to end, and list everything else as 'not in the first standard'.

## Brief (conductor, 2026-11-26; W1 is merged, this story is ready)

Extend `docs/shapeware-workflow-standard.md` (the W1 draft, umbrella `b4b30ab44`). One document is the standard; do not write a second one.

Read first, all in this repository: `docs/shapeware-workflow-standard.md` (keep its terms, its tone and its "proven, partly proven, not yet proven" marks); `docs/shapeware-workflow-findings-2026-11-26.md` §4 questions 6 and 7, §5; `docs/plan-reverse-sdlc-workflow.md` ("Iteration 2", "The front half", "Later, in order", "Budget, venue and risks", "Decisions for the operator"); `docs/shapeware-qualification-process.md`; `docs/sprint-723-report.md` (session times, the cells not measured); `docs/handoff-sprint-731.md` ("Backlog outside 731"); the kb pages `shapeware-spec-from-app`, `shapeware-spec-from-plan`, `spec-to-source-drill` under `docs/kb/pages`.

Code inspected by the conductor: bashy `examples/desk` at `ecc8e527` holds the apps `form`, `notepad`, `chart`, `viewer`, `page`, `gallery`, `evidence`, and the library `kit`. Only `form` has a contract; the others have a `SKILL.md` or nothing.

Add, after section 7 and before the "not in this first standard" section (renumber it):
1. **How an app enters.** Two paths, each as a short numbered list of the existing stages and runbooks, nothing new: an existing app (the reverse step: spec from the app, certify against it, then the same loop) and a new app (the instructions step: spec from instructions, owner review, first passing build becomes the reference). For each path say what must exist before a builder is asked to build. Mark each path proven, partly proven or not yet proven, with the source.
2. **The dogfood order.** The smallest order that runs end to end: `form` (this sprint), then one second app with agents in every role, then the remaining desk apps in one wave, then other examples in small waves. Every wave is its own sprint with its own plan. State the entry condition of each wave in one line. `kit` is a library: say that it needs its own decision and do not decide it.
3. **How a new tool or model joins.** The intake drill: which drill, on which certified specs, for which role; what it costs (runs per binding, the session times measured in Sprint 723, the quota rule that probes, worker sessions and runs share one plan quota); what record it leaves and what reads it. Mark what is not built.
4. **Open items for the operator review (story W3).** One table: Sprint 726, the forward test of the three notepad specs (`e130889b`), the judge study (`6e6632d8`), the Sprint 723 carry-overs (the Google step down, the Zhipu start tier), Sprint 730. For each: the options (confirm, reshape, fold in, leave in the backlog), one recommended option and a one-line reason. These are recommendations; the operator decides. Do not change any sprint or story.

Also: update the opening note and the "not in this first standard" section so they no longer say that questions 6 and 7 are missing; update the abstract in `docs/README.md` and the line in `docs/INDEX.md`.

Rules for the writing: plain English for a reader who does not know these sprints; no restating of the plan or the runbooks, link to them; every claim about a result cites its source; nothing unmeasured presented as done; planning only, nothing is built or run; the new sections together stay under 110 lines and the whole document under 500. Do not touch sections 1 to 7 except for cross-references. Do not write about the results of stories T1 to T4, which are still running. Public repository: no host names, logins, addresses or home paths.

Delivery: commit on your work branch only `docs/shapeware-workflow-standard.md`, `docs/INDEX.md` and `docs/README.md`, with trailers `Sprint: #731`, `Story:` and `Story-ID:` for this story and `Agent:` with your registered name. Verify command to record before submitting: `bash script/scrub-gate.sh` (exit 0). Do not push to main; the conductor reviews and merges.
