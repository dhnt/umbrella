---
id: 01a1eb74-a45e-7d17-8ebf-db64c54fd3be
seq: 17
form: page
type: lesson
title: 'Rolling an outpost release to the fleet: check for orphaned upgrades and slow hosts before blaming the release'
description: 'WHEN running ''outpost upgrade --from <release asset> --sha256 <sum>'' across paired hosts: (1) a first-try ''stale upgrade candidate at <bin>.upgrading'' means another upgrade process is still downloading (often one orphaned by a local ssh timeout, ppid 1) - list ''outpost upgrade'' processes on the host and kill them; the failing attempt''s cleanup deletes the other''s file, so the file looks absent. (2) outpost''s Go download from the GitHub CDN can crawl on one host while curl there is fast - download on a fast box, verify sha256, copy with plain scp, and use ''outpost upgrade --local''. (3) After the swap the re-exec''d init auto-rolls bashy to the matching version BEFORE starting the daemon; a slow bashy download keeps the daemon down and burns the 10-min confirm window, after which the watchdog reverts and quarantines the release - pre-install the matching bashy, and if the deadline passed extend confirm_deadline in ~/.cache/outpost/upgrade-pending-confirm.json (log a note in upgrade.log) before restarting init. (4) ''remote command exited without exit status'' after an upgrade = the daemon re-exec dropped the session = success; verify with status + upgrade.log confirm_ok. Learned 2026-11-17 on Sprint 656 (rc.37 rollout); product fixes 5ebd65af, 2e98378d.'
status: candidate
source:
    tool: claude
created: "2026-11-17T21:40:52Z"
---
