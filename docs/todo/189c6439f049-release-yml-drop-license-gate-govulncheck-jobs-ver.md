---
id: 189c6439f049
kind: task
title: 'release.yml: drop license-gate + govulncheck jobs; verify local-gate evidence bound to the tagged commit instead'
seq: 428
status: todo
priority: p2
created: 2026-11-17T19:48:41.108992Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Operator 2026-11-17: license-gate and govulncheck must NOT run on GitHub; run them once in the local full build on the frozen candidate. Today they cost ~8.5 min per release run and block the build jobs. Plan: the local gate (bashy dag, official build image, gate host) writes a committed evidence record {commit, go.sum hash, license verdict, govulncheck verdict, vuln DB date}; release.yml preflight only verifies the record names the tag's commit + go.sum hash, verdicts pass, and the DB date is within an agreed window (e.g. 7 days); build jobs start right after preflight. After rc.37 is promoted; verification = build + unit tests of the verifier + one dry-run of the preflight step locally.
