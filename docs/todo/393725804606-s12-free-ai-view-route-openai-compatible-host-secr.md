---
id: "393725804606"
kind: feature
title: 'S12 free-AI view route: OpenAI-compatible, host-secret key, allowance + cap, data minimization'
seq: 471
status: todo
priority: p1
labels:
    - shaping
    - llm
created: 2026-11-18T20:35:32.332417Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: codex. api/view in the site-server scaffold calls any OpenAI-compatible route via yoke/pkg/llmgw/openai; site.json holds base URL, model and the key's secret name; key from a host secret; per-visitor daily allowance + owner cap; test that the prompt holds only the caller tier's data. Docs list GitHub Models, Gemini free, Groq, OpenRouter free. Spike: owner code-shaping with an --agent CLI on a free model; record the result. Spec: docs/sprint-615-master-execution-plan.md
