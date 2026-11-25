---
id: 6ba1b4777931
kind: test
title: 'M4 A/O/C on the Page example: the sandbox scenario runs against examples/desk/page (MVP)'
seq: 735
status: assigned
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-25T04:28:08.884379Z
weave: 260
assignee: codex-gpt6.2-astra
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
---

Operator 2026-11-24: deliver today a minimal A/O/C with Page support in examples. KISS/MVP: the same A/O/C flow pointed at Page; fix only what breaks; no new features.

A/O/C: O owns the host + member list and approves; A (support, edit scope, no outpost); C (support, shape scope, outpost). Today it is built and tested only on examples/shaping/website (bashy tests/group-shaping-e2e, dag test-group-shaping-e2e, 62 checks).

Code inspected 2026-11-24 (bashy 62c8bc99, yoke ac3d3841):
- examples/desk/page is a shaped Go server app (shaped.json server.main "." with serve -addr $ADDR -data $DATA); shape Kind() defaults to "web", so yoke scopes, owner's-line activation (program.go ActivationPrincipalFor) and PullSource/PushPatch (transfer.go) already admit it.
- Desk apps register via examples/desk/page/register.sh (bashy commands add + atlas, desk modules from the local Go module proxy via register-modules.sh) and are served by `bashy app serve` (examples/desk/register_shaped_test.go: src activate/undo switch the active revision; the served page carries the genie panel markers /_shape/genie.js, data-bashy-genie).
- The website flow uses website.bsh serve/register (R10 makes the served site follow the owner's line). Page has no website shaping.js panel.

Build (smallest change): add a Page leg to the sandbox (same container, fake accounts, stub agent, outpost-signed identity, mounted app + site MCP with --site-app for Page). Scenario on Page:
1. O sets scopes: support circle/groups A edit, C shape (bashy shape scope).
2. C: shape_pull returns Page source + revision; local edit (one Page template/text change the verifier accepts); shape_push -> verified candidate, principal C, activation O.
3. O approves; history credits C; the mounted Page serves the approved revision (the visible change appears).
4. A second push on the old revision is refused naming both revisions.
5. A's code wish lands on O's queue (as on the website leg); A (edit-only), an account and anonymous are refused shape_pull/shape_push.
Existing website checks stay green. If Page does not follow the approval when served under the mount, root-cause it and make the minimal fix in the owning module (record the cause on this story).
Out of scope: a browser wish box for A on Page, new UI, new verbs.

Acceptance: the e2e (website + Page legs) green twice on the claimed gate host in the official image, raw logs kept. Commits carry Sprint/Story/Story-ID trailers and `Agent: <assignee>`. Push nothing to main; the conductor merges.

## Operator ruling 2026-11-24 20:35 PST (relayed by umbrella-15)

"Page support needs no additional change if A/O/C is supported." M4 is VERIFICATION ONLY: add the Page leg to the existing sandbox e2e; no Page-specific product code, no new UI or verbs. If the Page leg fails, record the root cause here and stop; the conductor brings it to the operator before any fix (a failure is a gap in generic A/O/C support, not Page work).
