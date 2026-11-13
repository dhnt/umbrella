---
id: f397d1cd72f6
kind: enhancement
title: 'Landing page: move Apps up under Recent (Cloud and Neighborhood below)'
seq: 256
status: assigned
priority: p1
labels:
    - app
    - web
created: 2026-11-13T20:51:42.456931Z
assignee: claude-fable5.1-s636
sprint: 636
sprint_id: 3a22a674-3f50-586e-914a-4be22f7e6de5
sprint_title: 'bashy apps UI: landing section order + Flow mark on the Shape button'
---

yoke pkg/webconsole/artifact/app.js renderHome: append the Apps section right after Recent, before cloudSection() and neighborhoodSection() (today Apps is last). Keep the 'no app matches' empty state in the same slot. Mirror the order in the SECTIONS settings-toggle list (Overview, Favorites, Recent, Apps, Cloud, Neighborhood) so Settings reads top to bottom like the page. Add a webconsole asset test that asserts the append order in renderHome (assets_test.go already greps function names). Verify: go test ./pkg/webconsole in yoke; open the installed console and confirm the order with Cloud and Neighborhood both visible. Then bump the yoke pin in bashy (bashy mod sync) and the umbrella gitlinks.
