---
id: 13774a3ff529
kind: test
title: 'gate venue: outpost tests that need a paired bashy or systemd fail in the bashy oci gate'
seq: 171
status: todo
priority: p2
labels:
    - outpost
    - gate
created: 2026-11-12T20:22:11.949947Z
---

Same 8 tests fail by name at outpost 36262d5 (baseline) and a78df1f in the loom + bashy oci gate (golang:1.27.2-bookworm, root, offline after module prefetch): cmd/outpost TestSSHDKeyAuthAcceptReject, TestRegisterServiceGuard (systemctl not found), TestSSHDirectE2E; internal/agent TestSSHHandlerShellGreets, TestSSHHandlerExec, TestSSHHandlerExecDetachedOutputDoesNotHoldChannel, TestSSHHandlerExecPTY, TestSSHHandlerCloudboxVouchedSkipsPassword - stderr 'bashy executable missing: install the paired bashy beside outpost or set OUTPOST_BASHY_BIN'. Classification: environment (venue lacks a paired bashy and a systemd user manager). Fix in the venue/preflight: build bashy at its pinned commit in the gate container and export OUTPOST_BASHY_BIN; TestRegisterServiceGuard needs a skip-with-reason when no systemd user manager exists or a venue that has one. Never fix in product code.
