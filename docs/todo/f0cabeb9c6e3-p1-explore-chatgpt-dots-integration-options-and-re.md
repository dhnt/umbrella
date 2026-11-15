---
id: f0cabeb9c6e3
kind: spike
title: P1 Explore ChatGPT/dots integration options and recommend a software-shaping pilot
seq: 324
status: todo
labels:
    - software-shaping
    - dots-integration
created: 2026-11-15T07:29:24.506109Z
sprint: 642
sprint_id: 7b4a9392-be5f-5398-a236-fba1d0868fae
sprint_title: 'ChatGPT/dots integration exploration: direct and steward-mediated access to Cloudbox, Outpost, and Bashy'
---

## Request and scope
Explore potential integration of ChatGPT/dots with the full Cloudbox, Outpost and Bashy stack under the software-shaping epic. Planning only: no implementation, deployment, infrastructure provisioning or agent launches. Keep the sprint in backlog without appointing a manager; the operator did not select one.

## Options to evaluate
1. Direct: ChatGPT/dots coordinates through a Cloudbox plugin gateway, Outpost machine access and Bashy tools/workflows. Deterministic operations do not require a continuously running local AI agent. Reasoning or code generation can use dots or an explicitly delegated coding agent.
2. Steward-mediated: dots delegates a bounded outcome; Bashy steward owns execution, conductors/workers, resource coordination, evidence and continuity.
3. Hybrid: expose bounded operations directly and offer explicit steward delegation for sustained work. Each assignment has one execution owner; transitions transfer ownership explicitly.

## Working preference
Explore direct integration first for bounded shaping workflows, with optional steward delegation. This is a hypothesis to evaluate, not an implementation decision. The preferred path does not inherently require a local AI coordinator.

## Planning deliverables
- Inventory existing MCP, shaping, steward, host-routing and public Cloudbox capabilities; separate implemented behavior, documented contracts and open work.
- Compare direct, delegated and hybrid routes for user experience, complexity, reliability and operational cost.
- Define the minimum user-scoped capability discovery, assignment, status, clarification, cancellation and result interfaces. Evaluate MCP Events for completion, blocker and approval notifications.
- Specify identity and grant mapping, action-specific approvals and verification boundaries. Preserve existing local MCP boundaries; assess an authenticated Cloudbox-facing adapter rather than assuming local administrative endpoints are remotely suitable.
- Define task identity and execution ownership, retries/idempotency, disconnection and host-offline behavior, cancellation semantics and reconnect/result recovery. Keep conversational context separate from the authoritative execution record.
- Walk through wish -> candidate -> verify -> preview -> approve -> activate -> undo for each route. Include optional local code-generation delegation and steward-owned sustained work.
- Recommend one initial pilot with dependencies, unresolved decisions and implementation acceptance scenarios. Relate communications dependencies to Sprint 620 and shaping integrations to existing work rather than duplicating them.

## Acceptance scenarios to specify, not implement
Permitted user completes the shaping lifecycle; unauthorized user is refused; failed verification prevents activation; approval binds to the reviewed candidate; repeated submission does not duplicate execution; disconnected client retrieves the same task; offline host reports an honest state; cancellation has a recorded outcome; ownership transfer does not leave two coordinators driving the same task; results distinguish asserted from verified success.

## Evidence and starting points
- OpenAI dots: https://learn.chatgpt.com/docs/dots
- Plugin MCP events: https://developers.openai.com/plugins/build/mcp-events
- Plugin authentication: https://developers.openai.com/plugins/build/auth
- Local surfaces: outpost/docs/mcp.md; yoke/mcp/transport.go; yoke/docs/cloudbox-members-attach-wire.md (public contract, marked draft).
- Steward runtime: bashy/internal/agentos/steward.go and steward_supervise.go; its operating skill is bashy/skills/bashy/commands/steward.md.
- Shaping definition/status: bashy/docs/software-shaping.md.
Revalidate product documentation when research begins. Existing inspection is source/document review, not live integration or reliability evidence. Keep private Cloudbox implementation details outside the public repository.

## Completion boundary
This story completes when the comparison and pilot recommendation are documented with evidence and remaining decisions. Creating this card does not complete the research. Implementation requires separately authorized follow-up work.
