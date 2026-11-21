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
