---
id: 0eaeb7a534e6
kind: feature
title: S10 outpost stamps circle/groups/owner for trust-identity apps; coopauth carries them
seq: 304
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
    - outpost
    - core
created: 2026-11-15T00:02:48.613993Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: codex. PUBLIC outpost + yoke change, small, separate commits, prerequisite of S6; useful to every app behind outpost (operator principle: apps receive the caller's relationship, circle and groups relative to the owner, not just the email). outpost: HostGrants.Lookup(email) -> {owner bool, circle, groups[]} from the copy that admitted the caller (same loop as Admits); in apps.go stamp X-Outpost-Circle, X-Outpost-Groups (comma list), X-Outpost-Owner (true|false) only when trust_cloud_identity is on and the request came through the tunnel; add them to identityHeaders so inbound copies are stripped; extend and VERSION the HMAC payload; do not reuse Remote-Groups (it carries admin|user for off-the-shelf SSO apps). Add a loopback/admin verb outpost grants lookup EMAIL --json for on-host callers (bashy CLI with --principal). yoke/pkg/coopauth: Identity gains Circle, Groups, IsOwner; VerifyOutpost checks the versioned signature; webconsole principal unchanged. Docs: outpost/docs/cooperative-web-apps.md header table + privacy note (the circle is the owner's private label; an app may use it, never show it to the member). Accept: outpost + yoke unit tests for stamp/strip/sign/verify and lookup; an app behind the fake tunnel sees the three headers for a member and X-Outpost-Owner=true for the owner; LAN/loopback requests carry none; existing apps unaffected (Remote-Groups unchanged). Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

Sprint 615 addition (2026-11-18): the site app is registered as cloudbox public (require_login=false). There the edge forwards a signed-in caller's email with no role and no share admission. The stamp must cover that path too: a forwarded email with no mutual membership gets X-Outpost-Circle empty (tier signed-in), and a member gets their circle. Anonymous gets no stamp.
