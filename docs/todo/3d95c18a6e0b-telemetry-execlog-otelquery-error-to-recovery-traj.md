---
id: 3d95c18a6e0b
kind: feature
title: 'telemetry/execlog/otelquery: error-to-recovery trajectory classification, cross-PID transitions, and bashy otel recovered'
seq: 43
status: todo
priority: p1
labels:
    - otel
    - execlog
created: 2026-11-08T01:01:08.088762Z
sprint: 590
sprint_id: e87405cd-e28f-57b5-bc3a-7727d4c92438
sprint_title: Third-party agent turn error-recovery OTel spans, Bash# KB wiki auto-composition, and KB/shaping tidy
---

In yoke/pkg/telemetry/exec.go, yoke/pkg/execlog/transitions.go, and yoke/pkg/otelquery: 1) Classify benign exit-1 probes (grep, rg, diff, cmp, test, [, pgrep) as cmd.benign=true without setting codes.Error. 2) Compute turn-level recovery attributes on gen_ai.turn (turn.commands.total/failed/benign, turn.had_error, turn.recovered, turn.recovery_kind, turn.outcome=recovered_success). 3) Update execlog.Transitions to chain commands across distinct bashy -c PIDs within the same (Episode, TurnID). 4) Add bashy otel recovered querying VictoriaTraces with offline fallback to ~/.agents/otel/spool/spans.jsonl. See docs/agent-turn-recovery-and-bashsharp-kb-plan.md.
