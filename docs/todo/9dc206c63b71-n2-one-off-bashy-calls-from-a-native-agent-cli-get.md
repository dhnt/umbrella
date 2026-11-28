---
id: 9dc206c63b71
kind: task
title: N2 one-off bashy calls from a native agent CLI get an identity and a mail notice
seq: 860
status: todo
created: 2026-11-28T09:24:06.731892Z
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
---

Problem: an agent started with its vendor CLI (not bashy <tool>) that calls bashy verbs one at a time has no identity and watches no inbox, so replies never reach it and mb send refuses to sign.
Behavior:
1. Identity. A bashy verb resolves its caller in this order: BASHY_AGENT in the environment; else the nearest ancestor process that is a known agent tool binary; else no agent. An agent ancestor with no recorded name is given one on the spot, <tool>-<8 hex>, printed once, and recorded keyed on that ancestor's pid plus process start time so a reused pid never inherits it. Where the vendor exposes a session id in the environment it refines the key. No agent ancestor means a human, script or automation: nothing changes for them, and authoring verbs keep today's refusal.
2. Notice. When the resolved identity has unread mail, the verb prints one line on stderr: you have mail, check or watch your bashy inbox. No message body. Printed when new mail arrives, then at most about once a minute until read. An env switch turns it off.
3. Wait. bashy inbox can block until the first message arrives and then exit, so an agent expecting a reply can run it as a background task.
4. Sender truth. mb send says whether the recipient is a watched session or reads on its next bashy call.
Scope (operator, 11-28): least disruption. Only bashy yoke verbs and registered commands resolve identity and print the notice. The bash and Bash# interpreter, scripts, and every POSIX or coreutils utility are untouched: no ancestry walk, no extra stderr.
Not in MVP: the notice on plain shell commands in agent mode; splitting subagents that share one tool process and expose no session id; detached, container or remote calls (they need BASHY_AGENT).
Code inspected: yoke pkg/bus/actor_ancestry.go (ProcessHasAncestor, per-OS parent pid), pkg/bus/board.go (ErrUnattributed), pkg/agentlaunch/identity.go (CurrentSessionClaim), pkg/chat/cmd_command.go (callerOwnsSession). Not yet inspected: the inbox peek and claim path (bashy yoke/inbox) and how the running tool is detected today; trace both first and reuse what exists.
Verification: unit tests for the lookup order, pid plus start time keying, the notice throttle and off switch, and that an interpreter or coreutils invocation prints nothing.
