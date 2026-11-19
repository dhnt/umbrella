---
id: 52d169ab8c3b
kind: question
title: R3 Investigate the man command-count precondition and prepare resolution
seq: 15
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:27.827032Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Depends on R1. Verify the exact current man:4 prerequisite observation:109 available names versus a greater-than109 test before man is invoked. Inspect source, configuration, declared scope and original inventory; reuse the S355 question. Do not invent names or introduce external utilities to satisfy a count. Prepare the root-cause analysis and supported resolution/authority question with evidence. Acceptance: proven prerequisite/control-flow evidence, explicit scope/provider impact and reviewed recommendation or exact authority question; any repair remains a proposal.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.
