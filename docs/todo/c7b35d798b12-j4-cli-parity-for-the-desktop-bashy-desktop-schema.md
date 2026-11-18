---
id: c7b35d798b12
kind: feature
title: 'J4 CLI parity for the desktop: bashy desktop schema|get|set|wish|undo|history --json'
seq: 315
status: done
priority: p1
labels:
    - software-shaping
    - desktop
created: 2026-11-15T02:58:08.836164Z
assignee: claude-opus5.5-s641
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the try-now showcase — a visitor shapes ai.dhnt.io inside the owner''s declared boundary, proven Red-Green-Refactor'
closed: 2026-11-18T20:13:12.672006Z
closed_by: claude-opus5.5-s641
---

UI-to-CLI parity is one way: every action the desktop offers needs a CLI path, so an agent can do what a person can and the guide can always answer 'and this is the command'.

Scope: bashy desktop schema (the declared properties and their types), get (the resolved document and where each value came from), set (one property, --dry-run), wish (the J3 path, --json), undo, history. Deterministic JSON, exit 0/3/1, no new core package if an existing one fits; the flow that composes them is a Bash# skill-script in examples/, not a core verb.

Acceptance: every J2 and J3 operation has a CLI equivalent with identical rules and output; --dry-run on set changes nothing; the skill-script walks a person from 'show me what I can change' to 'change it and undo it'; parity rows recorded.
