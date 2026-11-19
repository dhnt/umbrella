---
id: e36a293f92ca
kind: feature
title: 'S21 Common personalization wishes for public visitors: a default, owner-editable wish list in website.bsh enable'
seq: 522
status: todo
priority: p1
labels:
    - website
    - shaping
created: 2026-11-19T09:46:35.470307Z
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: 'Shaping-enabled simple site: showcase MVP on the operator''s résumé site'
---

Operator request 2026-11-19 (from the Sprint 641 J3 session). For public and anonymous visitors of a shaping-enabled site, offer a short list of common personalization wishes (for example dark or light, larger text, compact, high contrast, reduce motion), so personalization works without free-text wishes. When an owner creates or converts a site with website.bsh (assess/enable), add the list BY DEFAULT. The site owner can add or remove entries ('website.bsh wishes ls|add|rm --json' or equivalent; CLI parity, one way). Constraints from settled rules: public visitors change declared configuration only (638 S10 'public-facing apps are configuration-only'); each entry maps to a declared property patch, so no model call is needed and nothing can be spammed (free-text wishes and 'suggest to owner' stay limited to circles, see Sprint 641 J3b 770e6e1fa548); an entry outside the site's declared properties is refused at add time, fail-closed. Done when: enable writes the default list; ls/add/rm work with --json; a visitor applies an entry with no model call; an invalid entry is refused naming the property; Go tests against fakes; the kb runbook (kb/defaults shaping-enable-an-existing-website) is updated.
