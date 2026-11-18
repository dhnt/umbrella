---
id: 244c0d674df7
kind: feature
title: S1 Minimum contract checker, usable from shaping
seq: 414
status: todo
priority: p1
labels:
    - yoke
created: 2026-11-17T18:49:46.15739Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: there is no way to check a command or app against the contract.
Behavior: one minimal checker command that checks one command or app against the contract and reports by name: conform / adapted / declared-unsupported / FAIL. Written as a Bash# skill-script registered with commands add (Go only where a script cannot), so it is itself shapeable. shape verify can include it when the user or agent asks; not on by default, never blocks registration or activation. No catalog-wide baseline run in this sprint.
Depends on: S0.
Verification: runs on one featured command and on one app, reporting gaps by name; one shaping wish ("conform to the command contract") on the Hello World app yields a candidate the checker passes; existing shaping tests stay green.
