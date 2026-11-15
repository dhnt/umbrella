---
id: cbdb442735f2
kind: bug
title: 'outpost: ''outpost ssh ALIAS'' elevates by the alias name, not the alias''s host (cookie cached for the host is not found; prompts for a password)'
seq: 272
status: assigned
priority: p2
labels:
    - outpost
created: 2026-11-14T11:05:18.46012Z
assignee: claude-fable5.1-s630
sprint: 647
sprint_id: 5870e910-cf7b-5b7b-ba25-6a0424321901
sprint_title: 'S630 carry-over: signed identity, company identity, apps --url acceptance, satellite names, ssh alias elevation'
---

Found 2026-11-14: after 'outpost connect --user U HOST' cached a cookie for HOST, 'outpost ssh ALIAS -- cmd' (alias whose host is HOST) fails with 'elevate ALIAS: read password: no /dev/tty'; the ad-hoc form 'outpost ssh U@HOST -- cmd' works. Root cause (to confirm in code): the relay/dial path passes the alias name where the host name is expected for the elevation cookie lookup (OnElevate h) when the alias name differs from its host (aliases named like their host hide it). Fix: resolve the alias to its host before elevation/cookie lookup.
