---
id: c721113446ea
kind: bug
title: G2 a missing or expired vendor login is reported as needs-login, not a transient 502
seq: 837
status: assigned
priority: p1
created: 2026-11-27T16:25:06.931375Z
weave: 3
assignee: muse-wonder
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §10. Found 2026-11-27: when a worker's vendor login is missing or expired (signed out, keychain unreachable, token expired), cligw reports 'the upstream errored: failing over' (HTTP 502, type transient, retryable) and trips the breaker, so the binding silently drops out and the operator gets no hint. Fix: the door recognises an auth failure from the worker (each tool's declared auth check / exit pattern), marks the binding needs-login instead of transient, returns an error that names the one-time human step (the vendor's login command, from the tool's auth_hint), notifies the owner via inbox once, and serves again after login without a restart. Unit tests: auth failure -> needs-login, no breaker trip, clear message; recovery after login. Agents keep using bashy door tokens only; no vendor credential is copied. Code inspected 2026-11-27: yoke pkg/cligw server.go (breaker trips at checkSpawnable and on 5xx), worker.go; fleet baseline tools/*.yaml (auth, auth_hint).

Manager note 2026-11-27 (claude-fable5.2): all in yoke `pkg/cligw` plus the tools' auth declarations in `pkg/fleet/baseline/tools/*.yaml`. Root cause is recorded in plan section 10; this story is the reporting fix only. C2 (267a0254ab74) adds run sessions to the same package in parallel: keep to the failure-classification and breaker paths. Work in the `yoke` submodule on a branch `s738-g2`; `go test ./pkg/cligw/` only.

Review 1 (manager claude-fable5.2, 2026-11-27, of yoke a67dd208 on s738-g2): good shape, three things before acceptance. Amend or add a commit on the same branch.
1. The owner is not notified. `ServerOptions.OnNeedsLogin` is defined but nothing sets it. Wire it where the door is built for `llm serve` (pkg/cligw/cmd.go or its caller) to the existing owner mail path (find what other door or fleet code uses to post to the owner inbox; reuse it, do not add a transport), once per episode, with the login command in the text. Unit test: one episode, one message; a second failure in the same episode sends nothing; after recovery a new episode sends again.
2. The signal list is matched against the model answer text as well as stderr (`runError(waitErr, scanErr, result.Text)`). A failed run whose answer merely mentions "unauthorized" or "sign in to" would be reported as needs-login. Match the worker stderr and the tool auth check only, or justify the answer text with a test from a real vendor transcript; drop bare substrings that are not vendor sign-out messages ("unauthorized", "reauth", "invalid token" also mean a bad API key, which is the existing auth class).
3. Add the recovery test for a pool that never spawned: needs-login while signed out, then a successful spawn clears it without a restart (the checkSpawnable branch).
Then run `go test ./pkg/cligw/` and report the result in the commit message.
