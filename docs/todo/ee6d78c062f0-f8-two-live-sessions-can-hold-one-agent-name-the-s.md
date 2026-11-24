---
id: ee6d78c062f0
kind: bug
title: F8 Two live sessions can hold one agent name; the second is refused on the message board
seq: 700
status: todo
priority: p3
labels:
    - group-shaping
created: 2026-11-24T12:47:44.716243Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

2026-11-24: two interactive sessions both used claude-fable5.2. One had its bashy mb posts refused ('no matching live session claim ... seat held by live peer') in the middle of supervising a sprint, while sprint comments still worked. Wanted: at session start, when the name is already held live, say so and offer a distinct instance name, so attribution stays unique and neither session loses its channel. 2 points.
