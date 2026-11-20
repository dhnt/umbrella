---
id: e69b68ec7132
kind: enhancement
title: 'S4: Tree-sitter grammar tiering for bashy (grammar_set_bashy: 22 used languages vs 201 blobs, -11 to -16 MB)'
seq: 554
status: todo
priority: p1
labels:
    - gotreesitter
    - yoke
    - bashy
    - size
created: 2026-11-20T10:01:53.685161Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repos: gotreesitter, yoke, bashy. Complete docs/TODO.md Tree-sitter grammar tiering: gotreesitter/grammars currently embeds all 201 grammar_blobs/*.bin (20.37 MB), while yoke/pkg/treesitter and gfy/pkg/extract use 22 languages (~9.2 MB, or ~3.1 MB without swift/kotlin). Add a build tag / curated embed tier for bashy's used grammars with clean fallback / external blob loading for unembedded grammars. Acceptance: yoke/pkg/treesitter, cmds/ast, and gfy/pkg/extract tests plus pkg/atlas/localfirst_test.go pass; binary shrinks by ~11-16 MB. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
