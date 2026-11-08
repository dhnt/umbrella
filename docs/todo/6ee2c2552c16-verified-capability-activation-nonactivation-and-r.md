---
id: 6ee2c2552c16
kind: test
title: Verified capability activation, nonactivation and rollback
seq: 56
status: done
priority: p1
created: 2026-11-08T10:09:32.601833Z
assignee: opencode-deepseek-v4-pro
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:35.924431Z
closed_by: s595-manager
---

Split from caac5708 (part d). Prove the acquire/verify/retain loop: a capability registered or learned by a harness is discoverable with provenance and applicability only after verification passes; failed verification leaves it inactive and rolls back; retries are bounded; released recovery controls preserved. Acceptance: regression coverage for pass, fail-nonactivation and rollback paths using existing commands add / skill learn mechanisms.
