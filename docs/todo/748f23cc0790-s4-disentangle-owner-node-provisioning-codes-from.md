---
id: 748f23cc0790
kind: feature
title: S4 Disentangle owner node-provisioning codes from satellite member invitations
seq: 72
status: assigned
priority: p1
labels:
    - satellite
    - cli
    - fleet
    - satellite-cli
created: 2026-11-10T01:43:06.59031Z
assignee: opencode-glm-5.3
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S2.

Scope
- Separate hardware node-provisioning (host:invite-mint, which registers an owner-controlled node) from satellite member collaboration invites (which grant another human/agent account membership on a satellite so they attach their own Outpost under their own account).
- Make CLI verbs, flags, and output explicit across bashy satellite and bashy paired-host so operators never hand an owner-scoped host pairing code to another member.
- With pair-once (S2/S3), host pairing codes exist only for pairing with cloudbox; joining a satellite is membership + `outpost satellite attach`, so a member never handles a satellite pairing code. Owner node-provisioning (a code that makes the owner the host owner) stays a separate, explicitly labelled verb.
- Keep bashy/examples/satellite-member/satellite-member.bsh: it is the tested member onboarding skill-script (S587 e2e) and the base for persona onboarding (S604). Move its key safety rule into the verb it wraps: pairing refuses (or demands an explicit `--as-owner-node` acknowledgement for) a code minted by an account other than the one the user is signed in as, and says whose host it becomes. The script then only calls the verbs; its skill text shrinks accordingly.
- Sprint 568 D2/D3 is design-only and not a blocker: the S587 own-account decision (members pair with their own account, mutual membership, never a satellite-owner code for a member host) is the rule implemented here; S568 D2 records it.

Acceptance
- Node-provisioning commands explicitly label owner-transferred host registration.
- Member invitation and attachment preserve the member's own host ownership while granting mutual satellite visibility and app sharing.
- satellite-member check/pair/harden/publish/diag keep working (its go test passes; the S587 members e2e stays green).
