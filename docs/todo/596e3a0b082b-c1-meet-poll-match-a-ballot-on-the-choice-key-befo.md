---
id: 596e3a0b082b
kind: bug
title: 'C1 meet poll: match a ballot on the choice key before the colon (bug ed305169); poll coverage row'
seq: 574
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:47.637347Z
sprint: 685
sprint_id: f684d38b-201d-5579-bd47-c70e26524188
sprint_title: 'Group shaping coverage: every bashy app as a test case, plus cross-outpost agent steering in one circle'
---

The only code the poll coverage row needs. Form multi-respondent mode already works and is unit-tested (examples/desk/form/server/many_test.go). bashy meet poll with a described --choice (KEY: description) records every ballot invalid because normalizeChoice (yoke/pkg/meet/poll.go) matches the whole string (todo ed305169). Fix: match on the key before the first colon and have the poll prompt ask for the key. Unit test: table test in yoke/pkg/meet with described choices. Close ed305169 with it. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

- Entry: in your weave workspace, fetch `origin` in both `umbrella` and `yoke` (`git fetch origin`), start from `yoke` `origin/main` (`dcccc0fa` or newer) and `umbrella` `origin/main`, run `bashy mod drift`, and verify the baseline `GOWORK=off go test ./pkg/meet/` passes on the Linux gate host before making edits. Rebase onto `origin/main` before submitting.
- Venue: run Go builds and tests only on the Linux gate host (never run Go tests locally on the dev box). Check `bashy inbox` and `bashy claim list` for the reserved lane and gate-host transport command (`gate-lane check` must print ok; run via `gate-lane run ...`). Claim the lane (`bashy claim`) before using it and release it immediately after.
- Scope: touch only `yoke/pkg/meet/poll.go`, unit test file(s) in `yoke/pkg/meet/`, and closing bug todo `ed3051699fee` in `umbrella/docs/todo/`. If anything outside these files seems needed, stop and report instead of widening scope.
- Implementation requirements:
  1. In `yoke/pkg/meet/poll.go`, update `normalizeChoice(reply string, choices []string) string` so that when a choice has a colon (`KEY: description`), it matches a ballot on the choice key (text before the first `:`, trimmed/lowercased) as well as the full choice string, in both the head-line match and the whole-reply fallback, returning the canonical choice string from `choices`. Preserve plain choices without `:` and keep ambiguity refusal (`""` when more than one distinct choice matches).
  2. Update `pollPrompt` in `yoke/pkg/meet/poll.go` so it asks participants to reply with the choice key (the token before `:`) while still clearly showing the choices.
  3. Add a table-driven unit test in `yoke/pkg/meet/` covering described choices (`KEY: description`), key-only replies, full-string replies, prefixed/formatted replies, multi-line replies with rationale, ambiguous replies naming multiple choice keys, plain choices, and `pollPrompt` asking for the key.
  4. Mark bug todo `ed3051699fee` closed (`bashy todo done ed3051699fee` in the `umbrella` weave workspace) and commit that closure in `umbrella` on your weave branch.
- Commits and submission: set `BASHY_AGENT` to your assigned agent identity; include trailers `Sprint: #685`, `Story: #574`, `Story-ID: 596e3a0b082b`, `Agent: <assigned-agent>` on commits in both `yoke` and `umbrella`. Do NOT push `main` in either repo; manager merges and pushes after review. Submit via `bashy sprint submit 685 596e3a0b082b -m "<summary, yoke commit SHA, umbrella commit SHA, gate-host test receipt>"`.
- Public-repo rule: never commit machine names, OS logins, IP addresses, credentials, or home-directory paths (`script/scrub-gate.sh` is fail-closed). Describe hosts by role only.
