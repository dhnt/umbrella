---
id: 9e2c4591bdce
kind: bug
title: 'desk viewer & notepad: wire render.ChartSVG hook so fenced chart blocks render in views and PDF exports'
seq: 36
status: done
priority: p1
labels:
    - desk
    - pdf
    - chart
created: 2026-11-07T22:23:26.403587Z
assignee: agy-gemini3.8-flash
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
closed: 2026-11-08T00:00:39.048511Z
closed_by: agy-gemini3.8-flash
---

bashy/examples/desk/kit/render/fences.go defines var ChartSVG, but neither viewer nor notepad assigns render.ChartSVG at startup, causing fenced chart blocks in books and notes to degrade to 'chart renderer unavailable'. Wire the chart SVG renderer into viewer and notepad and verify with a test that fenced chart blocks emit <svg> in HTML and PDF exports.
