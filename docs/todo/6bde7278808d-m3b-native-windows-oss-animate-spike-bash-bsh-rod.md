---
id: 6bde7278808d
kind: spike
title: 'M3b native-Windows oss animate spike: Bash# .bsh rod run by native bashy.exe (no WSL cap)'
seq: 197
status: assigned
priority: p2
labels:
    - media
created: 2026-11-13T03:26:57.195206Z
assignee: codex-gpt6-sol
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Operator mb:13597 (2026-11-13). Follows M3 (76dd8d43, recorded blocker). Time-boxed spike on the Windows test host (alias in operator mb:13586), queued AFTER M2b releases the host claim.
0. First, cheaply isolate M3's stall: the WSL Wan2.2 TI2V-5B run finished denoise in 27.7 s, then produced no MP4 within 900 s with 26.7 GiB peak and no OOM - name the stalled post-denoise substep (VAE decode? save/encode?) and whether it ran on CPU or GPU. Memory may not be the cause.
1. Native Windows: a .bsh custom command (powershell fence) run by the native bashy.exe: pinned Python via uv; AMD's Windows PyTorch-ROCm wheels for gfx1151 (preview - verify availability and licence first); SDPA attention fallback (no FlashAttention). Wan2.2 TI2V-5B first; only if it renders, one 14B lip-sync clip (InfiniteTalk or Wan2.2-S2V). A native process is not under the WSL ~31 GiB cap (iGPU can use up to ~96 GB shared).
Rules: bashy claim host:<alias> first, release after; no WSL config change, no wsl --shutdown, never touch the default podman machine (live Klatch); disk-headroom preflight before weights; no AWS; nothing heavy on the dev host; never pass --yes yourself. Record the outcome either way: clip + clip-seconds per wall-second + peak memory, or a blocker with its root cause. Register an animate route=oss rod only if a clip renders.

PLATFORM RULE (operator mb:13598, kb decision windows-native-first-wsl-only-with-a-recorded-reason, bashy 7fea18e8): native bashy.exe + .bsh + uv + Windows builds FIRST; use WSL only with a recorded reason (why native failed or is unavailable) in the evidence.
