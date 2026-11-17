---
id: daa99f1f5a8e
kind: feature
title: Cloudbox alerts the owner when a paired host goes offline or unreachable
seq: 388
status: todo
priority: p0
created: 2026-11-17T11:51:11.253915Z
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

A host the owner marks always-on (or any paired host, by owner policy) that misses heartbeats or tunnel presence for longer than a threshold raises an alert to the owner through the existing notification channels, with one bashy CLI path (status, ack, mute, threshold) and no web-only control. It must distinguish offline (no tunnel), degraded (tunnel up, LAN sshd or apps down) and asleep (reported power state), say when the host was last seen, and clear itself on recovery. No alert storms: one alert per state change, deduplicated per host. Acceptance: a host stopped for longer than the threshold produces exactly one alert and one recovery notice, and bashy reports the same state the UI shows.
