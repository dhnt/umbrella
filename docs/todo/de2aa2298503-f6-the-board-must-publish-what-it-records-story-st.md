---
id: de2aa2298503
kind: bug
title: 'F6 The board must publish what it records: story status and assignee reach origin on assign, reassign and accept'
seq: 698
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-24T12:47:44.185476Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Two gaps seen in Sprints 675, 684 and 685. (1) sprint assign and sprint accept write the story file only in the shared umbrella checkout; origin kept showing accepted stories as todo until a manager published them by hand. (2) After a reassignment the committed story file still named the previous assignee, so the new worker's correct commit was logged as a bypass (Sprint 684 bypass 6). Wanted: the verbs commit and push the story-file change themselves (or refuse to finish until it is published), from a worktree on the origin head, never by leaving the shared checkout dirty. Unit tests on the verb with a fake remote. 5 points.
