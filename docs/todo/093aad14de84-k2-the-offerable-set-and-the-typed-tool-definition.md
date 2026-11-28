---
id: 093aad14de84
kind: feature
title: 'K2 the offerable set and the typed tool definition: model, tool, agent, registered command (ToolCommand overlay, no new runner kind)'
seq: 830
status: todo
priority: p1
created: 2026-11-27T15:34:19.121048Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §3.1, §4 K2. Two parts.

(1) The offerable set and the typed tool definition (moved here from Sprint 740 G1). Eligibility is one test: NAME is a fleet model, a fleet tool or agent, or a registered command (bashy commands add). bash, Bash#, coreutils and bashy internal verbs (read, write, edit, search, ast, kb, todo and the like) are refused, naming the reason. The class (model | tool | agent) comes from the fleet record, not a flag. Every offer carries one typed tool definition: name, class, model-facing description, typed input schema (the record args), output shape, effects, unit (token for model and agent; call or a named output unit for a tool). An offer with only an untyped argument list is refused naming what is missing. Definition digest = the existing tool-definition SHA-256 (yoke mcp policy.go ToolsSHA256 canonical form), computed for the one definition.

(2) No new runner kind: for a registered command generate a user-overlay ToolCommand (tool binary bashy, mode print, exec: bashy NAME {args}, effects + timeout from the registered record; herald.yaml pattern); bashy binds the record's own schema (registered.go:390). FIRST verify the door routes a model-less bashy tool row (cligw catalog.go:280-315 deriveInventory needs a tool+model binding); if not, that catalog change is part of the story.

Accept: unit tests per class (definition and digest for a model, a tool, an agent, a registered command), internal-verb refusal, untyped refusal, digest changes when the description or schema changes. Not in MVP: typed schemas for bashy's untyped built-in verbs; source digests and published source (Sprint 740 G1).

Code inspected 2026-11-27 (revised after review): yoke pkg/fleet commands.go command_schema.go types.go toolcommand.go baseline/tools/, pkg/toolcmd print.go:84-90, pkg/cligw catalog.go, mcp direct.go:56-64,179-309 policy.go; bashy internal/agentos registered.go. Revised at the sprint review 2026-11-27 (operator: every offer is a typed tool call in one of three classes, model, tool or agent; every call is metered whether free, shared or paid; Sprint 740 adds only the payment layer).

Tags (operator 2026-11-27, plan §3.1): the definition carries an optional tags list of free words (bashy offer NAME --tag a,b), like todo labels: no fixed list, no hierarchy. The fleet record's existing capability word (toolcommand capability:, e.g. transcribe, video, image-generation) is always included. Tags are covered by the definition digest. bashy offer tags shows the words in use; bashy offer list --tag filters. Tags are for finding and grouping only: no admission, refusal or limit reads them (effects stay the authority), and equivalence between offers is by name or capability, never by tag. Accept adds: unit tests for the capability word auto-included, the digest changing with a tag, --tag filtering, a tag never changing admission. Code inspected 2026-11-27: yoke pkg/fleet/baseline/tools/*.yaml (capability:), pkg/atlas atlas.go:396 (Effects); bashy todo labels as the pattern.

Revised 2026-11-27 night (operator: to an external agent everything is a tool; the bashy CLI calls any LLM and agent one-shot). The Model and Agent classes take the typed definitions of M1 (49ae75a9a181): llm (bashy llm call) and agent (bashy agent call); K2 adds no second definition for them. Depends on M1.
