---
id: 712cbab264f1
kind: test
title: P2 Specify gateway acceptance scenarios for Claude clients
seq: 334
status: todo
priority: p2
labels:
    - software-shaping
    - claude-integration
created: 2026-11-15T13:12:33.304363Z
sprint: 643
sprint_id: b3afcef3-bce0-5e7f-bbe0-400e1c629958
sprint_title: 'Claude clients to the full stack: one Cloudbox remote MCP gateway for web, desktop, mobile and remote machines'
---

## Scope
Specify acceptance scenarios for the gateway; specify, not run.

## Scenarios
- Carried from Sprint 642: a permitted user completes the shaping lifecycle; an unauthorized user is refused; failed verification prevents activation; approval binds to the reviewed candidate; repeated submission does not duplicate execution; a disconnected client retrieves the same task; an offline host reports an honest state; cancellation has a recorded outcome; ownership transfer never leaves two coordinators; results distinguish asserted from verified success.
- Claude-specific: the same task is visible from web, mobile and a remote Claude Code CLI; the OAuth connect from Anthropic's cloud succeeds; a headless bearer client is refused outside its scopes; revoking either auth mode stops access immediately; a Free-plan single connector reaches every host of the user; neither a chat "yes" nor an MCP App approval bypasses Cloudbox-side approval.

## Done when
Each scenario has preconditions, steps, expected evidence and venue. Running them is implementation-phase work.
