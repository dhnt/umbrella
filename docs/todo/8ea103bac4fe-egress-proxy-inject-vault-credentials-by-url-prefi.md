---
id: 8ea103bac4fe
kind: feature
title: 'egress proxy: inject vault credentials by URL prefix'
seq: 144
status: todo
priority: p2
labels:
    - security
created: 2026-11-11T22:01:36.229285Z
---

Gap 3 of docs/strands-shell-gap-analysis.md. Depends on contain --net public. Acceptance: config maps URL prefix (+optional methods) to a vault secret as bearer header or query param; injected only on the matching outbound request, never re-injected on redirects, never present in agent env/argv/output/audit (redacted); test shows curl to the prefix succeeds with no token in the command.
