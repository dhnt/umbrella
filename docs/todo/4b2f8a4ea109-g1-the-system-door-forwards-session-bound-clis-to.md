---
id: 4b2f8a4ea109
kind: bug
title: G1 the system door forwards session-bound CLIs to a user-session cligw (bashy llm up --session); no outpost change
seq: 836
status: todo
priority: p0
created: 2026-11-27T16:25:06.687699Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §10. Operator decision 2026-11-27 (revised twice the same day): NO change to outpost, and the system door stays the front.

Design: the system door (bashy llm serve on 24556, the supervisord llm unit under outpost's boot service) is unchanged and remains the ONE endpoint every agent, contained genie and peer outpost uses, with the same bashy tokens. It is the superset: local Ollama models, API-key models and CLIs whose vendor login is a file (codex, opencode) need no user login and keep being served in-process. Only CLIs whose login lives in the user's login session (on macOS the keychain: claude, muse, agy) need a session cligw.

Work:
1. Session cligw: bashy llm up --session, run in the user's login session by the user or an agent, serves cligw on an owner-only unix socket (never on 24556: no port fight, and supervisord's orphan replacement does not match it). It records its socket in the door state dir and removes it on exit. Today bashy llm up cannot start anything ('no self command': the llm adapter never sets broker.SelfArgv); fix that on the way.
2. Per-tool marker: the fleet tool definition says whether its login needs the user's session (true for claude, muse, agy on macOS; measured, not guessed, per OS).
3. Routing in the system door: requests for a binding whose tool needs the session are forwarded to the session cligw when its socket answers (the broker's existing forwarding path); everything else stays in-process as today.
4. Session cligw down (after a reboot, before anyone starts it): those bindings answer needs-session with the command to run (shares G2's error path), no breaker trip.
5. The session cligw re-execs itself when its bashy binary is replaced (paired upgrade, auto-roll, bashy update).

Not touched: outpost install, upgrade, takeover, reboot and release paths (checked: they manage only outpost's own registration); the supervisord llm unit stays enabled.

Acceptance on the dev box: the system door lists and serves codex as today; with no session cligw, claude-opus5.5 / muse-wonder / agy-gemini4-carbon answer needs-session naming bashy llm up --session; after bashy llm up --session from the user's shell, each answers PROBE_OK through 24556 with the owner token; an outpost restart and a bashy update leave both doors serving (the session one from the new binary). Linux and Windows: the system door serves file-login CLIs in-process; the session mode works where a vendor needs the desktop keyring or credential store.
