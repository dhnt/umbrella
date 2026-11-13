---
id: 4a826c0dde16
kind: doc
title: 'S6 packaging: register.sh, dag.md, defaults row, README, docs copy of the plan + INDEX line, kb page'
seq: 250
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:17:59.560824Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

examples/agentic/register.sh (from examples/brainstorm/register.sh minus atlas/app: commands add agentic-forge + skill add), examples/agentic/dag.md (test, register, smoke; smoke needs AGENTIC_SMOKE_HOST and a training tier), examples/defaults/bashy-defaults.bsh row, examples/agentic/README.md (concept, resolution ring, worth-it gate, tiers, micro-shaping loop, cold-vs-warm demo), bashy/docs/plan-agentic-command-skill-scripts.md (copy of the sprint plan; repo rule) and a line in bashy/docs/INDEX.md; a kb page via bashy kb add once it works (not hand-written). GOWORK=off go -C examples/agentic test ./... and bashy check --agent on every .bsh clean. Depends on S1-S5.
