# Sprint 689: Shaping sync, one owner on many devices

Epic: software-shaping. State: backlog (filed 2026-11-21, planning only; to be
reviewed with the operator before assigning).

## Why
The 2026-11-21 shaping review grouped shaping support into three workflows:

1. **Individual.** One owner with an outpost and an optional satellite:
   (a) consumer or site visitor, (b) producer or site owner, (c) the same owner
   on several devices.
2. **Group.** The primary owner's outpost or satellite with a list of members:
   real-time shared input editing plus per-app group features (Sprints
   684/685).
3. **Team.** One satellite, with each member owning an outpost: sync and rebase
   onto the primary owner's line plus an approval rule.

1a and 1b already ship: per-person version lines; wish, verify, approve,
undo and restore; release and offer/adopt for web apps. 1c is missing, and
group and team build on it. This sprint delivers 1c.

## Design (agreed 2026-11-21)
- **Optimistic sync.** A push of the line is a compare-and-swap against the
  line's authority: the owner's satellite, or the primary outpost when there
  is no satellite. A stale base is refused with a clear "pull first" result.
  The loser of a race pulls, rebases and re-verifies.
- **Offline.** When the authority is unreachable, work continues locally.
  Pull and rebase run automatically on reconnect.
- **No lock for a single owner.** The person is the baton; compare-and-swap
  settles any race between their own devices. A writer lease is needed only
  when several humans or agents edit one shared draft at once. That is group
  work, filed under Sprint 684.
- **Input.** Speech, pen and other inputs come from the OS or device. To
  shaping they are ordinary text input, so nothing here is input-specific.

## Facts at filing (code reading)
- Promotion tiers are `org` and `upstream` only
  (`bashy/internal/agentos/shape_promotion.go:46`); there is no own-device tier.
- Shaping locks and `bashy claim` are host-local
  (`yoke/pkg/shape/service.go:175,547`; `yoke/pkg/policy/coord/cli.go:133`).
- Offer refuses a released version (known bug; cause not yet recorded).
- Offer/adopt and incident repair are refused for CLI and service apps
  (`bashy/internal/agentos/shape_local.go:115-117`). Deferred; not this sprint.

## Stories
| # | Story | Notes |
|---|---|---|
| D1 | Own-device line remote with compare-and-swap push | reuse `yoke/pkg/shape/promotion.go` Incoming/Pull/Outgoing/Push |
| D2 | Rebase and re-verify local candidates on pull | reuse `yoke/pkg/shape/verify`; keep last known good |
| D3 | Offline work and reconnect catch-up, cross-OS | macOS, Linux, Windows native |
| D4 | Root-cause: offer refuses a released version | cause recorded before any fix |
| D5 | Root-cause: flaky draft DOM tests | `yoke/pkg/webconsole/genie_draft*_dom_test.go` |
| D6 | 1a/1b evidence record | targeted unit tests on the gate host, one shared record |

Group addition: Sprint 684 gains a single-writer lease on the shared draft.

## Non-goals
- Team approval (S640 T8, S625 X1). These come after 689 and 684 land.
- Offer/adopt and incident repair for CLI and service apps; named versions; an automated CLI↔web parity check.
- The hosted MVP (S669), variants and compare, the self-starting resident agent, upgrade-as-repair.

## Verification
Fast unit tests per story. One integration pass at the end: two devices of one owner on the fleet test hosts, each OS. Heavy runs never happen on the dev box.
