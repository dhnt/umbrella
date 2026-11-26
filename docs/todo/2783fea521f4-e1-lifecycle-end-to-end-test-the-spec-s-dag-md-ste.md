---
id: 2783fea521f4
kind: test
title: 'E1 lifecycle end-to-end test: the spec''s dag.md steps must build, test, install, run, serve and stop, on the reference and on every build'
seq: 802
status: todo
priority: p0
labels:
    - shapeware
created: 2026-11-26T17:19:12.368655Z
sprint: 726
sprint_id: 224903a6-fe24-5dba-afc4-b7d6f86af9e9
sprint_title: Shapeware MVP end-to-end loop on a second app, run by agents (reverse SDLC iteration 2)
---

Operator ruling 2026-11-26: after the spec is written and after source is generated, test the validity of the `dag.md` steps end to end: the app must build, install, run and serve. Mechanical, no model.

## What exists (Sprint 731, form)
- The private form grader v2.4 has a lifecycle phase: on a fresh copy of a folder it runs the spec's own `build`, `test` and `run` steps by exit code, then starts `serve`, adds an item, requires its page to answer 200, runs `stop`, and requires the page to stop answering. Namespaces, a fresh HOME, no display.
- agent-bench `packs/spec2src/t2-operate/reference/operate.sh` runs the same steps as a plain script, including `install`.

## Deliver
1. One lifecycle end-to-end test for notepad, built from those two pieces: every step of `spec/dag.md` in order (`build`, `test`, `install`, `run` through the installed command, `serve`, the page answers, `stop`, the page no longer answers), reporting one exit status per step and one verdict. The step text always comes from the spec, never from the candidate's copy.
2. It runs in two places: on the reference, as the last gate of R1 (the spec's lifecycle is valid); and on every R3 build, as a phase of the grade (the generated source honours it).
3. Controls: the reference passes; an empty folder fails; a folder with one step broken fails on that step alone.

Keep it small: reuse the form code; change only what names the app, the command used to create an item, and the page check. Runs on a claimed gate lane.
