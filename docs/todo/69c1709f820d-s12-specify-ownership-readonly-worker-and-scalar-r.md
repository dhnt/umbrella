---
id: 69c1709f820d
kind: spike
title: S12 Specify ownership, readonly, worker and scalar-runtime follow-ups
seq: 91
status: todo
priority: p2
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.915003Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

## Outcome
Design-only deliverable: four separate repair briefs, each with baseline evidence, safety invariants, dependencies, test commands and measurable acceptance.

Dependencies: S1; consume S11's mode guarantees before finalizing.

## Required briefs
1. Bridge pointer-origin/closure ownership: preserve retained native pointers and cross-call identity; do not repeat rejected call-scoped or weak-reference cleanup designs.
2. Readonly lifetime/identity: retained bindings, cloned identity remapping, owner attribution, zero-size slice cases and compiled negative-case execution.
3. Persistent C/C++/Go workers: cancellation, process groups, bounded lifetime, per-call environment and Sprint 600 routing; preserve actual language/runtime behavior.
4. Non-recursive scalar evaluation: interpreted correctness identity plus workload-specific timing, allocations and recursion-stack measurements. No automatic substitution of compiled execution.

External extraction ownership: Sprint 575 UUID 65ce85f5-87c0-5863-bf55-62de86f5df36 and Sprint 581 UUID cb7f2d66-9c30-5d68-9cbc-ec76c9f7f6d7. Do not duplicate extraction or authorize runtime redesign, reclamation experiments or worker conversion here.
Planning record only: implementation requires a separate execution instruction. Leave this story todo and unassigned; no code, worker launch or release is authorized by this rewrite.
