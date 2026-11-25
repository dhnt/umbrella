---
id: 121a44e332bc
kind: test
title: 'O1 Owner publish skill-script (MVP): release, offer to a member, adopt, undo, submit for any shaped app; proven once on form/poll'
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

MVP, rod not fish (operator KISS review 2026-11-24). Deliver one generic skill-script that takes APP and MEMBER and composes the existing small verbs, nothing new: owner wish (the app's own genie.examples line), verify, approve; shape release; shape offer --to MEMBER; member adopt --preview, then adopt; the change is visible to that member only; member undo; owner submit of the approved revision. It works for any app registered --type shaped. Prove it once, on the form/poll block of examples/desk/page. Its first step on the gate host confirms the console builds the app as a member instance (the check O0 b23982703c71 was filed for; if it fails, O0/F11 come back from the backlog with a recorded root cause). The worker writes and dry-runs it; the conductor runs it live. The live model-backed run is one paid run and needs the operator's go.

Depends on: D4 90f03f54 (offer refuses a released version).

Not in the MVP (fish; filed only when a need appears): runs on other blocks or apps (anyone runs the same script with another APP); a pinned page-plus-components release; offering to circles or suites (Sprint 710 model); public-face checks (710 H6 covers them). Plan: docs/sprint-683-master-execution-plan.md.
