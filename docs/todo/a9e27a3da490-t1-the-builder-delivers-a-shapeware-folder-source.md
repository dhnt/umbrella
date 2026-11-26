---
id: a9e27a3da490
kind: task
title: 'T1 the builder delivers a shapeware folder: source, launcher and a working dag.md lifecycle'
seq: 796
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T12:56:51.246113Z
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
---

Extend the spec2src task for form: the deliverable is the source, the ./form launcher and a dag.md with the five lifecycle steps (source, build, test, install, run) plus serve, per docs/shapeware-spec-v0.md section 5a. The grader additionally checks at the venue that the steps exist and that build, test and run work; the behavioural verdict is unchanged. One builder binding that passed in Sprint 723, 3 runs. Decide first what install means at a venue with no bashy (a launcher on PATH is the smallest answer) and write it into the task. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip' (operator 2026-11-26). Reuse agent-bench packs/spec2src with venue/, the Sprint 723 grader and kb runbook spec-to-source-drill. Operator review before start.
