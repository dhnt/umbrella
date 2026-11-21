---
id: befc2403023f
kind: chore
title: 'P1: Step 0 baseline on gate host - cold+warm build, per-OS sizes, package counts, whole-bashy rebuild-verify time'
seq: 587
status: assigned
priority: p0
created: 2026-11-21T09:22:07.427138Z
weave: 109
assignee: ycode-cascade-x3
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

P1 baseline, SMALLEST SET FIRST (relaunch spec 2026-11-21). Frozen start commit: bashy 5c8be965 - WAIT: origin bashy main has since advanced with S8/S8b script-only changes (ecdab0cd, 1bd504d6) which do not affect build measurements; measure at umbrella HEAD and RECORD the exact bashy sha measured (must be pre-A toolchain go1.27.2). Venue: claim ONE shared gate lane, official image ONLY via bashy oci, LAUNCHING SESSION ATTACHED (foreground, never detached - WSL idle-reboots kill detached containers, see root cause below). MEASURE IN THIS ORDER, committing results to this story file in your workspace AFTER EACH item so a kill loses nothing: (1) clean cold bashy dag build time, (2) warm dag build time, (3) per-OS binary sizes from the builds you already produced, (4) package counts (go list -deps). Record image id with the first commit. DEFERRED until gate-host keep-alive: whole-bashy rebuild-verify cycle and any long measurement. Propose P3/P4 thresholds only from recorded numbers.

HISTORY: run #105 (ycode-cascade-x4) KILLED by wrapper max-runtime 48m0s (killed_by field, exit -1), 0 commits, clean tree - watchdog, not manual kill, not resume collision. Its silence root cause was ENVIRONMENT: gate-host WSL idles/reboots (6 boots 01:35-02:01 PST, 20s-6min), killing detached lane containers. Worker exonerated. Manager interim deadline dropped as invalid.
