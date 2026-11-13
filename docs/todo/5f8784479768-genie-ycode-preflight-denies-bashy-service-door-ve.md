---
id: 5f8784479768
kind: bug
title: genie/ycode preflight denies bashy service-door verbs (missing Command Atlas classification)
seq: 194
status: todo
priority: p2
labels:
    - vendor-services
created: 2026-11-13T02:18:41.474961Z
---

S626 S7 F2 (docs/sprint-626-acceptance.md). Harness rule incomplete-preflight denies 'bashy plan|image|draw|pdf|video|email|drive' (command is missing a complete Command Atlas classification; plan also: needs a target/destination refiner) and 'bashy search', 'bashy tool cmd run', curl (front-door command requires a trusted digest-pinned executable resolver). Calls run only inside an @effects/@guard envelope. Fix: classify the registered service-door commands (role verbs) for the harness preflight.
