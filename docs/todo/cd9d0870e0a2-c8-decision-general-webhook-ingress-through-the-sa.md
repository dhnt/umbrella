---
id: cd9d0870e0a2
kind: spike
title: 'C8 Decision: general webhook ingress through the satellite (gates WhatsApp Cloud API, Teams, Google Chat)'
seq: 156
status: todo
priority: p3
labels:
    - communications
    - software-shaping
created: 2026-11-12T16:17:25.922337Z
sprint: 620
sprint_id: 91b5eb56-f45a-5905-acd4-c67eddfb7e69
sprint_title: 'Communications: two-way human/agent access (CLI + web UI, instant switch)'
---

Wave-3 channels (WhatsApp Cloud API, Microsoft Teams, Google Chat) are official but require a public HTTPS webhook and business/tenant registration. Record the architecture decision on whether satellite/outpost app share should host a per-owner webhook ingress under grants or defer, evaluated through the "rod, not fish" and software shaping principles in `[[kb:extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]` (relates `5e498abf46ae`, `ad1db13b585f`, `42f89d1069ee`). Decision only. Planned worker: claude-opus5.5.

### Rod, Not Fish & Software Shaping Evaluation Criteria
- **Mechanism, not a vendor catalog:** If webhook ingress is adopted, core/outpost must provide ONE generic, provider-agnostic webhook-to-`bashy-feed-envelope-v1` ingress mechanism under outpost app share / circle grants — never hardcoded per-vendor Go servers in core.
- **Per-channel `.bsh` normalizer units (rod, not fish):** Each wave-3 provider (WhatsApp Cloud API, Teams, Google Chat) must be expressible as a shapeable `.bsh` skill-script or shaped `api/<provider>.md` unit (`contract.bsh` `@effects`, signature verification, payload -> `bashy-feed-envelope-v1` JSONL) that feeds the same `comms/lib/listen.bsh` (C6) -> `bashy meet dm` single pairing gate.
- **Boundary & security analysis:** Evaluate how public webhook endpoints (which carry vendor HMAC signatures rather than interactive browser session cookies) interact with outpost default-deny grants, replay protection, rate limiting, and `yoke/pkg/shape/boundary` containment (`$BASHY_APP_DATA`).

### Deliverable
- Decision section recorded in `docs/comms-strategy.md` (or linked ADR) with a clear go/defer verdict, security boundary model, and the exact `.bsh` normalizer + `contract.bsh` shape for wave-3 channels if approved.
