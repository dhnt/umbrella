---
id: f232758ae073
kind: test
title: 'R2 judge: another vendor''s agent writes the hidden cases and controls'
seq: 783
status: done
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.856413Z
assignee: claude-opus5.5
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
closed: 2026-11-26T19:22:05.368399Z
closed_by: claude-fable5.2-s726
---

A binding from a different vendor than R1 writes independent hidden cases (private store) for the second app, following kb runbook spec-to-source-drill: documented behaviour only, one form of state per case, fresh HOME. Done when the reference passes 3 of 3 through the Sprint 723 grader and the empty workspace fails; digests recorded before any builder run. This binding is not a builder in R3. Plan: umbrella docs/plan-reverse-sdlc-workflow.md (iteration 2). Operator review and decisions 1-3 before start. Reuse the Sprint 723 harness as it is; build and test only on a claimed gate lane.

## Triage for the start (2026-11-26)

Unchanged in scope. Notes from Sprint 731: the judge works from kb runbook `spec-to-source-drill` part A (`bashy kb show spec-to-source-drill`); the conductor notes every guess for R4. The grader to reuse is the private form grader v2.4 (per-phase isolation, native executables removed, headless, lifecycle phase); only the contract, the cases and the service check change. Controls: the reference passes 3 of 3 including the lifecycle phase; the empty workspace fails. A case that fails the reference is fixed or dropped before any builder runs.

## Conductor note for the judge's session (2026-11-26; mechanics only)

Judge: `claude-opus5.5`. R1 and E1 are accepted: the spec is notepad v1.0 on bashy main `eb41d87b` (`examples/desk/notepad`; the spec release is the file list in `spec/README.md`), and the lifecycle test is agent-bench `packs/spec2src/venue/lifecycle-notepad.sh`.

- Your procedure is the kb runbook `spec-to-source-drill`, part A (`bashy kb show spec-to-source-drill`). Note every point where it leaves you guessing or is wrong: that list is a deliverable.
- Everything you write is private. Nothing of it goes into this repository, this workspace's branch or any public repository. Where the private store is, what to reuse from the form grader, how to reach the test host and how to deliver are in the conductor's private brief on the session host: `~/.bashy/evidence/s726/R2-private-brief.md`. Read it first.
- Never build, run or grade on the session host; the test host only. One grade at a time.
- Make no commit in this workspace. End with the report the brief asks for.

## Result (2026-11-26)

Judge `claude-opus5.5`, one session of 35 minutes (weave run 282), from the runbook and the mechanics notes only. Private set `notepad-hidden-v1` committed in the private docs repository (`13d6e66`): 27 independent hidden cases (28 written; one dropped because it failed the reference) and one page interaction; each case starts its own server on its own port and data folder and ends with `stop`. The grader is the form grader v2.4 with three changes: the spec's `build` step runs before the behaviour phases (the launcher does not build on demand); Go modules come offline from the lane's download cache; the lifecycle phase is a frozen copy of agent-bench `venue/lifecycle-notepad.sh`, reported apart from the behaviour verdict.

Controls on gate lane 2 (conform v0.1.1, spec v1.0 at bashy `eb41d87b`): the reference, source only, PASS 3 of 3, 177 of 177 assertions each, 28 of 28 cases and the interaction, lifecycle PASS on all ten checks; the empty workspace FAIL on every layer (1 of 177: a "fails with no server" step), lifecycle FAIL. Digests (sha256, first 16 hex), fixed before any builder run: hidden set `4c1448e6facce37c`; `lane-grade.sh` `6f5dea925930f7a0`; `grade-on-lane.sh` `e4f153cbf4e7c11f`; lifecycle test `ab0ea904fb994799`; visible `CONTRACT.md` `1624be7bbbf8b60d`; `dag.md` `4fdbfa7532413078`; judge binary `3fd12fbdbaacfc15`.

Defects of the reference against its own spec that the judge found (none asserted by a visible or hidden case; for the report and a later spec version, not fixed here):
1. `--format` is ignored: content sniffing always decides.
2. Content sniffing is broader than the contract: content holding certain html tags is treated as html where the contract says txt.
3. The first body write after an empty `add` is `r2`; the contract says `r1`.
4. One `features.yaml` acceptance line fails on the reference (`add ... --fields id,title` exits 2, and the note is stored anyway). `conform spec check` is static and cannot see this.

Runbook guesses (`spec-to-source-drill`, part A), for R4:
1. Per-case state: the runbook assumes state lives in HOME; here it is a data folder and a port.
2. Nothing on a case that begins with `stop`: a pid file left by an earlier phase can name a process of another namespace.
3. "Remove native executables" plus "reuse the grader" assumes a launcher that builds on demand; a build step was needed.
4. The form grader cannot build an app with module dependencies offline; the task text must say what the venue's module cache holds.
5. "Fix or drop a case that fails the reference": nothing on reporting the defect or on whether it blocks the builds.
6. Only `--json` commands are compared structurally; `curl` checks need byte-exact compact JSON.
7. "One case per input format" does not say whether each detection route counts.
8. No guidance on making hidden binary inputs (the hidden PDF comes from the reference's own exporter).
9. No idiom for "any non-zero exit".
10. Not in part A at all: the page interaction, the lifecycle phase, the digest method for the hidden set, the choice of a hidden port.
