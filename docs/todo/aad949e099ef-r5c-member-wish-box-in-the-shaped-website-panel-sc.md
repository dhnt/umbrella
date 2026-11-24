---
id: aad949e099ef
kind: feature
title: R5c Member wish box in the shaped website panel, scope-gated, through the site MCP
seq: 726
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T21:09:07.768377Z
assignee: agy-gemini4-carbon
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T22:17:54.992909Z
closed_by: claude-opus5.5
---

Part of R5 (5c1b07e994f1). bashy examples/shaping/website/template only (module site-shaping, no bashy/yoke imports: standalone_deps_test.go).
Today the panel's shape link is owner-only (main.go:195,203,236). Add a wish box to the panel (public/shaping.js + api/me) for a member whose stamp matches the app's shape scope: it posts the wish to the site MCP at the app's <mount>/mcp (same origin, through the outpost, so the member's cloudbox login identifies them; no token, no OS password), then shows verify/preview status; the owner additionally sees approve. api/me reports the caller's scope. The template reads scopes from the app's shaped.json (the same key R5a defines) with its own parser.
Acceptance: template main_test.go cases for owner, member with shape, member with edit, member without scope (no box), account, anonymous; GOWORK=off go test in template/.
