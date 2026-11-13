---
id: e013898155eb
kind: bug
title: M2b-song-b song-acestep rod must render offline from the staged checkpoint
seq: 204
status: todo
priority: p1
labels:
    - media
created: 2026-11-13T06:44:06.924995Z
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

From M2b-song (0d2e5664, evidence docs/sprint-627-m2b-song-evidence.md): the shipped rod (bashy 1aadad81) ignored the staged checkpoint path and auto-selected a 4B LM, causing two unintended ModelScope partial downloads (~412 MB, ~138 MB) at render time; the successful run needed a manual staged-checkpoint symlink and the LM disabled. Fix in the rod: always point ACE-Step at the staged checkpoint under BASHY_OSS_CACHE, LM off unless explicitly requested and staged, and set offline flags (no hub/ModelScope fetch during render; fail with the stage command if weights are missing). Verify offline with a fixture test (no network) and, on the Windows test host, one render with zero download markers. Never re-download (mb:13612).
