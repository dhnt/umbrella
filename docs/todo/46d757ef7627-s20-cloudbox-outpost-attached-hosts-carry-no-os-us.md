---
id: 46d757ef7627
kind: bug
title: 'S20 cloudbox+outpost: attached hosts carry no OS user, so ''outpost connect'' elevates with the caller''s local username and the host rejects it (repeated rejections lock the account)'
seq: 268
status: done
priority: p1
created: 2026-11-14T02:56:33.640869Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T03:16:39.179948Z
closed_by: claude-fable5.1-s630
---

Found 2026-11-14 after migrating the Windows hosts to pair-once + attach: 'outpost connect the Windows hosts' -> 401 invalid host password; with --user <os user> it succeeds. Root cause: the satellite attach exchange (cloudbox handlers/host_attach_satellite.go) accepts host/hostname/os/arch only and creates the Host row without OSUser, while the legacy /api/register/exchange recorded os_user; connect resolves the user from the host's reported os_user (cloudbox /api/v1/ssh/hosts), empty for attached hosts, then falls back to $USER. Side effect: each wrong attempt counts toward the elevation lockout (423, 15 min) - two lockouts today from automated retries. Fix where the cause lives: attach request carries os_user (outpost internal/agent/portal/satellite.go sends it like exchange.go does) and the satellite stores OSUser; also accept os_user on the host heartbeat/report so hosts on older outposts heal without re-attach. Workaround: --user. The test-route script now passes --user from the host spec.
