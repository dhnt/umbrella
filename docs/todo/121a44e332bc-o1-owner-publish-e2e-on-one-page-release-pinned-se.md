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

One skill-script modelled on examples/shaping/hello-world/e2e-agent.sh, run as the owner plus one paired member principal, on one page (examples/desk/page) carrying form/poll, viewer book and brainstorm blocks, plus the website face. One block at a time, in that order: owner wish (a genie.examples line for the block), verify, approve; shape release names a page release that pins the component versions it was verified with; shape offer --to MEMBER; member adopt --preview, then adopt; the change is visible to that member only; member undo; owner submit of the approved revision. The brainstorm block waits for 703 cb9b4b80 (register brainstorm as shaped). The worker writes and dry-runs it; the conductor runs it live. The live model-backed run is one paid run and needs the operator's go.

Depends on: 703 O0 b23982703c71 (console builds the desk-family apps from the module proxy); 703 D4 90f03f54 (offer refuses a released version); the step-0 shaping evidence baseline of 706 R5 5c1b07e994f1 (706 R8 d8b7f10afa31 was folded into it and closed wontfix); and a pinned page release, which no story builds yet (plan open decision 3: a 705 S3 outcome, a new 683 story, or this story releases the page alone and pinning waits). This story is a test and does not build the pinning.

Held with Sprint 683 until 705 S3 settles the page-plus-components model; re-review against S3 before assigning. Plan: docs/sprint-683-master-execution-plan.md.
