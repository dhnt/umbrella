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
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Seen 2026-11-24 during the Sprint 685 pin sync: at ycode 02d8930c, with all three gate lanes running, TestBenchmark_QualityLatency, TestTUIOverPTY and TestTUILiteralHandoffOverPTY failed; on an idle lane the same commit passed them (2,275 pass, 53 skip, only the known bug 08ee6df70b5d failing). Root cause first: which deadline or resource each one trips, whether the product is slow or the test bound is brittle. Fix where the cause lives; no deadline is raised without a recorded reason. 3 points.
