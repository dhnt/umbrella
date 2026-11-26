---
id: f232758ae073
kind: test
title: 'R2 judge: another vendor''s agent writes the hidden cases and controls'
seq: 783
status: todo
priority: p0
labels:
    - conform
created: 2026-11-26T11:23:43.856413Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
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
