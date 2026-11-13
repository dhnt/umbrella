---
id: bc1044370bc1
kind: feature
title: 'S10 blog: personal blog/wiki with rich media as a variant of site'
seq: 218
status: assigned
priority: p2
labels:
    - shaping
created: 2026-11-13T11:41:58.613382Z
weave: 58
assignee: opencode-glm-5.3
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Same base as S9 site (Hugo + Sveltia CMS); no new fork. Adds rich content from the bashy media suite (examples/vlog, video, cast, record, transcribe) plus diagrams, code and math for tech-savvy authors. Custom command in bashy/examples/, never core; job-only public wording. Depends on S9. Done = shaping demo (e.g. add a series index or auto-captions only on my copy).

DRY (conductor 2026-11-13, operator rule "do not repeat yourself"): do NOT copy the site base. Reuse examples/site: the blog is a template/variant of the site command (for example `site new --template blog`, with blog layouts and content under examples/site/templates/blog/ or a thin examples/blog wrapper that calls site), sharing the one Hugo generator and the one vendored Sveltia CMS (examples/site/sample/static/admin). No second copy of sveltia-cms.min.js or generator/main.go. Re-run the no-phone-home gate with the fixed script from origin/main (or PATH=/usr/bin:/bin); the copy in this workspace fails open.
