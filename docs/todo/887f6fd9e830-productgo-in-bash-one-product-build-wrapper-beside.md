---
id: 887f6fd9e830
kind: refactor
title: 'productgo in Bash#: one product-build wrapper beside bsh (bashsharp), byte-identical to the Go productgo'
seq: 609
status: done
priority: p1
created: 2026-11-21T14:45:17.696569Z
weave: 135
assignee: claude-fable5.2
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T21:09:48.475217Z
closed_by: muse-wonder-full
---

Operator 2026-11-21 (typed): 'yes, file it for 677 and have any agent work on it now'. Today the product build wrapper exists twice in Go (bashy/tools/productgo/main.go ~280 lines of logic, bash/tools/productgo) plus scripts/go-product.sh in each; bsh (bashsharp/cmd/bsh) has none, so its certified build lacks the inherited-signal runtime overlay. What productgo does: go env GOROOT/GOVERSION/GOOS/GOMODCACHE; refuse a GOVERSION other than the verified one; read GOROOT/src/runtime/signal_unix.go; patch it with ONE anchored replacement + appended helpers (patchRuntimeSource, anchor must occur exactly once, fail closed); copy the SDK out when GOROOT is inside GOMODCACHE (overlayRoot); write overlay.json {Replace:{src:patched}}; run go build -overlay=... -trimpath -tags bashy_runtime_snapshot (requireTrimpath; merge caller -tags/-overlay). TASK (expand stage only): add a Bash# implementation beside bsh in the bashsharp repo (e.g. cmd/bsh/productgo.bsh or scripts/productgo.bsh) that does exactly this, plus a build entry for bsh that uses it. Do NOT remove or change the Go copies in bashy/bash (contract later). Acceptance: (1) for go1.27.4, the Bash# version's patched signal_unix.go and overlay.json are BYTE-IDENTICAL to the Go productgo output (test compares both, fail-closed); (2) wrong Go version and missing/duplicate anchor fail closed with the same messages' meaning; (3) bsh built through it passes the existing bsh inherited-signal unit test (inherited_ignore_* in cmd/bsh); (4) Linux/macOS/Windows: Windows needs no overlay (same as Go version) and still builds. Bootstrap: run it with the current released bashy/bsh. Start on current heads; unit tests only; integration at the 677 milestone.

Root-cause log during implementation (new files only):
1. Product syntax in new cmd/bsh/productgo.bsh: Go ':=' binding RHS requires a Go string literal ('"\t...\n..."'), not Bash ANSI-C $'...'; unquoted '/*' inside [[ ]] also quoted as '"/"*'.
2. Product scalar coercion in new cmd/bsh/productgo.bsh: Bash# shell-to-Go argument bridge coerces bare 'false'/'true'/'0'/'1' strings to Bool/Int; prefixed '=' sentinel in parseTrimpathSpec so string '==' stays typed String.
3. Test harness in new cmd/bsh/productgo_test.go: scripts/go-product.sh 'go run' prepended real GOROOT/bin ahead of recording go shim on PATH, and distinct '-o' output names differed in full argv comparison; compiled pinned tools/productgo/main.go once via go build and used a common '-o' path.

Delivery & verification (2026-11-21):
Delivered on bashsharp branch agent/weave-issue-3 at commit 9ccf9a69f165642757b57b9990c0a289d9b1c1c5 (base origin/main 5848aff449cdff4c4fa77696602a93765e863fee; cmd/bsh/go.mod pins bash 42efe30317c4 and coreutils c5832f99ccf6 at current heads). Added cmd/bsh/productgo.bsh, wired DAG.md build-bsh, and added cmd/bsh/productgo_test.go (expand stage only; Go productgo copies in bashy and bash untouched). Dev-box unit verification (go1.27.4, GOWORK=off): go vet . PASS; go test -mod=readonly -v -count=1 ./cmd/bsh PASS (22.74s: TestBshImportBoundary, TestBshModuleRequires, TestInvocationRouting, TestBshBinary, TestProductGoByteIdenticalToGoReference across bsh + bashy --bashsharp and outside/inside GOMODCACHE, TestProductGoFailClosedGuards 8/8, TestBshProductInheritedIgnoredSignals 14/14 across bsh + sh, TestProductGoWindowsNoOverlay shim + PE bsh.exe); front + transpile short tests PASS; BASHY_BUILD_RUN=1 bashy dag build-bsh PASS + SIGTERM inherited-ignore smoke PASS; scrub-gate.sh PASS. Container/86-fixture/e2e integration gates deferred to Sprint 677 milestone per operator policy. Pre-existing unrelated note: root bashsharp go.sum lacks Darwin go-isatty sum when running GOWORK=off on ./cli outside Linux image (untouched).
