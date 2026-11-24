---
id: 3d3ca7b1c6ca
kind: feature
title: 'S1 Desk-kit revision store: shaping''s revision model for an artifact (history, undo, restore, save against base_rev)'
seq: 578
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:42:54.820612Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

One small file, examples/desk/kit/revision.go, shaped like yoke/pkg/shape/slot/slot.go: immutable snapshots plus an active/previous pointer. Save(item, part, base_rev, author, assistant, data): a base_rev that is not the active revision is refused with both revisions; no base_rev is a recorded overwrite. Undo swaps active and previous; Restore selects any retained revision; History lists {revision, author, assistant, created} with active and previous. The app chooses the bytes and decides who may write; the store never checks roles or identity and never owns the item file (snapshots sit beside it). One shared action handler for history, undo and restore so an adopting app wires a few lines and gets the same JSON on page and CLI. The contract table (same words and JSON as bashy shape history|undo|restore) goes in the kit README. Tag the kit v0.2.0. No merge, no lock, no roles. Unit tests (GOWORK=off go test ./... in examples/desk/kit): save, stale base returns both, save without base, undo swaps, restore any, save after restore, history order, reload from disk. 3 points. Plan: docs/sprint-684-685-master-execution-plan.md.
