---
id: 52d62b993ac8
kind: bug
title: Unify documented help-format syntax
seq: 46
status: done
priority: p1
created: 2026-11-08T09:52:36.054959Z
assignee: codex-gpt6-sol
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:32.843936Z
closed_by: s595-manager
---

Support COMMAND --help --format classic alongside central formatted help. Audit found 69/89 checked commands returned nonzero for the documented syntax. Preserve command-specific --format operands and literal arguments after --. Acceptance: valid help across checked command records, regression tests for ambiguity and separator handling; record engine/vendor exclusions.
