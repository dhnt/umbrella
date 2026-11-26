---
id: 95f4a97a278f
kind: task
title: W3 operator review of the workflow standard, then file the first execution sprint
seq: 790
status: done
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:02:30.177684Z
assignee: claude-fable5.2
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
closed: 2026-11-26T17:24:38.758224Z
closed_by: claude-fable5.2
---

Present the standard and the open decisions to the operator; record the rulings; file or update the first execution sprint with bounded stories. Nothing is implemented in this sprint. Material: umbrella docs/shapeware-workflow-findings-2026-11-26.md (findings F1-F12, implications, the eight questions) and docs/plan-reverse-sdlc-workflow.md. Planning only; KISS: describe the smallest workflow that runs end to end, and list everything else as 'not in the first standard'.

## Done (2026-11-26)

The standard (`docs/shapeware-workflow-standard.md`) and the report (`docs/sprint-731-report.md`) were presented to the operator with the open decisions. Rulings, as given:

1. The gate host display fault is fixed before the next runs: lanes are headless (`script/gate-lane.sh`); the host's Linux subsystem may be restarted at any time, coordinated with the other managers (todo `13d4dc76`).
2. The serve and stop gap is resolved now: form spec v2.2 (story `b390ac728272`).
3. A spec is self-contained; the design was left to the conductor: a spec release is its own folder, and the reference folder carries the spec's lifecycle in `spec/`.
4. Stepping the operate ladder further down is left for later; the Google runs that hit quota are dropped.
5. Sprint 726 is the next execution sprint, KISS: the spec author also writes the lifecycle; no required owner review step; no operate leg with an agent and no extra planning story for now; a mechanical end-to-end test of the lifecycle after the spec is written and after source is generated; the source-to-spec and spec-to-source kb runbooks are used, tested and improved during the sessions.
6. Sprint 726 is managed by another session; the Sprint 731 conductor triages its stories, shows the master execution plan, and hands over.

Carried out: Sprint 726 triaged (stories R1 to R4 updated, story E1 `2783fea521f4` filed), `docs/handoff-sprint-726.md` written with the master execution plan and shown to the operator, the card and the new session informed. The other items of section 11 of the standard (the notepad forward test, the judge study, the Sprint 723 carry-overs, Sprint 730) stay in the backlog; the operator made no ruling on them.
