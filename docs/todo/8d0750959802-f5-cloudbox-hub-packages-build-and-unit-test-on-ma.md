---
id: 8d0750959802
kind: refactor
title: F5 Cloudbox hub packages build and unit-test on macOS (k3s server behind a linux build tag)
seq: 126
status: todo
priority: p3
labels:
    - collaboration-followup
created: 2026-11-11T09:56:32.004498Z
sprint: 616
sprint_id: b1288158-05dc-57cc-8abe-0bef9d310d11
sprint_title: 'Collaboration MVP follow-ups: calendar example, deployed suite/circle e2e, browser e2e, portable cloudbox tests'
---

Today hub/internal/api imports internal/cluster, which pulls the k3s server/agent and Linux-only flannel and kube-router; the k3s stub-file approach is insufficient (tried in Sprint 614 and reverted). Put the k3s-backed part of internal/cluster behind //go:build linux with a non-Linux stub exposing the same functions, so internal/api, handlers, db and server build and run unit tests on macOS. Linux behavior unchanged; no cgo; Linux test host still runs the full set.
