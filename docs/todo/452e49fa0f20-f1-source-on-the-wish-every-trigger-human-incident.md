---
id: 452e49fa0f20
kind: feature
title: 'F1 Source on the wish: every trigger (human, incident, feed, schedule) enters the one shaping workflow with provenance and fenced text'
seq: 814
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T23:22:56.224058Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: runtime errors and issue feeds drive the existing shaping workflow unattended'
---

Delivery rules (conductor 2026-11-26, Sprint 730 started):
- Work on current heads: yoke and bashy at origin/main (yoke 257ce147, bashy b5e679bb or later). Commit inside the submodule on a branch named s730-<story-short-id>; the conductor merges. Never push to main, never bump pins, never touch other submodules.
- Commit trailers: Sprint: #730, Story: #<seq>, Story-ID: <id>, Agent: <your agent name>.
- Tests: only targeted unit tests of the packages you touch (go test -run <YourTests> ./pkg/<pkg>/). No full suites, no e2e, no long background runs; the conductor runs package suites on the gate lane. GOWORK=off for yoke.
- KISS: smallest change that meets this card; no new options beyond those named. Anything else you notice goes in your final report as future input.
- Final report: branch, commits, tests run with result, and any open point.

F1 scope (yoke only):
1. shape.Wish gets Source{Kind, Ref} (Kind: human|incident|feed|schedule; empty = human) and the candidate record keeps it. JSON field "source", omitempty.
2. Tracking (pkg/shape/tracking.go:89-90) accepts a todo whose Origin is "feed" (set by the feed, F2) besides "" and "shape"; anything else still refused.
3. One fence helper in pkg/shape (e.g. FenceUntrusted(label, text)) that wraps untrusted text between markers and escapes any closing marker inside the text. Use it in the wish brief (helpers.go:98-115) and in the console repair brief (webconsole/shaped_repair.go repairBrief, which inserts the incident message unfenced today).
4. Console incident repair (webconsole recordWish for candKindRepair) records Source{Kind: incident, Ref: incident id}.
Tests: fence survives a closing marker in the text; repair brief fences the message; a todo with Origin feed links; Source round-trips in the candidate record.

Sprint 730 rescope (operator 2026-11-26): the field loop is the existing shaping workflow with a different source. Add Source{Kind: human|incident|feed|schedule, Ref} to shape.Wish (yoke/pkg/shape/service.go:81-93) and the candidate record. Tracking accepts feed origins (shape/tracking.go:89-90 refuses any origin other than empty or 'shape'). One fence helper that escapes the closing marker, used by the wish brief (shape/helpers.go:98-115) and the repair brief (webconsole/shaped_repair.go:141-154, unfenced today). Unit tests: fence survives a closing marker in the text; a feed-origin todo can be wished. Plan: docs/sprint-730-master-execution-plan.md. Code inspected at yoke 257ce147. Operator go given 2026-11-26 (Sprint 730 started); this line from the planning stage no longer applies.
