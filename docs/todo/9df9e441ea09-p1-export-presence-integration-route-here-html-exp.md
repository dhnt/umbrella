---
id: 9df9e441ea09
kind: bug
title: 'P1 export/presence integration: route here HTML export through recordFace'
seq: 679
status: assigned
assignee: muse-wonder
priority: p1
labels:
    - page
created: 2026-11-23T14:41:45.847203Z
sprint: 696
---

In `bashy/examples/desk/page/export.go` (`exportHTMLLocked`), remove ONLY the 4-line temporary `if b.Kind == "here" { ... }` branch (lines 90-93) so HTML/PDF export routes `here` through `renderBlockFaces(r, it, b, recordFace)`. Keep `participantsHTML(it)` and `participantsListHTML(it)` intact.

Steps:
1. Branch `s696-9df9e441ea09` from current `bashy` `origin/main` (`0871471d`).
2. Remove lines 90-93 (`if b.Kind == "here" { ... }`) in `bashy/examples/desk/page/export.go`.
3. Run `GOWORK=off go -C bashy/examples/desk/page test -count=1 ./...` and confirm all tests pass.
4. Commit in `bashy` with `BASHY_AGENT=muse-wonder` and contiguous trailers (NO blank lines between trailers!):
   `Sprint: #696`, `Sprint-ID: a5df88f3-7163-5811-b45e-c16809082c06`, `Story: #679`, `Story-ID: 9df9e441ea09`, `Agent: muse-wonder`.
5. Commit the `bashy` submodule gitlink bump at the umbrella workspace root (`git add bashy`, same contiguous trailers) so both `bashy` and umbrella `git status` are 100% clean. Do NOT push.
