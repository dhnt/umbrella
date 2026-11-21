---
id: 5b9440a03603
kind: refactor
title: 'P4c: Convert batch - coupled cluster last (weave+sprint, mb/inbox, bus/room, kb, chat, meet, todo, dag, foreman)'
seq: 590
status: wontfix
priority: p2
created: 2026-11-21T09:22:07.862854Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T12:11:43.447201Z
---

CLOSED SUPERSEDED (manager, 2026-11-21): collapsed into the single conversion story ee056056de3e per operator order (one generator pass over the whole catalog, no batch split, no hand edits). Do not staff.

REPLAN 2026-11-21: P4 = ONE mechanical pass of the P3 generator over disjoint verb lists, run by parallel agy workers same day; this batch (c) = coupled cluster: weave+sprint, mb/inbox, bus/room, kb, chat, meet, todo, dag, foreman. Run the generator over THIS batch's verb list only (manager supplies the list at staffing; disjoint from a/b). Duplicated wiring from the switch accepted (mb weave.ResolveSprintScopeByHandle, dag sprintCapacityServices), removed later. ACCEPTANCE (moved): generated mains build + dispatch parity via targeted dev-box tests per verb; merged-tip build before acceptance; full 3-OS dispatch e2e runs ONCE at the sprint-final gate after P4+P5, not per batch (operator rule). Inexpressible verbs: record per-verb root cause here. Commit per sub-batch. IN SCOPE; p2 = dependency order only.

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.

P4 WORKER, explicit: ADD generated mains only - do NOT remove cases from the switch in this batch.

STAGING RULE (operator 2026-11-21, conductor relay): expand -> switch -> contract. EXPAND (this phase): add new things BESIDE the old (generated per-command mains beside the switch); both build and both pass their unit tests; NOTHING is removed or severed. SWITCH: only after P3+P4 complete, route entry/certified profile to the new path behind a flag/build tag, old path still buildable. CONTRACT (P5 only, last): delete the old switch, bashy_cert_base profile and the 23-yoke-package path. Shared code needed by a stage: DUPLICATE first, de-duplicate in contract. No story before P5 deletes or severs an existing path.
