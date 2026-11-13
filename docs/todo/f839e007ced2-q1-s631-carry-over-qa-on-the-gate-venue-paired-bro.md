---
id: f839e007ced2
kind: test
title: 'Q1 S631 carry-over QA on the gate venue: paired-browser preview assertions (S6 table, S9b chat) and live-tunnel e2e of the outpost ingress hardening (S2a, S2d)'
seq: 233
status: todo
priority: p3
labels:
    - qa
created: 2026-11-13T15:05:57.0985Z
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
---

From Sprint 631 close (conductor 2026-11-13). (1) Paired-browser shaping preview for table and the chat site: preview shows the candidate, the active app does not, another principal still sees base. (2) Through a real cloud tunnel: login-required /app/* works via the tunnel ingress and is 403 on loopback; /shell, /desktop, /clipboard 403 locally; forged X-Periscope-Role on local /ssh refused; escape hatch logged. Run only on the claimed gate venue (gate-linux or the Windows test host), never the dev box. Not on any satellite.
