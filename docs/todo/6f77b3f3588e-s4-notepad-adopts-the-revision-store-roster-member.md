---
id: 6f77b3f3588e
kind: feature
title: S4 Notepad adopts the revision store; roster members and named guests co-edit; export a named revision
seq: 572
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-20T21:08:47.186002Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

After S2. Notepad uses the kit revision store (S1) for the note body: notepad history ID, undo ID, restore ID REV, set --base-rev, export --rev N --to pdf. The group model is the one Klatch and Page already use: a roster member is admitted by the outpost-signed owner/member stamp; a guest joins by the owner's invite and gives a name or email first; an outsider is refused. To keep one copy, Page's join code (stamp check, name prompt, cookie binding, in examples/desk/page/identity.go) moves into the kit unchanged and Notepad uses it. No viewer/editor role, no merge. Author and kind (member, signed-in, anonymous) are recorded on each revision. Unit tests (httptest) with owner, member, named guest, outsider and a bad signature: stale save 409 with both revisions, undo, restore, guest without a name refused, export of a named revision; Page tests stay green. The live two-member run is Sprint 699 story I1. 5 points. Plan: docs/sprint-684-685-master-execution-plan.md.
