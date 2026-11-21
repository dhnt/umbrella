---
id: 195027c96521
kind: chore
title: 'A: go1.27.4 toolchain for bashy + outpost (tool) with productgo overlay re-pin'
seq: 585
status: assigned
priority: p0
created: 2026-11-21T08:29:57.32075Z
weave: 108
assignee: codex-gpt6.2-sol
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Phase 0A. Operator: do a clean job whatever it takes now. SPLIT (conductor 2026-11-21): (a) CODE WORK NOW in parallel with P1 - bump toolchain go1.27.2 -> go1.27.4 in EVERY module that compiles into a shipped binary or is scanned by the release vuln gate: bashy, outpost, yoke, coreutils, bashsharp, bash, sh (fork) - all verified at go1.27.2 at filing - plus tools/ and examples/ modules (P4 builds them on demand); record any module left at go1.27.2 here with a reason. productgo re-pin: bashy/tools/productgo/main.go:102 rejects GOVERSION != go1.27.2; update + RE-VERIFY signal_unix.go hash/patch vs go1.27.4 SDK (stop + record here if the patch no longer applies). Submodule-first per repo in your workspace (commit inside each submodule clone, umbrella pin last); dev-box targeted tests only (productgo tests, dag build). (b) DEFERRED until P1 baseline + gate-host keep-alive: gate-image rebuild (image.lock rolling rule, EXCLUSIVE gate-host claim) and fresh Bash 5.3 86/86 both modes by fixture name vs rc.39 evidence - do NOT attempt long lane runs yet (WSL idle-reboots kill detached containers; see P1 befc2403 root cause). Acceptance this round: per-module toolchain table on this story, dag build green, productgo tests pass; (b) recorded as remaining when you submit.

### Code delivery, weave #108

The workspace selects `toolchain go1.27.4` in `go.work`. The following module directives were checked with `go mod edit -json`. The tray module previously carried the SDK patch level in its `go` directive and now requires `go 1.27.4`.

| Module file | Go directive | Local submodule commit |
| --- | --- | --- |
| `bashy/examples/api-rods/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/board/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/brainstorm/server/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/cast/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/chrome/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/clip/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/defaults/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/chart/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/form/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/kit/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/notepad/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/desk/viewer/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/film/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/local-knowledge/kb-ui/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/onboard/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/oss-rods/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/outpost-profile/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/record/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/satellite-member/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/satellite-provision/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/service-door/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/session/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/shaping/website/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/shaping/website/template/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/site/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/table/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/transcribe/webm-feasibility/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/transcribe/webm-opus/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/tray/go.mod` | `go 1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/vlog/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/examples/whiteboard/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/bash53aggregate/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/bashysignalprobe/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/licensegate/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/releaseeligibility/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/verifyhost/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/windowswslocale/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/yashsuite/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `bashy/tools/ztst/go.mod` | `toolchain go1.27.4` | `fbeccbea3ca6` |
| `outpost/examples/hello-tessaro/go.mod` | `toolchain go1.27.4` | `f1aa073c9848` |
| `outpost/go.mod` | `toolchain go1.27.4` | `f1aa073c9848` |
| `yoke/examples/bedrock-key/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `yoke/external/otel/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `yoke/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `yoke/pkg/llmgw/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `yoke/pkg/oci/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `yoke/pkg/provider/go.mod` | `toolchain go1.27.4` | `60fdbbec2ecf` |
| `coreutils/go.mod` | `toolchain go1.27.4` | `c5832f99ccf6` |
| `coreutils/third_party/goawk/go.mod` | `toolchain go1.27.4` | `c5832f99ccf6` |
| `bashsharp/go.mod` | `toolchain go1.27.4` | `58fa3c439d06` |
| `bash/cmd/go.mod` | `toolchain go1.27.4` | `42efe30317c4` |
| `bash/go.mod` | `toolchain go1.27.4` | `42efe30317c4` |
| `bash/moreinterp/go.mod` | `toolchain go1.27.4` | `42efe30317c4` |
| `bash/tools/bash53evidence/go.mod` | `toolchain go1.27.4` | `42efe30317c4` |
| `bash/tools/bash53suite/go.mod` | `toolchain go1.27.4` | `42efe30317c4` |
| `sh/go.mod` | `toolchain go1.27.4` | `7a7a1b0f39fc` |
| `sh/moreinterp/go.mod` | `toolchain go1.27.4` | `7a7a1b0f39fc` |
| `bashsharp-tests/tools/go-by-example/gbe/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/go-full/diagnostics/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/go-full/source-remap/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/go-full/typecheck-diagnostics/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/go-oracle/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/grammar-oracle/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bashsharp-tests/tools/tour/go.mod` | `toolchain go1.27.4` | `acc46303f1e5` |
| `bonsai/go.mod` | `toolchain go1.27.4` | `e25a870a0d4a` |
| `gfy/go.mod` | `toolchain go1.27.4` | `aab4f6fad5be` |
| `gotreesitter/go.mod` | `toolchain go1.27.4` | `5522e72a297d` |
| `readline/go.mod` | `toolchain go1.27.4` | `6ed12265d8dd` |
| `yamux/go.mod` | `toolchain go1.27.4` | `2fc3d8a5d2f2` |
| `yamux/v5/go.mod` | `toolchain go1.27.4` | `2fc3d8a5d2f2` |
| `ycode/examples/agent-mini/go.mod` | `toolchain go1.27.4` | `4c6cee72ad8a` |
| `ycode/examples/bench/doorrelay/go.mod` | `toolchain go1.27.4` | `4c6cee72ad8a` |
| `ycode/examples/genie/go.mod` | `toolchain go1.27.4` | `4c6cee72ad8a` |
| `ycode/examples/ollm-list/go.mod` | `toolchain go1.27.4` | `4c6cee72ad8a` |
| `ycode/go.mod` | `toolchain go1.27.4` | `4c6cee72ad8a` |

### Directives still at Go 1.27.2

| Module file | Reason |
| --- | --- |
| `appstore/go.mod` | Independent Helm catalog tooling outside the Bashy release scan and build. |
| `agent-bench/go.mod` | Independent agent evaluation pack outside the release build and scan. |
| `nadir/go.mod` | Independent Nadir CLI and evaluator outside the Bashy and Outpost release scope. |
| `yamux/interop/v5replace/go.mod` | Interoperability fixture. The Yamux runtime modules were updated. |
| `bash/coreutils/go.mod`, `bash/coreutils/third_party/goawk/go.mod` | Historical nested Coreutils snapshot. The umbrella builds with the updated top-level Coreutils and goawk modules. |
| `yoke/external/ollama/src/go.mod`, `yoke/external/podman/src/go.mod` | External source snapshots. The consuming Yoke build selects Go 1.27.4, including when compiling packages from these snapshots. |
| `yoke/external/podman/src/test/tools/go.mod` | Test tooling inside the pinned Podman snapshot. |

The Bashy builds catalog for independent third-party products retains its existing product pins. The conductor can refresh published consumer dependency versions once the submodule commits are available remotely. The worker commits are available locally in the isolated submodule clones at `refs/weave/issue-108/go1.27.4`.

### Verification

- Both productgo drivers require `go1.27.4`. The darwin/arm64 1.27.4 SDK's `runtime/signal_unix.go` matches the 1.27.2 bytes and the existing SHA-256 `a9dd82ee8b8089ec69dc90cc8a2d3553839db41b3f01807311507c7fc117a3e0`. The insertion anchor occurs exactly once.
- Bashy productgo passed all eight tests in the focused DAG, including runtime controls, managed SDK relocation and source integrity. DAG run `1795256140046751000-a698fcd9`. The separate Bash productgo rejected 1.27.2 and built and ran an overlay probe with 1.27.4, confirmed by Go build metadata. DAG run `1795256215662564000-a698fcd9`.
- Fresh dev-box `bashy dag --force build` on the committed submodule heads passed `build-bash`, `build-bashy` and `build`. DAG run `1795256303819147000-dc4a90a7`. The Bashy artifact also passed inherited-signal and release-eligibility checks. Both built programs ran and report `go1.27.4` in Go build metadata.
  - `bin/bash.real` SHA-256 `e161ba83dc1bbdc45477f0564a30c112b705c4ec97530e9561ea6f549e418858`
  - `bin/bashy` SHA-256 `00f403bd9a9435c2c2b2e889f9101c5de447bcb97587f33f4caac7796ef1f534`

### Remaining after this submission

Once P1 baseline evidence and the gate-host keep-alive are in place, acquire the exclusive gate-host claim, roll the official build image under the `image.lock` rule, and record the new image ID. Run the Bash 5.3 fixture gate fresh in both modes, with a named comparison against the rc.39 evidence and a target of 86/86 in each mode.
