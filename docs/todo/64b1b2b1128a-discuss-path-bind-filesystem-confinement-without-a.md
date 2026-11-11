---
id: 64b1b2b1128a
kind: question
title: 'discuss: path-bind filesystem confinement without a container'
seq: 148
status: todo
priority: p3
labels:
    - security
created: 2026-11-11T22:01:36.502009Z
---

From docs/strands-shell-gap-analysis.md (not committed scope). Idea: contain --fs with read-only/read-write path binds via Landlock (Linux) and Seatbelt (macOS), container fallback on Windows. Needs an operator decision on cost and cross-OS parity before any design.
