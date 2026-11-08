---
id: "357098850837"
kind: feature
title: 'execlog/kb: auto-compose and evolve wiki-versioned KB runbooks with Bash# script/skill drafts from recovered turns'
seq: 44
status: todo
priority: p1
labels:
    - kb
    - bashsharp
created: 2026-11-08T01:01:08.186868Z
sprint: 590
sprint_id: e87405cd-e28f-57b5-bc3a-7727d4c92438
sprint_title: Third-party agent turn error-recovery OTel spans, Bash# KB wiki auto-composition, and KB/shaping tidy
---

In yoke/pkg/execlog/turnkb.go and bashy/internal/agentos: 1) When EndTurn completes with turn.recovered=true, reconcile against existing KB pages via deterministic turn-recovery-key and kb.NearDuplicate. 2) Create (add) if no matching KB page exists, or evolve (update/supersede) if a candidate exists, embedding a top-level executable Bash# (bsh) script block (@guard, @effects, @require, @ensure) where succeeded bashy commands form the script body and comments are derived from the user instruction, failed command pitfalls, and LLM solution response. 3) Leverage Store.Write wiki edition history (journal.jsonl, pure-Go gitSnapshot, kblife.Supersede, and in-page ## Editions table) and stamp filterable provenance tags (auto-composed, turn-recovered, user-instructed/implicit-turn, bashsharp). See docs/agent-turn-recovery-and-bashsharp-kb-plan.md.
