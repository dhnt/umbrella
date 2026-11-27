---
id: 0924f59ba807
kind: bug
title: Incident repair on a freshly registered shaped app needs a shared base release
seq: 819
status: todo
priority: p2
labels:
    - shapeware
created: 2026-11-27T01:12:59.234852Z
---

Sprint 730 F4 (2026-11-26): console repair verified but refused to activate with 'patch release needs an existing base release' (yoke webconsole shaped_repair.go:357) until bashy src release APP REV --shared was cut; a principal-private release is not seen by the console operator. Decide whether app add should cut the base release, or the runbook should say so.
