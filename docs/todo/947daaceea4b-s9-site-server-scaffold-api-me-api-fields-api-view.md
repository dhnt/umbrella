---
id: 947daaceea4b
kind: feature
title: 'S9 site-server scaffold: api/me, api/fields, api/view; fail-closed audience matrix'
seq: 469
status: todo
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-18T20:35:31.995371Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: claude. Go shaped.json server shipped by website.bsh enable. It serves the static build plus api/me (tier: owner | member:<circle> | signed-in | anonymous), api/fields (private fields filtered by audience) and api/view (S12). Identity via coopauth: a member has email + circle (S10); a signed-in non-member has authenticated + pseudonym, never an email (S11); unsigned = anonymous. Audience uses the cloudbox rule grammar plus signed_in, evaluated with the yoke boundary matcher; no audience = owner only. Test matrix: owner / recruiter / other circle / signed-in / anonymous / forged headers. api/request is in Sprint 665. Spec: docs/sprint-615-master-execution-plan.md
