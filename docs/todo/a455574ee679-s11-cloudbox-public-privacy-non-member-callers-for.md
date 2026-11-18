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

Planned vendor: claude (cloudbox). Public wire contract only; never quote hosted internals in public docs. Today a require_login=false app gets a signed-in caller's email as X-Periscope-User, and the access is audited under that email for the owner, even when the caller is no member of the host owner. Change: if the caller is not the owner and not an active mutual member of the host owner, forward X-Periscope-Authenticated: true plus X-Periscope-Visitor: a per-(owner, host, app) pseudonym (keyed HMAC, stable for one site, unlinkable across sites) and no email; pseudonymize the audit row too. Members and owner unchanged. Acceptance: unit cases non-member / member / owner / anonymous; compatibility check of every existing require_login=false app that reads the email (record which, and the decision). Release: coordinate with the Sprint 664 conductor (todo 3bf3516ffb34). Spec: docs/sprint-615-master-execution-plan.md
Design constraint (agreed with the Sprint 664 conductor 2026-11-18): the pseudonym is computed (keyed HMAC from a server secret), never stored. That means no table, no SchemaRevision bump and no schema golden change. Release is shared with S664 W1; whoever merges second rebases and regenerates the route goldens.
Access request by consent (operator 2026-11-18): circle members keep email + circle. A non-member who asks for privileged access must disclose their email, and only by explicit consent. On a public app, a request to the app's declared request path (api/request) is held by the edge behind a consent prompt ("share your email with the owner of <host>?"). Only after confirming is X-Periscope-User forwarded, for that one request, marked X-Periscope-Consent: access-request; the consent is audited under the email. Declining forwards nothing. No new membership-request store: the owner answers with the existing Invite + circle and the visitor uses the existing AcceptInvitation. Acceptance adds: no email without consent; consent covers one request only.
