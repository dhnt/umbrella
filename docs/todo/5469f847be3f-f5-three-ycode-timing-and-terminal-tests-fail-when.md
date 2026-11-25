---
id: 5469f847be3f
kind: bug
title: F5 Three ycode timing and terminal tests fail when the gate host is busy
seq: 697
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-24T12:47:43.904689Z
sprint: 713
sprint_id: 867b4689-21ed-53db-93f9-b2a926b28de6
sprint_title: 'Known reds triage after train 1: decide fix or won''t do for each pre-existing test red'
---

Seen 2026-11-24 during the Sprint 685 pin sync: at ycode 02d8930c, with all three gate lanes running, TestBenchmark_QualityLatency, TestTUIOverPTY and TestTUILiteralHandoffOverPTY failed; on an idle lane the same commit passed them (2,275 pass, 53 skip, only the known bug 08ee6df70b5d failing). Root cause first: which deadline or resource each one trips, whether the product is slow or the test bound is brittle. Fix where the cause lives; no deadline is raised without a recorded reason. 3 points.

## Unlinked to the backlog (2026-11-24, operator: close Sprint 703)

A known failing test is tracked, never closed as won't do (root-cause rule). It is not on the MVP path; fix it when it blocks a release gate, with the root cause recorded here.
