---
id: e36a293f92ca
kind: feature
title: 'R6 Common personalization wishes for public visitors: a default, owner-editable wish list in website.bsh enable'
seq: 522
status: todo
priority: p1
labels:
    - website
    - shaping
created: 2026-11-19T09:46:35.470307Z
sprint: 706
sprint_id: 626dbf6e-b665-5fbc-818b-54aa5c972a8c
sprint_title: 'Access tiers: anonymous, account, owner across cloudbox and bashy'
---

Operator request 2026-11-19 (from the Sprint 641 J3 session). For public and anonymous visitors of a shaping-enabled site, offer a short list of common personalization wishes (for example dark or light, larger text, compact, high contrast, reduce motion), so personalization works without free-text wishes. When an owner creates or converts a site with website.bsh (assess/enable), add the list BY DEFAULT. The site owner can add or remove entries ('website.bsh wishes ls|add|rm --json' or equivalent; CLI parity, one way). Constraints from settled rules: public visitors change declared configuration only (638 S10 'public-facing apps are configuration-only'); each entry maps to a declared property patch, so no model call is needed and nothing can be spammed (free-text wishes and 'suggest to owner' stay limited to circles, see Sprint 641 J3b 770e6e1fa548); an entry outside the site's declared properties is refused at add time, fail-closed. Done when: enable writes the default list; ls/add/rm work with --json; a visitor applies an entry with no model call; an invalid entry is refused naming the property; Go tests against fakes; the kb runbook (kb/defaults shaping-enable-an-existing-website) is updated.

## Code inspected 2026-11-24 (before planning; facts at origin heads)

- No declared properties or wishes in the website template or website.bsh (enable writes files at 162-205; shaped.json has server args only). The only property-patch path is cloudbox's desktop set (yoke pkg/fleet/desktop_cmd.go:111-119, token-scoped; refusal in cloudbox, private), unusable for anonymous visitors.
- MVP: browser-local only (spec: anonymous configures, nothing kept server-side): a wishes list in site.json (each entry = a CSS custom-property or class patch from a declared set), applied by shaping.js and kept in localStorage; website.bsh wishes ls|add|rm --json edits site.json and refuses an entry outside the declared set. Tests: website_test.go (enable writes the default list) and template main_test.go.
