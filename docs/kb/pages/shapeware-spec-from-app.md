---
id: 01a21794-386b-7432-bdb3-1af7421cfcb1
seq: 25
form: page
type: runbook
title: 'Write a shapeware spec from an existing app (reverse: app to spec)'
description: 'WHEN you draft or repair a shapeware spec (CONTRACT.md, features.yaml, examples) for an app that already exists and others must be able to rebuild it from the spec alone: assertions from real outputs, rules stated once, a worked example per input format, UI as checkable rules, behaviour separated from operations, then conform spec check, cert and mutate'
tags:
    - shapeware
    - conform
    - spec
    - contract
status: candidate
evidence: 'bashy examples/desk/form spec v2 (bashy 44c4d966): reference cert 14/14, 109/109 mutants; conform spec check clean on v2, flags three gaps on v1'
source:
    tool: claude
created: "2026-11-26T11:18:39Z"
---

Goal: write a shapeware spec for an app that already exists, sound enough that another builder can reproduce it from the spec alone. Soundness criteria: `docs/shapeware-spec-v0.md` section 20. Worked example: the bashy form app (spec v1 to v2, Sprint 723).

## Steps
1. **List the behaviours** from the app's commands and pages, not from its source layout. One assertion per behaviour: the command, the expected output, the exit code.
2. **Record real outputs.** Run the reference and paste what it prints. Replace run-specific values with placeholders (`{ID}`, `{PORT}`, `{TIME}`, `{KEY}`).
3. **Write the rules once, above the assertions:**
   - the output envelope and any always-present key;
   - every flag that works on several commands (for example a projection flag), defined in words;
   - open versus closed outputs, and why a closed one is closed;
   - where errors go and their exit code.
4. **Every input format gets a worked example file** that an assertion actually uses. A format named only in prose will be skipped by builders.
5. **UI as checkable rules:** one control per field, a programmatic label, how required fields are marked, allowed control kinds per field kind, button names. Add one page-interaction line: fill by label, submit, read back through the CLI.
6. **Separate behaviour from operations.** How the reference is built, served and worked around goes in its own section, marked as not required of other implementations.
7. **Features file:** each feature has an id, an intent, an effort estimate and at least one acceptance line.
8. **Check and prove:**
   - `conform spec check DIR` reports nothing;
   - `conform cert` passes the reference 3 times with no noisy assertion;
   - `conform mutate` kills every mutant. A surviving mutant is a missing assertion.
9. **State the venue** a rebuilt app must run on (OS, interpreter and toolchain versions, network, what is not installed).

## Guardrails
- If you cannot write an assertion for a sentence, it is not a requirement yet. Delete it or demonstrate it.
- Do not close an output just because the reference prints exactly those keys. Close only what protects content.
- Vary nothing in hidden cases that the spec does not document.
