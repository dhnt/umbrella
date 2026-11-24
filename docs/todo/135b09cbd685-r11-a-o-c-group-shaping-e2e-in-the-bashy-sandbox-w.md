---
id: 135b09cbd685
kind: test
title: R11 A/O/C group shaping e2e in the bashy sandbox with fake accounts (sprint acceptance)
seq: 727
status: assigned
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T21:09:08.027071Z
weave: 245
assignee: codex-gpt6.2-astra
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

## Phases (conductor, 2026-11-24)

Phase 1 (start now, independent of R5a/R5b/R5c/R10): build the harness in bashy tests/group-shaping-e2e/ with a bashy dag target. Fake grants server with the fake accounts; real outpost with loopback trust; website enable + serve + site MCP --outpost in one bashy-base container; stub agent CLI (record how the site MCP's agent binding resolves to it). Prove it with TODAY's behavior: O (owner) wishes, verifies, previews, approves through <mount>/mcp; A and C (members) can read but are refused shaping; an outsider and an anonymous caller are refused. Commit phase 1 green.
Phase 2 (after R5a, R5b, R5c and R10 merge; the conductor will message): flip the member assertions to the scoped scenario in the story above. Run only on the gate host (or the secondary gate host when its lanes are claimed), never the dev box; take a bashy claim on the host first.

## Phase 2 GO (conductor, 2026-11-24 14:20 PST)

All dependencies are merged: yoke 83aa3ad7 (R5a scopes core), bashy f07f57d9 (R5b site MCP scope gate + `bashy shape scope`, R5c panel wish box, R10 served site follows the owner's line, R1 account wording), umbrella cadba3d0e. Rebase the phase-1 workspace onto those heads first.

Then switch the scenario to the scoped case and keep phase 1's refusal checks:
1. O runs `bashy shape scope set --app APP edit --circle company --json` and `... shape --circle contractor --json` (or --group support for shape as the story says: A edit, C shape).
2. C (stamped member, circle contractor, groups [support]) calls shape_wish, shape_verify, shape_preview through <mount>/mcp: a verified candidate exists; C cannot shape_approve.
3. O approves through <mount>/mcp; history shows Author C on the owner's line; the served site (website.bsh serve with --principal O) switches to the new revision and /_shaping/api/version changes.
4. A (circle company, edit only) calls shape_wish: it lands as a request on O's queue (Kind request), no workspace.
5. A member outside group support, an account and an anonymous caller are refused shaping.
6. A second candidate made on the old base is refused at approve, naming both revisions.
7. No step uses an OS password.
Run twice on the gate host (claim it first), raw logs kept; commit, report the bashy commit for the conductor to merge.
