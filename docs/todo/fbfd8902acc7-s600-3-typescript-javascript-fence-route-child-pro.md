---
id: fbfd8902acc7
kind: feature
title: 'S600.3 TypeScript/JavaScript fence: route child_process through bashy'
seq: 64
status: todo
priority: p1
labels:
    - polyglot
created: 2026-11-09T01:26:08.937106Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Depends on S600.1. Node worker patches child_process (spawn, exec, execFile, fork and sync variants) at start, same argv rewrite and shell-string handling as S600.2. The TS/JS worker does not implement job_join/job_leave today (Python, Rust, C#, PowerShell do): add them so the worker and its spawned children join the shell job's process group. Acceptance: same fixture shape as S600.2 for ts and js fences, plus job membership and cancellation group-kill; existing TS/JS fence tests green.
