---
id: a9e27a3da490
kind: task
title: 'T1 the lifecycle in the spec: dag.md with a band per step, required by the linter and handed to the builder'
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

Operator ruling 2026-11-26: no separate pipeline; the lifecycle is part of the spec. (1) form's spec folder carries its dag.md with a Band: line per step next to Effects:, per docs/shapeware-spec-v0.md section 5a. In a spec-only release the build step is the spec-to-source step (an agent at the stated band builds from the contract; the judge decides). (2) A conform spec check rule: the five steps exist and each states a band. Inspect conform spec/check.go and the dag.md parser in bashy first. (3) The spec2src task hands the builder that dag.md and asks it to make the steps work; the grader additionally checks at the venue that build, test and run work; the behavioural verdict is unchanged. One builder binding that passed in Sprint 723, 3 runs. Decide first what install means at a venue with no bashy (a launcher on PATH is the smallest answer) and write it into the step. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip'. Operator review before start.
