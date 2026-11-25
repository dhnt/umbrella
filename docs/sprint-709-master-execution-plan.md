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
acceptance (operator rule 2026-11-24: no human user acceptance tests). No release.

## Outcome (2026-11-24)

Closed on the M3 acceptance: the A/O/C sandbox e2e (fake accounts, stub agent, official image) passed 62/62 checks twice on the gate host (44 existing + 18 new). No release.

| Story | Merged | Evidence |
|---|---|---|
| M1 `bashy mcp connect` | yoke `ac3d3841`, bashy `30fe0121` | gate-host unit run: yoke fleet 1049, dks 4 focused, bashy agentos 136 tests/subtests |
| M2 `shape_pull` / `shape_push` | yoke `4ee516f5`, bashy `1b3d428e` | gate-host unit run: yoke shape 66, bashy site MCP 12, template suite, vet |
| M3 sandbox e2e | bashy `62c8bc99` | two official-image runs, 62/62 each |

Notes:
- The satellite exchange admits a non-owner only when the owner's satellite admits them and they have signed in to that satellite once in the browser; the account token must already hold `satellites:delegate` and `host:proxy`. `bashy mcp connect` names each refusal. The cloudbox fake now models these rules.
- M1's first run timed out at the agy 40-minute print limit; its rebased work was finished by a fresh run.
- Open for the operator: `bashy mcp connect` presents the member's account token to the satellite named in the URL (the exchange needs it). Suggested follow-up: a dedicated token holding only `satellites:delegate` + `host:proxy`, and a check that the satellite is one the account is a member of.

Follow-up (operator, 2026-11-24): todo `e16cbb29`, linked to this sprint. `bashy mcp connect` presents only a per-session child token holding `satellites:delegate` + `host:proxy` (1h, revoked on exit) to the satellite; the account token stays with cloudbox. A hosted "known satellite" check is not possible without a cloudbox change.

Member prerequisites (for users of `bashy mcp connect`):
- The member has signed in to the owner's satellite once in the browser, and their account token holds `satellites:delegate` and `host:proxy`.
- The share must reach the satellite gate. Shares made on the master console are not projected to satellites until Sprint 710 H5 (`f095ebc7`) merges and ships with the release train; until then the owner shares the app on the satellite itself.

No human acceptance test (operator rule 2026-11-24): the sandbox A/O/C e2e (website + Page legs) is the acceptance; owners fix what it misses by shaping.

## Reopened and closed again (2026-11-25)

Reopened 11-24 20:10 PST for operator follow-ups; closed 11-25 with 6 of 7 stories.

| Story | Merged |
|---|---|
| e16cbb29 `mcp connect` sends only a 1h attenuated child token to the satellite | yoke 54ed5dea, bashy c450753f |
| M5 4450ac9097cd 709's two agentos reds (src pin, mcp golden) | bashy 98551856 |
| member setup doc for `bashy mcp connect` | bashy b1d1f9bd |
| M6 b659aecc1daa verifier checks share binmgr's tool cache (BASHY_BIN_CACHE) | yoke ff326a9d |
| pin round for yoke c78fb76d (M6 + 708's comment), agreed with the 699 release manager | bashsharp c86810bc, outpost 37193456, ycode ceb3b2de, bashy b8cce989, umbrella 02521dda5; drift 0 stale |

Moved to Sprint 714 (backlog, operator 2026-11-25: defer, design the right solution later): M4 6ba1b4777931 A/O/C on the Page example (test-only leg at bashy branch s709-m4-page-leg 29927c1e; website leg green, Page green up to C's push) and D1, the pre-existing defect that blocks it: `bashy go` fails in a fresh HOME because the embedded toolchain/go adapter has no sources to build its launcher.
