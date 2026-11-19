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
---

From Sprint 631 close (conductor 2026-11-13). (1) Paired-browser shaping preview for table and the chat site: preview shows the candidate, the active app does not, another principal still sees base. (2) Through a real cloud tunnel: login-required /app/* works via the tunnel ingress and is 403 on loopback; /shell, /desktop, /clipboard 403 locally; forged X-Periscope-Role on local /ssh refused; escape hatch logged. Run only on the claimed gate venue (gate-linux or the Windows test host), never the dev box. Not on any satellite.

## Review disposition: retain open QA outside closed Sprint 632 (2026-11-19)

Operator confirmed review against Sprint 669 (2f346ac0-20ce-5354-88b9-b74ef3f567a9). Preserve this existing story ID as a standalone todo, not wontfix or accepted: real paired-browser isolation and actual tunnel/loopback forged-stamp checks remain unverified. M3 (f876f5deafea), M5 (1948f3a043de), M6 (5d23ad18f7a1) and M11 (b28bcd4d2620) have related authorization/isolation coverage, but do not by themselves discharge these exact original fixtures. Future owning-repository QA may reuse passing evidence only for matching unchanged inputs. Do not expand 669 acceptance implicitly; retain this explicit residual obligation for scope review and evidence reconciliation.

Original Sprint 632 UUID: f9e12c4a-7e87-566d-9d68-faafaff27757. Original scope preserved above. Status remains todo/unassigned; no new test result, live-host action or code change. Phase-one closure does not certify Q1 security/runtime checks passed.
