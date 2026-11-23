---
id: deade8cd5420
kind: feature
title: 'LAN install MVP-1: install.sh/install.ps1 honour BASHY_RELEASE_BASE (mirror base URL or dir; archive + checksums from the mirror)'
seq: 634
status: assigned
priority: p1
labels:
    - install
    - lan
    - post-rc40
created: 2026-11-22T20:35:35.105261Z
assignee: claude-fable5.1
sprint: 694
---

Operator 2026-11-22: local-first install; not release-gating for rc.40. outpost/scripts/install.sh lines 39-47 and install.ps1 lines 25-35: when BASHY_RELEASE_BASE (or --base-url/-BaseUrl) is set, resolve the tag from <base>/latest, take the asset and checksums.txt from <base>/<tag>/ (BASHY_RELEASE_CHECKSUMS=github forces upstream digests), cp for a directory base; everything else unchanged. Live via dhnt.io -> raw outpost main. Acceptance: sh -n; install from a loopback mirror into a temp dir, version equals <base>/latest.
