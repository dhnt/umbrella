---
id: 4b2f8a4ea109
kind: bug
title: G1 run the model door in the user's login session on macOS, Linux and Windows
seq: 836
status: todo
priority: p0
created: 2026-11-27T16:25:06.687699Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §10. Root cause found 2026-11-27: the model door runs under outpost's system LaunchDaemon (io.dhnt.outpost, domain system, username = the user), so cligw workers have no access to the user's login keychain; claude, muse and agy (keychain logins on macOS) exit at once and are reported as 502 transient, codex (file login) works. The same door started from the user's login session (with exactly the service env) serves claude-opus5.5 and muse-wonder (PROBE_OK). Fix where the cause lives: run the door (the llm service, the only process that launches subscription CLIs) per user in the login session on all three OSes: macOS LaunchAgent (gui/<uid>), Linux systemd --user unit (lingering), Windows per-user logon task. Outpost and the other services stay where they are. No OS password is stored (operator ruling: tokens, never OS-password elevation). Acceptance: on each OS a service-started door passes TestLiveDoorReadiness-style probes for every subscription binding logged in on that host; a Mac rebooted but not yet logged in refuses with a named reason. Code inspected 2026-11-27: yoke pkg/cligw server.go, worker.go (workerEnv), router.go; bashy internal/agentos adapter_dispatch.go, yoke/llm/llm.bsh; launchctl print system/io.dhnt.outpost.
