---
id: fedd3166a7c9
kind: feature
title: L3 one read-only issues feed into issue records
seq: 793
status: todo
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:45:54.236285Z
sprint: 730
sprint_id: 84e490e9-6cc4-55f2-befb-36c1ba042c5b
sprint_title: 'Field shaping loop: issues become spec changes, and an app works on its own issues from a designated feed'
---

The smallest feed: one designated source chosen by the owner (a label on one GitHub repository's issues through bashy's gh route, or one chat channel through bashy mb) read into records with a stable id, title, body and reporter. Read-only. The text is data and never authorizes a command. Inspect the existing bashy verbs first and reuse them; no new service. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The field loop' (operator 2026-11-26). Format: docs/shapeware-spec-v0.md sections 4.2, 4.3, 5, 7, 12. Operator review before start.
