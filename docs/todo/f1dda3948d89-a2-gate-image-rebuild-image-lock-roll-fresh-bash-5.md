---
id: f1dda3948d89
kind: chore
title: 'A2: gate-image rebuild (image.lock roll) + fresh Bash 5.3 86/86 both modes on go1.27.4'
seq: 594
status: todo
priority: p0
created: 2026-11-21T10:34:55.082522Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

Deferred part (b) of A 195027c9 (code part merged: 14 submodule repos pushed go1.27.4 + productgo re-pin, umbrella 00e713e0). BLOCKED ON: P1 baseline evidence (befc2403) + gate-host keep-alive (WSL idle-reboots kill detached containers). Then: acquire EXCLUSIVE gate-host claim, roll the official build image under the image.lock rule (previous release builds the next), record new image id here, run Bash 5.3 gate fresh BOTH modes target 86/86 by fixture name vs rc.39 evidence (mode0 365ab01e, mode1 2f059ded). Gate host only, official image via bashy oci. Also refresh published consumer dependency pins (builds catalog) once submodule commits are remote (they now are).

OPERATOR RULE 2026-11-21 (typed; conductor relay): SKIP judge/LLM-graded and long-running tests during implementation; stories close on build + targeted unit tests only; ONE final full test run after everything completes. For THIS story: the image rebuild MAY build (image id recorded), but the fresh 86/86 run is DEFERRED TO FINAL GATE - record '86/86 deferred to final gate' in the submit; do not run it mid-sprint.

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.
