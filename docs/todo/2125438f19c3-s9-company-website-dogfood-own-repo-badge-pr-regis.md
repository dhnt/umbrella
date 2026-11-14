---
id: 2125438f19c3
kind: test
title: 'S9 Company-website dogfood: own repo, badge PR, register at the engine, run verification 1-7'
seq: 289
status: todo
priority: p1
labels:
    - shaping
    - verification
created: 2026-11-14T22:42:23.19614Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: claude. Operator decision first: the company website becomes its own repo (subtree split). One PR adds scaffold + tier-0 badge in the no-JS fallback and the footer + a three-level policy; the engine host registers it behind outpost (token in env); run verification steps 1-7 of the sprint plan; record candidate/revision ids and whether ?page= survives the edge login round-trip. Depends on S1-S8. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
