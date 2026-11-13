---
id: 76dd8d43190a
kind: spike
title: 'M3 oss animate: InfiniteTalk or Wan2.2-S2V lip-synced singing clip on a 24 GB NVIDIA host'
seq: 183
status: assigned
priority: p2
labels:
    - vendor-services
    - media
created: 2026-11-12T23:18:28.515152Z
weave: 29
assignee: codex-gpt6-sol
sprint: 627
sprint_id: 21c05c41-833f-598c-ab0b-3aab12cfbd8f
sprint_title: 'Music-video showcase: film pipeline with oss draft -> commercial final (song, image, animate, narrate, subtitles)'
---

Spec: docs/sprint-627-master-execution-plan.md (venue). Depends M1 and a confirmed 24 GB NVIDIA host (none confirmed; never the primary workstation). Fallback until then: browser route or still+pan, labelled. Record the host blocker if none appears.

VENUE/SCOPE (operator mb:13586, 2026-11-13): run on the Windows test host. Its GPU is an AMD Radeon 8060S (Strix Halo iGPU, unified memory with 128 GB RAM), NOT NVIDIA - so this is a TIME-BOXED ROCm SPIKE, not the CUDA recipe: PyTorch ROCm in the Ubuntu-24.04 WSL distro (or the Windows ROCm preview) for InfiniteTalk / Wan2.2-S2V; try Wan2.2 TI2V-5B first (smaller).
Rules: 'bashy claim host:<Windows test host alias, see operator mb:13586>' FIRST and release after. Never touch the default podman machine (live Klatch). No 'wsl --shutdown' and no .wslconfig change without operator approval: WSL sees ~31 GB unless raised, which likely blocks 14B models - ask before changing. Disk-headroom preflight before any weights. Reach: outpost ssh <user>@<Windows test host> -- wsl -d Ubuntu-24.04 -u root -- bash -s (stdin works; 'outpost ssh exec' does not forward stdin). Run long jobs in the foreground of one held session (setsid/nohup over bash -s did not start there). Nothing heavy on the dev host.
Record the outcome either way in the submit: works (seconds of clip per wall-clock second, peak memory, disk) or a blocker with its root cause. Wire the result as an 'animate' route=oss rod only if it works.

AWS GPU ROUTE (operator mb:13587, 2026-11-13): HARD CAP USD 50 total for this sprint's AWS GPU use; STOP at USD 40. Blocked until the operator's GPU quota request (G/VT on-demand + spot, currently 0 in us-west-2 and us-east-1) is approved - the vault automation user cannot request it; do not try. When approved: one g6e.xlarge (or g6/g5.xlarge) in us-west-2, spot preferred, tag sprint=627, instance-initiated-shutdown=terminate plus an in-guest shutdown timer; record start/stop times and running cost in the evidence; terminate immediately after the M3 render. The Windows test host ROCm spike continues meanwhile.

## ROCm spike outcome (2026-11-13)

**Blocked: no verified open-source `animate` artifact.** The Windows test host
has an AMD Radeon 8060S (`gfx1151`), not NVIDIA. Ubuntu 24.04 WSL exposed
31 GiB RAM and 8 GiB swap. No WSL configuration, shutdown, default Podman
machine, primary workstation, or AWS GPU was touched.

- Disk preflight passed at 310 GiB free before weights. The official
  [Wan2.2-TI2V-5B checkpoint](https://huggingface.co/Wan-AI/Wan2.2-TI2V-5B)
  downloaded in 442 s. After the spike, 278 GiB remained free; the isolated
  spike directory occupied 39 GiB and ROCm 7.2 occupied 15 GiB.
- AMD's [WSL ROCDXG bridge](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installryz/wsl/howto_wsl.html)
  1.2.0 plus ROCm 7.2 runtime and PyTorch 2.9.1+rocm7.2.1 detected the GPU.
  A 1024×1024 GPU tensor allocation and reduction passed.
- The unmodified Wan2.2 generator loaded the checkpoint, then failed at a
  direct FlashAttention assertion because that kernel was unavailable. For
  this **local test copy only**, its model import was changed to the existing
  PyTorch scaled-dot-product attention fallback. This is not a shipped patch.
- The bounded retry requested 17 frames at 1280×704, 24 fps, four sampling
  steps, CPU text encoder, model offload, and a 27 GiB process memory cap.
  Denoising completed in 27.7 s. No MP4 appeared during the following
  post-denoising stage; the process timed out at 900 s (exit 124). The exact
  post-denoising substep was not isolated. Measured cgroup memory peak was
  28,634,857,472 bytes (26.7 GiB), with zero OOM events. Completed clip
  throughput is **0 seconds of clip per wall-clock second** because no clip
  was produced. The timed-out process stopped cleanly.

The smaller TI2V-5B is a video/B-roll feasibility probe, not a lip-sync
model. InfiniteTalk and Wan2.2-S2V-14B were not run: no 24 GB NVIDIA host is
confirmed, and WSL's 31 GiB limit likely blocks the 14B path. Changing that
limit requires operator approval and would interrupt WSL. Until a successful
lip-sync render is measured, drafts must use the browser route or a **labelled
still image with a slow pan**. No `animate route=oss` rod was registered.
