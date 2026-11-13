---
id: 3fc111b9752f
kind: bug
title: 'bashy share: wire host grant add/ls/rm (rule shape: --circle/--group/--email) next to share who'
seq: 189
status: todo
priority: p1
labels:
    - cli
    - s619
created: 2026-11-13T00:32:01.67429Z
---

Found 2026-11-12 while writing the S619 manual check: yoke pkg/fleet share_grant_cmd.go (newHostGrantCmds: add HOST/APP --circle/--group/--email, ls HOST, rm HOST/APP ID; S619 run #64) is mounted only on yoke's own share root; bashy internal/agentos/fleet_verbs.go wires fleet.NewShareWhoCmd() only, so bashy rc.33 cannot set a group-based host grant. outpost apps share covers --circle or --email only. Fix: AddCommand the grant verbs beside who (one line + a verb test); ship in the next rc.
