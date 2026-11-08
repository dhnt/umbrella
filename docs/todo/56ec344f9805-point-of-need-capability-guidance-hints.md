---
id: 56ec344f9805
kind: feature
title: Point-of-need capability guidance hints
seq: 53
status: assigned
priority: p1
created: 2026-11-08T10:09:32.177595Z
assignee: codex-gpt6-astra
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
---

Split from caac5708 (part a). Emit contextual, deduplicated stderr hints recommending reuse of an existing capability, bashy command add for repeatedly used scripts, bashy skill learn for verified procedures, or bashy shape for unfitting behavior/defects. Build on the existing bashy-hint-v1 engine; no parallel extension framework. Correct usage mistakes, missing prerequisites and transient failures before suggesting software changes. Acceptance: repeated-script, missing-feature, unfitting-behavior and routine-error cases each produce the right advice; hints on stderr only; BASHY_HINTS=off suppression and per-session deduplication covered; stdout, machine output and exit status unchanged; active advice policy inspectable.
