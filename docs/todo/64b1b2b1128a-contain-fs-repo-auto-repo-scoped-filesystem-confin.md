---
id: 64b1b2b1128a
kind: feature
title: 'contain --fs repo: auto repo-scoped filesystem confinement for agents'
seq: 148
status: todo
priority: p2
labels:
    - security
created: 2026-11-11T22:01:36.502009Z
---

From docs/strands-shell-gap-analysis.md. Design agreed with the operator 2026-11-11: the git repo, plus what its own content declares it reaches, is the automatic allow set, rather than hand-written path binds.

Allow set (computed from cwd at process start):
- read-write: worktree root (git rev-parse --show-toplevel), its git common dir (worktrees/weave workspaces), submodule git dirs (.git/modules/...)
- read-only: declared reach only: go.work `use` entries, go.mod `replace ../x`, .gitmodules
- toolchain/runtime: system paths and SDK roots read-only; Go module/build caches, TMPDIR and ~/.bashy state read-write
- everything else denied by omission: credential dirs (~/.ssh, cloud CLI configs, vault store, browser profiles), other repos, the rest of $HOME

Mechanics:
- Linux: Landlock (unprivileged, inherited by children, can only narrow). Applied per process at start, keyed off cwd; this fits per-command agent invocation, and a different repo means a new process.
- macOS: Seatbelt subpath profile, extending the existing contain_darwin.go path.
- Windows: no unprivileged equivalent, so use the container route; per the cross-OS parity rule, fail closed (exit 125), never run silently unconfined.
- Symlinks escaping the allow set are refused at open.
- A denial is surfaced as a structured hint naming the path and the escape `--allow-path P`, routed through effect-derived confirmation, not a bare EACCES.

Rollout (two steps):
1. Opt-in `contain --fs repo` / `@contain`. Dogfood on our own agent sessions with every denial logged to the audit log.
2. Only after the denial log is clean, make it the default for agent sessions (BASHY_AGENTIC), with an explicit opt-out.

Acceptance (step 1): on Linux and macOS, inside a repo, reads/writes in the worktree and declared siblings succeed; reads of ~/.ssh and of another repo are denied with the structured hint; go build/test and git commit work; on Windows, --fs repo either uses the container route or exits 125. Unit tests for allow-set computation (plain repo, worktree, submodule superproject, go.work siblings).
