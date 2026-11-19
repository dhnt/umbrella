---
id: 832225f67276
kind: refactor
title: T3 Rename the kimi-cli seed to kimi
seq: 537
status: done
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:45.653644Z
assignee: claude-opus5.5-s671
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
closed: 2026-11-19T18:31:07.378615Z
closed_by: claude-opus5.5-s671
---

kimi is the CLI's official command name. Rename yoke baseline tool kimi-cli -> kimi with aliases kimi-code, kimi-cli; rename agent bindings/references; update tests and goldens. Accept: bashy tool show kimi and kimi-cli both resolve; targeted unit tests green.
