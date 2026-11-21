---
id: d3989b118dd7
kind: feature
title: 'P3 (ex-S7): catalog-driven dispatch + generated mains + on-demand slot builds; one-command pilot'
seq: 557
status: done
priority: p0
labels:
    - bashy
    - yoke
    - shape
    - architecture
created: 2026-11-20T10:01:54.093407Z
weave: 115
assignee: agy-gemini4-neon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T12:21:01.105813Z
closed_by: muse-wonder-full
---

REPLAN 2026-11-21: P3 = the GENERATOR + one-command pilot. Build a generator that emits one tiny main per catalog entry (package + module version from the existing catalog), and route the bashy switch through the EXISTING registered/shape-slot exec path (yoke/pkg/shape/slot Stage/Select/Activate/Undo/Restore + tree-hash build cache) - no new dispatch framework. bashy becomes thin entry: bsh engine + agentic hooks + catalog-driven dispatch. Sources stay in their packages; NO optional/ folder. S1 build-speed (d49c099b caches) lands inside this phase. Pilot: ONE command end to end through generator -> on-demand slot build -> dispatch; measure its edit->verified-active-slot cycle in minutes vs P1 whole-bashy number. UX unchanged: bashy <verb>. Gates: targeted dev-box tests (generator unit tests incl. golden main output; pilot dispatch e2e on dev box); the full 3-OS dispatch e2e runs ONCE at the sprint-final gate, not here. The generator is what P4 runs mechanically over disjoint verb lists - design its input (verb list file/catalog subset) for parallel workers. Commit per stage (generator / routing / pilot / cycle number). Root cause before any red (directive #3); trailers + Agent (directive #4).

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.

STAGING RULE (operator 2026-11-21, conductor relay): expand -> switch -> contract. EXPAND (this phase): add new things BESIDE the old (generated per-command mains beside the switch); both build and both pass their unit tests; NOTHING is removed or severed. SWITCH: only after P3+P4 complete, route entry/certified profile to the new path behind a flag/build tag, old path still buildable. CONTRACT (P5 only, last): delete the old switch, bashy_cert_base profile and the 23-yoke-package path. Shared code needed by a stage: DUPLICATE first, de-duplicate in contract. No story before P5 deletes or severs an existing path.

MANAGER REVIEW of run #115 (muse-wonder-full, 2026-11-21, executable evidence): generator+dipatch+pilot ACCEPTED at unit level pending S0-rebase merge. My runs in WS bashy @e4318f52 (GOTOOLCHAIN=go1.27.4 GOWORK=off): go test ./tools/productgo/ ok 15.750s; ./internal/cmdgen/ ok 1.918s; ./tools/cmdgen/ ok 0.529s; TESTS_EXIT=0; go build agentos+cmdgen+productgo BUILD_EXIT=0; earlier agentos Catalog/Pilot/ShapeSlot filtered tests ok 22.785s. Staging proof: agentos.go +7/-0 (catalog seam inserted before switch, ZERO switch cases removed), shape_slot.go +4/-0; deletions exist only inside modified build scripts/productgo (38 lines, tests expanded alongside). Worker-claimed numbers (recorded, not yet manager-reproduced): S1 warm dag build 7.342s; pilot stats cycle 1.415s, 3.19MiB/98pkgs. MERGE GATE: S0 baseline sync #116 must land first; then rebase-or-redo assessment + unit rerun; bsh integration NOT in this delivery (waits P2b bashsharp module).

POST-ACCEPTANCE SCOPE NOTE (operator 2026-11-21): the generator/new-dispatcher parts of this accepted delivery are NOT carried forward - conversion uses the existing registered-command ring instead. Only the pilot proof concept carries over (re-done under ee056056 via entry+register+delete-case); the build-speed caches stay. Unused generator code is dropped in ee056056's final stage.
