---
id: 09c8affd6fe4
kind: bug
title: 'M4b browser rods: declare jq/curl/ffprobe in requires; verify artifacts without degrading'
seq: 194
status: done
priority: p2
labels:
    - media
created: 2026-11-13T01:41:59.290611Z
assignee: muse-conductor
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
closed: 2026-11-13T02:48:30.647113Z
closed_by: claude-opus5.5-s627
---

From M4 acceptance review (bashy 3dcaf70d). 1) song-suno/image-chatgpt/animate-kling register requires=has=bashy only, but need jq, curl and ffprobe: per the M1 contract a missing dep must report unavailable with an install hint. 2) verify_audio/verify_video skip the ffprobe check when ffprobe is absent, and verify_image uses macOS-only sips, so on Linux/Windows the decode check silently degrades to a non-empty test (fail, not degrade; cross-OS parity). Fix: add has=jq has=curl has=ffprobe to requires and verify images with ffprobe on every OS.

VENUE RULE: code + offline fixture tests only on the dev host; no live browser generation, no model downloads, never pass --yes yourself (operator mb:13538/mb:13557). Base: bashy main (M5 f0fab4ac or later).
