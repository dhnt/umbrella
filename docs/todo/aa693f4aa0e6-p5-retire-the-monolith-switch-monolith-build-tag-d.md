---
id: aa693f4aa0e6
kind: refactor
title: 'P5: Retire the monolith switch; monolith build tag decision record (prebuilt vs build-on-demand)'
seq: 591
status: todo
priority: p2
created: 2026-11-21T09:22:08.016791Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

IN SCOPE for 677 (operator: convert all in 677); p2 = dependency order only (after P4c), not optional. Repos: bashy, yoke. Remove the hand-written switch (internal/agentos/agentos.go ~168 names); dispatch catalog-only. Keep monolith build tag for FROM scratch/air-gapped until rollout verified; decision record (prebuilt vs build-on-demand) from P1/P3 measured numbers incl. bare-host first-use latency. Full gate (bsh-facing change) in official image on gate host. Sprint 660 R4 (bbd047d0) runs AFTER this story: the generated Makefile forwarder must wrap the final post-switch build path, not be regenerated twice.
