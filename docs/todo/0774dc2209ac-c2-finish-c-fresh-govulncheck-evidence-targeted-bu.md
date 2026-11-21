---
id: 0774dc2209ac
kind: chore
title: 'C2: finish C - fresh govulncheck evidence + targeted builds on salvaged bumps (C 3f6a38f3 remainder)'
seq: 600
status: todo
priority: p0
created: 2026-11-21T11:26:49.459235Z
assignee: agy-gemini4-carbon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

Remainder of C 3f6a38f3dfd6 after run #110 failure (classification + salvage recorded on C). STARTING POINT - salvaged WIP commits preserved in weave workspace ~/.bashy/weave/umbrella-f8ff73b3/workspaces/issue-110 submodules (fetch by full sha into your clones, do not redo the bumps): bashy ab591e31f3deb789235571758a70297cb45c312c, outpost 06f2121bd9e75ffa5316eae4ec78b14582899a87, yoke dab686f81819c4a76d5a6f3b5e0eeb9d10b64c07. Manager sanity already green: outpost go build ./... ok, go list -m ok in all three, scripts/test-govulncheck-release.py 8/8.

REMAINING ACCEPTANCE WORK: (1) targeted builds/tests green per scope on the bumped graph (bashy dag targeted targets; root cause on story before fixing any red, directive #3). (2) FRESH govulncheck per scope (bashy, outpost, yoke) with yoke external/ollama+podman sources hydrated (the salvaged script change does this); record full output/summary per scope in your submit. (3) Confirm the salvaged vuln-ignore retirement (GO-2026-5932 emptied vs d91599c2 override bashy 7ddc31c9) against the fresh scan: retire if clean, else shrink to exact remaining reachable ids each justified on C 3f6a38f3. (4) Turn salvage WIP into proper delivery commits per submodule (amend or follow-up commits; Sprint/Story/Story-ID trailers for THIS story + Agent signed as yourself), submodule push first, then umbrella pins (directive #4). Commit after each scope verifies - run #110 died with 40m of uncommitted work; do not repeat that.

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.
