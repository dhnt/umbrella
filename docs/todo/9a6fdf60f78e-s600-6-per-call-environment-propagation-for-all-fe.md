---
id: 9a6fdf60f78e
kind: bug
title: S600.6 Per-call environment propagation for all fence workers
seq: 67
status: todo
priority: p1
labels:
    - polyglot
created: 2026-11-09T01:26:09.357321Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Worker env is fixed at launch (sh/polyglot Python.configure sets cmd.Env once); an export after the first call is invisible. Send the exported-variable delta with each call (calls already carry cwd), apply it to the worker process env for the call and restore afterwards, for every fence language with a persistent worker. Spawned children (S600.2-5) inherit it. Acceptance: export-after-first-call fixture per language; existing tests green.
