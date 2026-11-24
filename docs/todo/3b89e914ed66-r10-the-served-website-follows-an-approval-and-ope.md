---
id: 3b89e914ed66
kind: feature
title: R10 The served website follows an approval and open pages pick up the new version id
seq: 724
status: done
priority: p1
labels:
    - shaping
    - access-tiers
created: 2026-11-24T20:46:03.432041Z
due: 2026-12-04T00:00:00Z
assignee: agy-gemini4-neon
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
closed: 2026-11-24T21:33:03.552074Z
closed_by: claude-opus5.5
---

Part of the A/O/C case on R5 (5c1b07e994f1): everyone sees an approved change as fast as shaping allows. Today the website template's shaping.js reloads only after the viewer's own action. KISS: the template serves the active version id, and an open page polls it (a few seconds) and reloads, or shows a one-line notice while the viewer is editing, when it changes. No SSE and no new server. Acceptance: Go/DOM unit test that an approve on the host changes the served id and a page holding the old id reloads; no reload loop when the id is unchanged.

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- The public site does not follow an approval: website.bsh serve builds from DIR and restarts on the same port (246-289) and the owner is told to rerun serve after submit (319). Approve moves the principal's active revision in the managed src checkout (yoke pkg/shape/production.go:156-230); the console starts a per-revision server on the next request (webconsole/shaped_server.go:245-246,376).
- No version id, ETag, polling or SSE in the template (routes main.go:124-137; shaping.js loads me/fields once, 124/187; reload only after sign-out, 147-153). The desk kit SSE (kit/events.go) cannot be imported by the template (standalone_deps_test.go:33-43).
- So R10 is two steps: (1) the served site rebuilds from the owner's active revision on approve and exposes that revision id; (2) the panel polls the id and reloads. Tests: GOWORK=off go test in examples/shaping/website and in template/.
