---
id: 66c132903b6b
kind: feature
title: 'S2: Mode (b) isolated ephemeral --cligw LLM service, reverse proxy, and genie harness seam'
seq: 560
status: todo
priority: p1
labels:
    - yoke
    - cligw
    - agenthub
created: 2026-11-20T13:08:36.087546Z
sprint: 679
sprint_id: 7ab2fc0a-5df9-588a-a77a-8c851fe7ce74
sprint_title: 'One Agent: bashy genie unified TUI and multi-protocol agent/cligw hub'
---

Repo: yoke. Extend cligw.ServerOptions with PinnedTool, PinnedModel, and ExtraArgs so an ephemeral cligw.Server runs on 127.0.0.1:0 with isolated temp state without touching port 24556 or endpoint.json. Implement mode_cligw.go in yoke/pkg/agenthub to reverse-proxy /v1/chat/completions, /v1/responses, /v1/models, and /anthropic/v1/messages to the ephemeral cligw port while feeding OPENAI_BASE_URL + internal token into HarnessTurnFunc. Depends on S1. Spec: docs/plan-one-agent-genie-hub.md
