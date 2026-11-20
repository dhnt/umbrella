# Plan — Sprint 676: fleet hardening after the tool-shortcut tests

Operator request 2026-11-19: after testing `bashy <tool>` one tool at a time,
have agents investigate and fix the remaining gaps in parallel.

## Gap

- `bashy ycode` is the pre-existing built-in verb: it opens no steerable
  chat session. zcode and dsh declare no steerable launch, so `bashy zcode`
  and `bashy dsh` exit 127. (Kimi is parked: no subscription.)
- Pre-existing test failures on clean main block weave suite gates:
  four in bashy `internal/agentos`, two in yoke (`pkg/bus`, `pkg/chat`),
  one in agent-bench (`test_skill_arm`).
- yoke `scripts/fmtcheck.sh` fails on files unchanged on main, so the
  pre-push gate fails for everyone.

## Stories

| story | repo | lane | agent |
|---|---|---|---|
| 66d98310 four agentos tests | bashy | D | claude-sonnet5.5 |
| 96ff25a3 steerable ycode / zcode / dsh | bashy, yoke | E, F | claude-fable5.2, muse-spark1.3 |
| a4ef4a42 bus/chat tests | yoke | G | muse-wonder |
| fe274376 fmtcheck | yoke | H | opencode-deepseek-v4-pro |
| f935db2e test_skill_arm | agent-bench | I | muse-wonder-full |

Each lane runs in its own weave workspace, one agent per lane.

## Rules

Root cause first: name each failure's cause (product, test or venue defect)
before changing code; fix it where the cause lives. Smallest change; targeted
tests only (`GOWORK=off`); never `go work sync`. The conductor reviews every
diff and merges; nothing is pushed by a worker.

## Acceptance

1. `bashy ycode`, `bashy zcode`, `bashy dsh` open steerable sessions; the
   zero-token e2e covers them.
2. Each listed failure has a recorded root cause and a fix (or venue fix).
3. yoke `fmtcheck` passes on main.

## Non-goals

No kimi binding. No new benchmark runs. No production change.

## Rollback

Revert the merge commits; no data or production state is touched.
