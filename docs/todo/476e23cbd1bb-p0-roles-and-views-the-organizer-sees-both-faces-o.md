---
id: 476e23cbd1bb
kind: feature
title: 'P0 roles and views: the organizer sees both faces of a dual-view block, participants only theirs'
seq: 661
status: assigned
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T12:01:49.892116Z
weave: 171
assignee: codex-gpt6.2-sol
sprint: 696
---

Block kinds declare their faces (organizer, participant, display). Native adapters carry both the owner-keyed API (results, open/close, phase, assign turn) and the participant path; embed blocks carry two URLs, the private one with the engine's facilitator fragment or key. The organizer (page owner) sees dual-view blocks side by side on a wide screen or as tabs Organizer / Participant / Display; participants and viewers get only their face, and the organizer face, its controls and the sibling's facilitator key are never in their HTML, state or export. Page-level 'view as participant' toggle renders the whole page as a participant sees it with a throwaway identity. ?view=display is the projector face (organizer's chosen blocks, large type, no controls). Owner keys of embedded items live in the page store under the organizer's key, never shown by show or export. Proof: brainstorm (facilitator panel + board) and demo-queue (organizer + projector) as embeds, form (results + respondent) as a native; a participant fetch of the page HTML, state and export contains no organizer face and no key. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Decision (2026-11-23, Sprint #696 conductor clarification on sibling CSP and dual-view proofs):
- Desk apps built on `desk-kit` (`form`, `notepad`, `viewer`, `chart`, `calendar`, and `examples/brainstorm/server`) MAY gain the one-line additive opt-in `kit.SecurityOptions{Embeddable: true}.Apply(w)` (plus `Embeddable: true` in `contracttest.Config`, same-origin framing `'self'` only), each as its own small commit on that app with its own `GOWORK=off go test ./...` green and trailers naming the story that needed it (`#661` / `476e23cbd1bb`). This is the only sibling change allowed in Sprint #696.
- Non-kit engines (`whiteboard`, `table`, `klatch`, `demo-queue`) stay untouched: for them the embed face renders a link-out card and a standalone todo records the same-origin framing opt-in each would need.
- Proof update for `476e23cbd1bb`: use `form` (results + respondent) as the native dual-view proof and `brainstorm` (`examples/brainstorm/server`, facilitator panel + board) as the embed dual-view proof once it opts in; `demo-queue` (`examples/demo-queue` uses raw `frame-ancestors 'none'` without `desk-kit`) becomes a link-out card on the embed face plus a filed standalone todo.
