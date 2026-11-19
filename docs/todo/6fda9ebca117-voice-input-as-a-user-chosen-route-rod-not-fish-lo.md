---
id: 6fda9ebca117
kind: feature
title: 'Voice input as a user-chosen route (rod not fish): local, OS, self-hosted or BYOK hosted'
seq: 503
status: wontfix
priority: p1
labels:
    - shaping
    - voice
    - privacy
    - software-shaping
    - superseded
created: 2026-11-19T04:24:21.493852Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
closed: 2026-11-19T14:02:27.723128Z
---

Operator 2026-11-18 (Sprint 615 live run): the Shape page's mic only uses the browser's on-device model (missing in the operator's Chrome), and OS dictation's Fn key is taken by the input-source switch. Voice must be a route the USER chooses, for producers (owner wishes on the Shape page) and consumers (visitors on a shaped site) alike, for their own reasons: privacy, cost, governance, availability. Routes, all opt-in and listable: (1) browser on-device speech; (2) OS dictation; (3) self-hosted on the user's own machine (a local speech model behind bashy llm / outpost, nothing leaves their hosts); (4) BYOK hosted (e.g. Bedrock voxtral on the same OpenAI-compatible endpoint and key as the text route, or any provider the user brings); (5) a pooled route an owner offers their members. Rod not fish: small --json verbs (list routes, set the default per user and per app, test one) plus a declarative policy an owner can set for their site or console (which routes visitors may use, and whether audio may leave the browser or host); the page shows which route is active and where the audio goes, before recording. No route is hardwired; no vendor is the default by fiat; fail loudly with the fix when none is available (see the no-agent banner, 46647e42).

Part of Software Shaping (operator 2026-11-18): the route is shapeable. An owner or visitor shapes it in words like any other change ('dictate with my own speech model', 'never send audio off this machine', 'let my recruiter circle use the hosted route'). The wish maps to the same declared route settings and policy the verbs set, so the verbs and the wish land in one place. The routes and policy are declared, shapeable configuration on public surfaces (638 S10), never code.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. New speech routing/control plane is deferred; preserve existing on-device/OS voice support.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
