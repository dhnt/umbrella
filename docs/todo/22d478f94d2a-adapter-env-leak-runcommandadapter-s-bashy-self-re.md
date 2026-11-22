---
id: 22d478f94d2a
kind: bug
title: 'Adapter env leak: runCommandAdapter''s BASHY_SELF reaches go test child binaries; plus jq missing from standalone yoke/dag'
seq: 623
status: done
priority: p0
created: 2026-11-22T11:36:46.62794Z
assignee: claude-fable5.1
sprint: 692
closed: 2026-11-22T13:46:40.442723Z
closed_by: claude-fable5.1
---

ROOT CAUSE recorded by run #142 (agy-gemini4-carbon) on 2026-11-22 before it hit the 40-min turn limit: runCommandAdapter (bashy internal/agentos/adapter_dispatch.go) injects BASHY_SELF=/work/bin/bashy into the toolchain/go adapter's environment; it leaks into every binary go test builds, so bashySelfPath() inside agentos.test resolves to bashy instead of the test binary and self-re-exec tests run the wrong program. Reproduced in isolation: TestServiceMonitorSeedInternalAndCustomShareOneMechanism fails at d9598792 alone. Second: jq is missing from the standalone yoke/dag adapter (AssertStandaloneDeps / COUPLED-EXCEPTIONS.md), breaking the genie recipe tests. FIX (small, product): pass BASHY_SELF only to the adapter script itself and strip it (and other adapter-internal variables) from the environment of programs the adapter execs (go, go test children); give yoke/dag the jq it needs. Unit tests: a go test child launched through toolchain/go sees no BASHY_SELF; bashySelfPath() in a test binary returns the test binary; the genie recipe tests pass. Dev box: targeted -run only. Then the conductor reruns dag test on the gate host. Keep the turn short: no gate-host runs in this story. Parent: 3043a867.
