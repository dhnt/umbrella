---
id: c40c35f80d6b
kind: feature
title: 'S9 site: simple company website/presence as a shapeable custom command'
seq: 217
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-13T11:41:34.072356Z
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (LICENSE read, no open-core), >=1k stars, maintained -> fork + make shapeable; else build. Custom command in bashy/examples/site/, never core; job-only public wording. Base: gohugoio/hugo (Apache-2.0, Go) generator + sveltia/sveltia-cms (MIT) editor at /admin; optional puck (MIT) / GrapesJS (BSD-3) drag-and-drop. Serve output via the existing site app type; share via outpost or GitHub Pages (as examples/vlog). Done = shaping demo (e.g. add a pricing section only on my copy) + license re-verified.
