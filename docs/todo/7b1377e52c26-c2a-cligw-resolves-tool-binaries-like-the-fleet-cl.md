---
id: 7b1377e52c26
kind: bug
title: C2a cligw resolves tool binaries like the fleet (claude, muse, agy unseen in ~/.local/bin)
seq: 827
status: done
priority: p0
created: 2026-11-27T14:31:25.352336Z
assignee: claude-opus5.5
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
closed: 2026-11-27T16:48:22.037851Z
closed_by: claude-opus5.5
---

Plan: docs/sprint-738-master-execution-plan.md. Found in C1 (2026-11-27): cligw serves no claude, muse or agy binding on a host whose CLIs live in ~/.local/bin. GET /v1/models lists codex and opencode bindings only; a request for claude-opus5.5 or muse-wonder gets 'no matching candidate is installed and outside breaker cooldown'. Root cause (product defect): Router.toolInstalled (yoke pkg/cligw/router.go:499) does lookPath(tool.Binary()) on the door process's PATH (/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin, from the service unit), while bashy delegate resolves the managed pins and the user's bin dirs; claude, muse and agy are in ~/.local/bin, codex and opencode in /opt/homebrew/bin. Fix where the cause lives: cligw resolves a tool's binary the same way the fleet does (managed pin, then the user's bin dirs, then PATH) for both the servable check and the worker launch. Unit test: a tool only in a user bin dir is servable and launches. Then confirm GET /v1/models lists claude-opus5.5 and muse-wonder on the dev box.
