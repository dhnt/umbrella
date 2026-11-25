---
id: d246ca4e518e
kind: task
title: 'F11 Gate host: the installed bashy predates the local module proxy; only the lane runner is current'
seq: 704
status: todo
priority: p0
labels:
    - venue
created: 2026-11-24T12:56:16.658847Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

On the Linux gate lane the system bashy on PATH is an October build without 'mod proxy'; script/gate-lane.sh works around it by building a runner into the lanes directory and putting it first on PATH. Anything run outside gate-lane run still gets the old binary (that is why desk app tests failed with 'unknown revision examples/desk/kit/v0.1.0' on 2026-11-24, and why a ycode test passed with the old binary and fails with a current one). Decide and do one: update the installed bashy there through the normal update path, or make the preflight fail when a command resolves bashy outside the lane runner. Venue only; no product change. 2 points.
