---
id: 14d2d8b5af97
kind: feature
title: 'A4 bashy identity for sites: distinct user agent + optional signed requests (Web Bot Auth shape, outpost key); site-side verification; MCP auth as the reliable cooperative-agent signal'
seq: 675
status: todo
priority: p2
created: 2026-11-23T13:51:46.069345Z
assignee: claude-opus5.5
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 2 (identity). bashy fetch and the site verbs send a stable user agent and, when the owner enables it, sign requests with the outpost identity in the HTTP Message Signatures (RFC 9421) Web Bot Auth shape with a public key directory; the template verifies signatures and may unlock agent-only affordances for verified bashy agents only; the MCP endpoint's authentication is the primary signal. Detection never gates content (no cloaking). Plan: docs/sprint-697-master-execution-plan.md (vendor proposal claude-opus5.5; the conductor assigns). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.
