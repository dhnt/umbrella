---
id: f42dbcbcb006
kind: test
title: pin agent Bash-tool wrapper scripts as regression fixtures
seq: 146
status: todo
priority: p2
labels:
    - agent
created: 2026-11-11T22:01:36.366465Z
---

Gap 5 of docs/strands-shell-gap-analysis.md. bashy is the shell agent CLIs run on. Acceptance: fixture tests in bashy run the Claude Code Bash-tool wrapper (snapshot source, shopt -u extglob, eval '...' < /dev/null, pwd -P >| cwdfile) and the known Codex/OpenCode wrappers with no diagnostics and correct cwd persistence.
