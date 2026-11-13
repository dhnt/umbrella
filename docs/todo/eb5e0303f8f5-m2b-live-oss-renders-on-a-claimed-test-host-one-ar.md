---
id: eb5e0303f8f5
kind: test
title: 'M2b live oss renders on a claimed test host: one artifact per oss rod'
seq: 193
status: todo
priority: p1
labels:
    - media
created: 2026-11-13T01:29:16.115475Z
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Remaining check from M2 (341fb646, bashy 7e32a39c), deferred by operator rule mb:13538 (no model downloads or live model runs on the dev host). On a claimed test host (the Windows test host or a droplet; bashy claim host:<role>): run the disk-headroom preflight, first-use weight downloads, and 'bashy <verb> --route oss --json' once per rod (song-acestep, image-qwen generate+edit, narrate-local, transcribe-whisperx); record wall time, disk used and the bashy-svc-v1 envelopes. Needed before M7/M8 drafts.
