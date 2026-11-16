---
id: eedbeea2e096
kind: bug
title: 'go.work: conflicting filebrowser-quantum replaces break the umbrella workspace build'
seq: 381
status: todo
priority: p2
labels:
    - build
created: 2026-11-16T11:25:15.6096Z
---

Symptom (2026-11-16): any workspace-mode build at the umbrella root, e.g. 'go build ./cmd/bashy' in bashy/, fails with: conflicting replacements for github.com/gtsteffaniak/filebrowser/backend: qiangli/filebrowser-quantum/backend@...-40f3c84d55a9 vs @...-88b90a50350d. GOWORK=off builds are unaffected.

Root cause (build/config defect): members pin different commits of the File Browser fork. yoke (d160182c, 2026-11-14) and bashy (8a6dd8cf, rc.34 pins) moved to 40f3c84d; outpost/go.mod:353 and ycode/go.mod:16 still pin 88b90a50. The go.work header says version-scoped replaces resolve fork pin splits, but it has no entry for gtsteffaniak/filebrowser/backend (it only covers filebrowser/filebrowser/v2).

Note: 40f3c84d is the commit that removed the unlicensed go-cache/go-logger from the graph, so outpost and ycode on 88b90a50 likely still carry them.

Fix options: (a) preferred: bump outpost and ycode to filebrowser-quantum 40f3c84d (also aligns the license cleanup), then pin-bump the umbrella; (b) add a workspace replace for github.com/gtsteffaniak/filebrowser/backend in go.work. Verify with a workspace-mode build of bashy/cmd/bashy plus each module's GOWORK=off build.
