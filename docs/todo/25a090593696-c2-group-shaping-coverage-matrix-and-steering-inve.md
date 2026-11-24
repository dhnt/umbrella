---
id: 25a090593696
kind: doc
title: C2 Group shaping coverage matrix and steering inventory (doc)
seq: 575
status: todo
priority: p1
labels:
    - group-shaping
created: 2026-11-20T21:08:47.811665Z
sprint: 685
sprint_id: f684d38b-201d-5579-bd47-c70e26524188
sprint_title: 'Group shaping coverage: every bashy app as a test case, plus cross-outpost agent steering in one circle'
---

One doc under docs/. One row per registered app and CLI-only tool (page, session, notepad, form, brainstorm, chart, viewer, whiteboard, film, video, board, table, notes, site, clips, files, klatch): artifact, who may write, guest door, shaping hook, bashy entry point, revision adoption (done in Sprint 684 / can adopt the kit store / event log / not applicable), and a verdict column filled by the Sprint 699 run (I1). Rows that are not small are filed follow-ups with evidence, not work in this sprint: whiteboard (no read-only mode; one collab server per principal), film and video storyboards (plain files; film lock is the existing named-revision analog), brainstorm shaped registration, table (Linux only, recorded exception). Include the steering inventory from the code: a shared-session directive reaches a weave run on another host (yoke/pkg/weave/weave_directive.go) but not a bashy chat session (yoke/pkg/chat/cmd_interact.go); no inbound A2A server is wired; cross-outpost steering (X1 04bc82b8, X2 b1ad7a71) waits for Sprint 679. 2 points. Plan: docs/sprint-684-685-master-execution-plan.md.
