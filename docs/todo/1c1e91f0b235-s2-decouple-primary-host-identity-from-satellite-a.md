---
id: 1c1e91f0b235
kind: feature
title: S2 Decouple primary host identity from satellite attachments and retire master-token split-brain
seq: 70
status: assigned
priority: p0
labels:
    - satellite
    - outpost
    - fleet
    - satellite-cli
created: 2026-11-10T01:43:06.806217Z
assignee: claude-opus5.5
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S1.

Scope
- Pairing with cloudbox (the master) is the host's identity record only: owner account + host, stored in the master DB. It needs no satellite and opens no tunnel; the master keeps running no tunnel and no host routes (checked in code: master mode registers no /matrix, /v1, register, fleet, peer, mb or sprint routes). Everything that works today keeps working the same way: tunnels, app URLs, ssh/desktop/files, the /v1 LLM gateway and the coordination verbs (mb, inbox, sprint, fleet) are served by a satellite or a standalone server and need an attached one. Today the master cannot pair a host at all (/api/register/exchange is 404 there); the master-side record is part of the cloudbox ticket.
- Introduce a dedicated satellites[] (or attachments[]) configuration list in Outpost for secondary satellite endpoints and credentials so attaching to a satellite never overwrites the primary agent.json or breaks Master authentication in yoke/pkg/fleet/pairing.go.
- Design decision (operator, 2026-11-09): an outpost pairs ONCE, with cloudbox under the user's email account. That pairing is the host's identity and ownership everywhere; satellites are attachments of the account (membership), never a second pairing.
- Today a member pairs on the owner's satellite with a code from their own account there (verified in code; the satellite records the host with the master's host-to-satellite assignment), which points agent.json at the satellite and leaves master coordination to master-token. Such hosts migrate: they pair once with cloudbox and the satellite becomes an attachment; existing satellite-primary agent.json keeps working until migrated.
- Keep ~/.config/bashy/master-token as a read-only legacy fallback during transition and deprecate bashy fleet master-token save/mint.

Acceptance
- Attaching a host to a satellite does not overwrite the host's cloudbox pairing; coordination verbs reach the attached satellite (the coordination base) without a separate master-token file.
- A host paired once with cloudbox and attached to a satellite reaches that satellite's features (apps, coordination) with no master-token file and no satellite pairing code, and stays owned by its account. A host paired with cloudbox but attached to nothing has the same features as an unpaired host plus its account record.
- Account discovery in yoke/pkg/accounts/adapters/cloudbox enumerates both the primary host account and all attached satellites from canonical Outpost config.
