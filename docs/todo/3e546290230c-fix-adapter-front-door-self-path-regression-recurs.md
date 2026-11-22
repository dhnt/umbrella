---
id: 3e546290230c
kind: bug
title: Fix adapter front-door self-path regression (recursive DAG self path when BASHY=dag) from bashy 8a36ca1f
seq: 614
status: done
priority: p0
created: 2026-11-21T20:45:11.640497Z
assignee: claude-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-22T12:00:06.993882Z
closed_by: claude-opus5.5
---

Found by Sprint 682's C4 gate run 2026-11-21 (codex continuity): the example-apps consumer e2e form row exited before inference with a recursive DAG self-path; identical WSL fixture PASSES at bashy 5c8be965 and FAILS at current main with BASHY=dag. Introduced by 677 commit 8a36ca1f (adapter front-door). Related precedent: the account-adapter test regression (runCommandAdapter resolved bashySelfPath() to the test binary; fixed in TestMain). Root cause first: reproduce with BASHY=dag (inside a bashy dag body) and an adapter-routed command; record which self-path resolution (BASHY / BASHY_EXE / os.Executable / bashySelfPath) picks the wrong binary. Fix where it lives (adapter self-path must resolve to the real bashy executable, never a dag target name or test binary); unit test reproducing the BASHY=dag case. Blocks 682 C4's paid rerun and likely 677's integration run.
