---
id: 865a3b73a179
kind: feature
title: 'F Generic service door: shared provider selector, route field, tool commands as vendor providers, service-door.bsh + bashy-svc-v1'
seq: 172
status: assigned
priority: p0
labels:
    - vendor-services
created: 2026-11-12T23:18:13.75882Z
assignee: codex-gpt6-sol
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
---

Spec: docs/sprint-626-master-execution-plan.md (Design 1-6). Lift the transcribe selector (role match, accepts/requires, ambiguity, --provider wins) into a shared package; add optional route (oss|vendor|browser|api) to the command record (yoke/pkg/fleet/cli_commands.go); project tool commands: entries as route=vendor providers; add bashy providers [ROLE] / providers select; keep transcribe select as alias; auto order oss->vendor->browser->api; spend/send effects need --yes; service-door.bsh emits bashy-svc-v1; register service verbs via bashy/examples/defaults/bashy-defaults.bsh; search --backend aliases --provider. Verify: selector unit tests (order, --yes refusal, ambiguity, override), existing transcribe/search tests green, MCP discovery shows image and plan. Review: claude-opus5.5.
