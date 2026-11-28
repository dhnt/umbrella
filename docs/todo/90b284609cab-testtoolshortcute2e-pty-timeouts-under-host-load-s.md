---
id: 90b284609cab
kind: test
title: 'TestToolShortcutE2E PTY timeouts under host load (Sprint 746): root-cause, make waits load-tolerant'
seq: 873
status: todo
priority: p2
labels:
    - test
created: 2026-11-28T21:20:15.402627Z
---

Seen twice mid-Sprint 746 on the Windows test host's Linux lane while another heavy job ran (bashy internal/agentos/toolshortcut_e2e_test.go:399). Passed when rerun alone at baseline 72365e3e, at 5e983886 and at a32a1a39, and in the full final run. Recorded as venue (host load). Rule: a harness that fails under realistic load is a test defect (E2E waits must be configurable). Find which wait or timeout trips, reproduce under load at the same commit, record the cause, fix where it lives.
