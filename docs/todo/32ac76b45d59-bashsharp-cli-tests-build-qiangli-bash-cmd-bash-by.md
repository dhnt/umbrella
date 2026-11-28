---
id: 32ac76b45d59
kind: task
title: 'bashsharp cli tests build qiangli/bash/cmd/bash by package path: GOWORK=off go test ./cli fails (go.work-only dependency)'
seq: 867
status: todo
created: 2026-11-28T19:04:44.501941Z
---

Pre-existing (identical at bashsharp 0ec897e, found in Sprint 746 U3 on the Windows test host's Linux lane): with GOWORK=off every cli test whose helper (builtBashBin, cli/carrier_unix_test.go:54) builds github.com/qiangli/bash/cmd/bash fails 'no required module provides package'; bash/cmd is a nested module that itself requires bashsharp (cycle), so bashsharp cannot require it. Green in workspace mode. Options: build the shell under test from bashsharp's own cmd (cmd/bashsharp or a test main via TestMain re-exec), or move those tests to bash/cmd. Not repaired in 746 (out of MVP).
