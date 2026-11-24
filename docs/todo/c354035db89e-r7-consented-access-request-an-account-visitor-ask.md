---
id: c354035db89e
kind: feature
title: 'R7 Consented access request: an account visitor asks the owner for access and becomes a member through the existing invite and circle'
seq: 713
status: todo
priority: p2
labels:
    - shaping
    - access-tiers
created: 2026-11-24T18:25:09.554764Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Spec: docs/access-tiers.md (the only in-product path from account to member). Carried from Sprint 665 bc64cb9499f3 and Sprint 669 M3 (both retired). The visitor's email leaves the pseudonym only after explicit consent, for that one request; the owner grants with the existing invite and circle (outpost apps share, after Sprint 703's S14 fix); distinct from a change request (R5 queue). Public side: api/request and a consent prompt in bashy examples/shaping/website/template; cloudbox side: a private ticket by id. Acceptance: no email in any log or header before consent; a refusal without consent demotes to the plain 'contact the owner' link (Sprint 615 fallback); the granted visitor shows as member on the next request.
