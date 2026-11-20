---
id: 6f77b3f3588e
kind: feature
title: Co-edit a document and export its shared revision to PDF
seq: 572
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:47.186002Z
sprint: 684
sprint_id: 23044574-ddc0-51fe-a579-805a07e99ee5
sprint_title: 'Group shaping rod: one shared-item contract for every bashy app, proven on Klatch and Notepad'
---

Proof two of the Sprint 684 rod: a shared artifact. Two editors edit one Notepad document under the shared-item contract (G1): every save is a revision with author; a save against a stale base is refused with both revisions, never merged silently; reopen shows the latest revision; history and revert via bashy and the page with the same JSON. A viewer sees the saved revision and cannot save. Export a named revision through the existing notepad export --to pdf and verify text from both authors. No live merge. Run the G4 skill-script against Notepad; one editor acts through its member's agent. Contract: docs/plan-group-participation.md.
