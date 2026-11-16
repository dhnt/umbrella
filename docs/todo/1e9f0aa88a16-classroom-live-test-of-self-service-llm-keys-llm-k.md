---
id: 1e9f0aa88a16
kind: test
title: Classroom live test of self-service LLM keys (llm key) with team2027 students
seq: 383
status: todo
priority: p1
created: 2026-11-16T11:50:01.654446Z
---

Follow-up of Sprint 648 (closed 2026-11-16 on unit tests + live owner-path chain on lern-si). Next week's class: owner runs 'bashy llm self-service on --circle team2027' on the door host; each student (active mutual team2027 member) signs in to lern-si once in a browser, sets BASHY_FLEET_TOKEN to an account token with satellites:delegate, runs 'bashy llm key https://<lern-si>/matrix/h/<door-host>/app/llm' and 'eval "$(bashy llm env --from <door-host> --via cloudbox)"', then chats. Check: usage shows peer:self-<email>; pending students get the accept-invitation refusal; rerun rotates (old key 401); removal from team2027 blocks the next request; 'self-service off' afterwards keeps keys working. Fix any issue root-cause first. Door-host state left by Sprint 648: outpost 8f0d06e (prior binary kept for rollback), door running the b57ccf4f bashy from a staging dir until a release ships it, self-service OFF, lern-si outpost-profile carries the llm app with signed identity. Pending decision: member token onboarding (students need a satellites:delegate account token) may need a simpler path.
