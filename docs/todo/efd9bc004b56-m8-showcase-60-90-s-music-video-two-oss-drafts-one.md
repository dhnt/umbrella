---
id: efd9bc004b56
kind: test
title: 'M8 Showcase: 60-90 s music video, two oss drafts + one commercial final, cost/time recorded'
seq: 188
status: assigned
priority: p2
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:29.254656Z
weave: 41
assignee: claude-opus5.5
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md (verification). Original fictional characters, AI-generated disclaimer card, >=1280x720, visible lip sync, subtitles within 150 ms, operator side-by-side vs reference frames with a kept frame grid.

SCOPE FOR THIS RUN (conductor, 2026-11-13; draft first, final once): produce the TWO oss DRAFTS only, then STOP. Use examples/film film.bsh on the Windows test host (claim it; native-first, WSL with a recorded reason; never touch the default podman machine; no WSL config change; batch probes over the direct outpost ssh form; refresh the elevation cookie from the vault yourself). Rods: song-acestep, image-klein (FLUX.2 klein-4B), narrate-local, transcribe-whisperx - all offline from the staged cache (never re-download). animate: NO oss route exists (M3/M3b: VAE decode stall) - use the labelled still-image slow-pan fallback; do NOT use the browser (Kling) or any paid/api route. Original fictional characters only; AI-generated disclaimer card; bilingual subtitles via media subs; 60-90 s; 1280x720 or better. Record per draft: wall time, per-stage time, artifacts + SHA256, cost (zero). Lock the storyboard after the drafts. The commercial --final is an operator-approved REMAINING CHECK: never pass --yes yourself.

RUN 2026-11-13 (claude-opus5.5): BLOCKED, no draft completed; evidence docs/sprint-627-m8-drafts-evidence.md. Draft 01: song ok (oss, 240 s, 75 s WAV), then portrait 1280x720 FLUX.2 klein GPU VAE decode hung -> TDR (LiveKernelEvent 141) and, after a bounded tiled-decode probe, an unexpected reboot of the Windows test host (11:05Z). Root cause class: environment (gfx1151 WSL ROCm VAE decode at 1280x720; 512x512 decodes). Remaining: operator picks an option (512 portraits + aspect-correct still-pan in film.bsh; CPU VAE decode in image-klein.py; another image host; driver investigation), then two drafts + lock. No GPU work on that host for M8 until then. --final untouched, no --yes, zero cost.
