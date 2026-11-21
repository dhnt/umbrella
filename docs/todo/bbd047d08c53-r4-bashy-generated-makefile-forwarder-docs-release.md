---
id: bbd047d08c53
kind: chore
title: 'R4 bashy: generated Makefile forwarder, docs, release-gate equivalence on the gate host'
seq: 568
status: todo
priority: p1
created: 2026-11-20T18:51:58.526159Z
sprint: 660
sprint_id: 666d2a0c-b433-5286-880b-b5b02134f5cf
sprint_title: 'Post-rc38: DAG-only build entrypoints and Bashy make fallback'
---

Plan §R4. Conductor runs the gate: both Bash 5.3 modes 86/86 same named fixtures as rc.38; sequence with the release-pipeline refactor. Parent 5bc29f7f.

## Conductor update 2026-11-21 (operator: assign now)

Final spec for this run: replace bashy's hand-written Makefile (738 lines) with the generated dag forwarder, the same way R1/R2 did for bash, outpost, bonsai, gfy, nadir and readline (use their generator and commits as the model). Every target the old Makefile exposed must still work as a forwarder to the same-named `bashy dag` target (R3 already ported the Makefile-only targets into dag.md). Update docs that describe `make` targets for bashy to point at `bashy dag`. Start on current heads (check drift first). Tests: build + unit tests + a check that each old target name forwards to an existing dag target. The Bash 5.3 86/86 equivalence check is NOT run per story: it runs in Sprint 677's single integration run. Trailers: Sprint 660, Story-ID bbd047d08c53, Agent.
