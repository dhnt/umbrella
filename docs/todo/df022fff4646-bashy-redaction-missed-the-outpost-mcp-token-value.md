---
id: df022fff4646
kind: bug
title: 'bashy redaction missed the outpost MCP token: value-only (vault) redactor, no shape detection, not applied at log sinks'
seq: 448
status: assigned
priority: p1
labels:
    - bashy
    - outpost
    - security
created: 2026-11-17T21:30:13.790218Z
assignee: codex-gpt6-sol
sprint: 658
sprint_id: f426cf37-7c11-5d0c-beca-7e405177868d
sprint_title: outpost MCP admin token leaked to daemon.log (fix with the refactor/rebuild)
---

Operator 2026-11-17: 'bashy does redaction, and it failed.' Root cause (code-verified): (1) yoke/pkg/secrets EnvValueRedactor masks only VAULT-registered values present in the process env; app-generated credentials (outpost MCP bearer in agent.json, app SSO secrets, federation/cluster/node tokens) are never registered, so they are invisible to it. (2) The shape-aware matcher (policy/audit: secretishKey + highEntropyToken) runs on argv only, never on output or logs. (3) Redaction is applied only at a few egress points (broker capture, handoff, bus, feed); outpost's supervisor writes child stderr to daemon.log directly, and agent-facing command output is not covered. Fix: one redactor for every sink: (a) components register the secrets they mint (outpost MCP token, SSO secrets, join tokens) with the host redactor on creation/rotation; (b) shape fallback for key/value credential forms (bearer, token=, Authorization:) with high-entropy values; (c) apply at log writers (supervisor LogPath sinks, bashy-supervisord log, daemon.log) and agent-facing output. Regression test: start outpost, assert no MCP token in daemon.log and in captured agent output. Verification = unit tests + build (operator rule). Pairs with f83b4703.
