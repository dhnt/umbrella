---
id: 770e8b83683e
kind: doc
title: 'H3 public wire and routing: route hosted, routing rule, caller-settled approval, connected accounts; master side as a cloudbox ticket'
seq: 665
status: todo
priority: p1
labels:
    - bashy-hosting
    - wire
created: 2026-11-23T13:18:04.340436Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Planned vendor: muse (doc); the master-side ticket is filed by the operator and referenced here by id, never quoted. Add the hosted section to docs/vendor-chat-gateway-mvp.md: route: hosted beside sync|pull; rule = live paired outpost -> sync; registered caller with no host or host offline -> hosted; owner-host-bound verbs (an app that lives on someone's outpost) -> pull as today; per-call identity payload (caller, task_id, idempotency_key, secrets_token; versioned, signed, short TTL) and secrets:read token minting; hosted gated calls settle by the CALLER on the master (approve); audit mcp-hosted; runner registration (how the master provisions the runner verification key); connected accounts: the portal consent step completing the user's own bring-your-own-project OAuth client (web redirect to the master) and writing the refresh token to the user's vault under google/<acct>/credentials. Accept: section reviewed by the cloudbox owner; ticket id recorded on this story. Spec: docs/sprint-691-master-execution-plan.md
