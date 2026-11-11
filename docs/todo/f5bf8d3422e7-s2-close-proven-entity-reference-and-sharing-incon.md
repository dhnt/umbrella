---
id: f5bf8d3422e7
kind: bug
title: S2 Close proven entity-reference and sharing inconsistencies across existing apps
seq: 100
status: done
priority: p1
labels:
    - collaboration-mvp
created: 2026-11-11T00:52:36.247539Z
assignee: codex-gpt6-sol
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
closed: 2026-11-11T07:18:03.719416Z
closed_by: claude-opus5.5-s614
---

Depends on S1. Correct only demonstrated gaps in existing parsers, store resolvers, emitters and app links. Reuse canonical kind:id and [[kind:id]], existing UUID/UID, slug and scoped sequence semantics; do not mint a parallel artifact identity. Extend the existing closed registry only for a demonstrated unrepresented entity, with owning resolver and existing ratchet tests. Preserve identity across exports and clones; do not use host-local sequence as portable identity. Sharing/opening uses existing routing and audience checks. Acceptance: affected CLI/JSON/browser paths resolve the same entity; unresolved, ambiguous and denied references are explicit; references never grant access; unchanged tools verified without edits.

Cross-cutting operator requirement: all Bashy apps/features must support software shaping and follow 'rod, not fish'. Prefer one reusable Bash# (.bsh) command/skill/script wrapper composing existing verbs and external tools; keep each underlying operation independently usable. Put variable behavior in templates/config/formats and name the shaping hook. Write new Go only for a necessary missing primitive/backend, not orchestration that Bash# can express. No one-off classroom, competition, roster or provider coupling. Reuse [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]. Acceptance includes the documented shaping hook and reusable wrapper/contract evidence; discovery stories specify these rather than implementing them.

Agent-first CLI parity (operator requirement): everything a human can see or do in an app, including all administration and management, must also be available through Bashy CLI under equivalent identity, permissions and approval rules. Provide discoverable help, scriptable/noninteractive inputs, structured outputs, stable entity references and actionable errors. Prefer Bash# command/skill wrappers over existing APIs/verbs. A browser-only action or a raw API with no Bashy CLI entry is an integration gap. S1 audits the UI-to-CLI action matrix; S6 verifies equivalent read results and state changes through browser and CLI, including denied access; S7/S8 must include full user/admin CLI coverage in their adapter/MVP decisions. Existing supported CLI paths are reused rather than rebuilt.

Audience/interface requirement: Bashy is built for agentic tools to easily discover, use and manage all features through its CLI. Humans can also run the same CLI normally; it is not agent-exclusive, although human-oriented ergonomics are not its design priority. Bashy app/* web interfaces are designed to be human-friendly. Every web-visible capability and management action must have equivalent Bashy CLI support, with the same entities, permissions and approval rules. Agents may also inspect or operate web apps using bashy browser --live, REST APIs or web URLs; these are valid alternative paths, but can be more cumbersome or error-prone and do not substitute for CLI parity. Prioritize agent usability, discoverable help, scriptable/composable operations, structured inputs/outputs and actionable errors. Human TUI polish is not required; a CLI-only calendar does not supply the human-friendly web app.
