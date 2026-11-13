---
id: 6bde7278808d
kind: spike
title: 'M3b native-Windows oss animate spike: Bash# .bsh rod run by native bashy.exe (no WSL cap)'
seq: 197
status: done
priority: p2
labels:
    - media
created: 2026-11-13T03:26:57.195206Z
weave: 40
assignee: codex-gpt6-sol
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
closed: 2026-11-13T10:14:59.025177Z
closed_by: claude-opus5.5-s627
---

Operator mb:13597 (2026-11-13). Follows M3 (76dd8d43, recorded blocker). Time-boxed spike on the Windows test host (alias in operator mb:13586), queued AFTER M2b releases the host claim.
0. First, cheaply isolate M3's stall: the WSL Wan2.2 TI2V-5B run finished denoise in 27.7 s, then produced no MP4 within 900 s with 26.7 GiB peak and no OOM - name the stalled post-denoise substep (VAE decode? save/encode?) and whether it ran on CPU or GPU. Memory may not be the cause.
1. Native Windows: a .bsh custom command (powershell fence) run by the native bashy.exe: pinned Python via uv; AMD's Windows PyTorch-ROCm wheels for gfx1151 (preview - verify availability and licence first); SDPA attention fallback (no FlashAttention). Wan2.2 TI2V-5B first; only if it renders, one 14B lip-sync clip (InfiniteTalk or Wan2.2-S2V). A native process is not under the WSL ~31 GiB cap (iGPU can use up to ~96 GB shared).
Rules: bashy claim host:<alias> first, release after; no WSL config change, no wsl --shutdown, never touch the default podman machine (live Klatch); disk-headroom preflight before weights; no AWS; nothing heavy on the dev host; never pass --yes yourself. Record the outcome either way: clip + clip-seconds per wall-second + peak memory, or a blocker with its root cause. Register an animate route=oss rod only if a clip renders.

PLATFORM RULE (operator mb:13598, kb decision windows-native-first-wsl-only-with-a-recorded-reason, bashy 7fea18e8): native bashy.exe + .bsh + uv + Windows builds FIRST; use WSL only with a recorded reason (why native failed or is unavailable) in the evidence.

NEVER RE-DOWNLOAD (operator mb:13612): weights are already staged on the Windows test host in the WSL rod cache (BASHY_OSS_CACHE root /root/s627-m2b/cache; ~54 GB: song-acestep 18G, narrate-local 8.6G, transcribe-whisperx 6.2G, image-qwen 20G partial; plus 5.9G HF cache) with per-file SHA256 in docs/sprint-627-m2b-weights-evidence.md. When running rods natively, COPY the staged files (verify the recorded checksums) or point native rods at one shared cache - never fetch them again.

NETWORK (operator mb:13613): never "outpost ssh exec <alias>" (relayed via the cloud satellite). Use only the ad-hoc direct form "outpost ssh <user>@<host> -- ..." (mesh/LAN, ~3-4 s per call) and batch probes into ONE call (one script piped to bash -s, or one powershell -EncodedCommand).
