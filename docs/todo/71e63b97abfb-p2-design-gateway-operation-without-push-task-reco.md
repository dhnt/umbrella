---
id: 71e63b97abfb
kind: feature
title: 'P2 Design gateway operation without push: task recovery, Sprint 620 alerts, future MCP Events'
seq: 332
status: todo
priority: p2
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:33.008856Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Scope
Design operation without push to Claude; design only.

## Requirements to design
- No Claude client supports MCP Events yet (anthropics/claude-code#101434). Long work runs on our side under its owner; clients recover by task id from any client or machine (start on mobile, check from a remote CLI).
- Out-of-band completion, blocker and approval notices go through the Sprint 620 channels (docs/comms-strategy.md, webhook ingress C8 cd9d0870e0a2); do not duplicate that work.
- For Claude Code scheduled tasks, document the API /fire trigger as the event path into Claude.
- Keep MCP Events (Standard Webhooks, signed callbacks, subscription refresh) as the future path, shared with Sprint 642 where ChatGPT already supports it (spec still draft as of 2026-11-15).
- New since filing: Claude Code channels (research preview, code.claude.com/docs/en/channels-reference) — a local stdio MCP server pushes events into an interactive Claude Code session and can relay permission prompts to a remote approver. Evaluate an outpost/bashy channel plugin as the near-term event path for interactive Claude Code sessions, with its limits recorded: custom channels need the dev flag or an org `allowedChannelPlugins` entry, are ignored in `-p`/Agent SDK headless mode, and reach only Claude Code on a machine — claude.ai web and mobile still have no push, so task-id recovery remains the baseline there.

## Done when
Recovery, notification and future-events paths are documented with dependencies. No implementation.
