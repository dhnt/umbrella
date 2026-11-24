---
id: 2f6d27f53940
kind: task
title: 'table is Linux only: recorded exception for group shaping'
seq: 694
status: todo
priority: p3
labels:
    - group-shaping
created: 2026-11-24T11:57:47.502341Z
---

Found by the group-shaping coverage matrix (docs/group-shaping-coverage-matrix.md). Evidence: bashy/examples/table/table.bsh:54-56 linux_only() exits unless uname is Linux, called by install (:73) and start (:146); README.md:3,10 say Linux is required. The app is a Grist fork (shape-adapter/main.go:65-66 data under docs and landing.db). No guest door found; the CLI needs TABLE_TOKEN (README.md:97-98); no revision store (Grist owns its storage). Recorded exception: the group-shaping run cannot cover table on macOS or Windows hosts; decide whether to keep Linux-only or add a host route.
