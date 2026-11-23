---
id: df08cca51889
kind: feature
title: 'P0 page skeleton: desk app on the seven verbs, shaped registration, publish-outpost'
seq: 652
status: done
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T11:59:59.509445Z
weave: 167
assignee: claude-opus5.5
sprint: 696
closed: 2026-11-23T12:50:46.566885Z
closed_by: agy-gemini4-carbon
---

examples/desk/page: item = Markdown + block fences + audience + participants + revision counter (reuse Sprint 684 G3 revisions when they land); verbs add -f, open (id, URL, status only), show, set, list, share, close, export --to md|html; page.bsh + Go server on the desk kit; register.sh registers app add --type shaped (Sprint 682 pattern); shaped.json; dag.md; publish-outpost via kit/outpost.bsh (--require-login); kit contract test green; UI-to-CLI parity rows in bashy docs/ui-cli-parity.md. Spec: docs/page-live-group-page.md.

Delivery rules: docs/page-live-group-page.md, section "Delivery rules for the Sprint 696 manager and workers" (current heads, one branch per story in bashy, module-local unit tests only on the dev box, root cause before fix, security contract tested, trailers incl. Agent:, no scope beyond the story).
