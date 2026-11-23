---
id: 476e23cbd1bb
kind: feature
title: 'P0 roles and views: the organizer sees both faces of a dual-view block, participants only theirs'
seq: 661
status: todo
priority: p0
labels:
    - page
    - software-shaping
created: 2026-11-23T12:01:49.892116Z
sprint: 696
---

Block kinds declare their faces (organizer, participant, display). Native adapters carry both the owner-keyed API (results, open/close, phase, assign turn) and the participant path; embed blocks carry two URLs, the private one with the engine's facilitator fragment or key. The organizer (page owner) sees dual-view blocks side by side on a wide screen or as tabs Organizer / Participant / Display; participants and viewers get only their face, and the organizer face, its controls and the sibling's facilitator key are never in their HTML, state or export. Page-level 'view as participant' toggle renders the whole page as a participant sees it with a throwaway identity. ?view=display is the projector face (organizer's chosen blocks, large type, no controls). Owner keys of embedded items live in the page store under the organizer's key, never shown by show or export. Proof: brainstorm (facilitator panel + board) and demo-queue (organizer + projector) as embeds, form (results + respondent) as a native; a participant fetch of the page HTML, state and export contains no organizer face and no key. Spec: docs/page-live-group-page.md.
