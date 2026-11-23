---
id: 01efa4b05a24
kind: feature
title: 'P0 blocks: text and book (viewer, notepad), embed (iframe), timer'
seq: 655
status: done
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.951769Z
weave: 172
assignee: claude-opus5.5
sprint: 696
closed: 2026-11-23T13:43:40.502941Z
closed_by: agy-gemini4-carbon
---

Native blocks book:<id>/pN (viewer page rendered inline) and note:<id> (notepad note); embed:<same-origin path or URL> as an iframe for whiteboard, table, Klatch and the demo-queue projector (needs the kit CSP option); timer:<name> with facilitator start/stop/reset and ticks over SSE, visible to all. Each block kind is one small renderer under blocks/ plus a template so a shaping wish can add a kind. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Decision (2026-11-23, Sprint #696 conductor clarification on sibling CSP for embed blocks):
- Desk apps built on `desk-kit` (`form`, `notepad`, `viewer`, `chart`, `calendar`, and `examples/brainstorm/server`) send `frame-ancestors 'none'` by default and MAY gain the one-line additive opt-in `kit.SecurityOptions{Embeddable: true}.Apply(w)` (plus `Embeddable: true` in `contracttest.Config`, same-origin framing `'self'` only), each as its own small commit on that app with its own `GOWORK=off go test ./...` green and trailers naming the story that needed it. This is the only sibling change allowed in Sprint #696.
- Non-kit engines (`whiteboard`, `table`, `klatch`, `demo-queue`) stay untouched: for them the embed face renders a link-out card (`embed:... mode=link` / non-frameable fallback) and a standalone todo records the same-origin framing opt-in each would need.

Run #170 root cause (2026-11-23):
- `muse-wonder` completed cleanly (`exit: 0`, Meta `muse-wonder-1.0` stream `response.completed` in `logs/issue-170.result.md`) and committed `30caceb7` inside `bashy` (`s696-01efa4b0`, independently verified: `desk/kit` 5/5 packages and `desk/page` 21/21 tests green), so this was neither a vendor refusal, a test failure, nor a venue failure.
- Root cause of `state: failed`: the worker exited without committing the `bashy` submodule gitlink bump at the `issue-170` umbrella root and without a weave verify attestation (`verify: n/a`), causing weave's terminal dirty-tree handler to auto-commit `b5874cecb415` (`weave(auto): issue 170`) and record `failed`.
- Action: `30caceb7` preserved at `origin/s696-01efa4b05a24` (and `refs/heads/salvage/s696-01efa4b0-30caceb7`); `weave start --resume --run 170` spun at >100% CPU without spawning `muse` (even with `--pty never`), so reassigning `01efa4b05a24` to `claude-opus5.5` onto `bashy` `origin/main` (`4325998f`, where both `8677f12abd00` native poll/form blocks and `476e23cbd1bb` roles/faces have landed).
- Reassignment checklist for `claude-opus5.5`:
  1. Fetch salvaged commit `30caceb7` from `origin/s696-01efa4b05a24` (`git -C bashy fetch origin s696-01efa4b05a24`) and cherry-pick/integrate it onto `bashy` `origin/main` (`4325998f`): keep `blocks/blocks.go`, `blocks/templates/{book,note,embed,timer}.html`, `block_content.go`, and `block_content_test.go`, wiring `book`, `note`, `embed`, and `timer` cleanly into `renderBlockFaces` / `blockFace` / `serveBlock` (`GET /api/block`, preserving `knownParticipantLocked` + role projection), `page()` (`timerScriptFor`), and `blockMarkdownLocked` (`export`). Keep `SecurityOptions{Embeddable: true}` on `page` (`Embeddable: true` in `pageConfig`), use `var(--desk-*)` CSS tokens only, and render `timer`'s clock without controls on `displayFace` (`?view=display`) when projected. Credit `30caceb7` (`muse-wonder`) in the commit body while setting trailer `Agent: claude-opus5.5` (matching current story assignee).
  2. Add the 1-line additive `kit.SecurityOptions{Embeddable: true}.Apply(w)` (+ `Embeddable: true` in `contracttest.Config`) on `examples/desk/viewer` (main handler only, keeping raw sandboxed attachment CSP intact), `examples/desk/notepad`, `examples/desk/chart`, and `examples/calendar` — **each as its own small commit** with its own `GOWORK=off go test -count=1 ./...` green and `Sprint: #696` / `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06` / `Story: #655` / `Story-ID: 01efa4b05a24` / `Agent: claude-opus5.5` trailers (do NOT touch `form` or `brainstorm`).
  3. Keep non-kit engines (`whiteboard`, `table`, `klatch`, `demo-queue`) untouched: in `examples/desk/page`, ensure `embed` renders a link-out card (`<a href="..." target="_blank" rel="noopener noreferrer">`, no `<iframe>`) automatically whenever an `embed` ref targets `/whiteboard`, `/table`, `/klatch`, `/demo-queue` (or `/apps/<engine>`) or carries `mode=link` / `LinkOnly`, while frameable kit/same-origin URLs render `<iframe>`; verify `GOWORK=off go -C examples/desk/page test -count=1 ./...` is green (module-local tests ONLY on the dev box — do NOT run unfiltered `TestDeskToolsShipShapedServer`, use `-run TestDeskToolsShipShapedServer/page` at most).
  4. File ONE standalone todo in `docs/todo/` recording the same-origin framing opt-in that untouched non-kit engines (`whiteboard`, `table`, `klatch`; `demo-queue` is already in `3b16b02e6b1a`) would need, then commit the `bashy` submodule gitlink bump + new `docs/todo/*.md` cleanly at the umbrella workspace root (`Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #655`, `Story-ID: 01efa4b05a24`, `Agent: claude-opus5.5`) and leave `git status` completely clean in both `bashy` and umbrella without pushing.
