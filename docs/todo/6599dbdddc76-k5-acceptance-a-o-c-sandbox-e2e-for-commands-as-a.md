---
id: 6599dbdddc76
kind: test
title: 'K5 acceptance: A/O/C sandbox e2e for commands as a service (fake accounts, fake transcribe provider)'
seq: 833
status: todo
priority: p1
created: 2026-11-27T15:34:19.86828Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands as a service: offer bashy commands to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K5. Extend bashy dag test-group-shaping-e2e: C offers llm + transcribe to the circle; O (no LLM) shapes and A's wish runs on C's LLM; O runs bashy remote C -- transcribe in.wav and gets the artifact as a URI it streams; C shares a folder with the circle and A's agent lists/reads it in place (Range), non-member and path escape refused; non-member refused, revoke 401, limit 429; O offers to C (symmetry); the same audience rule admits a member's UI app use and their agent's command runs. Gate host only, minutes budget, no paid provider. Code inspected 2026-11-27: bashy tests/group-shaping-e2e README.md sandbox.py.
