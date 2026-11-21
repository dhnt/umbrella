---
id: d49c099b4a6f
kind: enhancement
title: 'S1: Cache productgo SDK overlay, cache go-tool binaries, and skip redundant optional meet-spa rebuilds'
seq: 551
status: todo
priority: p1
labels:
    - build
    - bashy
created: 2026-11-20T10:01:53.271864Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. Lands in P3 with the dispatch mechanism (v3). (1) tools/productgo: deterministic content-addressed SDK overlay cache keyed by GOVERSION+sourceHash+patchHash (on go1.27.4 after story A), verifying signal_unix.go hash every run, preserving Go build cache. (2) scripts/go-tool.sh: cache compiled tool binaries under bin/.tools/. (3) scripts/build-meet-spa.sh optional: skip pnpm+vite when artifact is content-fresh. Acceptance on DAG targets (never make): warm bashy dag build/install time recorded vs P1 baseline; dag test-build-fail-closed + test-meet-spa-fresh-regression pass; feeds the P3 shaping-cycle metric.

## Delivery & Measurements (2026-11-21, landed inside P3 `d3989b118dd7`, dev box darwin/arm64, Go 1.27.4)
- Commit (bashy): `45a897f2`
- Warm `bashy dag build-bashy`: **6.335s** (vs 45–60s pre-S1 dev-box baseline)
- Warm `bashy dag build` (`bash` + `bashy` + `elfaudit` + `releaseeligibility`): **7.342s** (<15s target beaten by >2x)
- `scripts/go-tool.sh releaseeligibility`: **7.152s -> 0.046s** (cached under `bin/.tools/`)
- `tools/productgo` test suite: **26.40s -> 14.38s** (with `TestProductOverlayCacheDeterministicAndFailClosed` proving deterministic reuse and fail-closed tamper rejection)
- `scripts/build-meet-spa.sh optional`: skips pnpm+vite when `(web, artifact)` fingerprint matches stamp; `required` and `check` still build fresh unconditionally (`bashy dag test-meet-spa-fresh-regression` 7/7 PASS)
- `bashy dag test-build-fail-closed`: PASS
