---
id: 6648c43cb15e
kind: feature
title: 'P1 brainstorm block (native): cards and voting from the page'
seq: 657
status: done
priority: p1
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.24485Z
weave: 173
assignee: claude-opus5.5
sprint: 696
closed: 2026-11-23T14:37:24.264834Z
closed_by: agy-gemini4-carbon
---

board:<session> renders the brainstorm board inline and lets a page participant vote with their identity as the voter (per-participant cookie jar towards brainstorm); facilitator phase controls stay in brainstorm (link out). Rounds and vote budget are brainstorm's. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Wave 4 P1 interface & file-disjointness contract (`assignee: claude-opus5.5`):
- Owned files in `bashy/examples/desk/page`: `block_board.go`, `block_board_test.go`, `blocks/templates/board.html` (+ `Board(BoardData)` in `blocks/blocks.go`), plus minimal wiring hooks in `main.go`, `face_html.go`, `block_form.go` (`blockMarkdownLocked`), `identity.go`, `cli.go`, `README.md`, `page.bsh`. Do NOT touch `export*.go` or `block_presence*.go`, and do NOT modify `examples/brainstorm` (file a standalone todo if any gap is found).
- HTTP composition only (`PAGE_BRAINSTORM_URL` / `BRAINSTORM_ADDR`, default `http://127.0.0.1:18091`, zero Go imports of `brainstorm`): read via `GET /api/state?session=<ref>` and mutate via `POST /api/action` (`add`/`edit`/`delete` card in `write` phase with `name = participant.Handle`; `vote` toggle in `vote` phase; rounds and `VoteBudget` stay brainstorm's). Support `page block add board PAGE [--session S] [--title T]` (or existing `board:<session>` fence).
- Identity, roles & security: bind each page participant identity to one opaque `brainstorm-participant` cookie token (`item.BoardVoters` or `item.Respondents`, migrated on `rename`/`merge` and dropped on `kick` in `identity.go`); isolate organizer preview (`?view=participant`) in `a.previews` so preview never mutates the real brainstorm session; keep facilitator phase/round controls as a link-out in brainstorm on `organizerFace` only, and never leak any brainstorm facilitator key/URL or voter token in participant HTML, `/api/state`, `/api/block`, `show`, or `export`. Publish `a.events.Publish(it.ID, blockID, it.Revision)` on mutations.
- Styling & dev-box verification: use `var(--desk-*)` CSS tokens only (`TestDeskContract` clean); test against the real `brainstorm` server binary built from `../../brainstorm/server` over HTTP; run `GOWORK=off go test -count=1 ./...` in `examples/desk/page` and `examples/desk/kit` plus `-run TestDeskToolsShipShapedServer/page` ONLY (never unfiltered `TestDeskToolsShipShapedServer`). Commit cleanly in both `bashy` and the umbrella workspace root (`Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #657`, `Story-ID: 6648c43cb15e`, `Agent: claude-opus5.5`), leave `git status` clean, and do NOT push.
