---
id: 6210caba276e
kind: feature
title: Expose paired-host reachability through the master CLI and host listing
seq: 598
status: todo
priority: p1
created: 2026-11-21T11:16:39.414412Z
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

Follow-up to daa99f1f. Direct master status for a paired host and the master indexed host listing must expose the same owner-scoped state, last observation, and alert projection as the paired satellite. Use authenticated owner boundaries, stale/unknown semantics and one-way CLI-to-existing-UI parity, including transferred/revoked pairings. Operator approved the current release with satellite verification while this remains separate.
