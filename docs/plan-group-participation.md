# Software shaping for group participation

Planning record for the epic, revised 2026-11-20 after the operator's review.
The sprint cards and their stories in `docs/todo/` are authoritative for
delivery order and acceptance. No code is authorized by this page alone.

## The pitch: one world for humans and agents

bashy is all you need. Five unifications, each a rung of the same ladder:

| | Unifies | Carrier |
|---|---|---|
| a | every platform and OS | bash: pure-Go Bash 5.3 plus the POSIX userland |
| b | every language | Bash# |
| c | every app | yoke and software shaping |
| d | every agent and agentic tool | `bashy genie` (Sprint 679) |
| e | everything under one roof | this epic: group shaping |

Group shaping is the groupware layer of every bashy tool and app: the people
and the agents of one circle or team work on the same items, under the same
roles, with the same verbs, on whichever hosts they own. Humans work with
agents, and agents work with agents, as one group. The epic extends
[Sprint 682 consumer shaping](plan-s682-consumer-shaping-example-apps.md)
(per-member versions of a tool) and the owner/producer work planned in Sprint
683 (promoting a version) to a shared item.

## The model: shaping degrades to wiki-style editing on an artifact

For a **tool**, the shaping loop is wish, candidate, verify, preview, approve
for me, undo. For an **artifact** (a document, a board, a storyboard, a poll, a
message thread) the same loop degenerates to wiki semantics:

| Loop step | On a tool (unchanged) | On a shared artifact |
|---|---|---|
| wish | plain-words request | an edit |
| candidate | isolated workspace | a draft |
| verify | declared checks decide | the app's own checks, or none |
| preview | isolated URL, argv or health | the view |
| approve | active for me | a saved revision, visible to the audience |
| undo / restore | previous or any revision | revert to any revision |
| promote | local, team, upstream | not needed: the audience already sees it |

Personal shaping of the tool stays per principal and is untouched. A member
may shape their own Notepad and still edit the team's document in it.

### The shared-item contract (Sprint 684, story G1)

- **An item is an app artifact addressed as `APP/ITEM`** (with the host where a
  host is needed, as the share verbs already address `HOST/APP`). No new noun.
- **Audience uses the existing rule grammar** from Sprint 619: a list of
  `{circles[], groups[], emails[]}` rules, any match admits, empty means owner
  only. The circle is the hard boundary. The share verbs (`share add|ls|rm|who`)
  gain the item path; they do not get a sibling command family.
- **Roles are owner, editor, viewer,** plus whatever the app already names
  (facilitator and participant, organizer and respondent, member and channel
  owner). Role names are the app's; the contract only requires that reads,
  writes and live subscriptions are each checked against one.
- **The console admits, the app enforces role.** Admission on read is the
  console's job, as for shared apps today. Role on write and on live
  subscriptions is checked at the app boundary from the principal the console
  already stamps. An outsider with a forwarded link is refused; a removed
  member's open session loses write, then read.
- **Revisions, not merges.** Every save is a revision with author and time.
  History lists revisions; revert restores one. A save against a stale base is
  refused with both revisions returned, never merged silently. Reopen and
  reconnect show the latest revision. A live merge engine is out of scope; an
  app that already brings one (whiteboard's collab service) keeps it as its
  own concern.
- **Two ways an agent participates (operator, 2026-11-20).**
  - **(a) A human with an agent.** The member drives `bashy <cmd>`, genie or
    delegate; the agent is the member's hands and acts under the member's own
    identity. Not new. It works today and the epic only exercises it (one
    participant in every run acts this way).
  - **(b) A named agent as a participant.** An agent is addressed by name and
    invited to rooms, items and groups like a member. It is an assigned
    agent carrying its member's identity (below). Today agents can be invited to a
    meeting only locally (`bashy meet`), the seat is not tied to circle or team
    admission, cannot act on apps or documents, and does not cross outposts.
    That integration is the new work: Sprint 684 story G5 on one host, Sprint
    685 stories X1 and X2 across outposts.
- **One kind of agent: assigned, always bound to one cloudbox account
  (operator, 2026-11-20).** A member assigns an agent to represent them and
  work on their behalf. It stays local on the member's outpost, is never a
  roster row, and carries exactly the member's identity, admission and
  permissions, with the agent name recorded beside the member in provenance.
  Other participants see it through room or shared-session presence as "that
  member's agent", and `@NAME` resolves to it the same way. When the member is
  removed or demoted, the agent is, by construction. A team-wide agent (a
  secretary, a reviewer) is simply the owner's assigned agent, admitted and
  capped as the owner is. There are no owner-registered roster agents and no
  agent without a person: every agent is associated with one cloudbox owner or
  member email, and its budget follows that person, never the team. No cloudbox
  schema or release is needed.
- **Who may invite (operator, 2026-11-20, chosen to simplify the design).**
  The circle is the only hard boundary, and the circle owner alone decides who
  is in it. **Inside a circle, invitation is open by default: any member of a
  team or item may invite any other circle member, human or agent, into that
  team or item,** with a role no higher than their own. No per-role invite
  capability is introduced. The one escape hatch is a per-team or per-item
  setting the owner can flip to owner-only invites; it is explicit and logged,
  as every guard must be. Agents assigned by a circle member are circle
  members through their owner and can be invited the same way.
- **UI to CLI parity holds for items** as it does for apps: every web action on
  an item has a bashy verb on the same entities with the same JSON and the same
  permissions. A CLI verb needs no page.
- **`@NAME` is the one addressing form (operator, 2026-11-20).** Three layers,
  kept separate: the address (`@NAME`, as `bashy meet` already accepts), the
  resolver (one roster of human members, their assigned agents and local
  bindings), and the carrier chosen by locality: the local room or chat session
  when the recipient is on this host, the cloudbox shared session or herald
  when it is on another outpost. A mention is addressing; it becomes steering
  when a live agent's harness consumes it, and remote steering when the carrier
  crosses hosts. The sender never picks the carrier. Sprint 684 story G6 brings
  mb send, chat steer and item comments to the form; Sprint 685 X1 owns the
  remote carriers.
- **Rod, not fish.** Each step is a small `--json` verb. The acceptance is one
  Bash# skill-script that composes them and runs against any app.

### No cloudbox change (operator, 2026-11-20)

Sprints 684 and 685 change nothing in cloudbox. The constraint that makes this
hold: **item audiences live on the outpost that hosts the app,** as host app
audience rules do today, and are evaluated against circle and team membership
the outpost already learns from the satellite. A member inviting another
circle member to an item writes a rule on that host, not in the relationship
store. Agents are presence, not roster rows; each is bound to one cloudbox account. Cross-outpost steering
uses the shared session and herald as they ship. If X1's inventory finds a gap
that only a cloudbox change can close, it is filed as a follow-up with
evidence, not pulled into these sprints.

### Cross-outpost steering inside one circle (Sprint 685, stories X1 and X2)

The group is not one host. A member's agent runs on that member's outpost; the
circle spans the satellite, several outposts and the sphere. The steering
surfaces already exist and are host-scoped or point to point today:

| Surface | Scope today | Fits |
|---|---|---|
| `chat steer | attach | grant | interrupt` | the host room on one machine | a human steering an agent beside them |
| `sprint session steer | approve | share` | cloudbox shared session, multi-host | a teammate steering or approving a run on another host |
| `herald` (A2A), `herald add` as a fleet binding | peer on someone else's infrastructure | agent to agent across hosts, with `--gate` for a verdict |
| `herald acp` | this machine as an ACP agent over stdio | an editor or a bot driving a remote agent, including over `outpost ssh` |
| `bashy mcp serve` | typed tools and shell sessions | tools and context, not steering |
| `outpost ssh exec | connect | tunnel` | paired hosts through the tunnel or mesh-direct | carrying any of the above to a paired host |

X1 inventories these against one scenario, records which path is integrated
end to end and which is not, chooses the protocol per case by the table above
(ACP for a client driving one agent, A2A for agent to agent, MCP for tools,
the shared session for human approvals), and integrates the smallest missing
link so a circle member on one outpost can steer a teammate's agent on another
under circle admission. X2 is the group e2e: two humans and their agents on two
outposts shape one item and steer each other's agents.

## Sprints

| Order | Sprint | Outcome |
|---|---|---|
| 1 | 684 | The rod, cut to the MVP on 2026-11-24: revisions for a shared item on shaping's own model (history, undo, restore, save against `base_rev`) in the desk kit, delivered on Page and Session first, then Notepad. One group model, the one Klatch already uses: the roster is the app's audience on the host, roles are owner and member, guests join by name at the owner's discretion. |
| 2 | 685 | The `meet poll` ballot fix and the coverage matrix (one row per app, follow-ups filed for what is not small). Cross-outpost steering (X1, X2) left the sprint and waits for Sprint 679. |
| 3 | 699 | Integration, as part of the release train: the group-shape skill-script on Page, Session and Notepad (I1) and the Klatch owner/member workflow (I2). |

Execution plan, story review and the settled decisions:
[sprint-684-685-master-execution-plan.md](sprint-684-685-master-execution-plan.md).
Where it differs from the contract above (no item path or role on the share
verbs, no per-item role, agent members and `@NAME` not scheduled), that page
and the sprint cards win.

Sprints 686 and 687 were folded into 685 on 2026-11-20; their stories kept
their identities and moved.

### Delivery rules

- Distinct fake identities for owner, editor, viewer and outsider; several
  accounts, including a satellite owner who is not the host owner. The venue is
  the fleet-mirror on a throwaway instance or the gate host, never the dev box.
- One participant in every run acts through its member's agent, so the
  "agents are hands" rule is exercised, not asserted.
- Each app in Sprint 685 gets one row: works, small fix landed, follow-up filed
  with evidence, or read-only not applicable. Only small baseline-proven fixes
  land in the sprint. Nothing is pre-authorized across all apps.
- Reuse first: the share rule grammar, `app pair --principal`, the desk kit,
  `notepad export --to pdf`, Form's multi-respondent mode, `meet poll`,
  brainstorm's facilitator controls, whiteboard's collab service, Klatch roster
  sync, cloudbox shared sessions, herald.
- Root cause before any fix. A venue failure is fixed in the venue.

### Dependencies and prerequisites

- Sprint 682 (in flight) gives the shaped-app registration pattern. Brainstorm
  runs today with no accounts and no principal, so its roles need that step.
- Sprint 683 (owner promotion) is not needed for group items.
- Sprint 679 (genie, One Agent) is a **precondition of Sprint 685**, not of
  684: X1's agent-to-agent path across outposts and the remote carrier for
  `@NAME` mentions need the inbound A2A v1.0 server over the shared SessionHub
  that 679's coserve-protocols goal delivers (herald is outbound only today).
  X1 may start its inventory before it lands; X2 may not. 684 and 679 run in
  parallel, 685 after both. The 679 card stays in the agentic-harness epic;
  recorded on both cards 2026-11-20.
- The Klatch instance lives in the gate host's container machine, which does not
  restart after that host's resets (todo ab6b9b87); the operator owns it and
  confirms before it is started.

### Risks

- Scope creep back into live merging. The contract says revisions and refused
  stale saves; whiteboard's own collab is the only exception, and it is not ours.
- Identity on LAN-only apps (brainstorm, session display) until they are shaped
  apps behind the console.
- Table is Linux only, against the cross-OS parity rule; it is a recorded
  exception row, not a blocker.
- Cross-host steering touches cloudbox, outpost and yoke. Public builds must not
  need private source; the shared session is used only through its public wire
  contract.

### Non-goals

Live CRDT or OT co-editing. New collaboration apps. An agent principal.
Promotion of items to upstream. Any release.

Future note: should agents one day be recognized as individuals in their own
right, the only change is at the binding, an agent becomes its own principal in
the roster instead of riding a person's; apps, share rules, `@NAME` and the
skill-script are untouched.
