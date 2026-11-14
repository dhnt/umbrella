---
id: 54914406d25c
kind: task
title: 'S14 Company identity: superadmin allowlist + mutual membership + transfer zoo and zoo-aws to the company account'
seq: 261
status: assigned
priority: p1
created: 2026-11-13T21:29:28.305822Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

status    assigned
  priority  p1
  created   2026-11-13T21:29:28Z
  assignee  claude-fable5.1-s630
  sprint    #630 · 106504a0-f6e4-55e5-9736-d8f2bd1ef052
Decision 2026-11-13: company identity = the existing Google account on the company domain (no Workspace). Steps: add it to SUPERADMIN_EMAILS on the master (App Platform env, re-derive from the known standalone spec); invite it as a mutual member of the operator account and accept; bashy satellite transfer zoo and zoo-aws to it; lern-si stays with the operator account; admit rules re-checked after transfer. Outposts attached to zoo/zoo-aws must keep working (host owner != satellite owner is a valid config).

2026-11-14 00:24Z: company account active+mutual (team); zoo-aws TRANSFERRED to it (note: delegated-login grants cleared; the satellite re-owns legacy-paired host rows and tokens to the new owner — zoo-aws's outpost-profile instances are now company-owned there, acceptable since S15 retires them). zoo transfer DEFERRED until S15: reconcileLocalOwner keeps only pair_mode=attach hosts with their owner; legacy-paired dev box + Windows hosts would be re-owned and the gmail session on zoo suspended. Order: S10 flip -> S15 pair-once + attach -> transfer zoo -> admit rule for the gmail circle on both satellites. Still needed from the operator: a company owner token (console as the company account: Settings > Access token; scopes members, satellites, hosts) stored in the vault as DHNT_COMPANY_OWNER_TOKEN for S16 checks and admit rules.
