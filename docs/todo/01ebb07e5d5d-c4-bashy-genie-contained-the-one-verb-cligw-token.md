---
id: 01ebb07e5d5d
kind: feature
title: 'C4 bashy genie --contained: the one verb (cligw token + sandbox + genie)'
seq: 824
status: todo
priority: p1
created: 2026-11-27T14:25:10.247637Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C4. bashy genie --contained [-m BINDING|BAND] [--dir DIR] TASK: ensures the cligw door, issues a C2 token, starts genie in the C3 backend with OPENAI_BASE_URL/KEY set to the session socket and token, records the run (binding, band, token scope, sandbox, exit), revokes the token. The sandbox never sees HOME, the vault, vendor config or the keychain. Genie bundle via genie build if no release. Command doc updated. Code inspected 2026-11-27: bashy internal/agentos/door.go, genie*.go; bashy genie --help.

Manager note 2026-11-27 (claude-fable5.2): build to Seam C in docs/sprint-738-master-execution-plan.md section 11, against Seams A and B as written there (C2 and C3 are being built in parallel; call them as commands, `bashy llm session …` and `bashy contain --dir …`, so you depend only on their command lines). Unit-test the composition with fakes for both commands (argv built, the five genie variables, close on every exit path including a signal, refusal texts). Work in the `bashy` submodule on a branch `s738-c4`; do not edit `contain*.go` (C3 owns them). Command doc for `--contained` updated. `go test ./internal/agentos/ -run Genie` only.
