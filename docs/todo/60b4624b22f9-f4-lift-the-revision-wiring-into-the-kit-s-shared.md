---
id: 60b4624b22f9
kind: refactor
title: F4 Lift the revision wiring into the kit's shared handler so an app adopts history, undo and restore in a few lines
seq: 696
status: wontfix
priority: p2
labels:
    - group-shaping
created: 2026-11-24T12:47:43.628933Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
closed: 2026-11-25T04:10:30.377059Z
---

Sprint 684 delivered the revision store (examples/desk/kit/revision.go) and its adoption by Page and Notepad, but each app carries its own wiring: about 250 added lines in page/main.go and about 580 changed lines in notepad/main.go. The rod's intent was a few lines per app. Move what is repeated (action dispatch for history, undo, restore; base_rev check and 409 with both revisions; author and kind from the caller; CLI verbs) into the kit's shared handler and options, then shrink Page and Notepad onto it with no behavior change: their existing unit tests are the acceptance (Page 55 tests + 31 subtests, Notepad 29), plus the kit's. New kit version and consumer repins by the Sprint 684 rule (candidate built only against a private proxy and caches). Do this before another app adopts the store. 5 points.

## Sprint 703 review 2026-11-24 (operator)

Priority lowered p1 -> p2: a refactor with no behavior change; Sprint 706 R5 does not depend on it.

## Won't do (2026-11-24, operator: close Sprint 703)

Not needed for the MVP or the supported workflows (anonymous visitor, member, owner sharing and group shaping). Reopen with a new plan if a need appears.
