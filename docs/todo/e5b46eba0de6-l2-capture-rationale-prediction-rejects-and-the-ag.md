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

Review (2026-11-26, code re-read at yoke 0bc70d51): larger than first triaged. The ledger is derived only if the reasons sit in records that survive, and several do not today.
- Do not store rationale and prediction only on candidate.json. Draft save deletes the draft dir with no archive (shaped_draft.go:533-535), reject deletes the candidate dir (service.go:925-976), and only the approve path archives to shape-work/.approved (service.go:890-922). Write Shape-Rationale and Shape-Predicted as trailers on the candidate commit (helpers.go:175-180) and on each draft step commit (shaped_draft.go:411), and keep them on the candidate record as well.
- Agent self-commits return the agent's HEAD and write no trailers (helpers.go:165-167). Either amend the trailers on or record them on the activation.
- Add a Shape-Problem trailer: the linked todo id if there is one, else the incident id, else the candidate's own tracking item. Repair candidates have no incident field today (shaped_repair.go:236-237); add it.
- Undo and restore need structured trailers, and this part is NOT cuttable: kind (undo or restore), the revision undone, the actor, and whether the system or a person did it. Today the kind is guessed from the subject and the undone version is not recorded. Only the free-text reason remains cuttable.
- Reject: one kept line is new stored state. Make it an append-only record beside the version line (request, problem key, agent, principal, optional reason, revision if any), written before the directory is removed. The tracking todo and any sealed evidence already survive.
- Failed attempts: a failed verify and an agent error are recorded on the candidate, but retries overwrite .evidence/<rev>.json and a draft refusal is lost on save or cancel. Record failures in the same append-only record.
- Agent at activation: ActivateOptions has no Agent field (production.go:141,230). Add it and write an Agent trailer; old entries fall back to the Shape-Agent trailer on the second parent.
- Tidy: carry the new trailers through ApplyTidy as Original-* (tidy.go:289).
- Members cannot link a follow-up to an existing problem today: linking a story in the console requires an operator (shaped_candidate.go:771). Decide whether a member may name an earlier problem by its alias.
- Parser: ParseCoverage starts at helpers.go:28 and ParseNext at :249; RATIONALE and PREDICTED extend the same closing block.
No coding until Sprint 730 completes (operator, 2026-11-26).

Revision 2 (2026-11-26, operator review; code at yoke 1ae2290c): start approved; plan in docs/sprint-732-master-execution-plan.md "Revision 2". Rescoped: widen the S730 decision log (shape/state/auto.go AutoDecision) with optional Rev, Agent, Principal, Line, Problem, Why, Expect; log human wishes (source human) without changing unattended-only behaviour; add reject, undo and restore events with actor and by person|system; WHY:/EXPECT: headings in the brief closing block, parsed like ParseCoverage; agent name passed to the activation. No commit trailers on undo/restore, no tidy carry-forward. Problem key = Source.Ref, else todo/story, else tracking item. Size M.

Record format (conductor 2026-11-26; L1 and L3 build on exactly this):
- One record: yoke/pkg/shape/state/auto.go AutoDecision, the Sprint 730 decision log. Add optional JSON fields, all omitempty: rev (the activated or undone revision), base (candidate base revision), agent (binding name), principal (who asked), line (principal line the event acted on), problem (key below), why, expect, by ("person" or "system"). Old lines must still parse; ReadAutoLog keeps working.
- Problem key: Source.Ref when set; else "todo:<id>" or "story:<id>" from the wish; else "cand:<candidate id>". An incident repair uses "incident:<id>"; L1 joins it to the attempt live at the incident's base revision, so do not try to join here.
- Log human wishes too. Keep logAuto's unattended-only callers as they are (off switch and refusal still key on Source.Unattended()); add one ledger write path that logs every source, with source "human" for an empty Kind.
- Events: keep trigger, attempt, verdict, activation, refusal. Add reject (Service.Reject, shape/service.go:980), undo and restore (the console history handlers and the CLI that call src.Restore / src.UndoSealed / src.RestoreSealed), each with principal, line, rev and by. The rollback after a failed repair patch release (webconsole/shaped_repair.go:364-373) is undo with by "system".
- Why and expect: add WHY: and EXPECT: sections to the brief's closing block in BriefWithExtra (shape/helpers.go), same bullet format as COVERED/NOT COVERED/NEXT, and parse them where ParseCoverage parses (shape/helpers.go:28); store on the candidate and on its verdict and activation lines. A missing section is empty, never an error.
- Agent name: pass it to the activation line (production.go:141,230 drop it today).
- Tests (targeted, GOWORK=off): a record round-trip with and without the new fields; a human wish writes trigger/verdict/activation lines with problem, agent, why, expect; reject, undo, restore and the system rollback each write one line with by set; the parser reads WHY:/EXPECT: and tolerates their absence.

Delivery rules (conductor 2026-11-26, Sprint 732 started):
- Work on current heads: yoke 625c20d9, bashy 25e87ba4, ycode cfa8bdc or later on origin main (fetch first; L0 changed the history handlers you touch). Commit inside the submodule on a branch named s732-<story-short-id> and push that branch; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #732, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: the smallest change that meets this story. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.
