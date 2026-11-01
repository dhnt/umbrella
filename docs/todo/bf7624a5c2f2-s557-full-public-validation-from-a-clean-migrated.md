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

2026-11-01 SDK prerequisite repair: focused run 41333468936 exposed raw
`go mod download` leaving the toolchain module non-executable with `_go.mod`
files. `script/initialize-reviewed-sdk.py` now initializes the exact Go1.27.2
coordinate following `src/cmd/go/internal/toolchain/select.go`: authenticate
bin/go using the public build-toolchains.tsv pin before changing modes, enable
pkg/tool and matching lib helpers before gofmt/bin/go, then copy nested module
files before src/go.mod. Payload bytes and original directory modes are
preserved. The download JSON is retained; bounded SDK `version` and compiler
`-V` checks must match before validation proceeds. Synthetic initialization,
idempotence, byte/mode preservation, hash/coordinate rejection, and symlink
rejection tests passed (3 tests); bash syntax and ShellCheck passed. No full
SDK copy, build, or local suite was run. Hosted Linux/macOS rerun remains the
acceptance requirement; no test exclusions or product SDK policy changes.
