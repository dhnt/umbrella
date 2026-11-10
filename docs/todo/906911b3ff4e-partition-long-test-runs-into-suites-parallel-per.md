---
id: 906911b3ff4e
kind: enhancement
title: 'Partition long test runs into suites: parallel, per-suite evidence, rerun only failed suites'
seq: 97
status: todo
priority: p1
labels:
    - test
created: 2026-11-10T20:37:23.405538Z
---

Operator direction 2026-11-10 after S606/S583 closure ran 3h+ over, largely re-running unrelated tests.

Goal: a long gate is a set of named suites (package sets or e2e scenarios). Suites run in parallel within resource caps. Each suite writes its own evidence record. A failure reruns only that suite. Unchanged suites reuse evidence.

1. One suite manifest per repo. bashy already has scripts/test-groups.txt (core, agentos, frontend, tooling, examples, e2e). Add the same for yoke and outpost: package sets, with heavy packages (bashy internal/agentos ~260s, yoke pkg/fleet ~70s) sharded by -run patterns.
2. Runner: bashy dag targets per suite (-j N -k), not a new runner. The e2e harness scenarios are suites too.
3. Per-suite evidence: suite name, source SHAs, input key (hash of the suite's package dependency closure), result, failing test names, duration. Comparison by test name, never by count.
4. Rerun: only failed or changed suites. A suite whose input key matches green evidence is reused and marked reuse.
5. E2e: cache the build stage by source SHAs (no rebuild or reship when unchanged). Optional E2E_KEEP fixture for iterating on one scenario, never for closure evidence.

Acceptance: a deliberately failing package reruns only its suite; an unchanged suite reuses its evidence; the closure evidence lists suites with fresh/reuse provenance.
