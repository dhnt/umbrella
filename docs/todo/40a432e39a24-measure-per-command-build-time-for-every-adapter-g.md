---
id: 40a432e39a24
kind: test
title: Measure per-command build time for every adapter group (optional, toolchain, yoke, examples, custom)
seq: 610
status: todo
priority: p0
created: 2026-11-21T15:03:59.285646Z
assignee: agy-gemini3.8-flash
sprint: 692
---

Operator 2026-11-21 (typed): 'have some agent verify the build time for the individual built command ... for all different groups. optional/example/custom and toolchain. slow for toolchain is acceptable, but it is preferred the build take less than 10 second, ideally 5 seconds.' TASK (measurement only, no code changes): on the gate host, in a claimed the gate host lane, official image, session attached: for EVERY command adapter in optional/, toolchain/, yoke/, examples/, custom/ on bashy origin/main, build it alone the way bashy builds it on first use, and record (a) cold build (empty Go build cache for that command, module cache warm) and (b) warm rebuild after a one-line source touch. Report a table per group: count, median, p90, max, and the list of commands over 10 s and over 5 s (warm), each with its top dependency weight (largest packages). Targets: warm < 10 s required, < 5 s ideal; toolchain/ exempt from the target but still measured. Record raw numbers in the story and a summary on the card; root-cause the slowest 5 (which dependency dominates). Do not fix anything in this story.
