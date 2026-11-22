---
id: 3043a8673980
kind: bug
title: '677 integration: root-cause and fix the 15 failing go tests from dag test at d9598792'
seq: 622
status: assigned
priority: p0
created: 2026-11-22T10:15:13.889158Z
weave: 142
assignee: agy-gemini4-carbon
sprint: 677
---

Integration run 2026-11-22 on the gate host (lane2, official image rc.40-go1.27.4, bashy d9598792, candidate ./bin/bashy dag test): 15 failures in 4 packages; logs at the lane2 results dir test2.log. ROOT CAUSE FIRST for each (name it, reproduce at the same commit and lane, compare against the pre-677 baseline bashy 5c8be965 with targeted -run, record the class on this story), THEN fix where it lives, one commit per cause. Conductor's first-pass hypotheses (verify, do not assume): (1) TestSourceRoute: 'go1.27.4 does not match go tool go1.27.2' - stale go1.27.2 toolchain in the lane cache volume lane2-s677-cache -> venue (pre-existing, already recorded); (2) TestACPHelpIsHeraldACPHelpByteForByte, TestACPProcessLevelInitializeSessionPrompt (deadline), TestRepairHermeticStrippedPathRunsThroughBashyRuntime (fork/exec EAGAIN), TestAgenticExampleProductEntries (signal: killed), internal/agentos package hit -timeout 10m -> container caps (8 CPU / 7 GB / pids) too small for the full suite -> venue; (3) TestMakeFallthroughFrontDoor, TestMakeFallthroughListAndHints, TestDagMakeHandlerShell, TestCreateToPostDAGFixture: make-fallthrough hint empty -> possible regression from Sprint 660 R4 (74100d67) - bisect; (4) TestGenieYoloRecipeProfile (profile missing id) and TestGenieRecipeGeneratesCallerWorkspaceAndModel -> possibly the S0 sibling-pin sync (ycode/genie) - bisect; (5) TestCommonOptionsVocabularyReport: golden differs because 677 added commands -> review the diff, then BASHY_UPDATE_COMMON_OPTIONS=1 if intended; (6) TestBuildShRollStagesGoToolchainAcrossVersionBump: doubled path /var/cache/var/cache/... under the container TMPDIR -> test defect in A2's test; (7) TestAgentRosterIncludesStandaloneRoomAssignments: unclear - rerun alone. VENUE: gate host lanes only (claim the gate-host lane 3 resource; lane2 is the conductor's), official image, session attached; never the dev box. Report the classification table on this story before fixing.
