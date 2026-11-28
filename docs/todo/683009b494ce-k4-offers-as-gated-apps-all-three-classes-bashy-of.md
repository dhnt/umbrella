---
id: 683009b494ce
kind: feature
title: 'K4 offers as gated apps, all three classes: bashy offer/remote, definition route, door admits signed member stamps per offer-NAME app, agent token cap'
seq: 832
status: todo
priority: p1
created: 2026-11-27T15:34:19.619768Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K4. One sharing model (operator 11-27): bashy offer NAME [--circle|--group|--email] [--limit] [--for] registers app offer-NAME on the door port with require_login + trust_cloud_identity and adds the audience via existing outpost apps share; offer llm = offer-llm (inference only); existing llm app and /k/ peers untouched. Door authorize: new branch when no credential + ArrivedViaCloud + VerifyOutpost/VerifyRelationship with that app's SSO secret + member/owner; X-Forwarded-Prefix app must match the offered command; principal member:EMAIL gets peer route limits and caps. Consumer: bashy remote HOST -- NAME, llm env --from HOST --member via SatelliteTokenSource (relax URL checks keycmd.go ~104, satellite_exchange.go:39). Fix share.go:249 login flip-back for gated apps. Discovery listing out of MVP: offer prints the consumer line to post with bashy mb. Code inspected 2026-11-27 (revised after review): yoke pkg/broker broker.go:299-326 peershare.go selfservice.go:211 share.go:190-265 keycmd.go, pkg/coopauth coopauth.go:234,271, pkg/fleet satellite_exchange.go; outpost internal/agent apps.go:238-252,633-728,1196-1209 grants.go.

Review 2026-11-27 additions (plan §3.1, §3.2): bashy offer covers all three classes and runs the K2 eligibility and typed-definition checks first. The offer app serves the typed definition and its digest read-only to the offer's audience (the route T2 reads); bashy offer list --json shows class, unit and digest. The door's prefix-to-offer check is per class: offer-llm admits only inference; a tool offer only its slash=NAME; an agent offer only its agent run. An agent offer takes --token-cap N: a call that reaches the cap stops and is counted for what it used. FIRST check whether the door can stop a running agent on its served-token count (cligw onUsage, server.go:1246); if not, enforce the cap between turns and record that here. --limit counts in the offer's unit (T1). No price, bid or credit flag here: --sgi and --ask are Sprint 740. Accept adds: unit tests for the definition route (audience only), per-class admission (a tool offer refuses inference and another command), the token cap. Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).
