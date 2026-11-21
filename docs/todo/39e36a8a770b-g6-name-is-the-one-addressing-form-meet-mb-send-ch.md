---
id: 39e36a8a770b
kind: feature
title: 'G6 @NAME is the one addressing form: meet, mb send, chat steer and item comments resolve through the roster'
seq: 583
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:49:22.347276Z
---

Three layers, kept separate: the address (@NAME), the resolver (one roster: human members, their assigned agents from G5 seen through presence, and local bindings from bashy agent list), and the carrier chosen by locality (the local room or chat session when the recipient is on this host; the cloudbox shared session or herald when it is on another outpost; Sprint 685 X1 owns the remote carriers). meet already accepts @name lines and @all; extend the same form to mb send (accept @NAME where a bare name works), chat steer (@NAME resolves to the live session instead of a session id), and comments on a shared item (G2/G3). The sender never picks the carrier. An unknown @NAME is refused with the nearest roster matches. Unit tests on the resolver; one CLI test per verb. Contract: G1, docs/plan-group-participation.md.
