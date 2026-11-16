---
id: 3fc5f21fac12
kind: test
title: 'Live vendor-chat acceptance: Claude, ChatGPT Work and Gemini sign in to the production gateway and drive hosts, run, delegate and approve'
seq: 377
status: todo
priority: p1
labels:
    - vendor-gateway
created: 2026-11-16T04:31:50.242295Z
---

Carry-over from Sprint 646 E1 (a0a72ad338de). The automated half is done: the gateway-mvp fleet scenario passed (162 checks) and production v0.18.74 answers discovery and the /mcp 401 challenge. This half needs the operator's own vendor accounts.

Steps, following docs/client-setup-claude.md, docs/client-setup-chatgpt-work.md and docs/client-setup-gemini.md:
1. Add https://ai.dhnt.io/mcp as a custom connector or app in each client.
2. Complete the OAuth consent.
3. Call hosts, run (a read verb), delegate (one worker with a valid subscription) and approve (a gated verb); resume the task from a second client.
4. Record the open live checks listed in the guides: the ChatGPT callback, Gemini DCR acceptance, and mobile reuse.

Record evidence (no tokens) and any gaps as follow-up stories.
