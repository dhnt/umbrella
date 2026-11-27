---
id: 683009b494ce
kind: feature
title: 'K4 offer verbs: bashy offer / offers / remote, composing peer add/share/limit/revoke + llm share, offered-by hint'
seq: 832
status: todo
priority: p1
created: 2026-11-27T15:34:19.619768Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K4. One sharing model for humans and agents (operator 11-27): an offer is an app of the host with an agent surface, shared with the existing audience rule (outpost apps share APP --circle/--group/--email); the door admits by the caller's stamp + member token (Sprint 709 exchange on the satellite), not peer:NAME credentials. Offerer: bashy offer CMD [--circle|--group|--email] [--limit] [--for], offer list/stop; offer llm = the existing llm app. Consumer: bashy offers [HOST] (command apps shared with me), bashy remote HOST -- CMD. Missing/unconfigured command errors name offering members. Verify the satellite stamps door routes for members; if not, that is the one outpost change. Also inspected: outpost/cmd/outpost/apps_share.go, yoke pkg/fleet share_who_cmd.go, docs/access-tiers.md. Code inspected 2026-11-27: yoke pkg/broker peercmd.go share.go peerlimit.go model_source.go.
