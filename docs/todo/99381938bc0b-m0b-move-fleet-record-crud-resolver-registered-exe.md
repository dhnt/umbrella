---
id: 99381938bc0b
kind: refactor
title: 'M0b: move fleet record CRUD + resolver/registered exec into yoke/core (binmgr behind an interface)'
seq: 875
status: todo
priority: p1
labels:
    - core
created: 2026-11-28T21:28:39.606491Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M0b). MOVE only. yoke pkg/fleet record files (types catalog write setpath overlay resolve kind_records kind_verbs commands, ~6k lines) and bashy commandResolverFor/registeredHandler move into yoke/core. Fleet keeps cloud overlay, probes, infra, etc. through the existing option/interface points. download.url stays as data; install goes behind an interface that binmgr implements outside the core. Behaviour and on-disk files unchanged. Full pkg/fleet, internal/agentos and cmd/bashy pass, compared by name. Extensions register in today's middleware order.
