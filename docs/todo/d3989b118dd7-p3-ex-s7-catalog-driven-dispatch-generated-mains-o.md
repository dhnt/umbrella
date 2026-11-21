---
id: d3989b118dd7
kind: feature
title: 'P3 (ex-S7): catalog-driven dispatch + generated mains + on-demand slot builds; one-command pilot'
seq: 557
status: todo
priority: p1
labels:
    - bashy
    - yoke
    - shape
    - architecture
created: 2026-11-20T10:01:54.093407Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repos: bashy, yoke. Re-scoped to v3 P3 (mechanism story; S1 build-speed lands inside this phase). bashy becomes thin entry: bsh engine + agentic hooks + generic catalog-driven dispatcher (internal/agentos switch becomes catalog entries). Builder generates a tiny main per command from its catalog entry (package + module version), builds on demand into shape slots reusing yoke/pkg/shape/slot (Stage/Select/Activate/Undo/Restore) + tree-hash build cache. Sources stay in their packages; NO optional/ folder. Pilot: ONE command end to end; measure edit->verified-active-slot cycle in minutes vs P1 whole-bashy number. UX unchanged: bashy <verb>.

## Delivery & Measurements (2026-11-21, dev box darwin/arm64, Go 1.27.4)

### Commits (bashy)
- `45a897f2` — Stage 0 (S1 `d49c099b4a6f`): `tools/productgo` content-addressed SDK/overlay cache, `scripts/go-tool.sh` `bin/.tools/` cache, `scripts/build-meet-spa.sh optional` content-fresh skip + regression tests.
- `27689a28` — Stage 1 (generator): `internal/cmdgen` + `tools/cmdgen` CLI + golden tests (`cobra_simple`, `cobra_wired`, `tool_applet`, `func_entry`) + tree-hash build cache (`<BASHY_HOME>/shape-cache/cmd/<name>/<treeHash>/`) + `yoke/pkg/shape/slot` integration.
- `faa95fb2` — Stage 2 (routing): `internal/agentos/cmdcatalog` (per-verb embedded YAML directory `entries/*.yaml`) + `internal/agentos/catalog_dispatch.go` routing through the existing `shapeSlotSelect` / `shapedRegisteredArgv` / `slot.EntryEnvironment` / `shapeSlotLaunch` path; preserves `VSC_PROFILE=cert`, `bashy_monolith`/`bashy_scratch` build tags, and `BASHY_CMD_DISPATCH=inprocess`.
- `2eb7b8c0` — Stage 3 (pilot): `internal/agentos/cmdcatalog/entries/stats.yaml` + `TestPilotCatalogDispatchE2E` (`stats` end-to-end).
- `e4318f52` — Root-cause fix: `parseGoWork` canonicalizes relative `-gowork` paths via `Abs`/`EvalSymlinks` before resolving workspace `use`/`replace` entries (pinned by `TestParseGoWorkResolvesRelativePaths`).

### Root causes recorded before fixes (Directive #3)
1. `TestBuildCacheAndShapeSlotLifecycle` failed on first run (`module not listed in go.work`): macOS `/var` -> `/private/var` symlink mismatch between `os.MkdirTemp` (`cmd.Dir`) and `go.work` `use "."`. Fixed in `internal/cmdgen/build.go` by calling `filepath.EvalSymlinks` on `genWork` and `LocalModules`.
2. `TestPilotCatalogDispatchE2E` step 4c failed on first run (`open .../yoke-edited/pkg/llmgw/go.mod: no such file`): test fixture defect — `yoke/go.mod` carries relative `./pkg/*` and `./external/*` replaces that the partial copy fixture omitted. Fixed in `copyYokeStatsSubset` by symlinking sibling entries while copying `pkg/stats`.
3. `tools/cmdgen -gowork ../go.work` failed (`open ../yoke/go.mod: no such file`): product defect in `parseGoWork` — `filepath.Dir("../go.work")` stayed relative when copied into temp build dir. Fixed in `e4318f52` with `TestParseGoWorkResolvesRelativePaths`.

### Measured Cycle Time & Sizes (dev box, darwin/arm64, Go 1.27.4)
- **Pilot (`stats`, `github.com/qiangli/yoke/pkg/stats.NewCmd`)**:
  - Edit -> verified-active-slot cycle (`TestPilotCatalogDispatchE2E`): **1.415s (0.024 min)** total
    - Targeted package tests (`go test ./pkg/stats`): **601ms**
    - Generate + tree-hash build + `slot.Stage` + `slot.Activate`: **414ms**
    - Live verification through unchanged `bashy stats summary --json`: **399ms**
  - Cold on-demand build + slot Stage/Activate + live dispatch: **3.421s (0.057 min)** (`tools/cmdgen -build` warm cache-miss compile: **468ms**)
  - Warm slot dispatch via bare-name shell shim (`bashy -c 'stats summary --json'`): **92ms**
  - Standalone `stats` slot binary size: **3,347,202 bytes (3.19 MiB)** vs whole `bin/bashy` **242,152,610 bytes (230.94 MiB)** (**72.3x smaller**)
  - Transitive package count: **98** (`yoke/pkg/stats`) vs **2,286** (`./cmd/bashy`) (**23.3x fewer**)
- **Comparison vs whole-bashy baseline**:
  - Pre-S1 dev-box warm `build` baseline (`docs/plan-sprint-677-fast-build-small-binary-shaping.md`): **45–60s (0.75–1.00 min)** build-only (before tests/install); pilot cycle (**0.024 min**) is **32–42x faster** than pre-S1 warm build alone.
  - Post-S1 dev-box warm `bashy dag build-bashy`: **6.335s (0.106 min)**; warm `bashy dag build` (`bash` + `bashy` + `elfaudit` + `releaseeligibility`): **7.342s (0.122 min)** (down from 45–60s, beating the `<15s` S1 target by >2x). Note: P1 (`befc2403`) on the gate host deferred its whole-bashy rebuild-verify cycle pending gate-host keep-alive.

### Parallel P4 Worker Usage
Parallel P4 workers add disjoint `<verb>.yaml` files under `bashy/internal/agentos/cmdcatalog/entries/` (zero merge conflicts) and invoke `tools/cmdgen` over disjoint verb-list files:
```sh
go run ./tools/cmdgen -catalog internal/agentos/cmdcatalog/entries \
  -verbs-file batch-p4a.txt -gomod go.mod -out /tmp/p4a-mains [-build -gowork ../go.work]
```

### Targeted Dev-Box Gates Executed
- `go test -v ./tools/productgo` — PASS (14.38s; down from 26.40s pre-S1)
- `bashy dag test-build-fail-closed` — PASS
- `bashy dag test-meet-spa-fresh-regression` — PASS (7/7 including optional skip/invalidation + required unconditional rebuild)
- `go vet ./internal/cmdgen ./tools/cmdgen ./internal/agentos/cmdcatalog ./internal/agentos` — PASS
- `go test -v ./internal/cmdgen ./tools/cmdgen` — PASS (4 golden main tests, disjoint verb lists, go.mod resolution, tree-hash cache + `slot.Store` Stage/Select/Activate/Undo/Restore, relative `go.work`)
- `go test -v -run 'TestPilotCatalogDispatchE2E|TestCatalogDispatch' ./internal/agentos` — PASS (end-to-end pilot dispatch, JSON/`--help`/exit-code parity, shell shim, edit->verified-active-slot cycle, Undo + Restore release)
- `go test -run 'TestCommands|TestAtlas|TestRegistered|TestShapeSlot|TestCatalogDispatch|TestNoCompletion' ./internal/agentos` — PASS
- `go build -tags bashy_monolith -o /dev/null ./cmd/bashy` and `-tags bashy_scratch` — PASS
- `CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o /dev/null ./cmd/bashy` — PASS
- `GOWORK=off go build -o /dev/null ./cmd/bashy` — PASS
- Full 3-OS dispatch e2e (`TestE2EAllListedCommandsDispatch`) deferred to the sprint-final gate per 2026-11-21 replan.
