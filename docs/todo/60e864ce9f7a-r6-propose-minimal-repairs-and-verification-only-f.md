---
id: 60e864ce9f7a
kind: task
title: R6 Propose minimal repairs and verification only for confirmed defects
seq: 18
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.165424Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Conditional on a proven defect or supported setup gap from R2-R5. Do not assume the residuals are all external to the product, and do not implement redesign or repairs during this planning scope. Prepare the smallest causal patch proposal in the owning repository, failing control, focused regression/affected licensed verification plan, build/source/artifact impact and rollback. Reuse existing runners; no assertion weakening, skips, added providers or arbitrary timeouts. Acceptance: reviewable evidence-backed proposals for any confirmed defects, or explicit no-repair-needed reasoning. Further implementation and invalidated full runs require concrete authorization.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.
