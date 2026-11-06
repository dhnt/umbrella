---
id: 72c55602dd2e
kind: test
title: 'S0 Layer ratchets: per-layer import tests with shrink-only allowlists'
seq: 23
status: todo
priority: p0
labels:
    - layer-separation
created: 2026-11-06T21:04:31.422072Z
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
---

Problem: nothing stops new cross-layer imports while fixes land. Change: extend sh/interp/gosource_dependency_test.go (ban gosource/lower/grammar; polyglot allowlisted until S5), bashy/internal/agentos/import_graph_test.go (cmd/bash bans yoke, coreutils, bashsharp, sh/polyglot; bashsharp+polyglot allowlisted until S3), bashy/cmd/bashy/core_imports_test.go (cert base bans all github.com/qiangli/yoke and bashsharp/transpile; allowlisted until S1/S2), new coreutils cmd/coreutils test (ban yoke, bashsharp, sh/{polyglot,gosource,lower,grammar}; polyglot allowlisted until S4); umbrella script/layer-gate.sh runs all GOWORK=off. Record current TestCoreImportBoundary status as pre-existing (yoke/pkg/telemetry linked via internal/core->yoke/pkg/fleet). Exit: green on pinned SHAs; mutation proof; allowlist entries each name their removing story. Plan: docs/plan-s575-master-execution.md
