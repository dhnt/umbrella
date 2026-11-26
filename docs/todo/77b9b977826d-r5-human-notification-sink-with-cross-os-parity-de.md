---
id: 77b9b977826d
kind: feature
title: 'R5 Human notification sink with cross-OS parity: desktop toast on macOS, Linux and Windows for bashy notify'
seq: 279
status: todo
priority: p3
labels:
    - windows
    - comms
created: 2026-11-14T22:23:12.916736Z
---

Triage 2026-11-25: moved out of Sprint 637 (a8b3d759) to keep that sprint on its MVP. A three-OS feature with a Windows test matrix; plan it together with the comms channel stories (C3 ntfy 46433a7796d3, C6 listeners c5ca9e3369d5).
Today desktop delivery exists only as shell functions in yoke/skills/agent-hub.md (osascript on macOS, notify-send on Linux); there is no Windows toast anywhere in the suite; examples/tray is watch-only and sends nothing. Cross-OS parity rule: documented workflows must behave the same on Windows, macOS and Linux, fail not degrade; Windows native first. Shape: one .bsh custom command (notify-desktop) usable as a bus sidecar sink (bus subscribe --sink exec -- notify-desktop) that renders a toast on all three OSes (Windows via native PowerShell toast, no WSL), with --dry-run and --json. This is the local-desktop channel, not a second bus. Done when: the same subscribe line produces a toast on all three OSes in the test matrix (Windows test host first); no OS-only path.
