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
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Owner publishing for a shapeable page and its shapeable components (any website)
---

On the Linux gate lane the system bashy on PATH is an October build without 'mod proxy'; script/gate-lane.sh works around it by building a runner into the lanes directory and putting it first on PATH. Anything run outside gate-lane run still gets the old binary (that is why desk app tests failed with 'unknown revision examples/desk/kit/v0.1.0' on 2026-11-24, and why a ycode test passed with the old binary and fails with a current one). Decide and do one: update the installed bashy there through the normal update path, or make the preflight fail when a command resolves bashy outside the lane runner. Venue only; no product change. 2 points.

## Moved to Sprint 683 (2026-11-24, operator: close Sprint 703)

Owner publishing (offer, adopt) is Sprint 683's workflow, held on 705 S3; this story travels with it instead of being dropped.
