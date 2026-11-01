---
id: 8a29757a7349
kind: chore
title: S557 modernize public bootstrap, sync, CI and developer instructions
seq: 5
status: assigned
priority: p1
created: 2026-11-01T09:18:54.061398Z
assignee: s557-public-tooling
sprint: 557
sprint_id: f5ccf563-f5d1-5b94-8be4-9388e51ef86d
sprint_title: 'Bashy v1.0.0 preparation: split private/public development and retire qiangli/dhnt'
---

Own only public umbrella script/bootstrap.sh, script/sync.sh, .github/workflows/test.yml, CLAUDE.md, docs/build.md (and relevant existing doc index entry if needed). Parent owns .gitmodules and go.work, adding agent-bench/gotreesitter/yamux to total 18 public submodules. Rewrite obsolete sibling replace documentation for version-pinned standalone GOWORK=off builds plus root go.work sibling development. All modules now Go 1.27 toolchain 1.27.2. sync must discover submodules from .gitmodules, clean-check first, fetch no recurse, fast-forward canonical branch and hydrate nested pins, stage gitlinks only; never edit/commit/push consumer dependencies automatically or overwrite unknown work. Bootstrap should hydrate pinned modules, install existing hooks and explain workspace vs standalone mode. Fix CI shell syntax loop so every script is checked, preserve scrub and gitlink checks. No private source/names/hostnames/paths in public docs. Do lightweight shell checks; no builds or full suites on development host. No commits until manager review.
