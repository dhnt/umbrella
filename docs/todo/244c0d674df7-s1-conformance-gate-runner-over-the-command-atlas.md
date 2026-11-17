---
id: 244c0d674df7
kind: feature
title: S1 Conformance gate runner over the command atlas
seq: 414
status: todo
priority: p1
labels:
    - yoke
created: 2026-11-17T18:49:46.15739Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: no suite measures commands against the contract (pillar recipe step 4; analog of the Bash 86/86 and POSIX gates).
Behavior: table-driven runner iterating pkg/atlas; per command x common option records conform / adapted / declared-unsupported (exit 2) / FAIL, keyed by command and fixture name, never by count. Scores the ~35 featured commands first. Runs in the official bashy-base image via bashy oci on the gate host; no hosted CI.
Depends on: S0.
Verification: two runs at the same commit produce identical per-name results; raw evidence recorded on the story.
