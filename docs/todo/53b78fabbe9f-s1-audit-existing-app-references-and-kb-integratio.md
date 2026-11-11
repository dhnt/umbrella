---
id: 53b78fabbe9f
kind: requirement
title: S1 Audit existing app references and KB integration; identify only proven gaps
seq: 99
status: done
priority: p0
labels:
    - collaboration-mvp
created: 2026-11-11T00:52:36.124074Z
assignee: codex-gpt6-sol-w84
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
closed: 2026-11-11T04:40:03.743789Z
closed_by: claude-opus5.5-s614
---

Inventory actual registered commands, code and existing acceptance evidence for Klatch, Tutor/Session, KB, Viewer, Notepad, Brainstorm, Whiteboard, Form, charts, recording, transcription and video. Record per tool: owning entity/store, accepted/emitted refs and UUID/UID/slug/scoped seq behavior, define resolver, browser open/share, audience checks, output/export, Git support and known defects. Reuse yoke/pkg/ref, bashy/docs/command-atlas.md section 2.8, script/e2e-refs.sh and existing Desk tests. Do not infer all tools are integrated merely because a common grammar exists. Acceptance: one compact matrix on this story with code/evidence refs; each gap mapped to S2-S6 or explicitly deferred; passing existing behavior needs no rewrite. Audit Memos/Calendar via S7/S8. No parallel identity/catalog design.

Cross-cutting operator requirement: all Bashy apps/features must support software shaping and follow 'rod, not fish'. Prefer one reusable Bash# (.bsh) command/skill/script wrapper composing existing verbs and external tools; keep each underlying operation independently usable. Put variable behavior in templates/config/formats and name the shaping hook. Write new Go only for a necessary missing primitive/backend, not orchestration that Bash# can express. No one-off classroom, competition, roster or provider coupling. Reuse [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]. Acceptance includes the documented shaping hook and reusable wrapper/contract evidence; discovery stories specify these rather than implementing them.

Agent-first CLI parity (operator requirement): everything a human can see or do in an app, including all administration and management, must also be available through Bashy CLI under equivalent identity, permissions and approval rules. Provide discoverable help, scriptable/noninteractive inputs, structured outputs, stable entity references and actionable errors. Prefer Bash# command/skill wrappers over existing APIs/verbs. A browser-only action or a raw API with no Bashy CLI entry is an integration gap. S1 audits the UI-to-CLI action matrix; S6 verifies equivalent read results and state changes through browser and CLI, including denied access; S7/S8 must include full user/admin CLI coverage in their adapter/MVP decisions. Existing supported CLI paths are reused rather than rebuilt.

Audience/interface requirement: Bashy is built for agentic tools to easily discover, use and manage all features through its CLI. Humans can also run the same CLI normally; it is not agent-exclusive, although human-oriented ergonomics are not its design priority. Bashy app/* web interfaces are designed to be human-friendly. Every web-visible capability and management action must have equivalent Bashy CLI support, with the same entities, permissions and approval rules. Agents may also inspect or operate web apps using bashy browser --live, REST APIs or web URLs; these are valid alternative paths, but can be more cumbersome or error-prone and do not substitute for CLI parity. Prioritize agent usability, discoverable help, scriptable/composable operations, structured inputs/outputs and actionable errors. Human TUI polish is not required; a CLI-only calendar does not supply the human-friendly web app.

Planning handoff: Sprint 614 is backlog/unclaimed; all eight stories remain todo and are linked to the goal checklist. This planning session did not run the audit or implement features, start a manager, launch workers, or deploy apps. Begin with this S1 inventory using existing docs/ui-cli-parity.md, examples/desk/kit/README.md, docs/shape-contract.md and the cited KB guideline. The parity clarification is committed in bashy at 2997fa61. S7/S8 contain the Memos/Calendar research and latest minimal-scope decisions; Calendar/Notes start as examples, and calendar selection favors least total effort, with web UI for humans and complete agent-friendly CLI parity. Existing unrelated work and local KB journal/read activity remain untouched.
