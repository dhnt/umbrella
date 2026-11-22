---
id: e0a18974cc3b
kind: task
title: Examples adapter coverage
seq: 607
status: done
priority: p0
created: 2026-11-21T14:44:44.133667Z
weave: 126
assignee: agy-sonnet5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T15:43:30.828848Z
closed_by: muse-wonder-full
---

Folder examples/. Every example app/command gets its own adapter entry; pure-script examples keep working as registered commands; each builds/runs standalone from its adapter with a fast test or smoke. Deliver: inventory with converted-or-reason per item. Starting point: bashy origin/main 62ee3c74 (pilot + optional + toolchain + 51 yoke standalone adapters landed). Model: yoke/stats + any optional/toolchain command. Adapter per command: bashy/<folder>/<cmd>/<cmd>.bsh + main.go (minimal main calling existing constructor; reuse yoke/internal/adapter cobra runner where it fits) + fast unit tests. Switch the command case in internal/agentos/agentos.go to runCommandAdapter(<folder>, name, args); flags/args/output/exit codes unchanged. Independence per command: builds alone GOWORK=off; dependency test/.golden proves no other command package in go list -deps. A command needing another calls bashy <verb> at process boundary. Commit per command-group (Sprint/Story/Story-ID trailers + Agent naming YOURSELF). Root cause before fixing any red. Fast unit tests only; integration deferred. GOTOOLCHAIN=go1.27.4; never make. Parallel sibling stories touch agentos.go in DIFFERENT cases - rebase onto origin/main before submit. Parent story ee056056.
