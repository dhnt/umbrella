---
id: 9b583d405206
kind: feature
title: 'S600.7 run() helper: caller-context command execution with result object'
seq: 68
status: todo
priority: p2
labels:
    - polyglot
created: 2026-11-09T01:26:09.497067Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Second slice, after S600.1-S600.6. A run(argv) request over the existing $callback channel executes in the caller's interpreter (functions, unexported vars) and returns rc, out, err, lines, truthiness (rc==0) and check(); default no raise. Host side shared Go; Python and Rust workers already decode callbacks; add client stubs for the other languages. Acceptance: per-language fixture; callback re-entry cap unchanged.
