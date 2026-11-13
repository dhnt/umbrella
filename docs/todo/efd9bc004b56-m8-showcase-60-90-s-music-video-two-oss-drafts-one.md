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
weave: 55
assignee: claude-opus5.5
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md (verification). Original fictional characters, AI-generated disclaimer card, >=1280x720, visible lip sync, subtitles within 150 ms, operator side-by-side vs reference frames with a kept frame grid.

SCOPE FOR THIS RUN (conductor, 2026-11-13; draft first, final once): produce the TWO oss DRAFTS only, then STOP. Use examples/film film.bsh on the Windows test host (claim it; native-first, WSL with a recorded reason; never touch the default podman machine; no WSL config change; batch probes over the direct outpost ssh form; refresh the elevation cookie from the vault yourself). Rods: song-acestep, image-klein (FLUX.2 klein-4B), narrate-local, transcribe-whisperx - all offline from the staged cache (never re-download). animate: NO oss route exists (M3/M3b: VAE decode stall) - use the labelled still-image slow-pan fallback; do NOT use the browser (Kling) or any paid/api route. Original fictional characters only; AI-generated disclaimer card; bilingual subtitles via media subs; 60-90 s; 1280x720 or better. Record per draft: wall time, per-stage time, artifacts + SHA256, cost (zero). Lock the storyboard after the drafts. The commercial --final is an operator-approved REMAINING CHECK: never pass --yes yourself.

RUN 2026-11-13 (claude-opus5.5): BLOCKED, no draft completed; evidence docs/sprint-627-m8-drafts-evidence.md. Draft 01: song ok (oss, 240 s, 75 s WAV), then portrait 1280x720 FLUX.2 klein GPU VAE decode hung -> TDR (LiveKernelEvent 141) and, after a bounded tiled-decode probe, an unexpected reboot of the Windows test host (11:05Z). Root cause class: environment (gfx1151 WSL ROCm VAE decode at 1280x720; 512x512 decodes). Remaining: operator picks an option (512 portraits + aspect-correct still-pan in film.bsh; CPU VAE decode in image-klein.py; another image host; driver investigation), then two drafts + lock. No GPU work on that host for M8 until then. --final untouched, no --yes, zero cost.

RETRY AFTER GPU FIX (operator approved 2026-11-13, mb:13700 + "yes"): the Windows test host now has AMD driver 26.10.1 + a NATIVE ROCm 10.0 venv (C:\rocm10\venv, torch 2.13.0+rocm10.0.0, HIP 7.15); bashy todo 69e99cd6. Order:
1. VERIFY FIRST: one real FLUX.2 klein-4B 1280x720 generate + VAE decode in that native venv, as a single GPU job. Record time, peak memory, and the Windows System log (no Event 141 / TDR).
2. If ANY Event 141/TDR appears: stop all GPU work immediately, do not retry or probe, record it, release the claim, and tell the conductor (the operator handles reboot and Klatch restore - never touch the default podman machine). Fall back to proven-size render + ffmpeg upscale only with conductor approval.
3. Only if step 1 passes: the two FREE oss drafts per the scope above (song-acestep, image-klein, narrate-local, transcribe-whisperx offline from staged weights; labelled still+pan animate; no browser/api; never --yes; zero spend), ONE GPU job at a time, native venv first (WSL only with a recorded reason). Lock the storyboard, then STOP; commercial final stays operator-approved.
Claim the host first, release on every exit; direct outpost ssh, batched; refresh the elevation cookie from the vault yourself.

DRAFT = ANIMATIC (operator mb:13723 + review request, 2026-11-13): purpose is to approve/change the plan before the commercial final. Required: locked shot list with cuts on the song beats, bilingual lyric subtitles, title/character cards, a visible shot number on every shot; stills small/fast (768x432 or 512-wide upscaled, fewer steps) after the one 1280x720 safety decode. Deliver for review: MP4 path (copied to the dev box, outside git), contact sheet of all shots, storyboard table (shot#/time/lyric/prompt) so the final re-renders exactly those shots. Zero spend.

FIDELITY LADDER (operator 2026-11-13: mock-up must cost a tiny fraction of the final): Draft A = board animatic, no generative models (text shot cards on a beat/click track, cards, shot numbers), target < ~1 min render. Draft B = rough animatic (song-acestep reduced steps, one ~512-wide ~4-step keyframe per shot reused per character + slow pan, subtitles from transcribe), target < ~10 min for 60-90 s. Record render/runtime ratio. Final = commercial re-render of exactly the approved shots.

DRAFT STRATEGY (operator mb:13726, supersedes the ladder above): cost scales with shot count, not duration, plus one proof slice. Song full length at draft quality; full-length animatic with one small still per shot (512-wide, few steps), pan/zoom, beat-locked cuts, bilingual subs, burned shot#; reuse stills for repeated sections (a 5-min song is ~25-35 distinct shots); look sheet (one medium-res still per character + set); ONE ~5 s proof slice at best local fidelity (optional ~USD 1 commercial proof only with operator --yes). Lock storyboard (shot#/time/lyric/prompt/seed); final re-renders only those shots. Targets: 1-min ~15-20 min, 5-min ~45-55 min compute. Make it the film draft default (--mock, proof-slice) if small, else follow-up story. 1280x720 safety decode first. Zero spend.
