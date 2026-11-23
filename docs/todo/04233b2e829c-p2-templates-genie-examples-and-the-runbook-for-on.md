---
id: 04233b2e829c
kind: doc
title: P2 templates, genie examples and the runbook for one-page meetings
seq: 659
status: done
priority: p2
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.540261Z
weave: 178
assignee: claude-opus5.5
sprint: 696
closed: 2026-11-23T14:57:25.926897Z
closed_by: agy-gemini4-carbon
---

templates/agenda.md, meeting.md, retro.md (reuse examples/session/formats/*); shaped.json genie.examples for the second-speed wishes (vote as a bar chart, hide results until closed, one row per participant for a status, a block pulling open pull requests); kb runbook 'Run a class or meeting on one page' describing the two speeds (data verbs run by the facilitator's agent in seconds; block kinds shaped through bashy shape wish in minutes), both doors and the join code. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).

Wave 5a P2 brief (`assignee: claude-opus5.5`):
1. Branch `s696-04233b2e829c` from current `bashy` `origin/main` (`70d36123`).
2. `bashy/examples/desk/page/templates/{agenda.md,meeting.md,retro.md}`:
   - Adapt the phase/timebox/visible-outcome structure from `bashy/examples/session/formats/*` (`meeting.md`, `class.md`, `session.md`) into ready-to-use `page add -f templates/<name>.md` Markdown documents with valid ` ```block ` fences (e.g. `here`, `hands`, phase `timer:<name> duration=...`, plus prose/CLI notes showing where the facilitator adds `poll`, `form`, `board`, `book`, `note`, or `embed` blocks on demand so every template parses cleanly via `parseBody` and `page add -f` out of the box without referencing nonexistent sibling items).
   - Keep wording general (team meetings, agendas, retrospectives, workshops/classes — the Sunday class is a UAT case, not the product).
   - Add a unit test in `bashy/examples/desk/page` verifying every `templates/*.md` loads cleanly through `parseBody` and `page add -f`.
3. `bashy/examples/desk/page/shaped.json` + `bashy/examples/desk/shaped_test.go`:
   - Add `genie.examples` to `bashy/examples/desk/page/shaped.json` covering the four second-speed wishes in concise user voice: (a) vote tallies rendered as a bar chart, (b) hide results until voting closes, (c) one row per participant to track a status/sign-off, (d) a block pulling open pull requests from a repository.
   - Add `"page"` to `TestConsumerPolishedToolsDeclareGenieExamples` in `bashy/examples/desk/shaped_test.go`.
4. Repo `kb` runbook `'Run a class or meeting on one page'` in `bashy/docs/kb`:
   - Add via `bashy kb --dir bashy/docs/kb add` (so `bashy/docs/kb/pages/<slug>.md`, `bashy/docs/kb/index.md`, and `bashy/docs/kb/journal.jsonl` stay consistent; `type: runbook`).
   - Cover: (a) opening one fixed page across **both doors** (`page publish-outpost --port PORT` + `page serve --lan --port PORT`, `--audience lan|satellite|host`, short `--code` join path + QR codes via `page open`, satellite signed-in pseudonym vs LAN `handle@address` anonymous binding, organizer dual-face view + `?view=participant` preview + `?view=display` projector, moderation `rename`/`merge`/`kick`); (b) the **two speeds** (*seconds*: facilitator or their agent running `page block add poll|form|board`, `page set`, `timer`, `hands` as data verbs with zero build; *minutes*: `bashy shape wish` / Genie on `page` to shape and verify a new block kind or layout); (c) closing and exporting the repo-committable session record (`page export ID --to md|html|pdf`, inline final block states, zero addresses or facilitator keys).
   - Update `bashy/examples/desk/page/README.md` (and `page.bsh` if appropriate) to mention `templates/{agenda,meeting,retro}.md` and the runbook.
   - Public scrub rule: NO real hostnames, OS usernames, local home paths, or private IPs anywhere.
5. Verify on dev box ONLY:
   - `awd bashy/examples/desk/page -- env GOWORK=off go test -count=1 ./...`
   - `awd bashy/examples/desk -- env GOWORK=off go test -count=1 -run '^(TestConsumerPolishedToolsDeclareGenieExamples|TestDeskToolsShipShapedServer)/page$' .`
6. Commit on `s696-04233b2e829c` in `bashy` (`BASHY_AGENT=claude-opus5.5`, contiguous trailers `Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #659`, `Story-ID: 04233b2e829c`, `Agent: claude-opus5.5`), commit `bashy` submodule gitlink bump at umbrella root (`git add bashy`, same trailers), run `bashy sprint submit 696 04233b2e829c --as claude-opus5.5 -m "..."`, and leave both working trees 100% clean without pushing.
