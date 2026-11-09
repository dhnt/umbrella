---
id: 72632f67ab13
kind: feature
title: 'S600.1 bashy spawn gate: gated exec entry + registration rule for fenced spawns'
seq: 62
status: todo
priority: p1
labels:
    - polyglot
created: 2026-11-09T01:26:08.653922Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Spec: docs/research-xonsh-python-fence.md section 1. Provide the bashy side shared by every fence language, built on the existing job-control seam (interp->worker protocol ops job_join/job_leave in sh/polyglot/process_group.go; interp lifecycle sh/interp/bashpp_stream_group.go; real-child substrate sh/interp/bashpp_process_cmd.go bashPPStartCmd) rather than a new mechanism: (a) a gated exec entry that runs argv through bashy resolution (built-ins, coreutils, registered commands, gates) — decide between bashy -c '"$@"' and a dedicated exec mode; (b) shell-string entry (bashy -c STRING); (c) registration rule: a command spawned from fenced code must be a bashy built-in, coreutils or registered via bashy commands add, otherwise refused with a diagnostic naming the command and the registration step, never a raw execve fallthrough; (d) a worker->interp spawn report/request op in the same protocol pattern as job_join so the interpreter applies the rule and records the child (one policy implementation, not per worker); (e) a shim directory of bashy links usable as a PATH prefix for compiled workers. Acceptance: unit tests for built-in, registered, unregistered (refused) and shell-string cases on darwin/linux/windows; a spawned child of a joined worker is in the job's process group and is group-killed on cancellation. Blocks S600.2-S600.5.
