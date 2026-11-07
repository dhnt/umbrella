---
id: 72c55602dd2e
kind: test
title: 'S0 Layer ratchets: per-layer import tests with shrink-only allowlists'
seq: 23
status: done
priority: p0
labels:
    - layer-separation
created: 2026-11-06T21:04:31.422072Z
assignee: claude-sonnet5.5
sprint: 580
sprint_id: 0cae3983-9725-5e31-b45d-3585e97e00de
sprint_title: Bashy checkpoint and release candidate v1.0.0-rc.25
closed: 2026-11-07T01:43:25.012898Z
closed_by: claude-opus5.5-s580
---

Problem: nothing stops new cross-layer imports while fixes land. Change: extend sh/interp/gosource_dependency_test.go (ban gosource/lower/grammar; polyglot allowlisted until S5), bashy/internal/agentos/import_graph_test.go (cmd/bash bans yoke, coreutils, bashsharp, sh/polyglot; bashsharp+polyglot allowlisted until S3), bashy/cmd/bashy/core_imports_test.go (cert base bans all github.com/qiangli/yoke and bashsharp/transpile; allowlisted until S1/S2), new coreutils cmd/coreutils test (ban yoke, bashsharp, sh/{polyglot,gosource,lower,grammar}; polyglot allowlisted until S4); umbrella script/layer-gate.sh runs all GOWORK=off. Record current TestCoreImportBoundary status as pre-existing (yoke/pkg/telemetry linked via internal/core->yoke/pkg/fleet). Exit: green on pinned SHAs; mutation proof; allowlist entries each name their removing story. Plan: docs/plan-s575-master-execution.md
