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

## Merged 2026-11-21 (conductor; operator: "fix it and incorporate the changes in main so it won't happen next time")

- Merged to main: outpost 854dd468 (installer service bootstrap defaults to OS startup) and bashy b67b7f39 (bashy registers Outpost at boot) + 130af35e.
- Second root cause found during recovery: the restore ran `bashy self install`, whose release path resolves `--version latest` (the latest PROMOTED release, rc.37) and installed it over a newer developer build without any version check, so the dev box lost the newer agent records (agy gemini4, opus5.5, sonnet5.5). Fix 130af35e: the release path compares the vcs.time stamps of the installed and incoming bashy and refuses a downgrade; `--allow-downgrade` or BASHY_SELF_ALLOW_DOWNGRADE=1 is the explicit escape hatch; unknown stamps never block. Unit test TestRefuseSelfDowngrade.
- Pre-existing, tracked separately (not repaired here): TestSourceRoute Go 1.27.4/1.27.2 toolchain mismatch reproduced on the unchanged base.
- Remaining check (deferred to the 652 milestone): unattended reboot validation on each OS.
