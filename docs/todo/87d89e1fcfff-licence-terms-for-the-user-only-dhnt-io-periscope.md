---
id: 87d89e1fcfff
kind: task
title: 'Licence terms for the user-only dhnt.io/periscope UI source (decided: proprietary, dhnt.io users only)'
seq: 319
status: todo
priority: p2
labels:
    - software-shaping
created: 2026-11-15T03:03:07.125528Z
---

DECIDED 2026-11-14 (operator): the dhnt.io / periscope UI stays PROPRIETARY and its source is made available to USERS OF DHNT.IO ONLY — not open source, not a public repository. Recorded in umbrella docs/dhnt-journey-design.md, section 'When the desktop itself becomes code-shapeable'.

What remains to settle:
  - the licence's permissions: read and shape FOR YOUR OWN USE, no redistribution, no fork-and-compete; whether it survives a lapsed account; attribution.
  - delivery: the source reaches a user through their own authenticated plane (the registry/catalog machinery that already serves apps), never a public remote — so a phase-D trove mount for it is a members-only store, not GitHub.
  - the phase: code-level shaping of the desktop needs a build per principal, which the hosted plane cannot do today; the natural home is phase D, on the user's own plane, where it also makes the 'nothing you built has to move' guarantee literal.

Unchanged by this decision: phase A shapes the desktop through the declared schema and property document, needs no source at all, and must stay a complete experience on its own — public builds and CI never depend on private source.
