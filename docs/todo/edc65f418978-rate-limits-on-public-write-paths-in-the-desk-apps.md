---
id: edc65f418978
kind: feature
title: Rate limits on public write paths in the desk apps (Page join, form submit, board compose) for anonymous traffic
seq: 731
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-25T03:59:09.280108Z
---

Owners publish apps publicly; anonymous visitors (and logged-in non-members, treated as anonymous) can write through Page join, form submit and board compose. examples/desk/page and examples/desk/kit have no limiter today (code inspected 2026-11-24). Add a per-client limit in the kit's shared handler with the owner able to tune it; key on the client address only once the hosted front door passes a trustworthy one (Sprint 710 H4). Filed separately from Sprint 710 by decision 2026-11-24.
