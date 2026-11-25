# Sprint 699: release train 1, one hosted-plane deploy

Epic: software-shaping. Release and sprint manager: claude-opus5.5 (taken
2026-11-24). The card and its stories are authoritative. Reconciled
2026-11-24 22:15 PST against the board, the hosted dev branch since v0.18.82,
the public repositories, and the managers of Sprints 708, 709 and 710 plus
the A/O/C scope conductor.

## Release rules (operator, 2026-11-24)

- KISS/MVP. Every released feature is **complete and usable**, even if it is
  minimal. An unfinished or unusable surface is never released. When part of
  a feature can ship, ship that part and put the rest in a follow-up sprint
  (Sprint 711 for this train).
- Scope is the typical business case A/O/C only: owner, support member
  without an outpost, and contractor member with an outpost. Anything else is
  future input.
- One deploy per train. No bashy release in this train.
- Every issue in this sprint is resolved, or it goes to the operator for
  approval with an explanation.
- No HUAT (operator, 2026-11-24): no human user acceptance tests. Every live
  check is agent-run, with sandbox or test accounts. The operator's GO is a
  release decision, not a test.

## Feature list: train 1 (hosted plane, dev beyond v0.18.82)

| # | Feature | Source | Usable from released clients? | Live check |
|---|---|---|---|---|
| 1 | Agent-ready public pages on dhnt.io: agents.txt, Markdown/JSON twins, skill.md, citations, Accept tie-break | 697 A2 (d80f551b) | Yes, any HTTP client or agent | `/agents.txt`, twins, headers, Accept matrix through the live edge |
| 1a | The same pages **without** the `/mcp` and `bashy site attach` advertising | 699 A2a (141bc34d) | Withholds what isn't usable yet (see below) | No `mcp:`, server card, `service-desc` or site-attach line on dhnt.io |
| 1b | Same-origin `/mcp` dispatch: Bearer to the gateway, anonymous/cookie denied while no upstream is set | 697 A2 | Yes, for Bearer callers (existing gateway) | A2 curl matrix |
| 2 | Client IP trust: no proxy trusted by default; platform client-IP header on the hosted deploy | 710 H4 (c7e970e6) | Infrastructure | Audit and rate-limit keys show real client addresses; a forged X-Forwarded-For changes nothing; roll back the env setting if the header is missing |
| 3 | Master host shares projected to attached satellites (grant and revoke) | 710 H5 (f095ebc7) | Yes: the share dialog in the released master console | Share on the console, member admitted on the satellite before first sign-in; revoke, member denied after the next sync |
| 4 | Re-invite re-sends the invitation email to a pending member | 710 (e22d0e55) | Yes: console, or `fleet member invite` in released bashy | Re-invite a pending test member; mail delivered |
| 5 | Signed-out satellites show a minimal "Sign in to <satellite>" page, with no master marketing and no owner disclosure | 710 (b7519dfa) | Yes, browser | Signed-out GET `/` on a satellite |

Public-side features that need no hosted change (709 `bashy mcp connect`,
the site MCP `shape_pull`/`shape_push`, 708's browser fix) ship with bashy
releases, not with this train. 709 confirmed that their hosted endpoints are
already live in v0.18.82.

### Held back (operator rule) and moved to Sprint 711

- **Site MCP on dhnt.io** (711 F1, daf6adc9). With `PUBLIC_SITE_MCP_UPSTREAM`
  unset, every anonymous agent that follows the advertised `/mcp` would be
  denied. A2a removes the advertising; F1 publishes the endpoint and turns the
  advertising back on in one change.
- **`bashy site attach`** (711 F2, 507e2cab). The verb first appears in
  bashy 775bcc30 (2026-11-23), and no released bashy has it (latest
  v1.0.0-rc.40-dev). It is re-advertised once a release carries it.
- **C4**, the five-app member matrix (8e5204e1, from 682). Blocked on O0
  b23982703c71. The A/O/C member path is already covered by the 706/709
  sandbox e2e plus the operator's real test.
- **I1**, the group-shape script (9c585822, from 684). It needs no deploy.
  It runs as a follow-up integration run on integrated main.

### Out of scope (unlinked, kept as future input; operator approval requested)

- I2, the Klatch owner/member workflow (5b72b105): outside A/O/C.
- The hosted-route test case (dfd4ebb8) and the H6b live smoke. The master
  side of the hosted route (hosted ticket eed85934) is not built, and the
  feature is outside A/O/C.

## Stories in this sprint

| Story | What closes it | Owner |
|---|---|---|
| A2a 141bc34d (p0) | Merged to the hosted dev branch before the freeze; unit tests assert absence when off and presence when on | worker, to be assigned after the operator approves |
| T1 76eac0ea (p0) | Freeze, gate once, operator GO, deploy, live checklist recorded in `sprint-699-evidence.md` | release manager |
| A5 4e147ad3 (p1) | Feel-at-home matrix on the live dhnt.io after T1, minus the MCP and site-attach legs (in 711) | muse-wonder (proposal) |

## Cutoff and freeze (set by the release manager)

- **Content cutoff:** 2026-11-24 22:15 PST. After it, only A2a and
  test-only harness commits may merge to the hosted dev branch.
- **Freeze target:** 2026-11-25 12:00 PST, announced as `699 FREEZE` on
  bashy mb. After it, no pushes or pin bumps to the hosted dev branch, bashy,
  yoke, ycode, bashsharp or the umbrella without asking the release manager.
  Acknowledged by the 708, 709 and A/O/C managers; 710 was asked on mb.

### Freeze preconditions (all must hold on the frozen commit)

1. A2a is merged.
2. `bashy mod drift` shows no stale row. Open at the cutoff:
   ycode → yoke and bashsharp → yoke (pinned 25ec97b5, head 39aef5bc).
   710 finishes this by 10:00 PST or hands it to the release manager, who
   does it under a claim. Whenever bashy's yoke pin moves,
   `internal/agentos/src_mount.go` `srcModulePins[yoke]` moves with it.
3. The bashy/ycode cycle is at its one-commit minimum.
4. Every umbrella gitlink equals its repository's default-branch head,
   moving forward only. At the cutoff, all are at head except bashy
   (98551856, head 2f238cc3 and later; kb- and README-only commits on top).
5. Clean repos: no uncommitted or unpushed work in any checkout used for
   the train. Local branches and worktrees with unintegrated patches are
   merged, pushed, or explicitly kept by their owner. Nothing with unique
   commits is deleted. Kept by their owner (708) as evidence: umbrella
   `sprint-704-yoke-pin-2615421d`, yoke `s704-p0b-candidate` and
   `s704-p0c-candidate`. Still open at the cutoff: umbrella
   `sprint-704-yoke-pin-2615421d`; yoke `s704-p0b-candidate` and
   `s704-p0c-candidate`; hosted worktree `s652/6210caba`; hosted
   `s710-h6-cand` (710, in flight); one untracked hosted todo from the
   rc.40 release (Sprint 692).

## Gates

- **Pre-release, once, on the frozen dev commit, on the gate host:**
  container unit suite, desktop-journey e2e with `BASHY_TAG` at the latest
  promoted bashy, and vet + build for primary and satellite, run as parallel
  legs on an idle lane.
- **Known reds** go in as recorded failures, never as passes:
  - ycode 08ee6df70b5d (wontfix).
  - bashy/yoke/fetch bf5c8c71.
  - bashy agentos 60d43cb7 and 01b745b8.
  - Hosted hub 376365ab: three feed JS cross-checks and one satellite route
    table test. Not yet root-caused; operator approval requested.
  - ycode timing tests 5469f847 (fail only on a busy lane).

  Any other red blocks the train, and its root cause is found first.
- **Operator GO**, recorded on the card, comes before the tag.
- **Deploy** per the hosted playbook: tag, images, master, satellites, live
  smoke. Satellite upgrades need the registry token rotated first (hosted
  todo 4af1cde, an operator credential action). Without that, feature 3 is
  not usable on satellites.
- **Live checklist:** the "Live check" column above, plus A5. Evidence goes
  in `sprint-699-evidence.md`: wire level, hosts by role.

## Not doing

A release per sprint. Any bashy release or rc tag. dhnt.io content changes
beyond what A2 and A2a carry.
