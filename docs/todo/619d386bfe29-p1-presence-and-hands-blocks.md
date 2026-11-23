---
id: 619d386bfe29
kind: feature
title: P1 presence and hands blocks
seq: 658
status: assigned
priority: p1
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.391427Z
assignee: codex-gpt6.2-sol
sprint: 696
---

here: who is on the page (handle and auth badge for everyone; address and fingerprint for the facilitator only), driven by SSE connections and last_seen; hands: a speaking queue (raise, lower, facilitator next/clear), lighter than demo-queue. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Wave 4 P1 interface & file-disjointness contract (`assignee: codex-gpt6.2-sol`):
- Owned files in `bashy/examples/desk/page`: `block_presence.go`, `block_presence_test.go`, `blocks/templates/here.html`, `blocks/templates/hands.html` (+ `Here(HereData)` and `Hands(HandsData)` in `blocks/blocks.go`), plus minimal wiring hooks in `main.go`, `face_html.go`, `block_form.go` (`blockMarkdownLocked`), `blocks.go` (`hands` display face if projected), `identity.go`, `cli.go`, `README.md`, `page.bsh`. Do NOT touch `export*.go` or `block_board*.go`.
- `here` (`Ref: "none"`, `Faces: ["organizer", "participant"]`): track active SSE connections per `(pageID, participantKey)` around `a.events.Serve` in `main.go` (ignoring unauthenticated/preview connections so preview never registers presence) + enrolled `it.Participants` (`last_seen`), publishing block SSE frames for `here` blocks on connect/disconnect/join/moderation. SECURITY CONTRACT: participant face and record/export face show `handle`, `auth` badge, and online/`last_seen` ONLY; `Address` and `Fingerprint` appear on `organizerFace` ONLY — NEVER in participant HTML, organizer preview (`?view=participant`), `show`, `/api/state`, `/api/block` for non-organizer, or `export md|html`.
- `hands` (`Ref: "none"`, `Faces: ["organizer", "participant", "display"]`): durable ordered `Hands []HandEntry` on `item` (deep-copied in `clone()`, updated/deduplicated/removed on `rename`/`merge`/`kick` in `identity.go`); `POST /api/action` `action: "hands"` (`raise`/`lower` for enrolled participants, isolated/refused in preview; `next`/`clear` restricted strictly to `organizerFace`, 403 otherwise) + CLI `page hands next|clear|list PAGE`, publishing block SSE frames on every mutation.
- Styling & dev-box verification: use `var(--desk-*)` CSS tokens only (`TestDeskContract` clean); run `GOWORK=off go test -count=1 ./...` in `examples/desk/page` and `examples/desk/kit` plus `-run TestDeskToolsShipShapedServer/page` ONLY (never unfiltered `TestDeskToolsShipShapedServer`). Commit cleanly in both `bashy` and the umbrella workspace root (`Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #658`, `Story-ID: 619d386bfe29`, `Agent: codex-gpt6.2-sol`), leave `git status` clean, and do NOT push.
