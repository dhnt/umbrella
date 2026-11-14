---
id: 5fb420f2c224
kind: task
title: S15 Pair once dev box + both Windows test hosts with the master; attach to zoo, zoo-aws, lern-si; retire profile dirs
seq: 262
status: done
priority: p1
created: 2026-11-13T21:29:28.576819Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T01:36:29.650591Z
closed_by: claude-fable5.1-s630
---

Depends on S10 (master mode: pair-once is IsMaster-gated). Per host: outpost pair-once under the operator account, outpost satellite attach for zoo, zoo-aws, lern-si (multi-attach, outpost 9bda173+), verify apps/door/ssh through each satellite, then remove the outpost-profile instances and the local profile directories. Keep the legacy zoo pairing until the attach path is verified. Also retire the stale satellite-local outposts (rc.27-dev) by upgrading them.

Layout (operator 2026-11-13): zoo (operator gmail account) <- dev box + both Windows test hosts; alien (operator novigens account) <- the two novigens hosts + dev box. The dev box attaches to BOTH: pair once under the gmail account, attach zoo (own) + alien (foreign owner). mayAttach = same owner OR mutual membership; the two accounts are already mutual (team circle). No host sharing or dual ownership needed for attach; a host grant on the dev box for the novigens identity only if its apps must be reachable through alien. The novigens hosts pair under the novigens account. DONE 2026-11-14: dev box = zoo, lern-si, zoo-aws, alien; the gate Windows host = zoo, lern-si, zoo-aws; the second Windows host = zoo, zoo-aws.
