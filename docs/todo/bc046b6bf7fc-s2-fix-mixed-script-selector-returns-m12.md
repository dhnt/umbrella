---
id: bc046b6bf7fc
kind: bug
title: S2 Fix mixed-script selector returns (M12)
seq: 81
status: todo
priority: p0
labels:
    - bashsharp-review
created: 2026-11-10T17:17:56.499898Z
sprint: 610
sprint_id: 225786a1-0676-58ef-9bdf-e3e1018c3818
sprint_title: Bash# correctness, checking, and execution guarantees
---

Depends on S1. Evaluate struct selectors in typed returns as typed expressions rather than literal shell text.
Acceptance: existing M12 prints k=7, with nested-selector and pointer-selector regression cases. Update the fixture currently expecting k=j.ID and regenerate the support ledger from its source. Check interpreted and compiled routes separately and preserve documented differences. No silent fallback from an unsupported typed expression to successful literal text.
Planning-only creation; implementation requires a later execution instruction. S3 follows S2.
