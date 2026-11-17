---
id: be8c35fd5732
kind: spike
title: S0C Audit released baseline, DAG parity and standalone pins
seq: 452
status: assigned
priority: p0
labels:
    - layer-separation
created: 2026-11-17T21:49:53.213113Z
assignee: s575-gates-review
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Read-only release/gate review. Inspect bashy release/tag refs and official image.lock, dag.md, Makefile, required test scripts; sh/coreutils/bashsharp/yoke standalone go.mod graphs and bashsharp-tests harness. Produce exact existing commands and missing bashy dag targets for all three independent build/test lanes, full former test prerequisites, both Bash 5.3 modes, certification preparation, resolved pin checks. Distinguish rc.37 actual executed evidence from architecture tests not covered by release. Inspect yoke/pkg/dag/interp_bashpp.go and bashy/internal/agentos/dag_bashpp.go wiring for relocation-only S6. No edits, builds, tests, remote host use or fixes. Cite paths and lines; no invented commands. Read current docs/plan-s575-master-execution.md.
