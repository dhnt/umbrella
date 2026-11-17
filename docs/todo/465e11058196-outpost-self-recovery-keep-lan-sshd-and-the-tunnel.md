---
id: 465e11058196
kind: feature
title: 'Outpost self-recovery: keep LAN sshd and the tunnel up and report why they dropped'
seq: 389
status: todo
priority: p1
created: 2026-11-17T11:51:11.42001Z
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

Follows the P0 root cause. Outpost should notice when its LAN sshd listener, mesh link or cloud tunnel drops and restore it with backoff, and record the reason (sleep, network change, upgrade re-exec, crash) in a local log cloudbox can read, so an outage explains itself. An always-on host should be able to declare that, so a sleep policy that would defeat it is reported at pairing or doctor time (bashy outpost doctor --json). Acceptance: killing the sshd listener or bouncing the network adapter recovers without operator action, and the recorded reason matches.
