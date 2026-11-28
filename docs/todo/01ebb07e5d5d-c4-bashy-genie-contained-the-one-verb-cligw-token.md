---
id: 01ebb07e5d5d
kind: feature
title: 'C4 bashy genie --contained: the one verb (cligw token + sandbox + genie)'
seq: 824
status: done
priority: p1
created: 2026-11-27T14:25:10.247637Z
assignee: codex-gpt6.2-astra
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
closed: 2026-11-28T00:54:16.420403Z
closed_by: claude-fable5.2
---

Plan: docs/sprint-738-master-execution-plan.md §3 C4. bashy genie --contained [-m BINDING|BAND] [--dir DIR] TASK: ensures the cligw door, issues a C2 token, starts genie in the C3 backend with OPENAI_BASE_URL/KEY set to the session socket and token, records the run (binding, band, token scope, sandbox, exit), revokes the token. The sandbox never sees HOME, the vault, vendor config or the keychain. Genie bundle via genie build if no release. Command doc updated. Code inspected 2026-11-27: bashy internal/agentos/door.go, genie*.go; bashy genie --help.

Manager note 2026-11-27 (claude-fable5.2): build to Seam C in docs/sprint-738-master-execution-plan.md section 11, against Seams A and B as written there (C2 and C3 are being built in parallel; call them as commands, `bashy llm session …` and `bashy contain --dir …`, so you depend only on their command lines). Unit-test the composition with fakes for both commands (argv built, the five genie variables, close on every exit path including a signal, refusal texts). Work in the `bashy` submodule on a branch `s738-c4`; do not edit `contain*.go` (C3 owns them). Command doc for `--contained` updated. `go test ./internal/agentos/ -run Genie` only.

Review 1 (manager claude-fable5.2, 2026-11-27, of bashy 8fc9d4b2): the composition is right. One seam change from the C3 review: host loopback must not be open inside the sandbox, so `bashy contain` gains `--loopback PORT` (C3 implements it; only that loopback port is usable inside). Add a commit on s738-c4: (1) before starting the sandbox, pick a free loopback port on the host (listen on 127.0.0.1:0, read the port, close); pass `--loopback PORT` to `bashy contain` and pass the port to the launcher, which starts `llm session forward --socket SOCK --listen 127.0.0.1:PORT`; the endpoint check then requires that exact port. (2) The run token reaches the sandbox only as OPENAI_API_KEY (already so); state that in the command doc as the one secret inside. (3) Unit tests for the new argv and the port check. `go test ./internal/agentos/ -run Genie`.

Review 1, addition (manager, from the first gate-lane e2e run, 2026-11-27): inside the sandbox `bashy llm session forward` cannot run. `llm` is a thin-core adapter built on first use under the user's cache ("bashy llm: adapter yoke/llm/llm.bsh not found" in the container), and the sandbox has no home, cache or toolchain. Everything that runs INSIDE the sandbox must be in the bashy core binary. So the launcher (`genie --session-launcher`) does the forwarding itself, in process: an `httputil.ReverseProxy` listening on 127.0.0.1:PORT whose transport dials the unix socket; no `bashy llm` call inside the sandbox. The host side (`llm session open` / `close`) is unchanged. Also check that everything else the launcher runs inside (`bashy run --target chat BUNDLE`, the session read) is core and needs no adapter, cache or network; say what you verified. Unit test: the in-process forwarder relays a request and the bearer header to a unix-socket test server.
