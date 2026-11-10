---
id: 1c1e91f0b235
kind: feature
title: S2 Decouple primary host identity from satellite attachments and retire master-token split-brain
seq: 70
status: todo
priority: p0
labels:
    - satellite
    - outpost
    - fleet
created: 2026-11-10T01:43:06.806217Z
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S1.

Scope
- Keep Outpost's primary agent.json anchored to the host owner's canonical Master / home portal account so bashy coordination (MB, inbox, sprint, fleet) always authenticates via the primary host identity.
- Introduce a dedicated satellites[] (or attachments[]) configuration list in Outpost for secondary satellite endpoints and credentials so attaching to a satellite never overwrites the primary agent.json or breaks Master authentication in yoke/pkg/fleet/pairing.go.
- Keep ~/.config/bashy/master-token as a read-only legacy fallback during transition and deprecate bashy fleet master-token save/mint.

Acceptance
- Attaching a host to a satellite preserves primary Master coordination without requiring a separate master-token file.
- Account discovery in yoke/pkg/accounts/adapters/cloudbox enumerates both the primary host account and all attached satellites from canonical Outpost config.
