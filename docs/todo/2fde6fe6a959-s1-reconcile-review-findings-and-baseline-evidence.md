---
id: 2fde6fe6a959
kind: requirement
title: S1 Reconcile review findings and baseline evidence
seq: 80
status: todo
priority: p0
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.380449Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Map every finding in all four docs/bashsharp-review-*.md reviews to a reproduction, existing capability, existing story, or deferred recommendation. Record exact candidate SHAs and known failures. Current inspected review pins: bashsharp 45ae8e2d0f1d0ad384355859a8f0eb4fed2a893c; sh d2913001421b8a2a6b247ee9953ca89c84ff2868; bashy a9958c91e4853206a45b4ec20e5aecc894b89453; bashsharp-tests 6d414e2ec30d34f4b382f0966acf1ff840c330d1. Revalidate at execution time.
Acceptance: every finding has a disposition and evidence reference; stale conclusions corrected through a reconciliation record, preserving original reviews. Explicitly recognize existing JSON diagnostics, environment plans, concurrency, C# fences and agent benchmarks. Record no-regression baseline, test commands and evidence identity; distinguish fresh runs from reused evidence.
Planning-only creation: no coding, execution ownership, worker launch or release. S2 depends on S1. Shared future gates: focused tests first; heavy suites only on remote test hosts; Classic 86/86 preserved; dialect-on comparison by fixture identity; workspace and GOWORK=off builds; submodule delivery before umbrella pin bumps; sprint/story trailers and public scrub gate.
