---
id: c57352602fd1
kind: spike
title: 'P1 Design Muse Code as the resident agentic tool on outposts: install, subscription or API-key auth, Contributor mode off, headless operation and agentlaunch binding'
seq: 352
status: wontfix
priority: p1
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:29.321639Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
closed: 2026-11-15T15:08:21.420085Z
---

Goal B. Per outpost host role (never named hosts in this public repo): install the muse CLI (macOS/Linux/Windows installers, dev.meta.ai/docs/muse-code.md); authenticate either with the subscription-connected Muse Code credential from CLI onboarding (flat monthly tiers, credential is Muse Code only; extra API keys are pay-as-you-go) or META_API_KEY from the host secret store for headless muse exec (dev.meta.ai/docs/muse-code/auth.md, subscriptions.md); Meta Managed Account hosts must use an API key. Pin Contributor mode OFF on every run (flag or env) and verify per host: subscriptions default it on, it is saved per computer, and headless behavior depends on settings-file state. Bind through the existing agentlaunch mechanism (yoke/pkg/agentlaunch) alongside other vendor agents: identity, model, billing class, band gates. Local tool wiring: bashy mcp serve stdio profile + loopback outpost MCP (outpost/docs/mcp.md); sandbox and approval posture for unattended runs; MCP tools are not sandboxed, so default to read-only toolsets (run.toolset) and effect grants. Cover updates, logout/revocation, usage accounting per host role, failure when subscription seats or rate windows are exhausted, and rollback to another vendor binding. Planning only: no installs, no sign-ins, no launches.

## Superseded (2026-11-15)
Superseded by Sprint 646 (2167db86-22b7-5429-9bfe-b96a8d93a353), the buildable MVP that merges Sprints 642-645; design of record docs/vendor-chat-gateway-mvp.md. The research above remains the reference; open live checks moved to Sprint 646 stories C1 (6f2d02f6be96) and E1 (a0a72ad338de).
