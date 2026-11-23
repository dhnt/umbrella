---
id: 488e3c331aa5
kind: feature
title: P1 export the page to the session record (md, html, pdf)
seq: 656
status: done
priority: p1
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.098956Z
weave: 175
assignee: muse-wonder
sprint: 696
closed: 2026-11-23T14:30:02.726259Z
closed_by: agy-gemini4-carbon
---

page export --to md writes the page with every block's final state inline: per-handle answers for collections, tallies with handles for votes (hidden under --anonymous), presence list, timer totals; never addresses. --to html self-contained; --to pdf through viewer's headless-Chrome path. The Markdown shape matches a session record a group commits to its repository. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Wave 4 P1 interface & file-disjointness contract (`assignee: muse-wonder`):
- Owned files in `bashy/examples/desk/page`: `export.go`, `export_pdf.go`, `export_test.go`, plus minimal wiring hooks in `main.go` (`export`), `cli.go` (`--to md|markdown|html|pdf`), `block_form.go` (`blockMarkdownLocked`), `README.md`, `page.bsh`. Do NOT touch `block_board*.go` or `block_presence*.go`.
- `--to md`: repo-committable session record Markdown (title, session metadata line with page id/status/audience/revision, body with every block's final state inline in body order via `blockMarkdownLocked(it, b)` — `poll` option->votes(handles) omitting handles under `--anonymous`, `form` per-handle answers omitting handles under `--anonymous`, `book` & `note` inline Markdown content when viewer/notepad reachable with graceful fallback when unreachable, `timer` final clock & state, `embed` public link only, `here` participant list when present — followed by `## Participants` listing `handle (auth)` only; preserve `-break export-addresses` for red/green leak test, and NEVER emit addresses, fingerprints, cookies, respondent tokens, or owner/facilitator keys).
- `--to html`: self-contained HTML (`kit.Page` inline `desk-kit` CSS, zero external CSS/JS, `recordFace` across all blocks + participants section, zero interactive submit/organizer controls, zero addresses/keys).
- `--to pdf`: print the self-contained export HTML to PDF via headless Chrome matching `examples/desk/viewer/pdf.go` (`CHROME_PATH` env override + `findChrome()`, `--headless=new --disable-gpu --no-sandbox --no-pdf-header-footer --user-data-dir=<temp>/profile --print-to-pdf=<out> file://<temp>/export.html`), served on `GET /api/export?id=<id>&to=pdf` (`application/pdf`, organizer-only 403 check) and written by `page export ID --to pdf [-o FILE]`. DEV-BOX RULE: unit-test `--to pdf` (HTTP + CLI) using a fake `CHROME_PATH` shell script in `t.TempDir()` that writes `%PDF-1.4\n` to `--print-to-pdf=*` and verifies throwaway `--user-data-dir` + zero secret leaks; NEVER launch real Chrome/Playwright on the dev box (real Chrome PDF run is deferred to gate host).
- Styling & clean exit: use `var(--desk-*)` tokens only; verify `GOWORK=off go test -count=1 ./...` in `examples/desk/page` and `examples/desk/kit`; commit in `bashy` AND commit the `bashy` submodule gitlink bump at the **umbrella workspace root** (`git add bashy`, `BASHY_AGENT=muse-wonder`, trailers `Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #656`, `Story-ID: 488e3c331aa5`, `Agent: muse-wonder`) so BOTH `bashy` and umbrella workspace `git status` are 100% clean before exiting, and do NOT push.
