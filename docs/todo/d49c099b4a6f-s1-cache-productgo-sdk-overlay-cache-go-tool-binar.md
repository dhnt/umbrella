---
id: d49c099b4a6f
kind: enhancement
title: 'S1: Cache productgo SDK overlay, cache go-tool binaries, and skip redundant optional meet-spa rebuilds'
seq: 551
status: todo
priority: p0
labels:
    - build
    - bashy
created: 2026-11-20T10:01:53.271864Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. (1) In tools/productgo/main.go, replace per-invocation os.MkdirTemp SDK copies (500 MB os.CopyFS) with a deterministic content-addressed cache directory keyed by GOVERSION + sourceHash + patchHash, verifying signal_unix.go SHA-256 on every run so Go's runtime build cache is preserved across invocations. (2) In scripts/go-tool.sh, cache compiled tool binaries (e.g. releaseeligibility) under bin/.tools/ instead of rebuilding from scratch in mktemp -d on every build (saves ~9.7s). (3) In scripts/build-meet-spa.sh optional, skip pnpm install + vite build when ../yoke/pkg/meet/artifact is already up to date with ../yoke/pkg/meet/web (keep required and check building fresh). Acceptance: warm make build/install completes in <15s (down from ~55s); make test-build-fail-closed and make test-meet-spa-fresh-regression pass. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
