---
id: 3060b0dbb4af
kind: doc
title: 'P1 kb runbook shapeware-spec-from-plan: convert an agent plan or a bashy sprint/todo set into a shapeware spec'
seq: 786
status: done
priority: p1
labels:
    - shapeware
    - conform
created: 2026-11-26T11:40:46.119673Z
assignee: claude-opus5.5
sprint: 727
sprint_id: 97421d56-349b-5fa1-9885-ee05a024a9d6
sprint_title: 'Instructions to spec: agents convert a bashy sprint''s stories into a shapeware spec, and the result is evaluated'
closed: 2026-11-26T11:53:36.712075Z
closed_by: claude-opus5.5
---

Inputs: (a) a plan written by an agentic tool's plan mode, (b) a bashy sprint card with its stories, or a set of todos. Output: a shapeware spec folder per docs/shapeware-spec-v0.md: SKILL.md with the type line and run block, features.yaml (one feature per story or plan step: id, intent, effort, acceptance lines, status tbd), CONTRACT.md assertions for behaviour that must hold, examples for every input format. Rules to state in the runbook: an acceptance line for every requirement; conform spec check clean; with no reference app the first passing build becomes the reference, then cert and mutate apply. Try it once on a real plan and once on a real bashy sprint before calling it done. Related kb pages: shapeware-spec-from-app, spec-to-source-drill. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The front half: instructions to spec' (operator 2026-11-26). Not on a sprint yet; schedule after Sprint 726.
