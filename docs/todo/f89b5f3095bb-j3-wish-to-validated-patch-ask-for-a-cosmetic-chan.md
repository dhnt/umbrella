---
id: f89b5f3095bb
kind: feature
title: 'J3 Wish to validated patch: ask for a cosmetic change in words, over the pooled route'
seq: 314
status: done
priority: p1
labels:
    - software-shaping
    - desktop
created: 2026-11-15T02:57:50.501846Z
assignee: claude-opus5.5-s641
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the try-now showcase — a visitor shapes ai.dhnt.io inside the owner''s declared boundary, proven Red-Green-Refactor'
closed: 2026-11-19T15:06:56.314225Z
closed_by: claude-opus5.5-s641
---

The AI layer on top of J2, and deliberately thin: the wish box is a convenience over the deterministic setters, never the only door.

Scope: the wish box on the desktop sends the sentence, the schema and the current document to the pooled /v1/ route and gets back a PATCH against the declared schema; the patch is validated server-side (type, enum, range, known tile ids) and that validation IS the verifier at this rung; a patch that does not validate is refused WITH THE REASON and nothing partial applies; an applied patch becomes a numbered revision carrying its wish text, so undo and history are the ones J2 already built. Same verb names rung 3 uses (wish, apply, undo, history) so the ladder is one vocabulary.

When the pool is unavailable the rung degrades to the plain settings of J2 and says so — never a silent fallback, never a greyed-out box with no reason.

Acceptance: three ordinary sentences produce the expected patches; a sentence asking for something outside the schema is refused naming what it asked for; a malformed patch applies nothing; with the pool down the settings still work and the box states why it cannot; the allowance from M6 is decremented and shown, including for a refused wish (the model call happened).
