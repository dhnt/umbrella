---
id: 49ae75a9a181
kind: feature
title: 'M1 one-shot model and agent tool calls: bashy llm call and bashy agent call, typed in bashy mcp tools (request/response)'
seq: 858
status: todo
priority: p1
created: 2026-11-28T06:33:13.706984Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Tools as a service (TaaS): offer a model, tool, agent or designated folder to your trusted group as a metered, typed tool call'
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 M1. Operator 2026-11-27 night: the bashy CLI calls any LLM and any agent as a one-shot tool call, request in, response out; that is the same typed call a Model or Agent offer serves.

Gap (code inspected 2026-11-27): no one-shot model call exists; bashy llm is the gateway (serve, pools, env, peer: yoke pkg/broker cmd.go:399,709, peercmd.go:26). A one-shot agent run exists, bashy chat --agent A --instruction ... --json --read-only (yoke pkg/chat chat.go:1231), but its bashy-chat-v1 Result (chat.go:205-221) carries no token usage, and neither call is a typed tool in bashy mcp tools.

Change: (1) bashy llm call [--model M|M@DOOR|--band L] [--system S] [--schema FILE] [--max-tokens N] PROMPT|- : one request through the door's existing inference route (broker.ResolveDoorModel, so a local model, a peer door or a member offer all work the same); returns a bashy-llm-call-v1 envelope {model, text, json (when --schema), usage {input, output}}. (2) bashy agent call AGENT|--band L|--capability C --task T [--file F] [--token-cap N] : a thin wrapper over the chat one-shot, read-only by default; returns {agent, output, exit_code, usage, capped}; chat's Result gains usage where the tool or the door reports it (acp.go already parses usage). (3) Both ship a typed tool definition (input schema, output shape, effects read-only, unit token), so they show as the typed tools llm and agent in bashy mcp tools for any local agent; K2 reuses these definitions for the Model and Agent offer classes.

Accept: unit tests: llm call against a fake door returns text and usage; --schema returns parsed json or a typed refusal; M@DOOR routes to the named door; agent call wraps a fake tool and reports usage; both appear typed in the MCP tool list with stable digests. Not in MVP: streaming, multi-turn sessions (that is bashy chat), tool use inside llm call, images.

Depends on nothing; wave 1. Repo: yoke pkg/broker, pkg/chat; bashy (verb mount).
