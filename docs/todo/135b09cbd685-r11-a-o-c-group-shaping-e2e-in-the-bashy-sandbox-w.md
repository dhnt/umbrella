---
id: 135b09cbd685
kind: test
title: R11 A/O/C group shaping e2e in the bashy sandbox with fake accounts (sprint acceptance)
seq: 727
status: todo
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T21:09:08.027071Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Sprint acceptance for the A/O/C case (operator, 2026-11-24): one e2e in the bashy sandbox with fake accounts; the operator runs the real-host test after the sprint closes, and bugs found start a new plan.

Code inspected 2026-11-24: nothing runs this end to end today. Reusable: the real outpost with OUTPOST_INGRESS_TRUST_LOOPBACK=1 (outpost cmd/outpost/main.go:1391-1393, internal/agent/ingress.go:46), which stamps identity from X-Periscope-User on loopback (apps.go:645-649) and signs the v2 relationship (703-725); the grant-copy shape outpost fetches (grants.go:33-40, fetched at :371); bashy oci + localhost/bashy-base:ubuntu24.04 (tools/bashy-oci/build-smoke.sh:6); the python runner pattern of tests/shaping-promotion/run.py (bashy oci containers, wish --from). Missing: yoke cloudboxfake has no grants route and is test-only (cloudboxfake.go:255); no multi-process container; no no-LLM path through the site MCP (no fake agent exists).

Build tests/group-shaping-e2e/run.py (bashy dag target, gate host only):
- one bashy-base container via bashy oci; inside: a tiny fake grants server (fake accounts O owner; A circle company, groups [support]; C circle contractor, groups [support]; app rule groups [support]), a real outpost with loopback trust pointed at it, the website (website.bsh enable/serve) and the site MCP (--outpost).
- no LLM: a stub agent CLI on PATH that applies a fixed edit (step 0: confirm the agent binding the site MCP uses can be a stub; record how).
- scenario: O sets scopes (A edit, C shape) with bashy shape scope; C wishes, verifies, previews through <mount>/mcp as C; O approves; the served page shows the change and the panel sees the new version id (R10); A's code wish lands as a request on O's queue; a member outside support, an account and an anonymous caller are refused shaping; a stale candidate is refused naming both revisions; no step uses an OS password.
Depends on R5a, R5b, R5c, R10. Acceptance: green twice on the gate host in the official image, raw logs kept.
