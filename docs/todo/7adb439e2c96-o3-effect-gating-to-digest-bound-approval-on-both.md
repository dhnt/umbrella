---
id: 7adb439e2c96
kind: feature
title: O3 Effect gating to digest-bound approval on both routes, plus a shaping lifecycle walkthrough
seq: 361
status: done
priority: p1
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T15:07:43.344434Z
weave: 79
assignee: muse-conductor
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
closed: 2026-11-15T16:50:59.067327Z
closed_by: claude-opus5.5-s646
---

Spec: docs/vendor-chat-gateway-mvp.md (decision 3).

Scope:
- When a `run` call or a worker action carries a destroy/spend/cred/priv effect, it raises yoke/pkg/ask Raise with a digest of the candidate.
- The gateway's approve tool carries that digest. The owning host settles the decision through ask.ApplyRemote, which fails closed. This works the same on the sync and pull routes.
- Walkthrough: `run shape wish` -> candidate -> approve(digest) -> activate -> undo, written up in the spec doc.

Done when: unit tests show an approval refused when the digest is stale, a decision for another host refused, and the denial when the approval goes unanswered.

## Worker rules (Sprint 646 manager, 2026-11-15)
- Read docs/vendor-chat-gateway-mvp.md in the umbrella repository, including the Task wire contract section, before writing code.
- Work only in your weave workspace.
- Run unit tests on touched packages only (GOWORK=off go test ./<pkg>/...); the full suites are deferred to QA.
- Commit trailers: Sprint: #646, Story/Story-ID for this story, Agent: <your agent name>.
- Never read, print or commit a credential value. Never fall back to an API key for a subscription worker.
- Submit with `bashy sprint submit 646 <story> -m "<evidence: commits, tests run>"`.

## Integration notes from the merged O0, O1 and O2 work (manager, 2026-11-15)
- Pull route: yoke pkg/weave/gateway_directive.go gatewayRunEffects currently fails gated verbs with state failed and reason gated-effect. Replace that with ask.Raise:
  - The digest is sha256 over the exact argv, host and task id.
  - Emit state needs-approval and an approval event {approval_id, digest, summary, effects}.
  - Run only after the approve directive settles through ask.ApplyRemote with a matching digest. A stale digest or a deny ends the task as cancelled/failed with a reason.
  - DenyUnanswered applies after a bounded wait.
- Sync route: bashy mcp serve --outpost (bashy internal/agentos/mcp_outpost.go, yoke mcp/policy.go) denies gated effects outright. Give it the same ask.Raise path, so a sync call returns needs-approval with the same approval event shape, and settle the approval through the same digest.
- One digest function shared by both routes, unit-tested.
- Shaping walkthrough: add a section to umbrella docs/vendor-chat-gateway-mvp.md walking `run shape wish` -> candidate -> approve(digest) -> activate -> undo through the tools, naming which effects gate where. Use real bashy shape verbs; check them with `bashy shape --help`.
