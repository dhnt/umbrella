---
id: 77b9b977826d
kind: feature
title: 'R5 Human notification sink with cross-OS parity: desktop toast on macOS, Linux and Windows for bashy notify'
seq: 279
status: todo
priority: p2
labels:
    - windows
    - comms
created: 2026-11-14T22:23:12.916736Z
sprint: 637
sprint_id: a8b3d759-ebd1-5fe5-b44c-ae68c465f22f
sprint_title: 'Reminders that fire: scheduler engine state, notify routes, calendar hand-off'
---

Today desktop delivery exists only as shell functions in yoke/skills/agent-hub.md (osascript on macOS, notify-send on Linux); there is no Windows toast anywhere in the suite; examples/tray is watch-only and sends nothing. Cross-OS parity rule: documented workflows must behave the same on Windows, macOS and Linux, fail not degrade; Windows native first. Shape: one .bsh custom command (notify-desktop) usable as a bus sidecar sink (bus subscribe --sink exec -- notify-desktop) that renders a toast on all three OSes (Windows via native PowerShell toast, no WSL), with --dry-run and --json. Coordinate with the comms channel stories (C3 ntfy 46433a7796d3, C6 listeners c5ca9e3369d5) so this is the local-desktop channel, not a second bus. Done when: the same subscribe line produces a toast on all three OSes in the test matrix (Windows test host first); no OS-only path.
