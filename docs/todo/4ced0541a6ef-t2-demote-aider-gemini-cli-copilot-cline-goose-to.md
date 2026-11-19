---
id: 4ced0541a6ef
kind: refactor
title: T2 Demote aider, gemini-cli, copilot, cline, goose to examples
seq: 536
status: todo
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:45.484752Z
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
---

Delete yoke/pkg/fleet/baseline/tools/{aider,gemini,cline,goose}.yaml (gemini MODELS stay, agy routes them). Remove aider from yoke/pkg/agentlaunch SeededProfiles + unsafe map. Cut bashy install-agent to the official set (drop aider, gemini, copilot). Refresh bashy/examples/fleet/tools/{aider,gemini,copilot,cline,goose}.yaml headers and drop the README --force note. detect.go env hints stay. Accept: yoke ./pkg/fleet/... ./pkg/agentlaunch/... and bashy ./internal/agentos/... green with GOWORK=off; bashy tool add works for each example.
