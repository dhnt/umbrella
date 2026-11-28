---
id: 9dc206c63b71
kind: task
title: N2 one-off bashy calls from a native agent CLI get an identity and a mail notice
seq: 860
status: done
created: 2026-11-28T09:24:06.731892Z
assignee: claude-fable5.2
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
closed: 2026-11-28T11:02:04.095917Z
closed_by: claude-fable5.2
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

## Delivery (2026-11-28)

Code trace first (the story's own first step). Most of the behavior already
existed and only lacked an identity for a native session:

- Notice: bashy's unread-mail hint (`internal/agentos/nudge.go`) already runs
  before every ordinary `bashy <verb>`, on stderr only, count and senders and
  never bodies, once per new arrival, off with `BASHY_HINTS=off`. It is in the
  front-door dispatch, so the bash and Bash# interpreter, scripts and the
  utilities never reach it.
- Wait: `bashy inbox --wait DUR` already blocks until mail arrives.
- Sender truth: `bashy mb` already reports queued versus unverified delivery
  per recipient.

What was built:

- yoke `d5e2b267`: `pkg/bus/adhoc.go`. With `bus.AdHocIdentity` on, an
  unattributed harness session is given a fleet instance derived from what is
  constant across its commands: the vendor session id when the tool declares
  one (claude, codex today), otherwise the harness process found by executable
  name among the command's ancestors, keyed on pid plus start time. The UUID
  is derived from the key, the label is `<tool>-<first 8 hex>`, the session is
  told its name once on stderr, and the identity is passed on through
  `BASHY_INSTANCE`. Off by default; `BASHY_ADHOC_IDENTITY=off` keeps the old
  refusal. Unowned ad hoc instances older than a day are retired when a new
  one opens, and a family at its cap gives up its oldest unowned one.
- bashy `096b1744`: turns it on for `bashy mb` and `bashy inbox`, and lets the
  unread hint borrow it for its lookup only; yoke pins.

Decisions that differ from the story text:

- Scope is narrower than "every bashy yoke verb resolves identity": the
  identity is granted only on messaging surfaces. An existing test
  (`TestAgentSessionUnderSharedAccountIsItsOwnPrincipal`, yoke `pkg/meet`)
  requires an unnamed agent to stay refused where a meeting grants authority;
  the first cut broke it, so the identity became opt-in per surface.
- The notice repeats per new arrival, as the existing hint does, not once a
  minute.
- When neither a vendor session id nor a harness ancestor is found, the old
  refusal and its guidance stand.

Evidence, fresh runs on the Windows test host (WSL lane), `GOWORK=off`:
yoke at `d5e2b267`: `go test ./pkg/bus ./pkg/room ./pkg/principal ./pkg/meet
./pkg/fleet ./pkg/chat`, all ok; `go vet ./pkg/bus` for linux, windows and
darwin, clean. bashy at the delivered tree: `go test ./internal/agentos -run`
the unread-hint, inbox-hook, wiring and shortcut tests, ok
(`TestUnreadHintReachesANativeAgentSession` passes); `go test ./mb` and the
identity-related `./inbox` tests in the nested yoke module, ok.

Not run: a live two-session exchange between a native CLI session and another
agent with an installed build, and full package suites. Known limits: a
harness whose process name is not the tool or its declared binary (a CLI
running under a generic runtime) and that declares no session id gets no ad
hoc identity; subagents inside one tool process share one identity; a session
that only reads can lose an unowned instance to the cap or the one-day sweep
and is then given a new name.
