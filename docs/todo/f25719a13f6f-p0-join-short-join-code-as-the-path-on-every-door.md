---
id: f25719a13f6f
kind: feature
title: 'P0 join: short join code as the path on every door; handle bound to address for anonymous participants'
seq: 653
status: todo
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.656217Z
sprint: 696
---

Join code (two words or 4-6 chars, unique per host, author-chosen or generated) is the page path on the loopback, LAN and satellite doors; ?id= keeps working; page serve --lan takes a fixed port; page open prints both links, a QR for each and the bare code; the page root is a join screen. Principal detection: console principal or the signed outpost relationship stamp = authenticated, no prompt; otherwise a handle prompt (name, email, or one-click random identifier). Identity key for anonymous = handle@client-address for the session, corroborated by the kit cookie and a client fingerprint; same handle from another address refused (or suffixed, per shaped.json); same address with a lost cookie reclaims its handle; the forwarded client address is trusted only through the tunnel. Participant record {handle, principal?, address, fingerprint, cookie, auth, joined_at, last_seen}; facilitator rename/merge/kick/--open, all logged; OTel attributes participant.handle/auth/address only when the owner's OTel is configured. Tests: refresh keeps one vote; second address same handle refused; distinct forwarded addresses through the tunnel; export carries no addresses. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).
