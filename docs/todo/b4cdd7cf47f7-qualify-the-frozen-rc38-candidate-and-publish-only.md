---
id: b4cdd7cf47f7
kind: task
title: Qualify the frozen RC38 candidate and publish only after operator hold is lifted
seq: 386
status: todo
priority: p1
labels:
    - operator-hold
created: 2026-11-17T11:49:55.979453Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Carry forward the existing local-release request; implemented infrastructure is delivered by stories428/429/431. Remaining scope: freeze the exact full Bashy candidate and producer pins, verify required DB/token regressions, obtain passing truthful local license/security evidence in the qualified locked image, generate and verify the full artifact family, retain exact source/build/dependency/asset/signing receipts, and measure the actual build/package/upload path with warm/cold conditions disclosed. The old b88 benchmark proves227s warm build/package only, not current-source timing or upload. Investigate red findings and propose minimum toolchain/dependency remediation before changes; no policy bypass or silent waiver. RC38 TAGGING AND PUBLICATION ARE ON OPERATOR HOLD until explicit further instruction. This task stays unassigned/todo; no build, upload, tag or publication is authorized by reconciliation. After hold lift, follow the existing complete-dev/promotion routes, verify all assets and actual elapsed release time against the operator target. Preserve the independently tagged POSIX evidence and do not rerun or modify licensed tests as a release shortcut. See docs/sprint-656-master-execution-plan.md.

2026-11-20 session-exit handoff: docs/sprint-656-release-handoff.md records delivered infrastructure, exact warm/cold timing limits, the remaining red security/current-candidate qualification, existing publication route, and retained POSIX evidence. The operator will build/release in another TUI session; no RC38 build, tag, upload or publication is started here. Follow that session's operator release instruction. Leave this task open for its actual qualification and publication receipts.
