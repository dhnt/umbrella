---
id: 121a44e332bc
kind: test
title: 'O1 Owner publish e2e on one page: release pinned set, offer to a member, member adopts and undoes, owner submits (form/poll, then viewer, then brainstorm blocks)'
seq: 715
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-24T19:03:06.512593Z
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Owner publishing for a shapeable page and its shapeable components (any website)
---

One skill-script modelled on examples/shaping/hello-world/e2e-agent.sh, run as the owner, one member inside an owner-named circle, one member outside it, a logged-in non-member and an anonymous visitor. The page (examples/desk/page) carries form/poll, viewer book and brainstorm blocks plus the website face, and the owner shares the page and its component apps as a suite with the circle (Sprint 710). One block at a time, in that order: owner wish (a genie.examples line for the block), verify, approve; shape release names a page release that pins the component versions it was verified with; shape offer to the circle's members (form per plan open decision 4); the member in the circle adopts --preview, then adopts; the change is visible to that member only; the member outside the circle sees no offer; the logged-in non-member and the anonymous visitor get only the public face (Sprint 710 access model: non-members are anonymous); the member undoes; the owner submits the approved revision. The brainstorm block waits for cb9b4b80 (register brainstorm as shaped). The worker writes and dry-runs it; the conductor runs it live. The live model-backed run is one paid run and needs the operator's go.

Depends on (683 stories since 703 closed): O0 b23982703c71 (after F11 d246ca4e518e) (console builds the desk-family apps from the module proxy); D4 90f03f54 (offer refuses a released version); the step-0 shaping evidence baseline of 706 R5 5c1b07e994f1 (706 R8 d8b7f10afa31 was folded into it and closed wontfix); 710 H6 14bb7d2b5eab (suite-to-circle sharing proven on a real satellite), plus 710 H1 ef2ce499a64a if the script shares from the CLI or H5 f095ebc76350 if from the master; a pinned page release, which no story builds yet (plan open decision 3); and the offer audience (plan open decision 4); the design record for 3 and 4 is being written as 705 S3 input and reviewed with the operator first. This story is a test and builds neither.

Held with Sprint 683 until 705 S3 settles the page-plus-components model; re-review against S3 before assigning. Plan: docs/sprint-683-master-execution-plan.md.
