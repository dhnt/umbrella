---
id: 9c585822cc31
kind: feature
title: 'I1 group-shape skill-script: one acceptance run for Page, Session and Notepad (integration, release train)'
seq: 579
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-20T21:42:54.996074Z
sprint: 724
sprint_id: 4c6a8940-8673-582a-adef-d7665a30d524
sprint_title: 'Consolidated follow-ups after train 1 (supersedes 711, 713, 714, 715, 718, 720): owner-sharing and A/O/C sandbox e2e, site MCP and site attach, deferred integration runs, known reds, MCP 2026-07-28'
---

Integration story of the group shaping epic, run once on integrated main at the frozen commits on the gate host; needs no hosted deploy. One Bash# skill-script composing the --json verbs, run against Page, then Session, then Notepad with distinct fake identities: share add a member, the member is admitted, history / undo / restore, share rm, the removed member and an outsider are refused, a guest joins by code with a name and is kicked; PDF of a named Notepad revision holding text from two authors. The same roster steps fill the verdict column of the coverage matrix (Sprint 685 C2) for Form and Brainstorm. Depends on Sprint 684 S1-S4 merged. Evidence in docs/sprint-699-evidence.md. Plan: docs/sprint-684-685-master-execution-plan.md.
