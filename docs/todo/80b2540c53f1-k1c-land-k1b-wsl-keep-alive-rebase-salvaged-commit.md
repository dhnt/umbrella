---
id: 80b2540c53f1
kind: bug
title: 'K1c: land K1b WSL keep-alive - rebase salvaged commits onto S0, rerun unit tests, deliver (K1b ffd48cc9 remainder)'
seq: 603
status: assigned
priority: p0
labels:
    - windows
created: 2026-11-21T12:04:41.903712Z
weave: 137
assignee: codex-gpt6.2-sol
sprint: 692
---

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

Remainder of K1b ffd48cc9993d after run #112 agy print-timeout (40m) during the now-deferred windows acceptance. DONE + manager-verified, preserved as live-bashy branch salvage/s677-k1b-112 @91d49783: spike 877510c5 (cat-on-pipe holds instance), feat 1b2834f1 (supervisord_wslhold + monitor/service hooks, additive), tests 91d49783 (536-line fake-starter suite; manager rerun: go test ./internal/agentos/ -run WSL ok). REMAINING: fetch salvage branch, rebase the 3 commits onto current bashy origin/main INCLUDING S0 baseline sync pins (6ce2c2cb) once landed (rebase only if trivial; else cherry-pick in order), rerun the fast unit tests + bashy dag build, fix reds with root cause first, push bashy then umbrella pin. Windows-native survival acceptance + control arm: DEFERRED TO MILESTONE GATE (gate.final) - record in submit, do NOT run it (that is what timed out #112). Parent K1 73dbfa3a + K1b close with this acceptance. Sign commits as yourself; keep original author trailers on rebased commits where the tooling allows.
