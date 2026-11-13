---
id: 01a1d466-25e0-7b2f-9b4e-679816ad0f33
seq: 7
form: page
type: gotcha
title: Windows ROCm Wan2.2 single-GPU import and VAE decode stall
description: 'WHEN probing Wan2.2 TI2V-5B on gfx1151 with AMD Windows Torch 2.9.1+rocmsdk20260116: the wheel omits torch.distributed FSDP, while Wan eagerly imports FSDP and unused S2V/Animate modules. A single-GPU probe can shim only these unused imports, but a 17-frame four-step run still spent over six minutes inside GPU VAE decode after denoise and produced no MP4 in 600 seconds; do not register an animate oss route on import or denoise success alone. Hash existing weights when moving from WSL; test VAE exit and MP4 explicitly. Evidence: docs/sprint-627-m3b-animate-evidence.md.'
status: candidate
source:
    tool: codex-gpt6-sol-n
    episode: ep-1f1925f5d48d2499
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T10:13:46Z"
---
