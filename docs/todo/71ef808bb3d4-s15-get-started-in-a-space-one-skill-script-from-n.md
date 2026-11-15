---
id: 71ef808bb3d4
kind: feature
title: 'S15 Get started in a space: one skill-script from nothing to working (person or agent)'
seq: 308
status: todo
priority: p1
labels:
    - software-shaping
    - trove
created: 2026-11-15T02:03:41.551995Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Operator framing 2026-11-14: the space is where an agentic tool lands and starts work, the way a coding agent starts in a fresh checkout today — but for every bashy user, not only developers.

Scope: one Bash# skill-script in examples/ with an embedded skill and --json verbs that, from nothing: creates the person's space, mounts the store they name (M1), puts the shaped app they came for in reach, and prints the two or three commands that follow. Idempotent; re-running on an existing space reports and changes nothing. An agent reads the same skill and works unattended; a person reads the same words.

Acceptance: from an empty home, one command yields a usable space with a GitHub-backed mount and a registered shaped app; the second run is a no-op with a stated reason; --json at every step; no new core verb.
