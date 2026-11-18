---
id: 9d7adcb33d61
kind: feature
title: J2 The desktop's cosmetic schema and property document, with plain settings and no model
seq: 313
status: done
priority: p1
labels:
    - software-shaping
    - desktop
created: 2026-11-15T02:57:50.362491Z
assignee: claude-opus5.5-s641
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: the try-now showcase — a visitor shapes ai.dhnt.io inside the owner''s declared boundary, proven Red-Green-Refactor'
closed: 2026-11-18T20:13:22.91848Z
closed_by: claude-opus5.5-s641
---

Rung 1 of docs/dhnt-journey-design.md, the half that needs no AI at all — and therefore the half that must work first.

Scope, KISS: a declared, versioned schema file with five or six typed properties (theme, density, tile order, which tiles show, their labels); a property document per ACCOUNT (email identity, never a browser or a device) holding that person's own layer; a resolver over an ORDERED LIST of layers, two entries for now (default, the person's own) so a satellite or host-local layer later is a new entry and not a redesign; an ordinary control in the interface and a --json setter for EVERY property, so the rung is fully usable and fully testable with no model call; numbered revisions with undo and history. A key the current schema does not understand is kept in the document, ignored at render and reported as unhonoured in --json — never deleted.

Hosted half (cloudbox, private): the document store and the additive endpoint — cloudbox todo fada4758. Public half: the schema format, the verbs (J4), the wire contract.

Acceptance: a person sets every declared property by hand and by CLI, the resolver explains where each value came from, undo and history work, an unknown key survives a schema version change, and nothing in this story calls a model.
