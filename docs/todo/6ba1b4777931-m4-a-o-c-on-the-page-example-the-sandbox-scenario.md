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
weave: 264
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

## Resume plan (operator 2026-11-24: "file and do the right thing")

The Page leg's blocker is a generic verifier defect, fixed by M6 b659aecc1daa (checks reuse the host's binmgr tool cache). After M6 merges: rebase the preserved Page leg (bashy branch s709-m4-page-leg, 773dfa09) onto bashy main with yoke repinned to M6; in the sandbox, seed the owner's tool cache with the Go toolchain `bashy go` expects (offline, from the mounted Go SDK, at binmgr's layout <cache>/go/<version>/go), test harness only. Acceptance unchanged: website + Page legs green twice on the gate host. Still verification only: no Page-specific product code.

## Run order for this assignment (conductor, 2026-11-24 ~22:55 PST; hard stop 11-25 10:30 PST)

M6 is merged: yoke main ff326a9d. The conductor holds claim repo:pin-bump-yoke-ff326a9d (announced on mb); this run works under it.

Step 1, pin propagation (agreed with the Sprint 699 release manager), each on its repo's current origin main:
- bashsharp -> yoke ff326a9d (all yoke modules it requires).
- ycode -> yoke ff326a9d + bashsharp (step 1 sha) + bashy (current origin main).
- bashy -> ycode (step 2 sha) with the genie replace (go mod edit -replace github.com/qiangli/ycode/examples/genie@v0.0.0=github.com/qiangli/ycode/examples/genie@<pseudo of the new ycode>) + bashsharp (step 1 sha) + yoke ff326a9d; ALSO set bashy internal/agentos/src_mount.go srcModulePins["yoke"] to ff326a9d's full sha.
- Build + short unit tests for all three on a claimed gate lane, GOWORK=off, -count=1; `bashy mod drift` with no stale rows and a minimal bashy<->ycode cycle.
- Baseline reds (any OTHER failing test name blocks): bashsharp go test ./... 44 FAIL identical to 08fabb33 (standalone builds of sibling cmd/bashy, cmd/bash); ycode -short TestHarnessStreamWaitsForAppendNotifications (08ee6df70b5d), and TestTUIOverPTY/TestTUIClearOverPTY only when lanes run in parallel (rerun idle); bashy -short TestCommonOptionsVocabularyReport (60d43cb7), TestEmbeddedAdaptersMatchSourceTree (01b745b8), TestDeskSkillDocumentedVerbsValid (fcfcd423). Compare by name.

Step 2, Page leg: rebase the preserved Page leg (bashy branch s709-m4-page-leg, 773dfa09) onto the step-1 bashy; in the sandbox seed the owner's tool cache with the Go toolchain `bashy go` uses (offline, from the mounted Go SDK, binmgr layout <cache>/go/<version>/go) - test harness only. Website + Page legs green twice on the gate host in the official image; raw logs kept.

Deliver commits (bashsharp, ycode, bashy, umbrella pins) in the workspace; push nothing; the conductor reviews and pushes in order. Trailers Sprint/Story/Story-ID + `Agent: <assignee>`.

## Delivery split (699 release manager, 2026-11-24 ~23:00 PST)

Deliver Step 1 (pin propagation) as soon as it is green: commit it, record the gate result, announce on mb "709 ROUND READY" with the bashsharp/ycode/bashy/umbrella SHAs and the gate log path, so the conductor pushes it without waiting for the Page leg. Then do Step 2 on top. M4's Page leg goes to main only if green twice by 11-25 10:30 PST.
