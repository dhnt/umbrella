---
id: 68aa823cc508
kind: bug
title: Make the Bashy Outpost bootstrap register a boot service
seq: 622
status: assigned
priority: p1
created: 2026-11-21T22:05:08.868488Z
assignee: codex-bootstrap
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

Explicit service bootstrap registers the Outpost supervisor at OS startup on macOS, Linux and Windows. The compatibility installers had defaulted to user scope for unprivileged callers, which meant login-only startup on macOS and Windows. Bashy self install now elevates only Unix system registration, and the Unix script registers the installed Outpost directly so older compatible release archives get the same boot registration. Windows boot registration requires elevated PowerShell. The install-only path and explicit user scope remain available.

Verification: Unix installer fixture passed for install-only, default system scope, explicit system scope, explicit user scope and failed registration. Focused Bashy self-install tests and Outpost service tests passed. Bashy cross-build for Windows amd64 passed. The broad Bashy test run encountered an existing TestSourceRoute Go 1.27.4/1.27.2 toolchain mismatch reproduced on the unchanged base. Live macOS launchd registration reported boot scope and the daemon health endpoint returned HTTP 200. Reboot and startup without login on each platform still need live verification.
