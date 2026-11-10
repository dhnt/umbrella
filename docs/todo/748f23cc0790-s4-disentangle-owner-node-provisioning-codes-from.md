---
id: 748f23cc0790
kind: feature
title: S4 Disentangle owner node-provisioning codes from satellite member invitations
seq: 72
status: todo
priority: p1
labels:
    - satellite
    - cli
    - fleet
created: 2026-11-10T01:43:06.59031Z
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S2, Sprint 568 D2/D3.

Scope
- Separate hardware node-provisioning (host:invite-mint, which registers an owner-controlled node) from satellite member collaboration invites (which grant another human/agent account membership on a satellite so they attach their own Outpost under their own account).
- Make CLI verbs, flags, and output explicit across bashy satellite and bashy paired-host so operators never hand an owner-scoped host pairing code to another member.
- Retire bashy/examples/satellite-member/satellite-member.bsh in favor of first-class CLI flows.

Acceptance
- Node-provisioning commands explicitly label owner-transferred host registration.
- Member invitation and attachment preserve the member's own host ownership while granting mutual satellite visibility and app sharing.
