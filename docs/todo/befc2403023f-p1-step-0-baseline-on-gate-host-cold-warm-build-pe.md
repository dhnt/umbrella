---
id: befc2403023f
kind: chore
title: 'P1: Step 0 baseline on gate host - cold+warm build, per-OS sizes, package counts, whole-bashy rebuild-verify time'
seq: 587
status: todo
priority: p0
created: 2026-11-21T09:22:07.427138Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

RUNS FIRST, before A changes any toolchain: measures TODAY. Frozen start commit: bashy 5c8be965 (umbrella pins as of 2026-11-21 staffing). Venue: claim ONE shared gate lane (bashy claim the lane resource; 8 CPU/7 GB, per-lane work dir, lane-prefixed container names), official image ONLY via bashy oci; never the dev box for these numbers. Measure: clean cold + warm bashy dag build times, per-OS binary sizes, package counts, whole-bashy rebuild-and-verify cycle for one command change (minutes - the number P3 must beat). Record exact numbers + image id on this story; propose P3/P4 thresholds for operator approval. No code change; release the lane when done.
