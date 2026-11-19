---
id: 4ced0541a6ef
kind: refactor
title: T2 Finish demoting aider, gemini-cli, copilot, cline, goose to examples
seq: 536
status: done
priority: p1
labels:
    - agents
created: 2026-11-19T17:49:45.484752Z
assignee: claude-opus5.5-s671
sprint: 671
sprint_id: 4e6b5dcd-e6c8-5949-864a-799d4e9a9b5e
sprint_title: 'Agentic tool support: official set + latest models'
closed: 2026-11-19T18:31:07.00066Z
closed_by: claude-opus5.5-s671
---

These tools were already retired in yoke baseline on 2026-10-09 with example files; retired stubs STAY (retirement preserves history). Remove remaining live first-class references: aider in yoke/pkg/agentlaunch SeededProfiles + unsafe-flag map, aider/gemini in yoke/pkg/weave weaveKnownFallback, aider/gemini/copilot in bashy install-agent. Refresh example headers if stale; drop the stale README --force note. detect.go env hints stay. Accept: yoke ./pkg/fleet/... ./pkg/agentlaunch/... ./pkg/weave/... and bashy ./internal/agentos/... green with GOWORK=off.
