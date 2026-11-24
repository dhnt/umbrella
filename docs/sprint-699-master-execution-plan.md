# Sprint 699: release train 1, one hosted-plane deploy for Sprints 682 and 697

Epic: software-shaping. State: **backlog** (filed 2026-11-23 on the
operator's direction: "consolidate the deploy for both sprints, create a new
sprint for the deployment, move the stories into the new sprint"; and the
standing rule in `CLAUDE.md`: no hosted-plane deploy per sprint). The card
and its stories are authoritative.

## Primary goal

One coordinated hosted-plane release carries every change merged to dev
since v0.18.82, tested once on the frozen dev commit and deployed once with
the operator's go. The live-site verifications that Sprints 682 and 697
deferred run after it and nowhere else.

## Stories

| # | Story | Store | From | Owner | What closes it |
|---|---|---|---|---|---|
| T1 | Deploy train 1 (`76eac0ea`): contents, pre-release gate once on the frozen dev commit, operator GO, tag, images, master deploy, satellites, live smoke, live checklist | umbrella | new | conductor of this sprint | the cloudbox playbook run once; the live checklist recorded in `sprint-699-evidence.md` |
| A5 | Feel-at-home matrix on the live dhnt.io (`4e147ad3e84b`) | umbrella | Sprint 697 | muse-wonder (proposal) | table per client recorded as observed on the live site, after T1 |
| C4 | Member-principal shaping e2e across the five example apps (`8e5204e127c4`) | bashy | Sprint 682 | conductor | the one approved paid matrix on the retained gate-host installation after Sprint 682 C5 lands; green rows accepted, red rows root-caused |
| I1 | group-shape skill-script (`9c585822`): one Bash# acceptance run on Page, Session and Notepad (roster member admitted, history / undo / restore, removal and outsider refused, guest by name, PDF of a named revision); fills the coverage matrix verdicts | umbrella | group shaping epic (Sprints 684/685) | conductor | green on integrated main at the frozen commits on the gate host, after Sprint 684 S1–S4 merge |
| I2 | Klatch owner/member workflow (`5b72b105`): sync, two members, removal, outsider, repeat sync | umbrella | Sprint 684 | conductor | recorded on the running instance; the operator confirms before it is started |

Sprint 697 A2 itself stays in Sprint 697, accepted on dev evidence (merged,
verified, not live); its live verification is T1's checklist.

## Order

I1 and I2 (added 2026-11-24) do not need the deploy either: they are the
integration tests of the group shaping epic, whose sprints close on unit
tests only (`sprint-684-685-master-execution-plan.md`). I1 waits for Sprint
684 S1–S4; I2 can run any time the instance is up.

C4 does not need the deploy: it runs on the gate host as soon as Sprint 682
C5 is merged, and is only here so that live and e2e verification is planned
in one place. T1 waits for the operator's timing (the next hosted feature or
a cadence). A5 runs after T1 is live.

## Contents of train 1 (hosted plane dev beyond v0.18.82)

- Sprint 697 A2: agent-ready public pages (dhnt/site v0.2.1) and the
  same-origin `/mcp` auth dispatch. `PUBLIC_SITE_MCP_UPSTREAM` stays unset
  until an owner site MCP endpoint is published.
- The Accept tie-break follow-up (absorbed by A2).
- Later hosted changes join as they merge to dev; each adds its live check to
  the T1 checklist.

## Before any tag or release cut: pins at heads (recorded 2026-11-24)

Step-by-step version, with the commands: [handoff-sprint-684-685.md](handoff-sprint-684-685.md).

Sprints 684 and 685 closed with dependency pins that trail their repository
heads, because Sprint 675's coreutils pin sync was still in flight and is the
next writer of all of them. **Nothing is tagged, frozen or cut from this
train until these are confirmed clean**, on the frozen commit:

- `bashy mod drift` at the umbrella root shows no `stale` row. Known stale at
  the time of writing: bashy → bashsharp and ycode → bashsharp (pinned
  `fa2401af`; bashsharp `main` had `abe0538` and `08fabb3`).
- Every umbrella gitlink equals its repository's default-branch head. Known
  behind: bashsharp, coreutils, yoke, outpost.
- The bashy/ycode pair is at its one-commit minimum (those two modules
  require each other, so one side always trails by exactly one pin commit).
- Pin commits are forward only: a new gitlink must contain the one on origin.

Known red tests to carry into the gate as recorded failures, not as passes,
unless Sprint 703 has fixed them first: ycode
`TestHarnessStreamWaitsForAppendNotifications` (bug `08ee6df70b5d`: with a
current bashy the agent's kb lookup gets no context) and `bashy/yoke/fetch`
`TestStandaloneHelpAndDeps` (`bf5c8c71f65e`). Any other failure is new and
blocks. Three ycode timing tests fail only when the gate host is busy
(`5469f847be3f`): run the comparison on an idle lane.

## Gates

- Pre-release, once: container unit suite, desktop-journey e2e with
  `BASHY_TAG` at the latest promoted bashy, primary and satellite vet and
  build, on the frozen dev commit, on the gate host.
- Operator GO before tag and deploy; no release without it.
- Live checklist after deploy: A2 curl matrix through the live edge (Bearer
  to the gateway, cookie or anonymous to 401 or the proxy), dhnt.io
  `/agents.txt` and headers, A5 rows, satellite upgrade and token check.
- Evidence: `docs/sprint-699-evidence.md`, wire-level, hosts by role.

## Not doing

A release per sprint; any bashy release or rc tag; content changes to the
dhnt.io pages beyond what A2 carries.
