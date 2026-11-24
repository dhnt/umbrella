---
id: 790d4c29d660
kind: bug
title: Session demo fixtures must reap descendants when a readiness assertion fails
seq: 689
status: todo
priority: p2
labels:
    - session
created: 2026-11-24T10:31:57.207058Z
---

Sprint 684 follow-up authorized by the supervisor. At bashy 6d88b2ac, investigation run 199 reproduced an early readiness assertion in test_demo_sigint_exits_clean_and_removes_throwaway_dir before the test sent SIGINT. At 188 seconds two demo dispatch parents and 19 live descendants survived unittest exit, including a session-server in its own process group. The diagnostic guard removed all 19. The same two cases passed with warm caches and left zero descendants. The full repaired suite at f00ac06f passed all 65 tests with a descendant guard. Run 215 investigated a fixture-only repair. Its draft needed a process-tree scanner because killing only the parent process group misses the separate server group. The supervisor deferred repairs larger than a small fixture helper. Find a bounded way to clean up the exact owned descendants on every test failure path. Prove a forced readiness failure leaves neither demo parent nor server while preserving test deadlines and ordinary SIGINT behavior. Evidence is in the Sprint 684 thread and run 199, under the cold SIGINT log and process-tree samples.
