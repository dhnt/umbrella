---
id: 01a1d5e9-772e-7ad1-9cdb-2452adf0ddac
seq: 11
form: page
type: gotcha
title: 'outpost ssh exec caps a remote command at 1 minute: a WSL keepalive held by it dies and WSL stops the distro'
description: 'WHEN holding a WSL distro alive (or running anything long) through outpost ssh exec on the Windows test host: exec has --timeout 1m by default (server-side max 10m), so a keepalive client ends after about 55 s and WSL powers the distro off about 15 s later, killing systemd units mid-run. Chain overlapping ''outpost ssh exec --timeout 10m'' keepalive sessions (a new one every 9 min, bounded); a detached ''cmd start wsl.exe ...'' from the exec session did not start at all.'
tags:
    - wsl
    - outpost
    - windows
status: candidate
evidence: 'S627 M8 revision run 2026-11-13: draft 07 run 1 lost during the song (journal: unit Stopping 16:52:27Z, System Power Off); chained 10m sessions held the distro for drafts 07 and 08. docs/sprint-627-m8-drafts-evidence.md'
source:
    tool: claude-opus5.5-g
    episode: ep-a6d20a6734566951
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T17:16:49Z"
---
