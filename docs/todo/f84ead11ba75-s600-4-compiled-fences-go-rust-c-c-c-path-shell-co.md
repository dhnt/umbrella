---
id: f84ead11ba75
kind: feature
title: 'S600.4 Compiled fences (Go, Rust, C, C++, C#): PATH/SHELL/ComSpec shim to bashy'
seq: 65
status: todo
priority: p1
labels:
    - polyglot
created: 2026-11-09T01:26:09.078426Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Depends on S600.1. Worker launch env prefixes PATH with the bashy shim directory and sets SHELL (and ComSpec on Windows) to bashy so bare-name spawns and shell-string calls (system(), popen(), sh -c) route through bashy. Document that absolute paths and raw execve escape (no containment claim; sandbox tier is the enforcement boundary). Acceptance: per-language fixture spawning built-in, registered, unregistered (refused) by bare name; existing native fence tests green.
