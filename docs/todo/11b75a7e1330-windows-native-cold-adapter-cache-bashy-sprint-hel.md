---
id: 11b75a7e1330
kind: bug
title: 'Windows native, cold adapter cache: ''bashy sprint --help'' runs ''go'' outside any module (''go: go.mod file not found'') instead of building the adapter; dispatch e2e red on Windows'
seq: 626
status: todo
priority: p0
labels:
    - bashy
    - windows
    - adapter
    - release
created: 2026-11-22T16:00:50.038804Z
sprint: 692
---

Candidate gate leg 4b (umbrella 8b8db523f, docs/sprint-677-integration-evidence.md): on the Windows-native gate resource, fresh install, BASHY_ADAPTER_CACHE empty, TestE2EAllListedCommandsDispatch fails on one assertion: commands_e2e_test.go:274 'sprint help does not carry the owner-accountability contract', got 'go: go.mod file not found in current directory or any parent directory; see go help modules Error: exit status 1'. Every other listed verb passed; Linux and macOS with the same cold cache passed. The Windows host carries no Go toolchain or source tree by design, so the adapter's cold build must go through the toolchain adapter / BASHY_ADAPTER_INPROC path and resolve the adapter source (source pin or embedded script + module). ROOT CAUSE FIRST: reproduce on the Windows-native gate resource (claim it; reach it the way run #148 did) with a cold cache and BASHY_ADAPTER_DEBUG/-x on the sprint.bsh adapter: which directory does 'go' run in (here= derivation from BASH_SOURCE on Windows paths? the embedded-adapter materialized path has no main.go beside it?) and which go is invoked. Then the smallest product fix in the adapter template (regenerate all adapters + adapterembed; TestEmbeddedAdaptersMatchSourceTree) or in resolveAdapterScript, with a unit test that models the Windows path shape. Verify: the e2e on the Windows-native resource passes from a fresh install with an empty cache (record exit code and wall time here). Owner codex (second codex instance), --repo bashy. TEST RULE (operator 2026-11-22): build + smallest targeted unit tests only, then submit; the re-run of the red gate legs is the conductor's. Root cause recorded on this story BEFORE the fix. Start on current origin main of each repo touched; Sprint/Story/Story-ID + Agent trailers; submodule commit first (do not push), the conductor merges and bumps pins. Long remote commands: nohup + poll, never block one command for more than a minute.
