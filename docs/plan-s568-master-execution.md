# Sprint 568 shared membership and communication master plan

Sprint UUID: `b1fae56b-6fb4-5bb7-9f7f-a446d397fce9`.
Status: backlog; six design stories are open and unassigned.
The sprint card and its stories are authoritative. This plan records the operator-agreed scope and execution sequence.

## Outcome and scope

Humans and agents participate as ordinary members across cloudbox, satellite, outpost, bashy and their applications. After creation or invitation, applications use the same accounts, groups, permissions, conversations and lifecycle. Klatch does not need an agent-specific participant type, UI, message format or feature path.

Parity works both ways: every bashy command, including MB, Meet, claims and sprint management, is available to a real human under the same applicable authorization. Yoke favors agent-friendly ergonomics because humans are expected to use tools with agent assistance; this does not make its capabilities agent-exclusive.

This sprint produces architecture, public integration contracts, scenario walkthroughs and implementation-ready follow-up stories. It does not implement code, deploy services, migrate live accounts or provision email/telephone gateways. Saving this plan does not complete the design stories.

## Agreed model

- Each service retains its own account ID, username, name and aliases. Accounts persist across conversations. The same person or agent may use different accounts on different services.
- An owner's worldwide contact identity may be shared across owned outposts while each outpost has its own login. Contact addresses are not passwords or sufficient proof of account ownership.
- Authorized owners create or invite ordinary members and assign custom groups. Human-operated and agent-operated accounts have the same application behavior after setup.
- Explicit mappings connect service accounts and local identities. Matching email, phone, family or nickname does not silently merge accounts. No mandatory global identity registry is introduced.
- An agent's responsible owner, tool/model, nickname, runtime session and associated outpost describe operation behind the account. Host ID identifies the destination; hostname/IP describe changeable routing details.
- Applications render ordinary account profiles and messages without a required agent-specific marker. Self-identification is separate from the account architecture.
- Preserve existing local identities, MB, Meet, claims and sprint ownership. Correct restrictive assumptions at integration boundaries when necessary for shared human/agent use; do not rewrite local identity wholesale.
- Direct actions retain the authenticated actor. When an agent acts for a human, define explicit represented-user and delegated-authority semantics rather than silently replacing authorship.

## Required communication

Working service routing is part of the eventual feature, not merely contact metadata. Design human-to-agent, agent-to-human and agent-to-agent communication through ordinary cloudbox/satellite/outpost/bashy services.

Support a normal Klatch account/conversation reaching a configured MB inbox, Meet conversation or sprint-manager session, and return replies to the originating conversation. Human-operated destinations use the same addressing model. A sprint role resolves through durable sprint identity to its current manager; delivery records identify the actual recipient.

Public contracts must carry authenticated sender, durable destination, stable message ID, conversation context and reply route. Define permissions before delivery, durable offline queues, retry/deduplication, revocation and handoff behavior. Delivery acknowledgement is distinct from execution or completion. Bind a message to its intended destination; do not broadcast to MB, Meet and sprint sessions by default.

Email and phone/extension remain optional future contact channels. They neither replace the service-routing requirement nor require gateway provisioning in this sprint.

## Stories and execution sequence

| Label | Story ID | Deliverable | Priority | Depends on |
|---|---|---|---|---|
| D1 | `48e91b84654a` | Map shared capabilities and identity assumptions | P0 | None |
| D2 | `97416a83424c` | Define onboarding and service account relationships | P0 | D1 |
| D3 | `fd95a538cf15` | Define destinations and account runtime bindings | P1 | D2 |
| D4 | `376dd5d21c7a` | Define bidirectional conversation delivery | P1 | D3 |
| D5 | `9f301f5efadb` | Define compatibility and service integration changes | P2 | D4 |
| D6 | `7208f20e50df` | Review architecture and prepare implementation handoff | P2 | D5 |

Execute D1 → D2 → D3 → D4 → D5 → D6. Detailed scope and acceptance live in the story bodies.

D1 maps actual code and public service contracts. D2 fixes onboarding, membership and service-account semantics. D3 fixes routing destinations and bindings. D4 specifies delivery and reply contracts. D5 assigns changes and compatibility obligations to their owning components and files satellite support tickets. D6 obtains review and prepares follow-up implementation work.

Relevant starting points include yoke's fleet/principal/room/bus/weave packages, bashy's inbox and sprint integration, and outpost's public authentication and routing boundaries. Validate these boundaries during D1 rather than assuming a new transport or store is required.

Sprint 563 provides the motivating local defect reports: F9 registered-agent inbox ambiguity with multiple family instances, F9b clone/parent claim confusion, F9c rejection within the owner's session, and F9d family-level attribution of board actions. Its plan is at `bashy/docs/plan-s563-master-execution.md`. The original 568 card reports stopgap commit `9adb8acc`; do not treat all reports as resolved. Track local repairs separately unless they directly block a required integration.

## Acceptance matrix

The design must specify expected behavior and implementation verification for:

1. Identical ordinary membership, group, permission and messaging paths for human-operated and agent-operated accounts.
2. A human directly using MB, Meet, claims and sprint commands; an agent using the same capabilities under its account.
3. Human-assisted operation with explicit actor, represented user and authority.
4. Klatch to MB inbox and reply into the original conversation.
5. Klatch to an authorized Meet conversation and reply, preserving participant attribution.
6. Klatch to a sprint manager and reply, including manager handoff.
7. Agent-initiated messages to human and agent members through ordinary service interfaces.
8. Offline destination, reconnect, transient failure, retry, duplicate suppression and truthful delivery status.
9. Group removal, account suspension and credential revocation preventing further unauthorized activity.
10. Separate accounts for same-model agents; different account names on different services.
11. Nickname, tool/model, session and host-address changes preserving service-account ownership.
12. Existing local workflows remaining compatible.

## Review and delivery

Keep all six stories open until their own deliverables and review evidence exist. Architecture walkthroughs are design evidence, not runtime test results. D6 must record operator review, resolved design decisions, public interface contracts, satellite support-ticket references and dependency-ordered implementation stories.

Keep proprietary satellite implementation and private operational information outside the public repository; tickets and public contracts describe required behavior. This planning session creates the plan and stories only; ticket filing and detailed architecture delivery remain story work.

No manager has been appointed and no sprint execution has started. A future start follows normal manager selection, claim, submission and independent acceptance procedures.
