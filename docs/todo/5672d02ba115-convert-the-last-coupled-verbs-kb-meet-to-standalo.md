---
id: 5672d02ba115
kind: refactor
title: Convert the last coupled verbs (kb, meet) to standalone yoke/ adapters by duplicating their glue
seq: 613
status: todo
priority: p0
created: 2026-11-21T20:17:29.52019Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Conductor review 2026-11-21 of bashy yoke/COUPLED-EXCEPTIONS.md: kb (in-process recall.Reader injection couples to cmds/graph) and meet (wireMeet callbacks into internal/agentos/steward.go for role/secretary activation) were kept in internal/agentos. Operator rule: no non-internal command depends on another, even if it means duplicate code. Do: own adapter entry under yoke/ for each, building alone, with the needed glue duplicated into its own package (kb gets its own recall reader wiring; meet gets its own copy of the steward activation hooks); bashy's case calls the adapter; same UX. Acceptance: builds alone GOWORK=off; AssertStandaloneDeps clean; unit tests; update COUPLED-EXCEPTIONS.md. Start on current heads; unit tests only.
