---
id: 1f250acd8cec
kind: task
title: bashy .goreleaser.yaml ShellRuntimeCommit ldflag targets wrong module path
seq: 140
status: todo
created: 2026-11-11T21:43:42.047849Z
---

Found in Sprint 617 review (2026-11-11). bashy/.goreleaser.yaml ldflags (lines ~49, ~75) set -X github.com/qiangli/bashsharp/transpile.ShellRuntimeCommit, but the module is github.com/bashsharp/bashsharp; the Go linker ignores -X for packages not in the build, so the stamp is probably never applied. Root cause first: inspect the stamp in a built release binary. Fix: correct the package path; verify the value in a goreleaser snapshot build.
