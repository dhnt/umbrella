---
id: dfb2cc56bd4f
kind: spike
title: S7 Assess Memos integration and define the smallest supported adapter
seq: 105
status: assigned
priority: p2
labels:
    - collaboration-mvp
created: 2026-11-11T00:52:36.973539Z
assignee: agy-gemini3.8-flash
sprint: 614
sprint_id: b3f5559a-e4b3-5d6a-9e1a-bdd0c3e7afd3
sprint_title: 'Collaboration MVP: consistent app references, KB catalog, and Memos/Calendar discovery'
---

Inspect whether Memos is already packaged, deployed or integrated before proposing work. Evaluate https://github.com/usememos/memos at an explicit supported release. Accept author-owned editing: shared co-editing is not required. Reuse existing app hosting/auth/sharing patterns and Memos API/MCP; keep notes native, with explicit KB short-note/reference registration and optional Git snapshot export. Verify team/private visibility mapping, identity/source preservation, token handling and existing refs adapter needs. Acceptance: evidence-backed exists/missing matrix, pinned compatibility recommendation and minimal follow-up stories for actual gaps. No fork, deployment, two-way content sync or separate notes catalog authorized by this spike.

Cross-cutting operator requirement: all Bashy apps/features must support software shaping and follow 'rod, not fish'. Prefer one reusable Bash# (.bsh) command/skill/script wrapper composing existing verbs and external tools; keep each underlying operation independently usable. Put variable behavior in templates/config/formats and name the shaping hook. Write new Go only for a necessary missing primitive/backend, not orchestration that Bash# can express. No one-off classroom, competition, roster or provider coupling. Reuse [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]]. Acceptance includes the documented shaping hook and reusable wrapper/contract evidence; discovery stories specify these rather than implementing them.

Agent-first CLI parity (operator requirement): everything a human can see or do in an app, including all administration and management, must also be available through Bashy CLI under equivalent identity, permissions and approval rules. Provide discoverable help, scriptable/noninteractive inputs, structured outputs, stable entity references and actionable errors. Prefer Bash# command/skill wrappers over existing APIs/verbs. A browser-only action or a raw API with no Bashy CLI entry is an integration gap. S1 audits the UI-to-CLI action matrix; S6 verifies equivalent read results and state changes through browser and CLI, including denied access; S7/S8 must include full user/admin CLI coverage in their adapter/MVP decisions. Existing supported CLI paths are reused rather than rebuilt.

Audience/interface requirement: Bashy is built for agentic tools to easily discover, use and manage all features through its CLI. Humans can also run the same CLI normally; it is not agent-exclusive, although human-oriented ergonomics are not its design priority. Bashy app/* web interfaces are designed to be human-friendly. Every web-visible capability and management action must have equivalent Bashy CLI support, with the same entities, permissions and approval rules. Agents may also inspect or operate web apps using bashy browser --live, REST APIs or web URLs; these are valid alternative paths, but can be more cumbersome or error-prone and do not substitute for CLI parity. Prioritize agent usability, discoverable help, scriptable/composable operations, structured inputs/outputs and actionable errors. Human TUI polish is not required; a CLI-only calendar does not supply the human-friendly web app.

Placement and graduation requirement: Calendar and Notes/Memos integrations start under bashy/examples/ as independently usable, software-shapeable examples with Bash# command/skill/script wrappers. They are not linked into or made required dependencies of the Bashy core. Reuse existing example registration, app hosting and contract patterns. Graduation is examples -> optional add-on -> foundation/core, following the existing evidence and platform/license/build requirements; this sprint does not authorize automatic graduation. Discovery recommendations and any implementation follow-up must state example-level placement. See [[kb:bashy/extend-bashy-small-verbs-bash-skill-scripts-shaping-hooks-and-th]].

Operator decision 2026-11-10: PARKED. The S7 spike (bashy docs/memos-decision.md, weave #86) recommends a Memos 26.11.0 example under examples/memos; the operator parked it. No follow-up story is filed; revisit only on an explicit operator request. S7 closes on the decision doc.
