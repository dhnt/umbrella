---
id: 5ebd65af3b15
kind: bug
title: 'outpost init: bashy auto-roll download blocks daemon launch and burns the upgrade confirm window (would auto-rollback + quarantine a good release)'
seq: 432
status: wontfix
priority: p1
labels:
    - outpost
created: 2026-11-17T20:39:11.511764Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-22T13:41:45.053682Z
---

WONTFIX (operator rescope 2026-11-22; Sprint 656 ended): not critical for the next release, which is v1.0.0-rc.40 under Sprint 692 (docs/plan-sprint-692-release-thin-bashy.md). Operator decision D3 2026-11-22: wontfix now; re-file if the fleet rollout of rc.40 via outpost auto-roll hits it.

Seen 2026-11-17 rolling outpost rc.37 to the macOS QA host. After 'outpost upgrade' swapped the binary, the re-exec'd init (supervisord) resolved bashy, found the managed bashy at rc.35, and reconciled it by downloading the rc.37 bashy (182 MB archive) inside bashyResolver.Path BEFORE starting any child. The host's Go HTTP download from the GitHub CDN crawled (32 MB after minutes; curl on the same host got ~7 MB/s), so the daemon stayed down >15 min and the confirm deadline (10 min) passed. When the init finally launches the daemon, watchdogPreStart reverts to .previous and QUARANTINES the release for being 'never confirmed healthy', although the new binary was never started. Manual recovery used: extend confirm_deadline in upgrade-pending-confirm.json (logged operator_note in upgrade.log), SIGTERM the blocked init, pre-install the matching bashy, start 'outpost supervisord' detached -> confirm_ok 20:38Z. Fix in outpost: launch the daemon first and reconcile bashy in the background (or with a bounded deadline + resume), and do not count time the daemon was never started against the confirm window. Also: this host's init was started by hand with no launchd agent ('outpost service install' absent) and logs to /dev/null; record it on the venue. Verification: unit tests for the init ordering + watchdog window; build.
