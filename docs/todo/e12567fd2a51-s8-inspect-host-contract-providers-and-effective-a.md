---
id: e12567fd2a51
kind: feature
title: S8 Inspect host contract providers and effective authority
seq: 87
status: todo
priority: p1
labels:
    - bashsharp-review
created: 2026-11-10T17:17:57.350056Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S3-S5. Checking identifies missing native decorator providers and required host capabilities. Add statically provable agentic-scope and effect-cap diagnostics; explicitly classify unknown effects.
Acceptance: standalone missing-provider reproduction is diagnosed before checked execution; supported bashy providers are recognized; false positives are avoided for user-defined decorators. Publish a matrix separating declarations, command dispatch enforcement, containment, native imports and foreign-worker boundaries. No policy dependency from the standalone language onto bashy/yoke.
Link existing Sprint 600 (UUID 1b4d2326-3a0e-583e-9cdf-358f396c39e3) for spawn routing, per-call env and worker lifecycle. Do not duplicate its implementation. PATH/SHELL shims must not be presented as universal containment.
Planning-only creation; no authority/default changes.
