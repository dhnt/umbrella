---
id: 2844cbe79bd7
kind: enhancement
title: S3 Expose existing KB as the browser catalog through Klatch and Viewer
seq: 101
status: done
priority: p1
labels:
    - collaboration-mvp
created: 2026-11-11T00:52:36.392532Z
assignee: claude-fable5.1
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
closed: 2026-11-11T07:14:38.117205Z
closed_by: claude-opus5.5-s614
---

Depends on S1 and relevant S2 fixes. KB is the primary catalog of short notes/references, using existing kind/filter/link/scope operations. Original content stays authoritative in its repo/app. Reuse Klatch navigation, Viewer rendering and Notepad editing; no Library database, second wiki store or alternate link syntax. Verify browse/filter/open/backlinks for personal/team/session materials; add only missing adapters/UI paths. KB record writes must use kb verbs, not hand-edited store files. Keep Viewer report-book history intact. Acceptance: a user opens KB from Klatch, finds a relevant record and follows its existing ref to original content; scoped access is honored and no full-content duplication is required.

Cross-cutting operator requirement: all Bashy apps/features must support software shaping and follow 'rod, not fish'. Prefer one reusable Bash# (.bsh) command/skill/script wrapper composing existing verbs and external tools; keep each underlying operation independently usable. Put variable behavior in templates/config/formats and name the shaping hook. Write new Go only for a necessary missing primitive/backend, not orchestration that Bash# can express. No one-off classroom, competition, roster or provider coupling. Reuse [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]. Acceptance includes the documented shaping hook and reusable wrapper/contract evidence; discovery stories specify these rather than implementing them.

Agent-first CLI parity (operator requirement): everything a human can see or do in an app, including all administration and management, must also be available through Bashy CLI under equivalent identity, permissions and approval rules. Provide discoverable help, scriptable/noninteractive inputs, structured outputs, stable entity references and actionable errors. Prefer Bash# command/skill wrappers over existing APIs/verbs. A browser-only action or a raw API with no Bashy CLI entry is an integration gap. S1 audits the UI-to-CLI action matrix; S6 verifies equivalent read results and state changes through browser and CLI, including denied access; S7/S8 must include full user/admin CLI coverage in their adapter/MVP decisions. Existing supported CLI paths are reused rather than rebuilt.

Audience/interface requirement: Bashy is built for agentic tools to easily discover, use and manage all features through its CLI. Humans can also run the same CLI normally; it is not agent-exclusive, although human-oriented ergonomics are not its design priority. Bashy app/* web interfaces are designed to be human-friendly. Every web-visible capability and management action must have equivalent Bashy CLI support, with the same entities, permissions and approval rules. Agents may also inspect or operate web apps using bashy browser --live, REST APIs or web URLs; these are valid alternative paths, but can be more cumbersome or error-prone and do not substitute for CLI parity. Prioritize agent usability, discoverable help, scriptable/composable operations, structured inputs/outputs and actionable errors. Human TUI polish is not required; a CLI-only calendar does not supply the human-friendly web app.
