---
id: 41997de0a4d5
kind: bug
title: 'Adapter first-use build inherits exported GOOS/GOARCH: cross-build env makes the dag adapter unrunnable (Invalid argument)'
seq: 637
status: wontfix
priority: p2
labels:
    - post-rc40
    - adapter
created: 2026-11-22T21:18:39.252085Z
sprint: 694
closed: 2026-11-27T22:46:17.061301Z
---

Seen 2026-11-22 on the puppy Linux machine with the candidate tree (bashy 092e1dce on 2cc8a8c2): GOOS=windows GOARCH=amd64 ./bin/bashy dag build-bashy ... -> /root/.cache/bashy/adapters/yoke/dag: Invalid argument on every target. The adapter cold build compiled yoke/dag for the exported target OS. Workaround: pass GOOS/GOARCH/CGO_ENABLED/BIN_DIR as dag VAR operands (body-scoped) and rm -rf ~/.cache/bashy/adapters/yoke/dag*. Fix: the adapter builder must force host GOOS/GOARCH (and CGO_ENABLED) regardless of the caller's env; related to 42f79daa/3dd8b4ec.
