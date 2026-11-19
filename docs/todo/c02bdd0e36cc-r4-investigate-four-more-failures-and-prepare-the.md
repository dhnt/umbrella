---
id: c02bdd0e36cc
kind: question
title: R4 Investigate four more failures and prepare the scope recommendation
seq: 16
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:27.94053Z
sprint: 675
sprint_id: 9b07aedb-77af-52d5-8af3-8035a213774c
sprint_title: Investigate S575 POSIX residuals and prepare certification
---

Depends on R1. Investigate actual S575 more TPs130/132/133/134, including retained LANG/LC_ALL/LC_COLLATE/LC_CTYPE helper diagnostics, against the exact frozen source and original venue. Compare historical S355 final-EOF/editor questions rather than assuming they explain these failures. Classify proven cause or uncertainty and required/optional certification scope. Acceptance: four individually evidenced findings and reviewed minimal repair or authority/scope recommendation, with the existing packet refreshed. Preserve all four raw FAILs; no silent optional exclusion or implementation changes.

Plan: docs/plan-posix-certification-after-separation.md. Current baseline: posix-baseline/s575-2026-11-19; public evidence: bashy/docs/s575-posix-engineering-baseline.md. S575 full run:117 journals/9337 execution TPs,9270 PASS group,4 FAIL,54 UNRESOLVED,9 INSPECT;0 UNINITIATED/UNREPORTED/caps. Archive SHA256:63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1. Preserve exact sources/artifacts and raw verdicts. Restricted journals, fixture details and correspondence stay private. Carried forward from S571 with the same story ID; historical evidence remains context. Planned backlog only: no code change, new full run, external transmission/submission or RC38 release authorized.
