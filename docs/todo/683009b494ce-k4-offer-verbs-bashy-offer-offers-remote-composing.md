---
id: 683009b494ce
kind: feature
title: 'K4 offers as gated apps: bashy offer/remote, door admits signed member stamps per offer-NAME app'
seq: 832
status: todo
priority: p1
created: 2026-11-27T15:34:19.619768Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K4. One sharing model (operator 11-27): bashy offer NAME [--circle|--group|--email] [--limit] [--for] registers app offer-NAME on the door port with require_login + trust_cloud_identity and adds the audience via existing outpost apps share; offer llm = offer-llm (inference only); existing llm app and /k/ peers untouched. Door authorize: new branch when no credential + ArrivedViaCloud + VerifyOutpost/VerifyRelationship with that app's SSO secret + member/owner; X-Forwarded-Prefix app must match the offered command; principal member:EMAIL gets peer route limits and caps. Consumer: bashy remote HOST -- NAME, llm env --from HOST --member via SatelliteTokenSource (relax URL checks keycmd.go ~104, satellite_exchange.go:39). Fix share.go:249 login flip-back for gated apps. Discovery listing out of MVP: offer prints the consumer line to post with bashy mb. Code inspected 2026-11-27 (revised after review): yoke pkg/broker broker.go:299-326 peershare.go selfservice.go:211 share.go:190-265 keycmd.go, pkg/coopauth coopauth.go:234,271, pkg/fleet satellite_exchange.go; outpost internal/agent apps.go:238-252,633-728,1196-1209 grants.go.
