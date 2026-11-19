---
id: 74083e97e887
kind: feature
title: Resolve portable todo, sprint and run references
seq: 525
status: assigned
priority: p1
labels:
    - refs
    - work
created: 2026-11-19T11:31:53.264738Z
weave: 96
assignee: muse-conductor
sprint: 668
sprint_id: b09e97b0-b580-5fc1-8a77-8c4377c92883
sprint_title: Uniform entity references and authorized discovery
---

Audit current Yoke todo, sprint and Weave run references against their actual parent identities and local sequences. A hierarchical reference such as host UUID / sprint sequence / todo sequence is portable when each segment resolves unambiguously; a UUID on every child record is not required. Preserve existing Story-ID aliases, sprint UUIDs, run identity distinct from conversation Instance, and legacy name/number lookups. Own pkg/issue, pkg/todo and pkg/weave work-ref resolver files; do not edit fleet Resource or the shared ref vocabulary (owned by #524). Repair only demonstrated ambiguous or unstable resolution, with persisted new identity only when the entity must stand independently. Verify old and proposed handles, duplicate local sequences under different parents, and unchanged authorization on a claimed test host. Preserve isolated source and review evidence; no push until a separately authorized manager review.
