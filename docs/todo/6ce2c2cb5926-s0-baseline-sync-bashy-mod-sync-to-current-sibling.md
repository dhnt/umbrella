---
id: 6ce2c2cb5926
kind: chore
title: 'S0: baseline sync - bashy mod sync to current sibling heads (pre-P2/P3, operator sync rule)'
seq: 601
status: done
priority: p0
created: 2026-11-21T11:49:10.497244Z
weave: 116
assignee: agy-gemini4-hydrogen
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T12:16:33.772056Z
closed_by: muse-wonder-full
---

FIRST, before P2/P3 code lands (conductor 2026-11-21, operator sync rule: never work on outdated code). Manager-verified drift in bashy (bashy mod drift, 11:52Z): cycle bashsharp pinned 4141cc07 HEAD 2175e583; cycle ycode+genie pinned e5be3135 HEAD e9d247c0; stale coreutils c6569352->b504ce9d, coreutils/third_party/goawk, bash 7855c2f0->1a8032db, outpost f066eaf0->c643f402, bonsai, gfy, readline, yoke/external/otel + yoke/pkg/llmgw + yoke/pkg/oci + yoke/pkg/provider (299a502d->da4b02a4). Under GOWORK=off this builds pre-go1.27.4 coreutils/bash.

WORK: start from CURRENT origin default branch of every repo touched (never stale umbrella pins/shared checkout). In bashy: bashy mod sync to current sibling heads; bump the bashy<->ycode cycle BY HAND per bashy CLAUDE.md (srcModulePins + skillhelp goldens if they move); same for bashsharp cycle. Producer repos first if any producer change is needed (none expected - heads already pushed). Verify: bashy mod drift clean (no stale/cycle for touched modules), bashy dag build green, fast unit tests for touched packages written/run (at minimum existing focused tests of packages whose pins moved; add the smallest maintained test if a moved pin changes behavior). NO integration suites (operator milestone rule - gate.final is conductor-called). Push bashy, then umbrella pin bump. Commit per stage (sync / cycle-by-hand / goldens / pin). Root cause before fixing any red (directive #3); trailers + Agent signed as yourself (directive #4). After this lands, P2 #114 and P3 #115 rebase onto it before submit (manager coordinates).
