---
id: c901b0309f31
kind: task
title: 'F0 Pins at heads: clear the stale pins left when Sprints 684 and 685 closed'
seq: 701
status: todo
priority: p0
labels:
    - release
created: 2026-11-24T12:56:15.928774Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

First story of this sprint and a precondition of any freeze, tag or release cut (Sprint 699). At the close of 684/685 (2026-11-24): bashy mod drift showed stale bashy -> bashsharp and ycode -> bashsharp (pinned fa2401af; bashsharp main at abe0538 then 08fabb3), and the umbrella gitlinks for bashsharp, coreutils, yoke and outpost trailed their repo heads, because Sprint 675's coreutils pin sync was in flight. Check first whether that sync already cleared them; if not, ask on bashy mb who is syncing, take the claim, bump producer first with bashy mod sync (bashy/ycode pair by hand), forward only, umbrella commit from a worktree on the origin head. Each changed consumer: build and unit tests on the gate host, results compared by name with the pre-change run on an idle lane; the known red tests of this sprint are the only allowed failures. Done when drift shows no stale row and every gitlink equals its repo head. Steps: docs/handoff-sprint-684-685.md. 2 points.
