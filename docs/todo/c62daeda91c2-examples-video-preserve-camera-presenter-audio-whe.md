---
id: c62daeda91c2
kind: bug
title: 'examples/video: preserve camera presenter audio when mixing or attaching per-step narration'
seq: 38
status: todo
priority: p1
labels:
    - video
    - audio
created: 2026-11-07T22:23:27.072999Z
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
---

In bashy/examples/video/video.sh, when narration.m4a is present (-map 0:v:0 -map 1:a:0), it replaces the audio track of the entire video including camera presenter takes. Support per-step/per-card narration sidecars (steps/<name>.m4a, cards/<name>.m4a) and/or audio mixing so terminal steps get voice-over while camera segments keep their recorded speech.
