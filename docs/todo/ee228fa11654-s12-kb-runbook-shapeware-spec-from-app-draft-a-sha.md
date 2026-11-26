---
id: ee228fa11654
kind: doc
title: 'S12 kb runbook shapeware-spec-from-app: draft a shapeware spec from an existing repo/app (reverse)'
seq: 779
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-26T05:33:11.757787Z
sprint: 723
sprint_id: a7f3f8dd-c83a-5191-9739-676397a50c45
sprint_title: 'Spec to source calibration: sound spec, validator, minimal model, judge band'
---

Operator 2026-11-25. A bashy kb runbook an agent follows to turn an existing app into a shapeware spec, written from what we did for form:
(1) inventory the CLI surface (--help, verbs, flags) and the UI pages;
(2) record behaviour from the running reference as CONTRACT.md assertions (record-from-reference, placeholders for ids, ports and keys; open/closed per output);
(3) features.yaml: one feature per behaviour, with an acceptance line, an effort point and a status;
(4) a worked example for every input format;
(5) state the output rules and UI rules once;
(6) separate behaviour from reference operation;
(7) conform spec check (static), then cert x3 + mutate on the reference;
(8) hidden cases are written privately by the grader, never by the author.
Validate the runbook by drafting one small app's spec with it.

Plan: umbrella docs/plan-spec2src-calibration.md and docs/shapeware-qualification-process.md (system view).
