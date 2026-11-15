---
id: 6d7b6f28ee09
kind: feature
title: 'J7 Agent-first desktop: the dhnt.io desktop and page actions as MCP tools on the master gateway, for third-party agentic tools'
seq: 366
status: todo
priority: p1
created: 2026-11-15T17:32:10.169268Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
---

Spec: docs/sprint-641-master-execution-plan.md section J7. Expose desktop_schema|get|history (read), desktop_set|undo (write, own doc, reversible), desktop_wish (routed by the M6 policy: own subscription via Sprint 646 when a host exists, else the configured allowance), page_list|page_invoke (caller's own pages, named actions only) on the master MCP endpoint (Sprint 646 G1 OAuth 2.1 + G2 /mcp). Master-native: a phase-A person owns no machine, so the host-routed run tool cannot reach the desktop. Same handlers as /api/v1/desktop/*; input schemas generated from the declared schema; identical refusal texts on UI/CLI/MCP; audited with the OAuth principal; desktop token scope split read/write. Fix todo 1d91d26edc7c (per-subcommand atlas effects) in the same pass for the local bashy mcp serve twin. Add a desktop section to the Sprint 646 C1 client guides. Done when: handler tests prove each tool, scope refusal, cross-account isolation, allowance vs own-route decision and identical refusal text; tools/list matches bashy desktop --help --json; a real connector sets then undoes a property on a no-machine account (recorded in J6). Implementation in the hosted plane is tracked privately; public docs describe the wire only.
