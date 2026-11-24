---
id: b5adee105b13
kind: feature
title: 'H1 bashy mcp serve --hosted: per-call master-signed identity, scratch home, timeout, output cap, no shell sessions, caller as principal'
seq: 663
status: todo
priority: p1
labels:
    - bashy-hosting
    - mcp
created: 2026-11-23T13:18:03.953357Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Staffing 2026-11-24: claude (reassigned from codex; the seam is the Sprint 697 A3 site profile in bashy/internal/agentos/mcp.go, add --hosted as a third profile beside outpost and site). Start from current heads.

Planned vendor: codex. Core (bashy internal/agentos + yoke/mcp), medium. HTTP only; each request carries a master-signed, versioned, short-TTL per-call identity (caller, task_id, idempotency_key, secrets_token) verified the way --outpost does (mcp_outpost.go pattern: 0600 runner key re-read per request, loopback only, fail closed, nonce cache against replay); fresh BASHY_HOME/scratch per call removed after; timeout; --max-output; shell_open/exec/close absent from tools/list; bashy.principal = caller in the audit line; effect policy unchanged (destroy/spend/cred/priv answer {state: gated}). Accept: tests for valid, expired, replayed and unsigned identity; scratch gone after the call; session tools absent; principal in audit; run_tool echo round-trips; a destroy verb answers gated. Spec: docs/sprint-691-master-execution-plan.md
