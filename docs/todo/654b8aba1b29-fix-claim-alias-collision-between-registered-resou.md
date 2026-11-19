---
id: 654b8aba1b29
kind: bug
title: Fix claim alias collision between registered resource and host member
seq: 523
status: done
priority: p0
created: 2026-11-19T10:31:19.589298Z
assignee: s666-codex-manager
sprint: 666
sprint_id: edd13140-c9a6-59d5-ad89-9cd59626ea58
sprint_title: Human–agent group productivity and fleet autonomy
closed: 2026-11-19T13:07:32.678587Z
closed_by: s666-codex-manager
---

Audit reproduced a registered host resource lease bypass by an explicit same-named host claim. The effective kind is used for logical conflict matching, while the original resource address must identify the persisted ledger record and attached lock. A storage-key comparison mistakenly skipped a different physical record; attached release also targeted the wrong key. Bounded regression covers lease and attached exclusion in both directions and cleanup preserving an independent same-holder record. Audit patch contributed by s666-claim-audit, integrated and independently reviewed by sprint manager; exact native gate pending. No live host mutation for reproduction. S10 green closure remains held until final verification.
