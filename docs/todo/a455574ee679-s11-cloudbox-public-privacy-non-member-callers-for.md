---
id: a455574ee679
kind: feature
title: 'S11 cloudbox-public privacy: non-member callers forwarded as authenticated + per-site pseudonym, never email'
seq: 474
status: wontfix
priority: p1
labels:
    - shaping
    - cloudbox
    - privacy
created: 2026-11-18T20:47:25.086611Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
closed: 2026-11-18T21:09:06.632009Z
---

Planned vendor: claude (cloudbox). Public wire contract only; never quote hosted internals in public docs. Today a require_login=false app receives a signed-in caller's email as X-Periscope-User, and the access is audited under that email for the owner, even when the caller is not a member of the host owner. Change: if the caller is neither the owner nor an active mutual member of the host owner, forward X-Periscope-Authenticated: true plus X-Periscope-Visitor, a per-(owner, host, app) pseudonym (a keyed HMAC computed from a server secret, never stored, so no schema change), and no email; pseudonymize the audit row too. Members and the owner are unchanged. Acceptance: unit cases for non-member / member / owner / anonymous; a compatibility check of every existing require_login=false app that reads the email. Release shared with Sprint 664 W1 (todo 3bf3516ffb34); whoever merges second regenerates the route goldens. The consented access request is in Sprint 665. Spec: docs/sprint-615-master-execution-plan.md

CLOSED, no change needed (2026-11-18, conductor). Root cause recorded: the premise was that the owner learns a non-member's email from the cloudbox audit row. That is false. AuditAPI.ListOwned and Clear filter on email = caller, so a host-share-access row keyed by the visitor's email is listed only to that visitor, never to the host owner. No owner-facing audit reader exists. The edge does forward the email over the tunnel to the owner's outpost, but S10 (outpost c4e1154) withholds it from the app and stamps a per-app pseudonym. So the site never learns it, and no cloudbox release is needed for Sprint 615. A future owner-facing audit view must pseudonymize non-members; noted here for whoever builds one.
