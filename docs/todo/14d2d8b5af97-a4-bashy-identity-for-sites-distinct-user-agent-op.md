---
id: 14d2d8b5af97
kind: feature
title: 'A4 bashy identity for sites: distinct user agent + optional signed requests (Web Bot Auth shape, outpost key); site-side verification; MCP auth as the reliable cooperative-agent signal'
seq: 675
status: todo
priority: p2
created: 2026-11-23T13:51:46.069345Z
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 2 (identity). bashy fetch and the site verbs send a stable user agent and, when the owner enables it, sign requests with the outpost identity in the HTTP Message Signatures (RFC 9421) Web Bot Auth shape with a public key directory; the template verifies signatures and may unlock agent-only affordances for verified bashy agents only; the MCP endpoint's authentication is the primary signal. Detection never gates content (no cloaking).
