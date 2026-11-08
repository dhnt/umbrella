---
id: 934e13cc241f
kind: bug
title: Honor explicit common-option boolean values
seq: 49
status: assigned
priority: p1
created: 2026-11-08T09:52:36.395199Z
assignee: opencode-kimi-k2.7-code
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
---

Reproduction: bashy agent list --explain=false still reports not executed. Acceptance: false executes the normal read-only listing, true describes without executing, invalid boolean values exit 2; cover shared parsing paths.
