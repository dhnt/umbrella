---
id: af8ee492004f
kind: bug
title: bashy sprint goal link never stores a first-time story link (thread says linked, story stays UNCOVERED)
seq: 243
status: todo
priority: p1
labels:
    - sprint
    - bashy
created: 2026-11-13T17:41:56.776224Z
---

Root cause (recorded 2026-11-13 while planning Sprint 632, read-only): yoke/pkg/weave/weave_story_goal.go linkSprintGoalStory (~line 696-730) rebuilds g.Stories from the existing entries and only replaces an entry whose id already matches (the repo-healing path). When no entry matches (`!matched`), it appends the thread line "linked story X to goal G" and returns "linked", but never appends sprintStoryRef{Repo: root, ID: it.ID} to g.Stories. Only `sprint goal add --story` (line ~627) appends. Effect: every story linked with `sprint goal link` stays in the card's "UNCOVERED by the plan" list and would trip the close gate (weave_story_coverage.go sprintCoverageGate) although the thread records the link.

Reproduction: Sprint 632 on this host: `bashy sprint goal add 632 --id parity --story 8ab0eb81` covers A1; `bashy sprint goal link 632 parity --story 57624adf` prints "goal parity linked 57624adf88eb" and the next `sprint show 632` still lists 57624adf as uncovered; re-running prints "linked" again (never "already links").

Fix (small, baseline-proven, separate C commit in yoke): in the `!matched` branch append the new ref before returning; add a unit test that links a new story and asserts sprintStoryCovered is true, plus one that re-links the same id with a different repo and asserts a single healed entry. Classification: product defect. After the fix, re-run the 14 pending links on Sprint 632 (listed on its thread) so the card shows 0 uncovered.
