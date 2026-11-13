---
id: 01a1d599-2612-7a87-84c0-23abe8bff352
seq: 10
form: note
type: lesson
title: 'Long WSL jobs on the Windows test host over outpost ssh: keep the distro alive, close interop stdin, set HOME'
description: ""
status: candidate
source:
    tool: claude-opus5.5-c
    episode: ep-b6cac83e96102e67
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T15:49:06Z"
---

WHEN running a long job in a WSL distro on the Windows test host driven over outpost ssh: (1) a transient systemd-run unit dies about 15 s after the last wsl.exe client exits, because WSL stops the idle distro; hold it with a bounded keepalive client (wsl.exe ... sleep N, pid recorded, killed by pid) started detached via a .cmd that runs 'start'; never change WSL config. (2) a systemd-run unit has no HOME; export it, or media.bsh's PowerShell fence cannot find its cached runtime. (3) WSL interop relays stdin to Windows processes: redirect </dev/null on any interop call made inside a caller's while-read loop (it drained film.bsh's portraits loop). (4) Systemd units can call Windows exes with -p Environment=WSL_INTEROP=/run/WSL/1_interop. (5) Remote bashy over outpost ssh: '2>&1' into the session, pipes into findstr and PowerShell hang the session; redirect to files and fetch them with 'outpost ssh sftp get'; call bare cmd.exe (a full C:/... path mangles /c). (6) Refresh the elevation cookie with 'bashy secret exec --stdin HOST_PW -- outpost connect HOST --stdin --keep-alive' (expires about hourly). (7) The native ROCm 10 venv (torch 2.13.0+rocm10.0.0) decodes FLUX.2 klein at 1280x720 in 12.5 s with no TDR; the WSL ACE-Step env is CUDA-only torch and runs on the CPU. Evidence: docs/sprint-627-m8-drafts-evidence.md.
