---
id: 7320c7d80031
kind: feature
title: 'K3 files for offered runs: input upload, artifacts result, consumer download, size caps, async'
seq: 831
status: todo
priority: p1
created: 2026-11-27T15:34:19.372087Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K3. Peer results are text only today; video/transcribe need files in and out. Upload inputs into the run's scratch dir (cap), outputs land in the offerer's designated output folder and return by reference (F2 URIs), by value only under a small cap; long runs via the existing async job verbs. Code inspected 2026-11-27: yoke pkg/toolcmd peer.go jobs.go http_media_test.go, pkg/cligw capability.go.
