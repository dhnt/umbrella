---
id: 01a217aa-868d-779d-b3cd-0f73d8c22bcf
seq: 28
form: page
type: runbook
title: 'Write a shapeware spec from instructions: an agent plan, a bashy sprint or todos'
description: 'WHEN you are asked to turn a plan (an agentic tool''s plan mode), a bashy sprint card and its stories, or a set of todos into a shapeware spec folder that agents can build from: separate behaviour from implementation, later stories override earlier ones, one feature per capability with acceptance lines and status tbd, rules then assertions in CONTRACT.md, an example per input format, open questions listed, conform spec check clean'
tags:
    - shapeware
    - conform
    - spec
    - plan
    - sprint
    - todo
status: candidate
evidence: 'First use: Sprint 727 conversion of the Sprint 537 notepad stories (results to follow)'
source:
    tool: claude
created: "2026-11-26T11:43:01Z"
---

Goal: turn instructions (an agent's plan, or a bashy sprint card with its stories, or a set of todos) into a shapeware spec folder that another agent can build from with no further questions. Format: `docs/shapeware-spec-v0.md`. Worked example of a finished spec: bashy `examples/desk/form` (`CONTRACT.md`, `features.yaml`, `examples/`). Related: [[shapeware-spec-from-app]] when the app already exists; [[spec-to-source-drill]] to test the result.

## Steps
1. **Collect the instructions as given.** For a sprint: `bashy sprint show N` and each story body. For todos: `bashy todo show ID`. For a plan: the plan text. Do not read the app's source, even if it exists; the spec must come from the instructions.
2. **Separate behaviour from implementation.** A story mixes what the app does (commands, outputs, pages) with how to build it (libraries, paths, tests, commit rules). Only behaviour goes into the spec. Record a library or path only when a user or agent would observe it.
3. **Resolve conflicts by date.** Later stories override earlier ones (a renamed command, a changed output). Write the final behaviour; list each override in a short "Decisions" section of `SKILL.md` with the story it came from.
4. **Write `features.yaml`.** One feature per user-visible capability: `id`, `intent`, `effort` (Fibonacci points), `status: tbd`, and `acceptance` lines of the form `command => expected` taken from the instructions.
5. **Write `CONTRACT.md`.**
   - A rules section first: the output envelope and always-present keys, every flag that works on several commands, open versus closed outputs, where errors go and their exit code.
   - Then numbered assertions in dependency order: a command, its expected output, its exit code. Use placeholders (`{ID}`, `{PORT}`, `{TIME}`, `{KEY}`) for run-specific values. Give page requirements as a `ui` assertion on the accessible inventory.
6. **Write `examples/`.** One worked file per input format the instructions name, each used by at least one assertion.
7. **Write `SKILL.md`.** The type line and the standard run block from the format, a behaviour summary that points at the contract, the venue an implementation must run on, and the "Decisions" and "Open questions" sections.
8. **Mark what the instructions do not say.** Where an output shape or an error text is not given, choose the simplest form, state it as a rule, and list it under "Open questions". Never leave a requirement in prose only: if you cannot write an assertion or an acceptance line for it, it is an open question, not a requirement.
9. **Check.** `conform spec check DIR` must report nothing. Fix and rerun until clean.
10. **Reference.** With no app yet, the first build that passes the contract becomes the reference; then certify it (`conform cert`) and measure the suite (`conform mutate`). If an app exists, run the contract against it: every failing assertion is either a spec error or a place where the app left its instructions, and each one is recorded.

## Guardrails
- Do not invent features the instructions do not contain; do not drop ones they do.
- Keep outputs open (`"...": "..."`) unless closing one protects content.
- Text that only a person reads (list formatting, help) is free: require the exit code, not the wording.
- Keep the spec small: an assertion per behaviour, not per example.
