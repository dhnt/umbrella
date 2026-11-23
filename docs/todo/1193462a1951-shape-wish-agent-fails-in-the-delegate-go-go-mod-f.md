---
id: 1193462a1951
kind: bug
title: 'shape wish --agent fails in the delegate: ''go: go.mod file not found in current directory or any parent directory'' (agy, codex and claude routes alike)'
seq: 647
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-23T05:52:50.367781Z
sprint: 693
---

Found 2026-11-23 during Sprint 693 S3 on the owner's workstation console (bashy apps on loopback 22749): bashy shape wish dhnt-site --page /about --element 'section=team revision=361e576b8921' --agent agy:gemini4-carbon '<copy edit>' -> status failed, error 'shaping agent: delegate: exit status 1: go: go.mod file not found in current directory or any parent directory'. Identical for codex:gpt6-astra and claude:opus5, and when invoked from a directory that contains a go.mod. The app is the shaped Go module github.com/dhnt/site (root package site, cmd/server). Workaround used: bashy shape wish --from <hand-edited copy>. ROOT CAUSE FIRST (CLAUDE.md): reproduce, find which process runs 'go' outside the candidate module (the delegate's cwd, or a 'go' invocation in the agent bootstrap), classify product/test/venue, then fix where the cause lives (yoke pkg/shape). Not gating for 693; the evidence records the gap.
