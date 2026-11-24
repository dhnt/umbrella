---
id: 121a44e332bc
kind: test
title: 'O1 Owner publish e2e: release, offer to a member, member adopts and undoes, owner submits (form, then viewer, then brainstorm)'
seq: 715
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-24T19:03:06.512593Z
sprint: 683
sprint_id: a2c119a7-7ca5-571e-8e50-7a19ae1e583f
sprint_title: Shaping-enable the example apps for owners/producers (follow-up)
---

One skill-script modelled on examples/shaping/hello-world/e2e-agent.sh, run as the owner plus one paired member principal. Per row: owner wish (a genie.examples line), verify, approve; shape release; shape offer --to MEMBER; member adopt --preview, then adopt; the change is visible to that member only; member undo; owner submit of the approved revision. Rows in order: form/poll, viewer, brainstorm (after 703 cb9b4b80). The worker writes and dry-runs it; the conductor runs it live. The live model-backed run is one paid run and needs the operator's go. Depends on O0, 703 D4 90f03f54 (offer refuses a released version), 706 R8 d8b7f10afa31. Plan: docs/sprint-683-master-execution-plan.md.
