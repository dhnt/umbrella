---
id: 01a1d4a0-ca90-709c-83db-32557c29702c
seq: 8
form: page
type: gotcha
title: gfx1151 WSL ROCm GPU VAE decode at 1280x720 hangs the GPU and can reboot the Windows host
description: 'WHEN running an image/video diffusion rod (FLUX.2 klein, Wan2.2) on the AMD gfx1151 Windows test host under WSL ROCm at >=1280x720: denoise finishes in seconds but GPU VAE decode hangs, Windows logs LiveKernelEvent 141 (TDR), the process spins with GPU engines idle, and a second GPU job on the hung GPU rebooted the host (Kernel-Power 41), stopping every WSL distro incl. the podman machine. Check the Windows event log for LiveKernelEvent before any further GPU work after a stall; never start another GPU job after a TDR; 512x512 decode works. Also stop the ACE-Step server after the song stage (WSL ~31 GB; server 13 GB + FLUX 17 GB). Evidence: docs/sprint-627-m8-drafts-evidence.md.'
tags:
    - gpu
    - rocm
    - wsl
    - windows
    - film
status: candidate
evidence: Sprint 627 M8 draft 01 + vae probe, 2026-11-13; System/Application event logs on the Windows test host
source:
    tool: claude-opus5.5-o
    episode: ep-729e080b5b7d2f0e
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T11:17:49Z"
---

See description. Options under evaluation: portraits at 512 with an aspect-correct still-pan, CPU VAE decode, another image host.
