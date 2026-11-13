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
