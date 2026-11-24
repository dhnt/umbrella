---
id: b5adee105b13
kind: feature
title: 'H1 bashy mcp serve --hosted: per-call master-signed identity, scratch home, timeout, output cap, no shell sessions, caller as principal'
seq: 663
status: assigned
priority: p1
labels:
    - bashy-hosting
    - mcp
created: 2026-11-23T13:18:03.953357Z
weave: 232
assignee: claude-fable5.2
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Staffing 2026-11-24: claude (reassigned from codex; the seam is the Sprint 697 A3 site profile in bashy/internal/agentos/mcp.go, add --hosted as a third profile beside outpost and site). Start from current heads.

Planned vendor: codex. Core (bashy internal/agentos + yoke/mcp), medium. HTTP only; each request carries a master-signed, versioned, short-TTL per-call identity (caller, task_id, idempotency_key, secrets_token) verified the way --outpost does (mcp_outpost.go pattern: 0600 runner key re-read per request, loopback only, fail closed, nonce cache against replay); fresh BASHY_HOME/scratch per call removed after; timeout; --max-output; shell_open/exec/close absent from tools/list; bashy.principal = caller in the audit line; effect policy unchanged (destroy/spend/cred/priv answer {state: gated}). Accept: tests for valid, expired, replayed and unsigned identity; scratch gone after the call; session tools absent; principal in audit; run_tool echo round-trips; a destroy verb answers gated. Spec: docs/sprint-691-master-execution-plan.md

## Delivery 2026-11-24 (claude)

Code: bashy `110f9ceb` on branch `agent/weave-issue-232` (parent `532a316a`, the
origin head at start; yoke at its origin head `25ec97b5`, unchanged). The bashy
commit is not pushed: the umbrella pin in this branch names it and the
conductor pushes bashy before merging the pin. No yoke change was needed: the
profile builds one server per request, so the policy, audit line and scratch
home are bound to the verified caller without a new yoke hook.

Wire and behavior: `bashy/docs/mcp-server.md`, section "Hosted runner".

Acceptance, all in `bashy/internal/agentos/mcp_hosted_test.go` (fresh run,
dev box, `go test -run TestMCPHosted ./internal/agentos`: ok):

- valid, unsigned, expired identity (plus wrong key, tampered, over-long,
  future-dated, incomplete, duplicate header, non-loopback, public or short or
  missing key file): `TestMCPHostedIdentity`; 401 over HTTP in `TestMCPHostedServe`.
- replayed identity answers `{state: replayed}`; scratch gone after the call;
  session tools absent from `tools/list`; principal in the audit line;
  `run_tool echo` round-trips; `run_tool rm` answers gated with `destroy`:
  `TestMCPHostedServe`.
- timeout (exit 124) and `--max-output`: `TestMCPHostedLimits`. Flag
  validation: `TestMCPHostedFlags`.
- Smoke with a built binary over curl on the dev box: 401 unsigned; 68 tools,
  no `shell_*`; echo, replay, gated, timeout and audit as above; about 25 ms
  per request to build the server, about 75 ms for an executing call.

Regression: `go test -run 'MCP|Mcp|Gateway|Site|Audit' ./internal/agentos` ok;
`go vet` ok; Windows cross-build of `cmd/bashy` ok; `yoke/mcp` tests ok.

Not passing, and not caused by this story: the whole `internal/agentos`
package run on the dev box hit the default 10-minute `go test` limit and
reported four failures. Each fails the same way at the parent commit
`532a316a` with this change absent (fresh runs, same box):

- `TestEmbeddedAdaptersMatchSourceTree`: embedded adapters drifted from the
  example sources (needs `go generate ./internal/agentos/adapterembed`).
- `TestCommonOptionsVocabularyReport`: `fetch -A/--user-agent` is not in the
  reviewed short-option baseline.
- `TestReleaseSbomCLI`: the license gate reports `yoke/pkg/provider` as unknown.
- `TestPilotCatalogDispatchE2E`: the slot store is empty after a cold dispatch.

Class: pre-existing at the pin bump, product or test data outside this story;
left untouched for their owners. The sealed gates (`bashy dag test`,
`test-bash-gate`) were not run here: heavy suites belong on the test host.

Open for the next stories:

- H2: the call's child env carries `BASHY_SECRETS_TOKEN`; the seam is
  `mcpHostedCall.exec`. The H2 owner plans to scope the token to vault-aware
  paths and will change that one line and its test assertion.
- H3: a gated hosted call answers `gated` and nothing here executes it after
  the caller settles; the wire for carrying that settlement to the runner is
  H3's. The replay cache is in-process, so the master's record is the durable one.
- H4: every call starts with empty caches. Built-in commands cost about 55 ms
  cold; a command bashy provisions on demand downloads again on every call, so
  the image should pre-provision what it serves and mount it read-only
  (`BASHY_COMMANDS_PATH` already passes the runner's registered commands through).

Merged 2026-11-24 by the conductor: bashy 5d160655 (cherry-pick of 110f9ceb onto docs-only main commits; code unchanged from the tested parent). Pre-existing agentos failures tracked as bashy todo 221aa363.
