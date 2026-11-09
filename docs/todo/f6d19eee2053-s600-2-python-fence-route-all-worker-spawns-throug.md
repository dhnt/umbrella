---
id: f6d19eee2053
kind: feature
title: 'S600.2 Python fence: route all worker spawns through bashy'
seq: 63
status: todo
priority: p1
labels:
    - polyglot
created: 2026-11-09T01:26:08.799042Z
sprint: 600
sprint_id: 1b4d2326-3a0e-583e-9cdf-358f396c39e3
sprint_title: Fenced code spawns run through bashy (all fence languages)
---

Depends on S600.1. Python worker (sh/polyglot pythonWorker) patches subprocess.Popen, os.system, os.popen, os.exec*/spawn*/posix_spawn and asyncio subprocess at start; rewrites argv to the bashy gated entry so the child is a real process (pid, pipes, wait/poll, signals, pass_fds, cwd, env native). shell=True/os.system become bashy -c STRING. Acceptance: fixture spawning built-in, registered and unregistered commands (refused); real-process semantics checked; existing Python fence tests green.
