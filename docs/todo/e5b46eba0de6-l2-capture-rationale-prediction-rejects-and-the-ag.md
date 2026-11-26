---
id: e5b46eba0de6
kind: feature
title: L2 Capture rationale, prediction, rejects and the agent at activation
seq: 804
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T19:45:25.158191Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

Problem: the ledger lacks the reasons. Agents return COVERED / NOT COVERED / NEXT but no rationale or prediction; reject deletes the candidate with no trace; the agent name is dropped at activation; undo and restore carry no reason.
Behavior: extend the closing block with RATIONALE and PREDICTED (stated before verify) and store both on the candidate; keep one ledger line for a rejected candidate before its directory is removed, with an optional reason; pass the agent name through to the activation record; accept an optional reason on undo and restore. All new fields optional, so existing agents and records keep working.
Code inspected (2026-11-26): yoke/pkg/shape/helpers.go:94-116 (brief and closing block); service.go:925-943 (Reject deletes); yoke/pkg/shape/production.go:132-144,230 (ActivateRequest.Agent not passed to src.ActivateOptions); yoke/pkg/src/activate.go:262-271.
Verification: unit tests for parsing with and without the new fields, reject line kept, agent present in history.

Triage (2026-11-26): p1, no dependencies, runs in parallel with L1 (L2 adds the Candidate fields; L1 reads them when present). Cuttable if costly: the reason on undo and restore, since standing is derived without it. Planning only until Sprints 726 and 730 are done.
