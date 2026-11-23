---
id: ee64f6717a74
kind: bug
title: shape wish --from import carries no wish provenance, so a frozen stale-base check passes vacuously
seq: 648
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-23T05:52:50.529229Z
---

Found 2026-11-23 during Sprint 693 S3: a candidate created with 'bashy shape wish APP --page /about --element "section=team revision=<stale>" --from DIR' verified with verdict pass although the element carried a stale revision; the frozen check checks/stale-base.bsh (bashy examples/shaping/site/template) refuses 'stale, re-read' when SITE_WISH_PAGE/SITE_WISH_ELEMENT are present (proven directly, and in the S0b hermetic run for an agent-carried wish). The import path does not record page/element into the candidate, so the check has nothing to compare. Expected: --from imports record the same provenance as agent wishes (or the verifier passes the wish's page/element env for every candidate kind). Root cause before fix; yoke pkg/shape (import path) is the suspect. Not gating for 693.
