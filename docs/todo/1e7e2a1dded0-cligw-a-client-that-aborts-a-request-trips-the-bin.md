---
id: 1e7e2a1dded0
kind: bug
title: 'cligw: a client that aborts a request trips the binding''s breaker; a hung vendor turn has no deadline'
seq: 855
status: done
priority: p2
created: 2026-11-28T00:51:44.250647Z
closed: 2026-11-28T01:36:53.520664Z
---

Found 2026-11-27 in the Sprint 738 acceptance drill on the dev box. One contained run with claude-opus5.5 hung for more than 8 minutes: the door had routed a request and the vendor CLI turn never finished (no usage line after the routing decision). After the caller was stopped with SIGTERM the door refused the next session open for that binding with 'breaker cooldown'; restarting the session door cleared it. Two defects to root-cause separately: no per-turn deadline on a vendor worker, and a caller abort counted as an upstream failure. Evidence: private Sprint 738 drill notes.

Root cause and outcome (2026-11-27). Two claims, checked separately in yoke `pkg/cligw`.

1. **A caller abort trips the breaker: product defect, fixed.** When the caller's request context ends, the worker is killed and the backend answers 502 (`TestAgentBackendClientCancelKillsWorker` asserts exactly that). `route` in `server.go` tripped the agent's breaker on any status of 500 or more, without looking at why. Fix: yoke `4c70844e`, the breaker counts a 5xx only while the caller's own context is live; the door's own request timeout is set on a derived context and still counts. Unit test `TestCallerAbortDoesNotCountAgainstAgent`. bashy pin `1b8320e4`.
2. **"A hung vendor turn has no deadline": not a defect, the claim was wrong.** `DefaultRequestTimeout` is 10 minutes end to end (`server.go`), applied to every routed request. In the drill I stopped the run after about 9 minutes, before it fired. Why that one claude turn stalled is not known: it was seen once, passed on retry, and was not reproduced. Not chased.
