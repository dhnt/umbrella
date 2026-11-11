---
id: b1a560033251
kind: refactor
title: S5 Refactor Tutor into Session (clean rename, roles from formats)
seq: 103
status: todo
priority: p2
labels:
    - collaboration-mvp
created: 2026-11-11T00:52:36.680429Z
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
---

Depends on S1 (name-collision check only). Operator decision 2026-11-11: refactor, not alias. Tutor is new and has no field use or tested stored state, so rename it outright to Session — no tutor alias, no compatibility shim, no migration of stored state. Scope: move examples/tutor -> examples/session (tutor.bsh -> session.bsh, register.sh registers `session`, skill name, contract, prompts, content, server, browser test, Python tests and README); rename every user-visible string, identifier, state/data directory and env name from tutor to session; update live references (docs/setup.md, examples/record, examples/shaping/hello-world/register.sh, skills/bashy recipes, kb pages found by `bashy kb search tutor`). Historical records (CHANGELOG, release notes, closed todos, past sprint plans) stay unchanged. Role labels are not hardcoded: the organizer/participant names come from each format's `roles` (class: teacher/student; meeting/session/solo as defined), and generic text uses "session"/"organizer". Hosts that registered the old example drop it explicitly (`bashy commands rm tutor`, `bashy skill rm tutor`) — documented in the README, not automated.

Done when: `bashy commands session` resolves and `tutor` does not; `git grep -i tutor` outside historical records returns nothing or only deliberate format role text; the renamed example's existing tests (test_contract, test_flows, test_formats, test_nudge, test_plan, test_prep, test_registration, test_render, test_run, browser-test) pass under their new names; register.sh is idempotent on a clean host.

Cross-cutting operator requirement: all Bashy apps/features must support software shaping and follow 'rod, not fish'. Prefer one reusable Bash# (.bsh) command/skill/script wrapper composing existing verbs and external tools; keep each underlying operation independently usable. Put variable behavior in templates/config/formats and name the shaping hook. Write new Go only for a necessary missing primitive/backend, not orchestration that Bash# can express. No one-off classroom, competition, roster or provider coupling. Reuse [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]. Acceptance includes the documented shaping hook and reusable wrapper/contract evidence; discovery stories specify these rather than implementing them.

Agent-first CLI parity (operator requirement): everything a human can see or do in an app, including all administration and management, must also be available through Bashy CLI under equivalent identity, permissions and approval rules. Provide discoverable help, scriptable/noninteractive inputs, structured outputs, stable entity references and actionable errors. Prefer Bash# command/skill wrappers over existing APIs/verbs. A browser-only action or a raw API with no Bashy CLI entry is an integration gap. S1 audits the UI-to-CLI action matrix; S6 verifies equivalent read results and state changes through browser and CLI, including denied access; S7/S8 must include full user/admin CLI coverage in their adapter/MVP decisions. Existing supported CLI paths are reused rather than rebuilt.

Audience/interface requirement: Bashy is built for agentic tools to easily discover, use and manage all features through its CLI. Humans can also run the same CLI normally; it is not agent-exclusive, although human-oriented ergonomics are not its design priority. Bashy app/* web interfaces are designed to be human-friendly. Every web-visible capability and management action must have equivalent Bashy CLI support, with the same entities, permissions and approval rules. Agents may also inspect or operate web apps using bashy browser --live, REST APIs or web URLs; these are valid alternative paths, but can be more cumbersome or error-prone and do not substitute for CLI parity. Prioritize agent usability, discoverable help, scriptable/composable operations, structured inputs/outputs and actionable errors. Human TUI polish is not required; a CLI-only calendar does not supply the human-friendly web app.
