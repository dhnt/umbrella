---
id: 255b1585220c
kind: bug
title: F7 The fleet probe reports an agent usable when its vendor quota is exhausted
seq: 699
status: wontfix
priority: p2
labels:
    - group-shaping
created: 2026-11-24T12:47:44.453603Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
closed: 2026-11-25T04:10:34.866464Z
---

2026-11-24: bashy weave fleet --fleet agy-sonnet5.5 --probe answered USABLE (smoke token confirmed); the sprint manager launched on it was refused on its first real turn with 'Individual quota reached ... Resets in 94h', and sat idle for 15 minutes with nothing on the thread. agy-opus5.5 was in the same state. Wanted: the probe (or the manager launch) detects a quota refusal and reports the agent unusable with the reset time, and a managed session whose first turn is refused surfaces that on the sprint thread instead of idling. 3 points.

## Won't do (2026-11-24, operator: close Sprint 703)

Not needed for the MVP or the supported workflows (anonymous visitor, member, owner sharing and group shaping). Reopen with a new plan if a need appears.
