---
id: 01efa4b05a24
kind: feature
title: 'P0 blocks: text and book (viewer, notepad), embed (iframe), timer'
seq: 655
status: assigned
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.951769Z
weave: 170
assignee: muse-wonder
sprint: 696
---

Native blocks book:<id>/pN (viewer page rendered inline) and note:<id> (notepad note); embed:<same-origin path or URL> as an iframe for whiteboard, table, Klatch and the demo-queue projector (needs the kit CSP option); timer:<name> with facilitator start/stop/reset and ticks over SSE, visible to all. Each block kind is one small renderer under blocks/ plus a template so a shaping wish can add a kind. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Decision (2026-11-23, Sprint #696 conductor clarification on sibling CSP for embed blocks):
- Desk apps built on `desk-kit` (`form`, `notepad`, `viewer`, `chart`, `calendar`, and `examples/brainstorm/server`) send `frame-ancestors 'none'` by default and MAY gain the one-line additive opt-in `kit.SecurityOptions{Embeddable: true}.Apply(w)` (plus `Embeddable: true` in `contracttest.Config`, same-origin framing `'self'` only), each as its own small commit on that app with its own `GOWORK=off go test ./...` green and trailers naming the story that needed it. This is the only sibling change allowed in Sprint #696.
- Non-kit engines (`whiteboard`, `table`, `klatch`, `demo-queue`) stay untouched: for them the embed face renders a link-out card (`embed:... mode=link` / non-frameable fallback) and a standalone todo records the same-origin framing opt-in each would need.

Run #170 root cause (2026-11-23):
- `muse-wonder` completed cleanly (`exit: 0`, Meta `muse-wonder-1.0` stream `response.completed` in `logs/issue-170.result.md`) and committed `30caceb7` inside `bashy` (`s696-01efa4b0`, independently verified: `desk/kit` 5/5 packages and `desk/page` 21/21 tests green), so this was neither a vendor refusal, a test failure, nor a venue failure.
- Root cause of `state: failed`: the worker exited without committing the `bashy` submodule gitlink bump at the `issue-170` umbrella root and without a weave verify attestation (`verify: n/a`), causing weave's terminal dirty-tree handler to auto-commit `b5874cecb415` (`weave(auto): issue 170`) and record `failed`.
- Action: `30caceb7` preserved locally as `refs/heads/salvage/s696-01efa4b0-30caceb7`; resuming run #170 with `muse-wonder` to apply the sibling CSP/link-out decision above, file the non-kit framing todo, and commit the umbrella gitlink cleanly.
