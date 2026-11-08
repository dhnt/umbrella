---
id: d2218fd33222
kind: feature
title: Machine-readable capability recommendation record
seq: 54
status: done
priority: p1
created: 2026-11-08T10:09:32.314694Z
assignee: claude-sonnet5.5
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
closed: 2026-11-08T17:58:34.888455Z
closed_by: s595-manager
---

Split from caac5708 (part b). One versioned structured record for registration/shaping recommendations: reason, evidence, next command and argument vector, prerequisites, verification method, authorization requirement, and executable-step vs proposal distinction. Extension order: existing composition, declarative configuration/adapter, execution-verified learned skill, then shaped implementation. Acceptance: schema documented and versioned; emitted by the hints in the point-of-need story under --json; schema regression tests.
