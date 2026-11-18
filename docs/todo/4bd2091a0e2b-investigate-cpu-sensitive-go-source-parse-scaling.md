---
id: 4bd2091a0e2b
kind: bug
title: Investigate CPU-sensitive Go-source parse-scaling guard
seq: 455
status: todo
priority: p2
created: 2026-11-17T23:43:28.802695Z
---

Preservation investigation only; no test or product fix authorized. TestSpellingShadowParseScaling compares best-of-three wall times for800 and6400functions, requiring ratio<=12. Frozen a4141771 and reference-only99501d39 used the same official rc.37 image, Go1.27.2 and2GiB Go memory limit. With4Go CPUs, ten focused repeats were10pass/0fail for baseline and9pass/1fail for candidate; the candidate full suite failed at14.06 while the untouched full suite passed. With GOMAXPROCS1, BOTH trees gave2pass/8fail (baseline maximum14.89, candidate13.31). With8CPU quota and GOMAXPROCS8, BOTH trees passed all ten focused repeats. The runtime probe confirms32logical CPUs and that Go correctly follows the configured quota. Demonstrated cause: the existing wall-clock guard is sensitive to CPU parallelism. The precise GC/scheduler mechanism is not isolated, and no algorithm change is demonstrated by reference-only relocation. Keep the threshold, assertion and test selection unchanged. The final candidate full root and nested-module grade passed in the qualified eight-CPU lane with serial Go packages; captured output distinguishes fresh runs from Go cache reuse. Source equivalence preserves3269files, with only declared reference transforms and module metadata. Follow up on making the performance guard less dependent on CPU scheduling after the refactoring; do not repair or weaken it during575.
