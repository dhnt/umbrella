---
id: 7da5f9db66e2
kind: feature
title: 'K1 cloudbox: bearer token edit endpoint (PUT /api/v1/tokens/:id)'
seq: 543
status: done
priority: p0
labels:
    - tokens
created: 2026-11-19T19:55:21.079423Z
assignee: claude-opus5.5-s672
sprint: 672
sprint_id: 29ae1f6b-e8b8-5520-be86-51a7c2dd4d8c
sprint_title: Token minting and CLI parity for access tokens
closed: 2026-11-19T20:16:48.867845Z
closed_by: claude-opus5.5-s672
---

CLI parity for the console's token edit (name, scopes, requests per day, route policy). Same rule as bearer revoke: not self; caller must hold the target's current scopes; new scopes must be a subset of the caller's; no admin scopes; OAuth tokens refused; audited as token-update. Tests beside v1 tokens. Built on a worktree off origin/dev (local dev holds others' unpushed work). Production release only with operator go-ahead.
