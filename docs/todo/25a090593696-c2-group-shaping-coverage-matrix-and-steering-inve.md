---
id: 25a090593696
kind: doc
title: C2 Group shaping coverage matrix and steering inventory (doc)
seq: 575
status: done
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:47.811665Z
weave: 230
assignee: claude-sonnet5.5
sprint: 685
sprint_id: f684d38b-201d-5579-bd47-c70e26524188
sprint_title: 'Group shaping coverage: every bashy app as a test case, plus cross-outpost agent steering in one circle'
closed: 2026-11-24T12:36:12.443488Z
closed_by: agy-gemini4-hydrogen
---

One doc under docs/. One row per registered app and CLI-only tool (page, session, notepad, form, brainstorm, chart, viewer, whiteboard, film, video, board, table, notes, site, clips, files, klatch): artifact, who may write, guest door, shaping hook, bashy entry point, revision adoption (done in Sprint 684 / can adopt the kit store / event log / not applicable), and a verdict column filled by the Sprint 699 run (I1). Rows that are not small are filed follow-ups with evidence, not work in this sprint: whiteboard (no read-only mode; one collab server per principal), film and video storyboards (plain files; film lock is the existing named-revision analog), brainstorm shaped registration, table (Linux only, recorded exception). Include the steering inventory from the code: a shared-session directive reaches a weave run on another host (yoke/pkg/weave/weave_directive.go) but not a bashy chat session (yoke/pkg/chat/cmd_interact.go); no inbound A2A server is wired; cross-outpost steering (X1 04bc82b8, X2 b1ad7a71) waits for Sprint 679. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.

## Worker rules

- Entry: in your weave workspace, fetch `origin/main` in `umbrella` and inspect the current `origin/main` submodule heads (`bashy` `033fbe8f`, `yoke` `dcccc0fa`, `outpost` `5f566a72`). Rebase onto `umbrella` `origin/main` before making edits and before submitting.
- Scope: doc-only (`docs/` and standalone follow-up todos in `docs/todo/`). Do NOT modify product or test code.
- Evidence rule: every row in the coverage matrix and every statement in the steering inventory MUST be verified directly from reading the current source code (`bashy/examples/...`, `yoke/pkg/...`, `outpost/...`). Cite exact file paths and symbol/line evidence for every row and claim; do not guess or extrapolate.
- Deliverables:
  1. One markdown document under `docs/` (e.g., `docs/group-shaping-coverage-matrix.md`) containing:
     - Coverage matrix with one row for each of the 17 registered apps and CLI-only tools (`page`, `session`, `notepad`, `form`, `brainstorm`, `chart`, `viewer`, `whiteboard`, `film`, `video`, `board`, `table`, `notes`, `site`, `clips`, `files`, `klatch`), with columns: App/Tool, Artifact, Who May Write, Guest Door, Shaping Hook, Bashy Entry Point, Revision Adoption (`done in Sprint 684` for `page`/`session`/`notepad` / `can adopt the kit store` / `event log` / `not applicable`), Follow-up Todo, and Verdict (`pending Sprint 699 I1`).
     - Steering inventory from the code covering `yoke/pkg/weave/weave_directive.go` (shared-session directive reaching remote weave runs), `yoke/pkg/chat/cmd_interact.go` (not reaching a bashy chat session), inbound A2A server status (none wired), and deferred cross-outpost steering (`X1` `04bc82b8`, `X2` `b1ad7a71`) waiting on Sprint 679.
  2. Standalone follow-up todos (`bashy todo add --no-sprint` — NOT linked to Sprint 685) with concrete code evidence for each non-small gap (`whiteboard`, `film`/`video` storyboards, `brainstorm` shaped registration, `table` Linux-only exception), after checking `bashy todo list` so existing open todos are reused rather than duplicated. Link each follow-up todo ID in the matrix.
  3. Add the doc's abstract to `docs/README.md` and its one-line entry to `docs/INDEX.md` (nothing added to `CLAUDE.md`).
- Verification and commits: run `script/scrub-gate.sh --all` (or on all added/modified files) before committing. Never include machine names, OS logins, IP addresses, credentials, or home-directory paths (`script/scrub-gate.sh` is fail-closed); describe hosts by role only. Set `BASHY_AGENT` to your assigned agent identity and include trailers `Sprint: #685`, `Story: #575`, `Story-ID: 25a090593696`, `Agent: <assigned-agent>`. Do NOT push `main`; manager merges and pushes after review. Submit via `bashy sprint submit 685 25a090593696 -m "<summary, umbrella commit SHA, doc path, follow-up todo IDs, scrub-gate pass>"`.
