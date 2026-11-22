---
id: b869a2852a07
kind: task
title: Convert coupled yoke verbs to yoke/ adapters (weave sprint mb inbox kb chat meet todo dag foreman)
seq: 606
status: done
priority: p0
created: 2026-11-21T14:44:43.98384Z
weave: 129
assignee: agy-gemini3.8-flash
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T16:07:01.206367Z
closed_by: muse-wonder-full
---

RELAUNCH (manager, 2026-11-21): previous run (opus5.5) died at the 40m print cap with ZERO commits and zero file writes. Do the opposite: COMMIT AFTER EACH VERB (10 small commits), easiest first so progress banks early: todo, dag, mb, inbox, kb, chat, meet, foreman, sprint, weave. If a verb resists for >10 minutes, exception-list it (one-line reason in the commit + yoke/COUPLED-EXCEPTIONS.md) and move to the next verb. A partial delivery with commits beats a complete plan with none.

Starting point: bashy origin/main 7e461396 (pilot + optional + toolchain + 51 yoke standalone + examples + custom adapters ALL landed). Model: yoke/stats + any custom/ command. Per verb: bashy/yoke/<verb>/<verb>.bsh + main.go (minimal main calling existing constructor; reuse yoke/internal/adapter cobra runner) + fast unit tests incl deps test (no other command package in GOWORK=off go list -deps; builds alone). Switch the verb case in internal/agentos/agentos.go to runCommandAdapter("yoke", name, args); flags/args/output/exit codes unchanged. Where a verb needs another verb, call bashy <verb> at the process boundary; keep every wire/state contract. Sprint/Story/Story-ID trailers + Agent naming YOURSELF on every commit. Root cause before fixing any red. Fast unit tests only. GOTOOLCHAIN=go1.27.4; never make. Deliverable: all 10 verbs converted or exception-listed. Parent ee056056.
