---
id: "393725804606"
kind: feature
title: 'S12 AI view route: one OpenAI-compatible route, owner BYOK, daily cap, data minimization'
seq: 471
status: done
priority: p1
labels:
    - shaping
    - llm
created: 2026-11-18T20:35:32.332417Z
assignee: claude-opus5.5-s615
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
closed: 2026-11-18T21:28:21.165228Z
closed_by: claude-opus5.5-s615
---

Planned vendor: codex. api/view calls one OpenAI-compatible route via yoke/pkg/llmgw/openai; site.json holds base URL, model and the key's secret name; the key comes from a host secret. A free API tier and bashy llm on the owner's host both fit this config; the MVP tests one live. Simple daily cap. Tests: the prompt holds only the caller tier's data; a route test against a fake endpoint. Spec: docs/sprint-615-master-execution-plan.md

Trailer correction (conductor, 2026-11-18): bashy commits d2e91376 and 94601a88 (pushed) carry the Story numbers of S9 and S12 swapped. S9 is #469 and S12 is #471; the Story-ID trailers in both commits are correct and authoritative. Published history is not rewritten.
