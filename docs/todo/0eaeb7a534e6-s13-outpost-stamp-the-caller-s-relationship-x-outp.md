---
id: 0eaeb7a534e6
kind: feature
title: 'S13 outpost: stamp the caller''s relationship (X-Outpost-Circle, X-Outpost-Groups, X-Outpost-Owner) for trust-identity apps from the grant copy; outpost grants lookup EMAIL --json; coopauth.Identity gains Circle/Groups/IsOwner'
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
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: codex. PUBLIC outpost + yoke change, small, separate commits, prerequisite of S6; useful to every app behind outpost (operator principle: apps receive the caller's relationship, circle and groups relative to the owner, not just the email). outpost: HostGrants.Lookup(email) -> {owner bool, circle, groups[]} from the copy that admitted the caller (same loop as Admits); in apps.go stamp X-Outpost-Circle, X-Outpost-Groups (comma list), X-Outpost-Owner (true|false) only when trust_cloud_identity is on and the request came through the tunnel; add them to identityHeaders so inbound copies are stripped; extend and VERSION the HMAC payload; do not reuse Remote-Groups (it carries admin|user for off-the-shelf SSO apps). Add a loopback/admin verb outpost grants lookup EMAIL --json for on-host callers (bashy CLI with --principal). yoke/pkg/coopauth: Identity gains Circle, Groups, IsOwner; VerifyOutpost checks the versioned signature; webconsole principal unchanged. Docs: outpost/docs/cooperative-web-apps.md header table + privacy note (the circle is the owner's private label; an app may use it, never show it to the member). Accept: outpost + yoke unit tests for stamp/strip/sign/verify and lookup; an app behind the fake tunnel sees the three headers for a member and X-Outpost-Owner=true for the owner; LAN/loopback requests carry none; existing apps unaffected (Remote-Groups unchanged). Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
