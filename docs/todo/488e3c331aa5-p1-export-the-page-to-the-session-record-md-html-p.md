---
id: 488e3c331aa5
kind: feature
title: P1 export the page to the session record (md, html, pdf)
seq: 656
status: todo
priority: p1
labels:
    - page
    - software-shaping
created: 2026-11-23T12:00:00.098956Z
sprint: 696
---

page export --to md writes the page with every block's final state inline: per-handle answers for collections, tallies with handles for votes (hidden under --anonymous), presence list, timer totals; never addresses. --to html self-contained; --to pdf through viewer's headless-Chrome path. The Markdown shape matches a session record a group commits to its repository. Spec: docs/page-live-group-page.md.
