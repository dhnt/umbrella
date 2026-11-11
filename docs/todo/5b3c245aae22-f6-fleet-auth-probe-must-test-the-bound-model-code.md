---
id: 5b3c245aae22
kind: bug
title: F6 Fleet auth probe must test the bound model (codex-gpt6.1-sol unusable)
seq: 127
status: todo
priority: p3
labels:
    - collaboration-followup
created: 2026-11-11T09:56:32.352425Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Host todo 641d697b: weave fleet --auth reports codex READY, but agent codex-gpt6.1-sol fails at the first call (400 model_not_found with a ChatGPT account), which cost a Sprint 614 relaunch. Probe the agent's bound model, not just the tool, and drop or rebind the agent on hosts where it cannot run.
