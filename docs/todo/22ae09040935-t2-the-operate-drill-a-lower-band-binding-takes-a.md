---
id: 22ae09040935
kind: task
title: 'T2 the operate drill: a lower-band binding takes a built folder through build, test, install, run and serve, cold'
seq: 797
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:56:51.585032Z
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
---

A new small drill (agent-bench pack task): the subject gets one passing T1 folder and its run block, with no other context, and must run the lifecycle: build, test, install, one CLI command with the expected answer, start the service, fetch the page, stop the service. Graded mechanically: exit codes, the contract run against the installed app, and no step improvised outside dag.md. Start one band below the builder and step down, 3 runs per binding; include a small local model on the test host if one is registered. Protocol note before runs; probes; quota check. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip' (operator 2026-11-26). Reuse agent-bench packs/spec2src with venue/, the Sprint 723 grader and kb runbook spec-to-source-drill. Operator review before start.
