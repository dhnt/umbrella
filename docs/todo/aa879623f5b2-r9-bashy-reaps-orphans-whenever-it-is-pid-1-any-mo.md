---
id: aa879623f5b2
kind: feature
title: R9 bashy reaps orphans whenever it is PID 1 (any mode), so bashy images need no --init
seq: 401
status: todo
priority: p1
created: 2026-11-17T15:54:10.162308Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
---

Operator 2026-11-17: bashy creates everything, so it should reap orphans itself. Found in the rc.37 run: in the official build image, PID 1 is /bashy (bashy -c), which does not reap; killed descendants stayed as zombies and every process-group kill test failed (yoke agentpty, chat, cligw, dag signal). Passing --init (podman-init as PID 1) fixed it, which is now the venue fix in tools/bashy-build/run.sh. The mechanism already exists: bashy supervisord's reaper (internal/agentos/supervisord_linux.go) reaps when PID 1 or a PR_SET_CHILD_SUBREAPER, and handles the race where wait4(-1) steals a status the real waiter needs (arm/stash). Scope: start that reaper whenever bashy is PID 1 in any mode (shell, -c, script, dag), wired so the interpreter's own child waits still get their true exit statuses; Linux only (other platforms unchanged). Then drop --init from run.sh. Acceptance: in a bashy-entrypoint container without --init, the yoke process-group kill tests pass and a stress test of orphaned grandchildren leaves no zombies; the shell's own 0 and wait statuses are unchanged (bash 5.3 gate 86/86 both modes).
