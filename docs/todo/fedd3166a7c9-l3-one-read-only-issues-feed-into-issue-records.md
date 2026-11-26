---
id: fedd3166a7c9
kind: feature
title: L3 one read-only issues feed into issue records
seq: 793
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:54.236285Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

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
No coding until the operator says so (2026-11-26).
