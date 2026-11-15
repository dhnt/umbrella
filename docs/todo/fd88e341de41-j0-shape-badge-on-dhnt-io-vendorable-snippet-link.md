---
id: fd88e341de41
kind: feature
title: 'J0 Shape badge on dhnt.io: vendorable snippet, link contract, check (638 S2 design)'
seq: 282
status: todo
priority: p1
labels:
    - shaping
    - examples
created: 2026-11-14T22:42:22.172785Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: dogfood dhnt.io — a member shapes the company site in their own GitHub-backed space, proven Red-Green-Refactor'
---

Planned vendor: glm. Example custom command bashy/examples/shaping/badge/badge.bsh with embedded skill. Verbs: snippet APP --engine URL [--tier 0|1] [--label] prints the <a> with inline flow.svg and design-archive wording; js prints badge.js; link APP --page P [--element E] composes the deep link (CLI parity); check URL runs bashy browser --mode solo and asserts the anchor/button and href. Tier 1: Shadow DOM, createElement only (Trusted Types), describe() port from genie.js, window.open noopener, ?shape=off kill switch, <=6 KB, idempotent re-mount, no fetch/cookies/storage. Accept: snippet validates; check passes on examples/site sample; link equals the composed href. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
