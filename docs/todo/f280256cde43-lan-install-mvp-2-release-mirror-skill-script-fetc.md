---
id: f280256cde43
kind: feature
title: 'LAN install MVP-2: release-mirror skill-script (fetch/publish/serve) — bashy as the LAN web server for installs and upgrades'
seq: 635
status: wontfix
priority: p1
labels:
    - install
    - lan
    - post-rc40
created: 2026-11-22T20:35:35.608218Z
assignee: claude-fable5.1
sprint: 694
closed: 2026-11-27T22:46:21.180374Z
---

bashy/examples/release-mirror/{release-mirror.bsh,README.md,register.sh} (pattern examples/update). fetch: all 5 release archives + checksums.txt + latest from GitHub; publish <archive|dist dir>: a local build as <dir>/<id>/ with its own checksums; serve: bashy rclone serve http <dir> --addr :8080 with install.sh/install.ps1 pre-baked to this mirror, README.md = live bashy skill show bashy + one-liners for sh/PowerShell + loom line. Classroom scenario: participants tell their agent 'Set up bashy from http://<organizer-host>:8080'. Acceptance: dev-box end-to-end fetch -> serve -> one-liner into a temp dir -> version equality.
