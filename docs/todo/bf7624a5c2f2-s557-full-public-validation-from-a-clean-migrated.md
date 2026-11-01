---
id: bf7624a5c2f2
kind: test
title: S557 full public validation from a clean migrated umbrella checkout
seq: 6
status: assigned
priority: p1
created: 2026-11-01T09:25:51.180429Z
assignee: s557-public-tooling
sprint: 557
sprint_id: f5ccf563-f5d1-5b94-8be4-9388e51ef86d
sprint_title: 'Bashy v1.0.0 preparation: split private/public development and retire qiangli/dhnt'
---

Provide reproducible manual CI validation on public hosted runners for the migrated umbrella, using existing subproject test entrypoints and exact gitlink candidate identities. Cover independent GOWORK=off build resolution plus workspace unit suites and Bashy make test, Bash compatibility, Bash# corpus and relevant public conformance runners. Linux/macOS/Windows native coverage must report real results with explicit platform applicability. Run foreign suites only in existing containment runners. Licensed VSC remains private and separate. No release tags or publishing. Keep all paths/host references public-safe. Manager will dispatch and inspect actual results.
