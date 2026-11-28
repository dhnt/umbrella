---
id: 49ae75a9a181
kind: feature
title: 'M1 one-shot model and agent tool calls: bashy llm call and bashy agent call, typed in bashy mcp tools (request/response)'
seq: 858
status: assigned
priority: p1
created: 2026-11-28T06:33:13.706984Z
weave: 8
assignee: claude-fable5.2
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Tools as a service (TaaS): offer a model, tool, agent or designated folder to your trusted group as a metered, typed tool call'
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 M1. Operator 2026-11-27 night: the bashy CLI calls any LLM and any agent as a one-shot tool call, request in, response out; that is the same typed call a Model or Agent offer serves.

Gap (code inspected 2026-11-27): no one-shot model call exists; bashy llm is the gateway (serve, pools, env, peer: yoke pkg/broker cmd.go:399,709, peercmd.go:26). A one-shot agent run exists, bashy chat --agent A --instruction ... --json --read-only (yoke pkg/chat chat.go:1231), but its bashy-chat-v1 Result (chat.go:205-221) carries no token usage, and neither call is a typed tool in bashy mcp tools.

Change: (1) bashy llm call [--model M|M@DOOR|--band L] [--system S] [--schema FILE] [--max-tokens N] PROMPT|- : one request through the door's existing inference route (broker.ResolveDoorModel, so a local model, a peer door or a member offer all work the same); returns a bashy-llm-call-v1 envelope {model, text, json (when --schema), usage {input, output}}. (2) bashy agent call AGENT|--band L|--capability C --task T [--file F] [--token-cap N] : a thin wrapper over the chat one-shot, read-only by default; returns {agent, output, exit_code, usage, capped}; chat's Result gains usage where the tool or the door reports it (acp.go already parses usage). (3) Both ship a typed tool definition (input schema, output shape, effects read-only, unit token), so they show as the typed tools llm and agent in bashy mcp tools for any local agent; K2 reuses these definitions for the Model and Agent offer classes.

Accept: unit tests: llm call against a fake door returns text and usage; --schema returns parsed json or a typed refusal; M@DOOR routes to the named door; agent call wraps a fake tool and reports usage; both appear typed in the MCP tool list with stable digests. Not in MVP: streaming, multi-turn sessions (that is bashy chat), tool use inside llm call, images.

Depends on nothing; wave 1. Repo: yoke pkg/broker, pkg/chat; bashy (verb mount).


Rescope (conductor, 2026-11-27 code check): bashy delegate (yoke pkg/chat delegate.go) is already the one-shot agent call and already has --max-tokens (a hard cap that refuses adapters which cannot enforce it) and --json. So there is NO new bashy agent call verb: the typed tool agent wraps bashy delegate --json [--max-tokens N]. Its bashy-chat-v1 Result gains usage {input, output} where the adapter reports it (omitted otherwise, never guessed). The model half is the new verb bashy llm call (subcommand of pkg/broker NewCmd, new file pkg/broker/llmcall.go), one non-streaming request to the local door's OpenAI-compatible route, or to DOOR for M@DOOR via broker.ResolveDoorModel. Typed tools: register llm (llm call) and agent (delegate) as typed MCP tools where bashy's built-in typed tools are declared (find it: yoke mcp direct.go / bashy internal/agentos cobra_schema.go); if that needs a bashy change, keep it to the registration and note it for the conductor's pin bump.
Worker rules (conductor claude-opus5.5, 2026-11-27; KISS/MVP):
- Read yoke/CLAUDE.md first. Work in the yoke submodule of your workspace on branch s739-m1, based on current origin main. Change only what this story's Accept needs; no refactors, no renames, no new dependencies.
- Tests: targeted unit tests for the packages you touch only, e.g. `cd yoke && GOWORK=off go test ./pkg/broker/ ./pkg/toolcmd/`. No full suites, no e2e, no network, no podman, no paid provider. Use fakes (httptest) for doors and agents.
- Commit in yoke with trailers: Sprint: #739 / Story: #858 / Story-ID: 49ae75a9a181 / Agent: <your agent name>. Do not push main, do not bump any pin, do not edit other repos except as the story says.
- Finish by appending a "Delivery" paragraph to this story file (files changed, test command and its result) and commit it in the umbrella workspace with the same trailers.
- Budget about 30 minutes. If blocked, write the blocker in the story, commit, and stop. Do not work around a failing pre-existing test: record it.
