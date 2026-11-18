---
id: 4b633be22c28
kind: doc
title: S0 Write the normative one-app command contract
seq: 413
status: todo
priority: p1
labels:
    - yoke
created: 2026-11-17T18:49:46.007633Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: yoke has the engine (pkg/atlas, registry) and common options (pkg/adapt) but no written contract, so each command's agent-facing behavior is ad hoc. "One app" means bashy behaves as one coherent app for users and agents: a contract on observable behavior, never on implementation. Plan: docs/plan-sprint-655-one-app.md.
Behavior: write yoke/docs/command-contract.md, short and normative, borrowing existing standards: POSIX XBD 12.2 utility syntax plus --help/--version; the common options as pkg/adapt declares them (--json, --fields, --null, --dry-run, --no-input, --explain) with their existing rules; one versioned result envelope (schema_version, status, data, error, hints) with existing hint/recommend records as kinds of it; exit codes 0/1/2 (usage or declared-unsupported option)/126/127 plus 6 = yield as in Bash#; effects metadata aligned with atlas axes; apps: every UI action has an equivalent CLI command; conformance is optional: commands and apps (including third-party ones from commands add / app add / shaped apps) register as today and may be made to conform, e.g. by shaping; tiers (experimental/preview/supported) stay the declarer's choice. Add a small reference package in yoke (envelope type, exit-code constants) next to pkg/adapt, and publish the contract where shaping agents look it up (bashy skill doc or kb page).
Depends on: none.
Verification: doc reviewed and accepted by the operator; reference package tests green; doc index lines added in yoke.
