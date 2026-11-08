---
id: d1def60609c8
kind: enhancement
title: 'examples/video: add image/slide storyboard cards and SRT/VTT subtitle burn-in'
seq: 39
status: done
priority: p1
labels:
    - video
    - transcribe
created: 2026-11-07T22:23:27.409229Z
assignee: agy-gemini3.8-flash
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
closed: 2026-11-08T00:00:40.445819Z
closed_by: agy-gemini3.8-flash
---

In bashy/examples/video/video.sh: 1) card only renders terminal text via agg; add a slide <image.png> <seconds> directive to render static PNG/JPEG diagrams, slides, or exported PDF pages at 1080p30. 2) Add subtitle burn-in / soft-track support (--subtitles or captions.srt/vtt) composing with bashy transcribe output.
