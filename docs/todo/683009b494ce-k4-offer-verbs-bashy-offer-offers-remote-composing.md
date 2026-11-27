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

Plan: docs/sprint-739-master-execution-plan.md §4 K4. Offerer: bashy offer CMD [--to MEMBER|--circle NAME] [--limit] [--for], offer list/stop; offer llm = existing inference share. Consumer: bashy offers [PEER], bashy remote PEER -- CMD (alias of tool cmd run --peer). Missing/unconfigured command errors name offering peers. Record whether cloudbox exposure + --print/door import suffices for a non-owned member host. Code inspected 2026-11-27: yoke pkg/broker peercmd.go share.go peerlimit.go model_source.go.
