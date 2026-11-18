---
id: f7649d9479f5
kind: feature
title: S13 refactor the operator's résumé site by running website.bsh assess/enable
seq: 472
status: todo
priority: p1
labels:
    - shaping
    - dogfood
created: 2026-11-18T20:35:32.49827Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enable an existing website: free host or owner outpost, guest and circle tiers'
---

Planned vendor: claude. On the operator's own public résumé site (Next.js static export on GitHub Pages; URL in private memory), run website.bsh assess/enable. Engine-mode client (api/me 404 = public only); private-field type moved to the companion repo with audience:; recruiter-circle fields (contact, certificates); one view (recruiter summary); tier-0 link in the header and the no-script fallback; a Request access contact link (the visitor reaches the owner themselves). Every manual step the scaffold missed is fixed in S8, not by hand. Spec: docs/sprint-615-master-execution-plan.md
