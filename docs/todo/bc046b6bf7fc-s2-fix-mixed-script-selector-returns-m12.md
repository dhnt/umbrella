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

## Outcome
Repair M12 successful wrong-result behavior: typed selector returns evaluate values rather than returning literal source text.

Dependencies: S1.

## Acceptance
- Existing M12 prints k=7; cover nested selectors and pointer selectors.
- Update the fixture currently expecting k=j.ID and regenerate the support ledger from its source.
- Typed expressions evaluate correctly or refuse explicitly; no successful literal-text fallback.
- Verify mixed interpreted, package-led and compiled routes independently where applicable; retain documented route differences.
- Preserve ordinary shell return behavior and typed value identity.

S3 follows S2 by sprint delivery policy.
Planned owner: codex (reviewer, gate and merge: claude).
