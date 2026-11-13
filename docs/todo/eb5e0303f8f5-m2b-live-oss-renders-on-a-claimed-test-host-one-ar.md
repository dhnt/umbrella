---
id: eb5e0303f8f5
kind: test
title: 'M2b live oss renders on a claimed test host: one artifact per oss rod'
seq: 193
status: assigned
priority: p1
labels:
    - media
created: 2026-11-13T01:29:16.115475Z
weave: 30
assignee: muse-conductor
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Remaining check from M2 (341fb646, bashy 7e32a39c), deferred by operator rule mb:13538 (no model downloads or live model runs on the dev host). On a claimed test host (the Windows test host or a droplet; bashy claim host:<role>): run the disk-headroom preflight, first-use weight downloads, and 'bashy <verb> --route oss --json' once per rod (song-acestep, image-qwen generate+edit, narrate-local, transcribe-whisperx); record wall time, disk used and the bashy-svc-v1 envelopes. Needed before M7/M8 drafts.

VENUE (conductor per operator mb:13586, 2026-11-13): the Windows test host (alias in operator mb:13586). 'bashy claim host:<alias>' FIRST, release after; never touch its default podman machine (live Klatch); no 'wsl --shutdown' or .wslconfig change without operator approval (WSL sees ~31 GiB). Work in the Ubuntu-24.04 WSL distro reached via outpost ssh ... -- wsl -d Ubuntu-24.04 -u root -- bash -s; one held foreground session for long jobs. If the outpost elevation cookie expires, ask the conductor (it refreshes from the vault). Disk preflight before weights. GPU there is AMD gfx1151 with ROCm 7.2 + PyTorch ROCm already installed by M3 (see the M3 story outcome): use ROCm where a rod supports it, else CPU; record per rod: works/blocked, wall time, peak memory, disk, and the bashy-svc-v1 envelope. Nothing heavy on the dev host; no AWS.

PLATFORM RULE (operator mb:13598, kb decision windows-native-first-wsl-only-with-a-recorded-reason, bashy 7fea18e8): native bashy.exe + .bsh + uv + Windows builds FIRST; use WSL only with a recorded reason (why native failed or is unavailable) in the evidence.
