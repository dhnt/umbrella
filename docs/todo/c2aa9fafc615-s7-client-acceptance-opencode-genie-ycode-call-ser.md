---
id: c2aa9fafc615
kind: test
title: 'S7 Client acceptance: opencode, genie, ycode call services via shell, MCP and llm API'
seq: 180
status: done
priority: p1
labels:
    - vendor-services
created: 2026-11-12T23:18:14.943104Z
weave: 24
assignee: claude-opus5.5
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
closed: 2026-11-13T02:27:48.674477Z
closed_by: claude-opus5.5-s626
---

Spec: docs/sprint-626-master-execution-plan.md. Depends S1-S6. Each client calls one seeded service per category through bashy <verb> --json, bashy mcp serve and the llm API slash= filter. Record a client x door x service matrix; failures get root cause before fix.

Conductor notes (2026-11-12): build bashy from bashy origin/main (be7118e6 or later) with GOWORK=off and use that binary by path (never replace ~/.local/bin/bashy). Service verbs are default custom commands registered by examples/defaults/bashy-defaults.bsh; on this host only `video` is registered, so register the defaults first (into an isolated BASHY home if possible). Seeded services to cover: plan (claude/agy/muse), search (search-codex/claude/agy/muse, brave), image (codex:image is SPEND: do not run it; dry-run/selection only), draw (claude), pdf (claude/agy), video (agy), transcribe (muse), email.read/drive.read (claude, READ-ONLY, count/ids only). Clients: opencode, genie, ycode (clients only). Doors: shell (bashy <verb> --json), MCP (bashy mcp serve), llm API slash= filter. No bypass flags; nothing sent/shared/spent. Record the client x door x service matrix in docs/sprint-626-acceptance.md (umbrella) with raw outcomes; failures get a recorded root cause (product/test/environment) before any fix. Commit with Sprint/Story/Story-ID and Agent: claude-opus5.5; do not push.
