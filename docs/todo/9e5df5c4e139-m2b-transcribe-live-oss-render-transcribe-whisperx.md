---
id: 9e5df5c4e139
kind: test
title: 'M2b-transcribe live oss render: transcribe-whisperx'
seq: 203
status: todo
priority: p1
labels:
    - media
created: 2026-11-13T04:13:36.475906Z
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Split of M2b (eb5e0303) per operator mb:13600. Windows test host (alias in operator mb:13586): 'bashy claim host:<alias>' first, release on every exit; native bashy.exe/.bsh/uv first, WSL only with a recorded reason (mb:13598); never touch the default podman machine; no WSL config change; disk preflight; no AWS; nothing heavy on the dev host. Reuse weights already on the host (do not re-download). Commit evidence as soon as it lands. If a render legitimately needs more than the run's max-runtime, stop, record why, and ask the conductor to raise it explicitly.
Depends on M2b-w. Render one SRT from the song clip or a fixture (bashy providers select transcribe + rod) with weights from M2b-w; record works/blocked, wall time, peak memory, disk, the bashy-svc-v1 envelope, and the artifact checksum.

NEVER RE-DOWNLOAD (operator mb:13612): weights are already staged on the Windows test host in the WSL rod cache (BASHY_OSS_CACHE root /root/s627-m2b/cache; ~54 GB: song-acestep 18G, narrate-local 8.6G, transcribe-whisperx 6.2G, image-qwen 20G partial; plus 5.9G HF cache) with per-file SHA256 in docs/sprint-627-m2b-weights-evidence.md. When running rods natively, COPY the staged files (verify the recorded checksums) or point native rods at one shared cache - never fetch them again.
