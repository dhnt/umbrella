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
Behavior: yoke/docs/command-contract.md, short and normative, with stable requirement IDs C1-C15: POSIX XBD 12.2 syntax plus --help/--version; the pkg/adapt common options (--json, --fields, --null, --dry-run, --no-input, --explain) with fixed meanings; unsupported options exit 2; one result envelope = the shipped coreutils/pkg/weavecli Envelope (schema_version loom-v2, additive changes only); stderr hint/recommend records are side-channel; exit codes 0-6 from weavecli (6 = input_required = Bash# yield), 125 wrapper, 126, 127, 128+n; atlas effects and reversibility; app CLI parity; conformance optional; tiers the declarer's choice.
Decision 2026-11-18 (KISS): no new reference package. The reference implementation is the existing coreutils/pkg/weavecli (about 100 call sites), so commands adopt the contract by using it; a new yoke package would duplicate it. yoke has no docs index, so no index line applies.
Draft: yoke 1b6deefa (docs/command-contract.md).
Observed gap for the S1 checker: BASHY_HINTS=off does not suppress the bashy-recommend-v1 record after `bashy sprint nosuch` (C12).
Depends on: none.
Verification: operator accepts the doc.
