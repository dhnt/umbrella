---
id: 759c57a66ff5
kind: bug
title: bashy delegate has no depth counter for genie-to-genie nesting
seq: 809
status: todo
priority: p2
labels:
    - genie
created: 2026-11-26T19:45:26.28323Z
sprint: 732
sprint_id: f71a8649-8650-54de-9d57-9b5b04015fef
sprint_title: 'Shared shaping ledger: reasons travel with the app across agents in group shaping'
---

From genie's shell, bashy delegate genie:<model> starts a child genie; the child can delegate again. No depth variable exists on this path (compare BASHY_MEET_DEPTH in yoke/pkg/meet), so nesting is bounded only by the allow list, timeouts and spend. Code inspected (2026-11-26): ycode/internal/harness/bashy/delegate.go:165-353; yoke/pkg/chat/delegate_guard.go. Not verified: whether BASHY_DELEGATE_ALLOW reaches the child's environment.

Triage (2026-11-26): linked to Sprint 732 at the operator's request; independent of the ledger and not on the acceptance path.

Review (2026-11-26, code re-read at yoke 0bc70d51 and ycode fcc970b2): confirmed, raised to p2. Still independent of the ledger and off the acceptance path.
- No depth counter exists on this path in yoke, ycode or bashy. delegate.go:165-353 and delegate_guard.go:43-74 check arguments, timeout, the allow list, cap and credentials only.
- Now verified: BASHY_DELEGATE_ALLOW does reach the child. The child environment is the parent's with credential-shaped names scrubbed (chat.go:703,799-801; delegate_guard.go:94-109), and genie's own allowlist names BASHY_DELEGATE_CALLER and BASHY_DELEGATE_ALLOW (ycode/examples/genie/agent.yaml:432). So genie to delegate genie:m to child genie can repeat without bound, limited only by timeouts and spend.
- Pattern to mirror: BASHY_MEET_DEPTH (yoke/pkg/meet/meet.go:43, guardDepth :51-58, markDepth :61).
- Fix: about 15 lines in yoke/pkg/chat/delegate.go before Invoke (around :125-131): read BASHY_DELEGATE_DEPTH, refuse at the limit, set depth plus one. Add the name to genie's agent.yaml and agent-yolo.yaml allowlists, or the count resets at each genie hop, and to shape's delegateEnvAllow. One test.
- Three repos: yoke, then the ycode genie yaml, then the bashy pin bump.
No coding until Sprint 730 completes (operator, 2026-11-26).
