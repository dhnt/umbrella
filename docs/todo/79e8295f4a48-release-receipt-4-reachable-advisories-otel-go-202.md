---
id: 79e8295f4a48
kind: bug
title: 'Release receipt: 4 reachable advisories (otel GO-2026-6974/6975, gobwas/ws GO-2026-6940, gorilla/websocket GO-2026-6278); bump yoke, outpost, ycode, bashy'
seq: 751
status: assigned
priority: p0
labels:
    - release
    - security
created: 2026-11-25T12:50:16.239277Z
assignee: claude-opus5.5
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
---

Found by scripts/local-release-gate.sh on rc.41 candidate 54fcfae9 (gate host lane 3, official image), govulncheck DB modified 2026-11-24T15:56Z. Root cause (environment/advisory data): new advisories published after the rc.40 receipt (DB 2026-11-11) against pinned dependency versions; no code change introduced them. Reachable: bashy (all three profiles) otel v1.45.0 (fix v1.47.0) and gobwas/ws v1.4.0 (fix v1.5.0); outpost otel; yoke otel, gobwas/ws and gorilla/websocket v1.5.3 (fix in the 2025 pseudo-version already used by outpost/bashy/ycode). Override is retired (D2), so the fix is a dependency bump: yoke -> outpost -> ycode -> bashy (+ srcModulePins), engine modules (bash, sh, coreutils, bashsharp) untouched so the sealed Bash gate evidence still applies. Then rerun legs 2, 4 (Linux + Windows native), 5, dist and the receipt.
