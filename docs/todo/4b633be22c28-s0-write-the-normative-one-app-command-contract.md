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

Problem: yoke has the engine (pkg/atlas, registry, binmgr) and adapters (pkg/adapt, fleet.Adapter rows) but no written contract, so each verb's agent-facing behavior is ad hoc. Pillar (c) 'one app' needs a borrowed standard as pillars (a) Bash/POSIX and (b) Go spec have.
Behavior: write yoke/docs/command-contract.md, normative, borrowing existing standards: POSIX XBD 12.2 utility syntax guidelines plus --help/--version; common options --json, --fields, --null, --dry-run, --no-input, --explain (as declared in pkg/adapt); one versioned result envelope (status, data, error, hint; schema_version); exit codes 0/1/2/126/127 plus 6 = yield as in Bash#; effects metadata (destructive, network, pairing, cost) aligned with atlas axes; the MCP projection rule (a conforming command is an MCP tool: input schema from flags, output from envelope); apps join by exposing actions as conforming commands, web UI is a view over them (UI->CLI parity one-way); declared-unsupported options fail loudly with exit 2.
Depends on: none. Spec for Sprint 655.
Verification: doc reviewed and accepted by the operator; doc index lines added in yoke.
