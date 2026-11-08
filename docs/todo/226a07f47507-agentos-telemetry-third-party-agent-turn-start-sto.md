---
id: 226a07f47507
kind: feature
title: 'agentos/telemetry: third-party agent turn start/stop delineation via CLI hooks and cross-process turn state'
seq: 42
status: todo
priority: p0
labels:
    - otel
    - hooks
created: 2026-11-08T01:01:07.985951Z
sprint: 590
sprint_id: e87405cd-e28f-57b5-bc3a-7727d4c92438
sprint_title: Third-party agent turn error-recovery OTel spans, Bash# KB wiki auto-composition, and KB/shaping tidy
---

In yoke/pkg/telemetry/turn.go and bashy/internal/agentos/{installagent.go,nudge.go}: 1) Persist active per-episode TurnState (~/.bashy/turns/<episode>.json) holding trace_id, turn_span_id, start_time, scrubbed prompt_summary, and command sequence across separate bashy -c processes. 2) Register Stop hook alongside SessionStart and UserPromptSubmit in claudeHookEntries and installCodexHooks. 3) Wire UserPromptSubmit (StartTurn) and Stop (EndTurn + assistant solution summary extraction) in bashy nudge --hook, with an automatic idle-window turn closure fallback for unhooked agents. See docs/agent-turn-recovery-and-bashsharp-kb-plan.md.
