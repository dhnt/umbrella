---
id: b3580b976c31
kind: bug
title: P0 Root-cause the always-on Windows test host going unreachable (2026-11-16/17)
seq: 387
status: todo
priority: p0
created: 2026-11-17T11:51:11.076315Z
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

Root cause first (repo rule): name it, check the venue, find what changed, record the cause; no fix before that. Evidence from the Sprint 641 release run (times PST): 2026-11-16 ~19:10 a long ssh session to the host's WSL was cut with 'Connection closed by remote host'. Minutes later ssh to the host's LAN port 2222 timed out on every address (link-local and both global IPv6), and ping got 0 replies (Windows drops ICMP, so ping alone proves nothing). 2026-11-17 02:14 still timed out. The cloud-relayed outpost exec path answered 'elevation required', so it was not tried with elevation. 2026-11-17 ~03:40 plain ssh answered again. Context: another sprint said the operator reserved the host for a class session for about 2 hours (from ~19:40 11-16), which may or may not be related. Nobody was alerted; it was found only because a test run needed the host. Investigate: Windows event log (Kernel-Power 41/42 sleep or reboot, network adapter resets, Windows Update restarts), the outpost daemon log and its upgrade ledger, sshd listener state (tunnel-only vs LAN), mDNS/IPv6 address changes, WSL shutdown, and power/sleep policy. Classify as product, configuration or environment, and fix it where the cause lives.
