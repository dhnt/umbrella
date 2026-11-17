---
id: 8b7e558fdedf
kind: spike
title: S0A Prove reference-only Bash and Bash# extraction feasibility
seq: 450
status: assigned
priority: p0
labels:
    - layer-separation
created: 2026-11-17T21:49:52.627031Z
assignee: s575-engine-review
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Read-only design review. Inspect sh/interp and sh/syntax Bash# evaluator/parser coupling, bashsharp front/transpile and docs/seam.md. Determine whether full physical separation can preserve rc.37 behavior using ONLY moves, package/import references and dependency wiring, without changing logic, APIs, tests or duplicating runtime. Cite exact files/symbols and private-state edges that prevent or permit this. Propose the smallest concrete move map; distinguish any required API/logic edits explicitly. No edits, commits, builds, native suites, remote host use or fixes. Return findings, not a success claim.
