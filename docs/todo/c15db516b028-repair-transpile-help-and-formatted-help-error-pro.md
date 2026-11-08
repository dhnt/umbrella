---
id: c15db516b028
kind: bug
title: Repair transpile help and formatted-help error propagation
seq: 48
status: done
priority: p1
created: 2026-11-08T09:52:36.281615Z
assignee: codex-gpt6-sol
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:33.246976Z
closed_by: s595-manager
---

Reproduction: bashy help transpile --format=classic prints unknown flag: --help but exits 0. Provide real transpile usage; prevent formatted help from masking command errors as successful help. Acceptance: output and exit-status regression coverage, preserving legitimate legacy help output.
