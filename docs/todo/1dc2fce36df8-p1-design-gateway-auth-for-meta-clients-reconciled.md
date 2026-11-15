---
id: 1dc2fce36df8
kind: spike
title: 'P1 Design gateway auth for Meta clients reconciled with the shared S643 baseline: OAuth 2.1 for interactive clients and connector account linking, scoped Bearer for headless, one Cloudbox identity'
seq: 348
status: todo
priority: p1
labels:
    - software-shaping
    - meta-integration
created: 2026-11-15T13:45:12.280497Z
sprint: 645
sprint_id: a9bec834-6066-56ee-971d-8cd0d412222b
sprint_title: 'Meta Muse to the full Cloudbox stack: Muse clients as the user interface, Muse Code CLI as the outpost agent'
---

Delta on S643 auth story 31424ce68e52, not a second design. Cover: Muse Code remote-MCP OAuth 2.1 (muse mcp login, dynamic client registration on by default, token refresh); Muse directory connector OAuth incl. mandatory-where-possible Read Only option or API-key submission; Meta AI Connectors OAuth account linking; scoped Cloudbox Bearer for Model API / CI callers. Map each to the public Cloudbox token scopes (yoke/docs/cloudbox-members-attach-wire.md), tenant isolation, revocation, and the loopback-refusal contract in yoke/mcp/transport.go (issuer, resource URI, audience). Record every place Meta docs are silent (token lifetimes, callback requirements) as verify items. Sources: dev.meta.ai/docs/muse-code/extending.md, platform.muse.ai/docs sections 3 and 5.4, dev.meta.ai/products/connectors. Planning only.
