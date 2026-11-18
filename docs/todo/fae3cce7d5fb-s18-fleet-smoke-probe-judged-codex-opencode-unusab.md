---
id: fae3cce7d5fb
kind: bug
title: S18 fleet smoke probe judged codex/opencode unusable through a metered API binding
seq: 484
status: done
priority: p1
labels:
    - fleet
    - weave
created: 2026-11-18T21:14:12.868295Z
assignee: claude-opus5.5-s615
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
closed: 2026-11-18T21:28:21.911087Z
closed_by: claude-opus5.5-s615
---

Root cause (recorded 2026-11-18, conductor): yoke pkg/fleet Catalog.SmokeArgv smoked a tool through its first non-retired binding in name order. For codex that is codex-bedrock-gpt6-sol and for opencode opencode-bedrock-glm-5, both kind: api models keyed by aws-bedrock, which this host does not hold. The smoke failed, the probe cache recorded the TOOL as unusable, and sprint assign excluded every codex and opencode binding ('cached probe: unusable tool:codex'), although codex exec and opencode run answer SMOKE-OK directly on their subscription bindings. Classification: product defect in the probe. Fix: prefer a non-api binding for the smoke, keeping an api binding only as the fallback when nothing else is declared; test TestSmokeArgvPrefersNonAPIBindings.
