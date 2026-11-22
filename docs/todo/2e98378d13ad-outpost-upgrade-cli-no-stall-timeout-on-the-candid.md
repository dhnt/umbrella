---
id: 2e98378d13ad
kind: bug
title: 'outpost upgrade CLI: no stall timeout on the candidate download; a failing concurrent attempt deletes another attempt''s in-progress .upgrading file'
seq: 433
status: wontfix
priority: p2
labels:
    - outpost
created: 2026-11-17T20:39:11.654109Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-22T13:41:44.501562Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 656 ended): not critical for the next release, which is v1.0.0-rc.40 under Sprint 692 (docs/plan-sprint-692-release-thin-bashy.md). Re-file against outpost if the rc.40 fleet rollout hits it.

Seen 2026-11-17 (rc.37 rollout): 'outpost upgrade --from <github url>' on the macOS QA host stalled for >9 min at 30-200 KB/s with no timeout; the ssh client timed out but the remote process kept running (orphaned, ppid 1). The next attempt hit 'stale upgrade candidate ... remove it and retry' (O_EXCL), and its error path removed <binary>.upgrading — the OTHER, still-running attempt's file — so the advice in the message was performed silently and the file looked absent. Same first-attempt error on two Windows hosts. Fix: a progress/stall deadline on StageFromURL, a lock (or pid-stamped candidate name) so concurrent attempts fail fast without deleting each other's file, and remove only a file this process created. Related: outpost todo 84438d40 (unexpected EOF). Verification: unit tests in internal/agent/upgrade; build.
