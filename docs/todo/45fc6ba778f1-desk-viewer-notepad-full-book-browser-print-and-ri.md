---
id: 45fc6ba778f1
kind: enhancement
title: 'desk viewer & notepad: full-book browser print and rich HTML-to-PDF export in notepad'
seq: 37
status: done
priority: p1
labels:
    - desk
    - pdf
created: 2026-11-07T22:23:26.741631Z
assignee: agy-gemini3.8-flash
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
closed: 2026-11-08T00:00:39.509077Z
closed_by: agy-gemini3.8-flash
---

1) In bashy/examples/desk/viewer/page.go, the in-browser Print/PDF button invokes window.print() on the single-page view; add a full-book print/PDF view or action so browser printing covers all pages. 2) In bashy/examples/desk/notepad/export.go, pure-Go fpdf export only supports cp1252 Latin-1 headings/lists/code without tables, images, or full UTF-8; use headless Chrome printPDF (matching viewer) when available with pure-Go fallback.
