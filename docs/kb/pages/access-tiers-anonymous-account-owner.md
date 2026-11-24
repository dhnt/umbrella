---
id: 01a20ecf-5e6e-7bfa-a9bc-3cd6052dd25d
seq: 22
form: page
type: decision
title: 'Access tiers: anonymous, account, owner; relationships anonymous, account, member, owner'
description: 'WHEN deciding who a caller is or what they may change in cloudbox, outpost, bashy or a shaped app: three levels (anonymous, account = logged-in cloudbox account without a live host, owner = account with a paired host; a satellite is a kind of outpost), four per-host relationships on the outpost stamp (anonymous < account < member < owner; wire value signed-in becomes account), ''user'' means the OS user only, authorization is always cloudbox''s, anonymous visitors configure declared features and never code, group and team shaping are one workflow on the owner''s host with the owner''s LLM.'
tags:
    - shaping
    - access-tiers
    - cloudbox
    - outpost
status: validated
evidence: docs/access-tiers.md; operator decisions 2026-11-24; Sprint 706 R3
source:
    tool: claude-fable5.1
created: "2026-11-24T18:26:40Z"
updated: "2026-11-24T21:33:21Z"
---

Design of record: umbrella docs/access-tiers.md (operator decisions 2026-11-24). Levels are per person (what they have with cloudbox) and decide the gateway route: anonymous none, account hosted, owner sync (hosted while every host is offline). Relationships are per caller x host owner and come only from the cloudbox identity stamped by outpost (X-Outpost-Relationship, v2 HMAC) and verified by yoke coopauth; apps, CLI and MCP consume them unchanged and fail closed downward. Level never implies relationship and vice versa. Identity is mandatory for any kept change. Code shaping needs owner or named maintainer on that app and the owner's host as venue; public surfaces are configuration-only for non-owners. Team shaping = group shaping with contributing owners as members of the primary owner: one shared line, candidates per requester, rebase and re-verify before approval, owner plus named maintainers approve, no team scope, no driver lease. One owner on many devices shapes the app's host remotely (gateway run shape, site MCP), no per-device line. Gaps and their stories: Sprint 706 R1 (stamp word), R2 (account tier through a satellite, cloudbox admission rung), R5 (granted member shapes on the owner's host), R7 (consented access request, the account to member path). Retired 2026-11-24 by this model: Sprints 639, 640, 667, 669, 679, 689.
