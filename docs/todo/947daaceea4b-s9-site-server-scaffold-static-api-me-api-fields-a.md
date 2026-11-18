---
id: 947daaceea4b
kind: feature
title: 'S9 site-server scaffold: static + api/me, api/fields, api/view; fail-closed audience matrix'
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

Planned vendor: claude. Go shaped.json server shipped by website.bsh enable: serves the static build + api/me (caller tier: owner | member:<circle> | signed-in | anonymous), api/fields (private fields filtered by audience), api/view (S12). App registered as cloudbox public (require_login=false): anonymous passes, a signed-in non-member arrives as authenticated + per-site pseudonym, never an email (S11); members carry email + circle via S10. Identity via coopauth (signed outpost stamp; unsigned = anonymous). Audience = cloudbox rule grammar + signed_in, evaluated with the yoke boundary matcher; no audience = owner only. Tier name for non-members is signed-in, never guest (guest is cloudbox's default member circle). Test matrix owner / circle / other circle / signed-in / anonymous / forged headers, CLI and HTTP. Spec: docs/sprint-615-master-execution-plan.md
