---
id: "393725804606"
kind: feature
title: 'S12 AI view route: owner or visitor BYOK, free API or bashy llm, allowance + cap, data minimization'
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

Planned vendor: codex. api/view in the site-server scaffold calls any OpenAI-compatible route via yoke/pkg/llmgw/openai. site.json holds the owner's route: base URL, model and the key's secret name; the key comes from a host secret. Routes: (a) a free API tier (GitHub Models, Gemini free, Groq, OpenRouter free); (b) bashy llm on the host (cligw over agent CLIs such as opencode with limited free access, or local models) with the owner token. Visitor BYOK, for signed-in visitors with their own outpost: (1) a per-request route of their own (their bashy llm or a provider key), used for that call only, never stored or logged, and not counted against the owner's allowance or cap; (2) CLI website.bsh view URL fetches the tier-allowed data with the visitor's session and renders it with the visitor's own bashy llm. Per-visitor daily allowance plus owner cap on the owner route. Tests: the prompt holds only the caller tier's data on every route; a visitor key never appears in logs or storage; a route test against a fake bashy llm. Spike: owner code-shaping with an --agent CLI on a free model; record the result. Spec: docs/sprint-615-master-execution-plan.md
