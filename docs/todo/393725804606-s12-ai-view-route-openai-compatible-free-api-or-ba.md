---
id: "393725804606"
kind: feature
title: 'S12 AI view route: OpenAI-compatible (free API or bashy llm over agent CLIs), allowance + cap, data minimization'
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

Planned vendor: codex. api/view in the site-server scaffold calls any OpenAI-compatible route via yoke/pkg/llmgw/openai; site.json holds base URL, model and the key's secret name; the key comes from a host secret. Two kinds of route, same config: (a) a free API tier (GitHub Models, Gemini free, Groq, OpenRouter free); (b) bashy llm on the host (cligw over agent CLIs: opencode and other tools with limited free access, or local models), with the owner token, for owners with an outpost or a free host where the CLI is installed. Per-visitor daily allowance + owner cap; test that the prompt holds only the caller tier's data; a route test against a fake bashy llm. Spike: owner code-shaping with an --agent CLI on a free model; record the result. Spec: docs/sprint-615-master-execution-plan.md
