---
id: 1e7e2a1dded0
kind: bug
title: 'cligw: a client that aborts a request trips the binding''s breaker; a hung vendor turn has no deadline'
seq: 855
status: todo
priority: p2
created: 2026-11-28T00:51:44.250647Z
---

Found 2026-11-27 in the Sprint 738 acceptance drill on the dev box. One contained run with claude-opus5.5 hung for more than 8 minutes: the door had routed a request and the vendor CLI turn never finished (no usage line after the routing decision). After the caller was stopped with SIGTERM the door refused the next session open for that binding with 'breaker cooldown'; restarting the session door cleared it. Two defects to root-cause separately: no per-turn deadline on a vendor worker, and a caller abort counted as an upstream failure. Evidence: private Sprint 738 drill notes.
