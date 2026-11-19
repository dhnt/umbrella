---
id: 02ec195eb33f
kind: bug
title: 'outpost ssh: lan-direct dial uses the bare peer name and fails when it doesn''t resolve (no relay fallback)'
seq: 534
status: todo
priority: p2
labels:
    - outpost
    - ssh
created: 2026-11-19T16:36:22.632726Z
---

Seen 2026-11-19 on the dev box: 'outpost ssh <user>@<peer> -- ...' failed with 'lan-direct dial <peer>:2222: dial tcp: lookup <peer>: no such host'. The bare peer name doesn't resolve on that LAN, though the mDNS '<peer>.local' name does, and plain ssh through an ssh-config alias works. Expected: lan-direct uses the peer's recorded LAN address (or tries <name>.local) and falls back to the relay instead of failing. Venue check before fixing: confirm against the S629 mesh-direct change on the same outpost build; root-cause before fix per CLAUDE.md. Workaround in use: the e2e WSL transport has a plain-ssh mode.
