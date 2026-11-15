---
id: 5ca1445c6625
kind: bug
title: 'G3b Exactly-once across sync->pull fallback: the outpost claims the gateway key on the sync route and the pull conductor surfaces the stored result'
seq: 368
status: assigned
priority: p0
labels:
    - software-shaping
    - vendor-gateway
created: 2026-11-15T17:46:44.637163Z
weave: 80
assignee: claude-opus5.5
sprint: 646
sprint_id: 2167db86-22b7-5429-9bfe-b96a8d93a353
sprint_title: 'Vendor chat UIs + subscription agents on the full stack: one Cloudbox MCP gateway with dynamic sync/pull routing (MVP)'
---

Found in review (codex-gpt6-astra, confirmed by the manager, 2026-11-15).

Defect: the master's sync route (cloudbox G3, handlers/mcp_gateway_router.go) sends neither the idempotency key nor the task id to the outpost, and bashy mcp serve --outpost never calls yoke weave.ClaimGatewayTaskOnHost. Failure: a sync run_tool executes on the host, the satellite dies before the reply returns, the master falls back to pull with the same key, and the host conductor sees a fresh key and runs the command a second time. E1a gateway-mvp step 4 asserts exactly one host execution and will fail.

Wire contract (both sides must match):
- The master sends on every sync call two headers, X-Gateway-Task-Id and X-Gateway-Idempotency-Key. They pass satellite /mcp-host/:host -> HostProxy -> the outpost bashy-mcp app.
- The cloudbox side of this is done by the manager, not in this story.

This story (yoke + bashy):
1. bashy mcp serve --outpost reads both headers on a tools/call that executes (run_tool and direct tools). A call missing either header is refused (fail closed); there is no local-only bypass in --outpost mode.
2. Before executing, call weave.ClaimGatewayTaskOnHost(key, taskID).
   - If not fresh, do NOT execute. If the stored record holds a result, return it with the same reply shape; otherwise return state running/queued.
   - If fresh, execute, then write the result into the SAME host gateway record (the record and outbox format O1 uses: state, text, exit, verified), so the pull conductor can see it.
3. Pull conductor (yoke pkg/weave/gateway_directive.go): when a run/delegate directive arrives for a key whose host record was claimed by sync, do not execute. If the record has a result, emit ack + state + result events from it (flushRecord). If it is still running, emit state running and flush the result when it completes.
4. Gated calls are unchanged: the sync route answers gated before claiming, so the pull route still owns approvals.
5. Tests (GOWORK=off):
   - yoke weave: a pull directive after a completed sync claim emits the stored result and does not execute.
   - yoke weave: the same after an in-flight claim.
   - bashy agentos: --outpost without the headers is refused.
   - bashy agentos: a duplicate key does not execute twice.
6. bashy go.mod pins the pushed-able yoke commit. Workers do not push; the manager merges.

Trailers: Sprint: #646, Story/Story-ID, Agent: <you>. Submit with evidence.
