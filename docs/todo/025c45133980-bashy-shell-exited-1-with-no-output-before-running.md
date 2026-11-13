---
id: 025c45133980
kind: bug
title: bashy shell exited 1 with no output before running a command (looked like a silent mb send failure)
seq: 190
status: todo
priority: p2
labels:
    - bashy
    - agent-shell
created: 2026-11-13T00:44:42.94361Z
---

Observed 2026-11-12 ~00:36-00:37 UTC on the dev host, Claude Code Bash tool with CLAUDE_CODE_SHELL=bashy (rc.31-dev). Three consecutive commands of the form `bashy mb send claude-opus5.5-s627 --as qiangli "<text>" ; echo "exit=$?"` returned exit 1 with EMPTY stdout/stderr; the trailing echo never ran, so the shell failed before executing the line (mb send itself was never invoked). A minimal message one minute later succeeded. Not reproducible: exact failing text replayed to another recipient and both suspected tokens (bypass, BASHY_AGENT) sent to the same recipient all succeeded (exit 0). PreToolUse hook ruled out (it only guards the installed shell binary and prints BLOCKED). Only correlated event found: service monitor relink warnings at 16:35:41 local (lan-inference/ollama/ollama-pool not activated by this monitor). Concurrency at the time: sprint 626/627 managers and 4-5 weave workers active. Classification: UNKNOWN (likely environment/transient shell startup), not a confirmed mb defect. Next: capture shell startup failures (stderr + exit reason) so a recurrence is diagnosable; on recurrence, run `bashy -c true` immediately and record. Product gap regardless of cause: a shell that exits 1 must say why.
