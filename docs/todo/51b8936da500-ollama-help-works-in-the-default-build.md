---
id: 51b8936da500
kind: bug
title: ollama help works in the default build
seq: 57
status: done
priority: p1
created: 2026-11-08T11:33:00.145988Z
assignee: muse-spark1.3
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: bashy CLI consistency and capability shaping
closed: 2026-11-08T17:58:36.288632Z
closed_by: s595-manager
---

Found by the S595 help-syntax re-audit (93 verbs; only ollama still fails). In the default build (no -tags bashy_engines,embed_runner) bashy ollama --help and ollama --help --format classic exit 1 with 'local inference requires the engines build'. Acceptance: --help/-h in the stub build print usage (including that local inference needs the engines build) and exit 0; non-help invocations keep the current refusal and exit status; engines build unchanged; unit tests cover stub help and refusal.
