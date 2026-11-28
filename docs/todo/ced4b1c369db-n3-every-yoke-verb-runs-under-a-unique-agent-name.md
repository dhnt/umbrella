---
id: ced4b1c369db
kind: task
title: N3 every yoke verb runs under a unique agent name and id, never the bare tool name
seq: 861
status: assigned
created: 2026-11-28T09:51:01.597893Z
assignee: claude-fable5.2
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
---

Problem: N2 grants the ad hoc identity only on messaging (mb, inbox, the unread hint). Every other yoke verb called from a native agent session still records the bare tool name: principal.Resolver.Self falls back to the detected tool, so for example a resource claim is held by 'claude' and two sessions of one tool are indistinguishable.
Rule (operator, 11-28): a unique agent name plus id is required for any yoke command, e.g. bashy claim.
Behavior:
1. One resolution at the front door. Before any yoke or registered verb runs, bashy resolves the caller once (declared name, else the N2 ad hoc identity) and stamps it on the process, so both resolvers (bus.BoardIdentity / ResolveAuthoredActor and principal.Resolver.Self) and every child see the same instance. N2's per-surface switch and the borrow-and-restore in the unread hint go away.
2. No tool-name fallback. An agent session that cannot be resolved (no declared name, no vendor session id, no harness ancestor) is refused with one message saying an agent id is required and how to give one (BASHY_AGENT). It is never recorded as the bare tool.
3. Authority is unchanged in substance: having a name is not having a right. A meeting, a sprint or a claim still decides by its own rules whether that name may act. The yoke meet test that expects an unnamed harness to be refused at the identity step is rewritten to expect refusal at the authority step.
4. Humans, scripts and automation with no agent harness are untouched, and the bash and Bash# interpreter and the utilities never run this step.
Not in MVP: renaming holders already recorded as a bare tool name; subagents sharing one tool process.
Code inspected: yoke pkg/principal/resolve.go (Resolver.Self, DetectTool fallback), pkg/bus/adhoc.go, pkg/meet/adopt_api.go (callerPrincipal); bashy internal/agentos/agentos.go (dispatchWithContext), nudge.go. Not yet inspected: each verb's own holder or owner resolution (claim, todo, weave, sprint, handoff); list them first and confirm they go through one of the two resolvers.
Verification: unit tests for the front-door stamp, the refusal, one verb per resolver (a claim holder is the ad hoc label), and the rewritten meet test.

## On hold (operator, 2026-11-28)

Not started, and not to be started without a new go-ahead. The tools already
work for an agent that is told to use them and to name itself; the gap worth
closing is only that an agent should not need to be told: it should learn its
name and the inbox the first time it uses a bashy tool. N2 covers that for
messaging. Requiring an identity on every yoke verb, and refusing a session
that cannot be resolved, is a tightening nobody asked for yet.

## Off hold, and delivery (2026-11-28)

Operator, same day: do both. Correct the session where bashy can (name it),
and refuse with a guiding message where it cannot. A silent bare tool name is
the thing to remove.

- yoke `4b756baa`: `bus.StampAdHocIdentity`. A native session that declared
  nothing and can be identified is given its ad hoc instance and the process
  is stamped as a launcher stamps a session it starts (`BASHY_INSTANCE`, its
  UUID, family and label, and `BASHY_AGENT` = the label). One that cannot be
  identified returns `ErrAgentIDRequired`; `AgentIDGuidance` says how to name
  it.
- bashy `e48a1832`: `agentIdentityGate` runs once in the front-door dispatch
  before any verb. Identifiable: stamped, told its name once, the verb and its
  children run as that agent. Not identifiable: refused on a coordination verb
  (mb, inbox, notify, meet, claim, sprint, todo, weave, handoff, resume,
  delegate, coach, foreman, supervise, ask, bus, feed, herald, activity).

Decisions that differ from the story text:

- The refusal covers the coordination verbs, not every yoke verb. Build,
  lookup and help verbs (dag, kb, skill, commands, the tool passthroughs) and
  the two verbs that fix the problem (agent, instance) still run for a session
  nobody can name; refusing those would stop it reading how to name itself.
- A session that set any name for itself, even one registered nowhere, is left
  as it is.
- No yoke meet change was needed: the stamp happens in bashy before the verb,
  so the yoke-level rule (an unnamed harness is unattributed) and its test
  stand. The N2 per-surface switch stays as a second line for an adapter run
  on its own.
- A full instance store (the per-tool cap with nothing to retire) does not
  refuse: the session runs unnamed as before.

Evidence, fresh runs on the Windows test host (WSL lane), `GOWORK=off`:
yoke at `4b756baa`: `go test ./pkg/bus ./pkg/principal ./pkg/meet`, ok;
`go vet ./pkg/bus` for linux, windows and darwin, clean. bashy at the
delivered tree: `go vet ./internal/agentos` for linux and windows, clean;
`go test ./internal/agentos -run` the identity-gate, unread-hint, inbox-hook,
wiring, shortcut, claim, dispatch, front-door and principal tests, ok.

Not run: a built binary driven from a real native session (for example a
claim taken with no declared name and read back from the claim list), the
tagged e2e dispatch test, and full suites. Known limits: a CLI running under
a generic runtime with no session id cannot be identified and is refused on
coordination verbs until it sets `BASHY_AGENT`; holders already recorded as a
bare tool name are not renamed.
