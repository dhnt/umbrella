---
id: f72974c90f01
kind: task
title: R5 Release builds use registered runners (the local release build moves onto this model)
seq: 397
status: todo
priority: p2
created: 2026-11-17T12:12:36.362651Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
---

When R1-R3 land, the local release build (todo b4cdd7cf) becomes a dag over registered runners: linux/windows on the always-on host in bashy oci, darwin on a macOS runner, GitHub only for publishing assets. Acceptance: one bashy command builds rc assets on the local runners in about 15 minutes, with GitHub touched only for the upload.
