# Sprint 709: member pull/push from the member's own machine

Sprint UUID: `b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2`. Epic: software-shaping.
Spec: `docs/access-tiers.md`. Follows Sprint 706 (shaping scopes, A/O/C).

## Why

A team inside one company often spans circles (business owner and analyst,
operations, dev). A developer must be able to work on the owner's app from
their own machine with their own tools: pull the owner's version, change it
locally, push a patch, and have the owner approve it (operator, 2026-11-24).

## Who decides what

Permission is the owner's and stays per app: the satellite admits a member
only where the owner's share covers them, the owner's outpost stamps the
member's circle and groups from the owner's member list, and the Sprint 706
scopes decide what the member may do. Cloudbox only proves identity: the
member's own account token, exchanged on the satellite for a short-lived
`host:proxy` token, carries exactly what their browser login carries. No OS
password anywhere, and no cloudbox change.

## Stories

| # | Story | Repos | Depends on |
|---|---|---|---|
| M1 `9a05b486f0b3` | `bashy mcp connect`: a local MCP client reaches the owner's site MCP with an exchanged token | yoke, bashy | none |
| M2 `b15e7074d8ba` | site MCP `shape_pull` and `shape_push` (patch + base, stale base refused, verified on the owner's host, owner approves) | yoke, bashy | none |
| M3 `b5ea4df67b8f` | A/O/C sandbox e2e adds C pull, local edit, push, O approves (acceptance) | bashy | M1, M2 |

M1 and M2 run in parallel; M3 after both. Every story carries a dated "Code
inspected" note. Unit tests on the gate host; the sandbox e2e is the
acceptance; then the operator runs the real test. No release.
