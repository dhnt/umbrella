---
id: 01a1d7b4-2703-7599-ae5a-e8f14082d2de
seq: 14
form: page
type: gotcha
title: outpost satellite attach answers 409 host_exists while a stale legacy host row or master assignment exists under another owner
description: 'WHEN attaching a pair-once host to a satellite whose owner differs from the host owner, or to a satellite that was transferred: a leftover legacy host row on the satellite or a satellite assignment on the master (same host name, other owner) blocks the attach. Fix as THAT owner, agentically: exchange a master token holding satellites:delegate for a satellite token (POST <satellite>/api/v1/tokens/exchange, scopes hosts:read,hosts:write), DELETE <satellite>/api/hosts/<name>?confirm=<name>&purge=true, then POST <master>/api/satellites/unassign {satellite_id, host_name}; re-run outpost satellite attach. Attached hosts keep their machine owner, so the satellite owner''s host list will not show them afterwards; the master record does. Learned 2026-11-14 (Sprint 630, zoo-aws and alien).'
status: candidate
source:
    tool: claude
created: "2026-11-14T01:37:50Z"
---
