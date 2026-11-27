---
id: 4b2f8a4ea109
kind: bug
title: G1 the model door runs in the user's login session (bashy llm up); no outpost change
seq: 836
status: todo
priority: p0
created: 2026-11-27T16:25:06.687699Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §10. Operator decision 2026-11-27: NO change to outpost (boot service, upgrades and reboots stay as they are). The model door runs in the user's login session, started by the user (bashy llm up) or by an agent working in that session; after a reboot it is down until started again. Same on macOS, Linux and Windows: a process in the user's session, no new service registration.

Root cause recap: under outpost's system LaunchDaemon the door cannot use keychain vendor logins (claude, muse, agy); from the user's session the same door serves them (PROBE_OK).

Work (checked against outpost upgrade, reinstall, reboot and release code 2026-11-27):
1. bashy llm up starts a detached door in the caller's session. Today it always fails 'broker: this binary cannot start the door (no self command)': broker.SelfArgv is set only in bashy/internal/agentos/door.go:25, while bashy llm runs the separate adapter bashy/yoke/llm/main.go, which never sets it. Fix in the adapter.
2. The supervisord llm unit stays disabled (the baseline already ships enabled:false, yoke pkg/fleet/baseline/services/llm.yaml). If it is enabled it either starts its own door at boot (wins port 24556) or kills a user-started door as an orphan (supervisord_adopt.go:80-150, argv match). bashy llm up --service warns that a boot-service door cannot use keychain logins on macOS.
3. A user-started door re-execs itself when its bashy binary is replaced (outpost paired upgrade, boot auto-roll, bashy update), so it never keeps an old binary (today only outpost supervisord watches binaries, supervisord.go:172).
4. When the door is down, clients and agents are told to run bashy llm up in the login session (the existing 'start it: bashy llm up' message, plus G2 for a signed-out vendor).

Not touched: outpost service install/upgrade/takeover/reboot paths (verified they only manage io.dhnt.outpost / outpost.service / the outpost task), install.sh, postinstall.

Acceptance on the dev box: llm unit disabled; bashy llm up from the user's shell starts the door; GET /v1/models lists claude-opus5.5, muse-wonder, agy-gemini4-carbon and each answers PROBE_OK; supervisord leaves the door alone; after bashy update the door is serving from the new binary; outpost restart does not affect it. Linux and Windows: bashy llm up in a user session serves that host's logged-in subscriptions.
