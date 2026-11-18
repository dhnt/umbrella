---
id: a455574ee679
kind: feature
title: 'S11 cloudbox-public privacy: non-member callers forwarded as authenticated + per-site pseudonym, never email'
seq: 474
status: todo
priority: p1
labels:
    - shaping
    - cloudbox
    - privacy
created: 2026-11-18T20:47:25.086611Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: claude (cloudbox). Public wire contract only; never quote hosted internals in public docs. Today a require_login=false app receives a signed-in caller's email as X-Periscope-User, and the access is audited under that email for the owner, even when the caller is not a member of the host owner. Change: if the caller is neither the owner nor an active mutual member of the host owner, forward X-Periscope-Authenticated: true plus X-Periscope-Visitor, a per-(owner, host, app) pseudonym (a keyed HMAC computed from a server secret, never stored, so no schema change), and no email; pseudonymize the audit row too. Members and the owner are unchanged. Acceptance: unit cases for non-member / member / owner / anonymous; a compatibility check of every existing require_login=false app that reads the email. Release shared with Sprint 664 W1 (todo 3bf3516ffb34); whoever merges second regenerates the route goldens. The consented access request is in Sprint 665. Spec: docs/sprint-615-master-execution-plan.md
