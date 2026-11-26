---
id: c61a0ec7e18a
kind: doc
title: 'W1 draft the shapeware workflow standard: stages, gates, roles, artifacts, records'
seq: 788
status: done
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:02:29.430555Z
weave: 279
assignee: claude-opus5.5
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
closed: 2026-11-26T13:51:44.100899Z
closed_by: claude-fable5.2
---

Write docs/shapeware-workflow-standard.md: the shapeware workflow as one standard, proven stage by stage with what was actually done on bashy's form app.

Read first (all in this repo): docs/shapeware-workflow-findings-2026-11-26.md (findings F1-F12, implications, the eight questions, tooling ideas 4a, group shaping 4b), docs/plan-reverse-sdlc-workflow.md (the full trip, the field loop, the front half), docs/shapeware-spec-v0.md (sections 4.2, 4.3, 5, 5a, 7, 12, 18-20), docs/shapeware-qualification-process.md, docs/sprint-723-report.md, docs/spec2src-protocol-v2.md, and the kb pages under docs/kb/pages whose names start with shapeware- or spec-to-source.

The document answers questions 1 to 5 and 8 of the findings, section 4:
1. The stages end to end (instructions, spec, compile, build, test, install, run or serve, field shaping), each with: who does it (role and the least band, or no model), the artifact, the gate (mechanical or human) and the evidence it leaves. One table, then one short subsection per stage with the form example for it. Mark every stage as proven, partly proven or not yet proven, with the source.
2. What done means for one shaping pass. Shaping is iterative; 'verified with tbd' is a normal state. Use the release classes of the spec format; do not invent new ones.
3. Roles: spec author, judge, builder, operator agent, conductor; and the people: account member (A), owner (O), contractor (C), with the two human gates (the owner approves what the app is; consent before it runs on a machine).
4. Hidden cases when there is no reference app yet.
5. Where records live: per app and per binding.
8. What is deliberately not in this first standard.
Operator rulings to state as rules: no separate pipeline, the lifecycle (dag.md) is part of the spec with effects and a measured band per step; a spec is compiled (lint, later a dry run) before it is built; end-to-end tests are the spec's contract and run on the build and again on the installed app; a stated band is a measured band.

Rules for the writing: plain English for readers who do not know these sprints; define each term once; no restating of the spec format or the runbooks, link to them; every claim about results cites the report or protocol; do not present unmeasured things as done; under 400 lines. Public repo: no host names, logins, addresses or home paths (script/scrub-gate.sh must pass).

Also add one line to docs/INDEX.md and an abstract to docs/README.md for the new file.

Delivery: commit on your work branch only docs/shapeware-workflow-standard.md, docs/INDEX.md and docs/README.md, with trailers Sprint: #731, Story and Story-ID for this story, and Agent: with your registered name. Verify command to record before submitting: bash script/scrub-gate.sh (exit 0). Do not push to main; the conductor reviews and merges.
