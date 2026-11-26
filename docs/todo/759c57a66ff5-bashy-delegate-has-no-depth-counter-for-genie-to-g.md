---
id: 759c57a66ff5
kind: bug
title: bashy delegate has no depth counter for genie-to-genie nesting
seq: 809
status: todo
priority: p3
labels:
    - genie
created: 2026-11-26T19:45:26.28323Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

From genie's shell, bashy delegate genie:<model> starts a child genie; the child can delegate again. No depth variable exists on this path (compare BASHY_MEET_DEPTH in yoke/pkg/meet), so nesting is bounded only by the allow list, timeouts and spend. Code inspected (2026-11-26): ycode/internal/harness/bashy/delegate.go:165-353; yoke/pkg/chat/delegate_guard.go. Not verified: whether BASHY_DELEGATE_ALLOW reaches the child's environment.

Triage (2026-11-26): linked to Sprint 732 at the operator's request; independent of the ledger and not on the acceptance path.
