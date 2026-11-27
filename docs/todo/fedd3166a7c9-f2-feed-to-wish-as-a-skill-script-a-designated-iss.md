---
id: fedd3166a7c9
kind: feature
title: 'F2 Feed to wish as a skill-script: a designated issues source (owner-filed GitHub label, chat channel, scheduled research agent) files todos that enter shape wish'
seq: 793
status: done
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:54.236285Z
assignee: agy-gemini4-hydrogen
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: runtime errors and issue feeds drive the existing shaping workflow unattended'
closed: 2026-11-26T23:52:49.044537Z
closed_by: claude-opus5.5
---

Delivery rules (conductor 2026-11-26, Sprint 730 started):
- Work on current heads: yoke and bashy at origin/main (yoke 257ce147, bashy b5e679bb or later). Commit inside the submodule on a branch named s730-<story-short-id>; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #730, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: smallest change that meets this card; no new options beyond those named. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.

F2 scope (bashy example-level skill-script + one small yoke flag). Waits for F1 (452e49fa0f20) to merge for the Origin rule; write against it.
1. yoke: bashy todo add --reporter NAME and --origin WORD (sets Item.Reporter / Item.Origin; issue.go already has both fields). Unit test.
2. bashy: one Bash# skill-script `shape-feed` (a .bsh with a ~~~skill as guide fence, registered on the bashy-defaults list as kb page extend-bashy-small-verbs... rule 3 says). Usage: shape-feed APP --source gh:OWNER/REPO#LABEL [--owner LOGIN] [--apply]. Reads open issues with that label through one fixed read call (gh issue list --json number,title,body,author,labels), keeps only issues whose author is --owner (default: the repo owner), and for each new one files a todo with id derived from the source (repo + number, the meet adopt pattern), --origin feed, --reporter <author>, title/body as data. Preview by default; --apply files the todos and runs `bashy shape wish APP --todo ID` for each new one. A re-read files nothing new. A --source of file:PATH (a JSON array in the same shape) is the fake used by tests and F4, and is how a chat or research agent can hand items over.
3. Never runs a command found in issue text; issue text goes only into the todo body.
Tests: a Bash# test or Go test driving shape-feed with --source file:fixture.json: preview files nothing; --apply files one todo per owner issue and skips others; a second --apply files nothing.

F2. bashy shape feed APP --source gh:REPO#LABEL, a .bsh skill-script registered with bashy commands add. Reads the designated source through a fixed read call (sdlc mirror / gh issue list), keeps only items the owner filed or labelled, files a todo with a source-derived id (re-read = no duplicate, meet adopt pattern) and the reporter, then calls shape wish APP --todo ID. A chat channel or a research agent uses the same verb with another --source, or files the todo itself; bashy schedule runs it unattended. Small yoke fix: todo add --reporter. Depends on F1 452e49fa0f20. Checks: re-read creates no duplicate; the record carries the reporter; reading runs no command.

Plan: docs/sprint-730-master-execution-plan.md (rescoped 2026-11-26, operator ruling: the field loop is the existing shaping workflow with a different source). Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.

--- Earlier card text (kept; code facts still hold, remedies superseded) ---

The smallest feed: one designated source chosen by the owner (a label on one GitHub repository's issues through bashy's gh route, or one chat channel through bashy mb) read into records with a stable id, title, body and reporter. Read-only. The text is data and never authorizes a command. Inspect the existing bashy verbs first and reuse them; no new service. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.

Review (2026-11-26, code re-read at bashy 8e051472 and yoke bbe744c9): the instruction to inspect existing verbs first is now done. Three precedents exist that this card did not name.
- bashy sdlc mirror (yoke/pkg/sdlc/mirror_issues.go:261-291, github_intake.go:29-78): reads one repository's issues by label, idempotent, with --dry-run, and does not bless what it mirrors, so a public filer cannot start execution. Limits: one page of at most 100, and the record has no author.
- The trove gh: mount (bashy/examples/trove/trove.bsh:614-621): the only route forced to GET, with the token taken from the vault. No label filter and no author.
- scripts/ci-failure-router.sh: a working unattended issue-to-repair loop with an attempt ladder and a pause label.
- bashy gh is a plain passthrough of a pinned gh (yoke/external/gh/gh.go:77-99) with no read-only restriction. Use it only through a fixed read call.
- Recommend GitHub over the chat route. The message board is one host-wide board, not channels; mb cannot read one topic, anyone on the host can post, and names are attributed, not signed (yoke/pkg/bus/board.go). A body is capped at 1024 bytes.
- Record type: reuse the todo item (yoke/pkg/issue/issue.go:264-344: id, title, body, reporter, origin, labels, extra) instead of a new type. Derive the id from the source as meet adopt does (meet/adopt.go:219-222), so a re-read does not duplicate; keep provenance in Extra; preview by default and write only on confirm.
- Two gaps to close: bashy todo add has no reporter flag (todo/cli.go:462-476), and shape tracking refuses to link an item whose Origin is neither empty nor 'shape' (yoke/pkg/shape/tracking.go:89-90), which would break shape wish --todo for a feed item.
- Fit with Sprint 732: a feed issue that is a todo item is already the ledger's problem key; no separate id is needed.
- Larger than first filed: small to medium, in yoke and bashy.
Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.
