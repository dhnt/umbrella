---
id: 1aebed67bd59
kind: task
title: 'release bashy v1.0.0-rc.37 (first self-rebuilding release): tier verdict, QA refs, promote'
seq: 430
status: done
priority: p0
created: 2026-11-17T19:56:46.998283Z
assignee: claude-opus5.5-s656
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-17T20:07:08.14447Z
closed_by: claude-opus5.5-s656
---

Candidate bashy 7d906572 (tag v1.0.0-rc.37-dev, GitHub release run 44154674019 green 2026-11-17 19:54Z). Local verdict (official build image on the gate host): fixed point R1=R2, yoke 189/189, bashy Go tests, Bash 5.3 gate 86/86 both modes, 5 make-free script checks; recorded in docs/release-failure-ledger.md (umbrella a23c7a13). Remaining: native tier smoke (darwin, linux, windows) -> bashy release/tier-verdicts/7d906572.json; umbrella tag candidate/bashy-v1.0.0-rc.37; refs/qa/v1.0.0-rc.37/{linux,darwin,windows}; bare tag v1.0.0-rc.37 at 7d906572; promote.yml; checksums.txt identical to -dev.
