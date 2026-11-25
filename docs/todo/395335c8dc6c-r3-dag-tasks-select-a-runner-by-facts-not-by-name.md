---
id: 395335c8dc6c
kind: feature
title: R3 dag tasks select a runner by facts, not by name
seq: 395
status: wontfix
priority: p1
created: 2026-11-17T12:12:36.071793Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
closed: 2026-11-25T09:53:15.846059Z
---

A dag task declares what it needs (match: os=darwin, gpu=true, venue) and bashy picks a registered runner that satisfies it, through the existing Transport and capacity checks; a task that names nothing runs locally exactly as today. Offline or insufficient runners refuse with a named reason, never silently fall back to the local machine for heavy work. Acceptance: one dag with a darwin task and a linux task runs each on the matching runner from the dev box.

Closed as won’t do with Sprint 653. The operator chose registered custom scripts for remote runner workflows.
