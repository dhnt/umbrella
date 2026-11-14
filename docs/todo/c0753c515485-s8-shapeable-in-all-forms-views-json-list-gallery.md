---
id: c0753c515485
kind: feature
title: 'S8 shapeable in all forms: views.json (list|gallery|cards|timeline), presenters and source adapters as shaping hooks; shaped.json properties + Genie examples; wish/verify/approve/undo walkthrough'
seq: 297
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:53.476952Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: claude + glm. Example level. The trove is a STARTER every user shapes into their own form (software shaping applies to every bashy app): (1) views.json declares how the tree is shown (list, gallery, cards, timeline; columns, sort, grouping) and the explorer renders from it; (2) presenters/*.bsh + presenters.json (S2) declare how an entry is presented; (3) source adapters are recipes (scheme -> argv emitting bashy-node-v1 rows) a user can add; all three are shaped.json properties exposed to the Genie with examples (make the gallery the default, add a 'this week' timeline, add a presenter 'three bullets in Spanish', add a source). contract.bsh and checks/ protect the engine-facing parts. Walkthrough recorded: bashy shape wish|verify|preview|approve|undo on each hook as a member; the owner's view unchanged. Rod, not fish: small --json verbs with meaningful exit codes; any higher flow is a short Bash# skill-script composing them, itself shapeable. Accept: the Shapeable-with-Bashy checklist (bashy/docs/software-shaping.md) holds for trove; three shaped variants (view, presenter, adapter) verified and undone with evidence; every hook is a file or verb, never Go. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
