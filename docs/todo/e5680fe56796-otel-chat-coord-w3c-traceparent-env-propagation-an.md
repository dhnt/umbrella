---
id: e5680fe56796
kind: feature
title: 'otel/chat/coord: W3C TRACEPARENT env propagation and cross-process agent episode identity'
seq: 41
status: todo
priority: p0
labels:
    - otel
    - agentos
created: 2026-11-08T01:01:07.887822Z
sprint: 590
sprint_id: e87405cd-e28f-57b5-bc3a-7727d4c92438
sprint_title: Third-party agent turn error-recovery OTel spans, Bash# KB wiki auto-composition, and KB/shaping tidy
---

In yoke/pkg/telemetry, yoke/pkg/chat, yoke/pkg/policy/coord, and bashy/cmd/bashy: 1) Add ExtractEnvContext and InjectEnv in telemetry.go and extract TRACEPARENT on bashy startup so child bashy -c invocations inherit active parent spans. 2) Inject TRACEPARENT into agentChildEnv in chat.go and wrap interactive chat.Session prompt-to-idle turns in StartGenAITurn. 3) Extend harnessSessionEnv in coord/identity.go (CLAUDE_CODE_SESSION_ID, CODEX_SESSION_ID, GEMINI_SESSION_ID, OPENCODE_SESSION_ID, AGY_SESSION_ID) and add deterministic parent-agent PID fallback (ep-ppid-<agent>-<ppid>). See docs/agent-turn-recovery-and-bashsharp-kb-plan.md.
