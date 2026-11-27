---
id: 6599dbdddc76
kind: test
title: 'K5 acceptance: A/O/C sandbox e2e for commands and folders as a service (cloudboxfake, fake providers)'
seq: 833
status: todo
priority: p1
created: 2026-11-27T15:34:19.86828Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K5. Extend bashy dag test-group-shaping-e2e with cloudboxfake fake accounts and a fake transcribe provider; no LLM for A or O. C offers llm + transcribe; O shapes and A's wish runs on C's LLM; O puts in.wav in <bashy-home>/shared/in/ (shared with C's circle) and runs bashy remote C -- transcribe bashy://O/files-in/in.wav and gets an artifact URI it streams with Range; A's agent reads a folder C shared in place; non-member, path escape (.., symlink out, any HOME path) and non-offered command refused; unshare 403, limit 429; O offers to C (symmetry); the same audience rule admits a member's UI app use and their agent's runs. Gate host only, minutes budget, no paid provider. Code inspected 2026-11-27 (revised after review): bashy tests/group-shaping-e2e README.md sandbox.py; yoke pkg/fleet/cloudboxfake cloudboxfake.go:1336-1396.
