---
id: 2f0b95586ead
kind: task
title: 'R0 Plan the record lifecycle: preview/publish, discard intermediates, compacted published record, trace id'
seq: 820
status: wontfix
priority: p1
labels:
    - shaping
created: 2026-11-27T12:18:23.003837Z
sprint: 736
sprint_id: 9e389311-95fc-569e-a7b2-f05784d7369e
sprint_title: 'Ledger retention: preview/publish lifecycle, trace id as evidence, compacted published record'
closed: 2026-11-27T22:53:05.623506Z
---

Plan the retention of the shaping record. Planning only: the output is a master execution plan in docs/, reviewed with the operator before any code.

Operator note (2026-11-27), the important part: trace id and rotation of the record. Add a preview/publish step. Once a version is published, intermediate versions are discarded; only the published view and its related logs are retained, compacted. The compaction is explored during implementation of this sprint.

Inputs from Sprint 732 (docs/sprint-732-report.md, "Left out"):
- A trace id as observed evidence: today an attempt cites shape-evidence:<rev> or the incident id; the shaping path has no OTel spans and no trace id reaches the verdict.
- Rotation of the decision log: <home>/shape/auto-decisions.jsonl is host-wide and append-only; the ledger view is bounded, the file is not.
- Also to triage, not required in scope: members linking a follow-up to an existing problem by its alias (owner decision); the unused copy of the delegate env allowlist in yoke pkg/webconsole/shaped_delegate.go; a clearer standing than "pending" for a stale-refused approval.

What the plan must settle (inspect current code first and record "Code inspected"):
- What "published" means against what exists: src releases and named versions (shape release, offer, submit), the Sprint 731 spec-as-release, the activation line. Reuse an existing step if one fits before adding a verb.
- What is discarded at publish (intermediate candidate records, draft steps, superseded/undone attempts, their decision lines, preview trees) and what is retained (the published view, its ledger entries, the evidence they cite), and how undo/restore behave across a publish boundary.
- The compacted record format and where it lives (beside the decision log, in the version line, or both), so the Sprint 732 fold, standing and viewer filter keep working on compacted history; old logs still read.
- Where a trace id comes from and how an attempt and a ledger read cite it.
- Bounded stories, acceptance checks on the gate host (extend the group-shaping e2e), risks (losing reasons a later agent needs; privacy of retained logs) and rollback.
