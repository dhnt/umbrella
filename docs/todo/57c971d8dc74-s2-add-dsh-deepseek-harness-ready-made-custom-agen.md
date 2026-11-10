---
id: 57c971d8dc74
kind: feature
title: S2 Add dsh (DeepSeek Harness) ready-made custom agent CLI recipe in bashy/examples/fleet/tools/dsh.yaml
seq: 77
status: done
priority: p1
labels:
    - fleet
    - cli
    - examples
created: 2026-11-10T15:56:59.609267Z
assignee: agy-gemini3.8-flash
sprint: 608
sprint_id: 409cb1b5-7378-5651-8937-ba149e395500
sprint_title: Add dsh custom agent CLI example and document agentic CLI support
closed: 2026-11-10T18:15:58.117458Z
closed_by: agy-gemini3.8-flash
---

Add bashy/examples/fleet/tools/dsh.yaml for DeepSeek Harness (https://github.com/deepseek-ai/deepseek-harness.git) as a ready-made custom agent CLI in examples/ only (not in builtin baseline tools). Support headless one-shot execution (dsh --profile headless), ACP stdio server (dsh --profile acp), DSH_HOME state_dir isolation, danger-full-access autonomous mode, telemetry and session-log-deepseek opt-out, cordis.patch.yml setup for both OpenAI-compatible gateways (llm-pi-ai) and native DeepSeek API (deepseek-official), and integration for skills (~/.dsh/skills) and instructions (~/.dsh/AGENTS.md). Update bashy/examples/fleet/README.md.
