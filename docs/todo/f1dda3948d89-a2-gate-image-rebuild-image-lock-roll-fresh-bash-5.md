---
id: f1dda3948d89
kind: chore
title: 'A2: gate-image rebuild (image.lock roll) + fresh Bash 5.3 86/86 both modes on go1.27.4'
seq: 594
status: todo
priority: p0
created: 2026-11-21T10:34:55.082522Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Deferred part (b) of A 195027c9 (code part merged: 14 submodule repos pushed go1.27.4 + productgo re-pin, umbrella 00e713e0). BLOCKED ON: P1 baseline evidence (befc2403) + gate-host keep-alive (WSL idle-reboots kill detached containers). Then: acquire EXCLUSIVE gate-host claim, roll the official build image under the image.lock rule (previous release builds the next), record new image id here, run Bash 5.3 gate fresh BOTH modes target 86/86 by fixture name vs rc.39 evidence (mode0 365ab01e, mode1 2f059ded). Gate host only, official image via bashy oci. Also refresh published consumer dependency pins (builds catalog) once submodule commits are remote (they now are).
