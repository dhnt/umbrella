# Sprint 654 delivery evidence

Sprint 654 (*Self-contained offline bashy: protected bootstrap and reusable artifact services*, `e505bc2c-9f7b-5ce5-a426-7b88c6a8d198`) delivered stories `S0`–`S8` (`#403`–`#411`) across `yoke`, `bashsharp`, `outpost`, `bashy`, and `umbrella`. No release tag or hosted-plane deployment was performed.

## Synchronized candidate identities

| Repository | Baseline SHA | Delivered SHA | Verification summary |
| --- | --- | --- | --- |
| `coreutils` | `5f9da9132e14` | `96e079612fa5` | Synchronized upstream POSIX coreutils head; zero Sprint 654 imports into `coreutils` or `sh`. |
| `yoke` | `17bf1a1dda58` | `257ce14714d9` | `pkg/artifact` (ORAS v2.7.0 CAS, bbolt v1.5.0 catalog, crash journal, loopback service, seal/bundle/OCI/Ollama/pressure/fixed-point), `pkg/gomod` (`goproxy` v0.27.0 over CAS, durable Loom `refs/bashy/published/**`, singleflight `.zip` regeneration, `modfile.Parse` `replace`-aware closure capture), `pkg/prune/rods` (`artifact` noun), `pkg/resources` (`pressure {evaluate,status,alerts}` + inode accounting), `external/loom` (published-ref GC/backup protection), `external/ollama` (offline GGUF/manifest packs, readiness evals, `keep_alive=0` memory unload), `external/gotoolchain` (CAS seed restore + sealed env). |
| `bashsharp` | `9d621d8cdd7e` | `0ec897e5814a` | Synced `coreutils` and `yoke` sibling pins; standalone `front`/`transpile` tests and `cmd/...` builds passed. |
| `outpost` | `24c7e91e39b1` | `fbad06db1f38` | Synced `coreutils` and `yoke` sibling pins; standalone `boundedlog`/`bashypath` tests and `cmd/outpost` build passed. |
| `bashy` | `b873a4a636d6` | `b5e679bb3243` | `self {bootstrap,seal,verify,status,export,import,prune,oci,fixed-point,runner-stage}`, `model offline {capture,restore,eval,unload,tier}`, sealed in-process routing for `go`/`resource`/`mod`, activated pressure-based Weave/limit admission and diagnostic command exemptions, `tools/bashy-build/{build.sh,run.sh,fixedpoint-offline.sh}`, and synchronized root + `toolchain` + `yoke` + `custom` + `optional` module pins (`bashy mod drift`: 0 stale edges). |

## Story ledger (`S0`–`S8`)

| Story | ID | Key commits | Gate evidence |
| --- | --- | --- | --- |
| `S0` Offline contracts & reuse boundaries | `#403` (`6b538b5383c5`) | `yoke` `e7f40ab30d54`, `umbrella` `7e5d93e5c` | `docs/offline-bashy-contracts-v1.md`, `pkg/artifact` + `pkg/atlas` + `pkg/src` tests, `fmtcheck.sh`, 3-OS `CGO_ENABLED=0` `go vet` PASS. |
| `S1` Protected ORAS CAS + bbolt catalog + `artifact` prune | `#404` (`60d8af61317e`) | `yoke` `e1b922629a31`, `umbrella` `5b0015327` | `-race` `pkg/artifact` (18/18) + `pkg/prune` (7/7), crash journal recovery, live-PID lease protection, Windows sharing-violation deferral, 3-OS `go vet` PASS (`1m15s`). |
| `S2` Embedded Go proxy & immutable Loom publication | `#405` (`2cdd5b99ad8e`) | `yoke` `b42b30dec512`, `umbrella` `dd4b34af9` | `-race` `pkg/gomod` (21/21) + `pkg/artifact`, durable Loom ref before catalog commit, immutable overwrite refusal, singleflight `.zip` regeneration verifying `sha256` + `h1:`, `mod proxy {serve,publish,status}` PASS (`1m15s`). |
| `S3` Gate A: bootstrap, seal, verify, status & portable ORAS recovery | `#406` (`4451c946a2bd`) | `yoke` `5cafc812db50`, `bashy` `6f5c518260e8` | `self {bootstrap,seal,verify,status,export,import,prune}`, `tools/productgo` startup-signal overlay routing, incomplete/tamper/traversal/wrong-OS bundle refusal, `yoke` gate (`1m20s`) + `bashy` 3-OS gate (`1m40s`) PASS. |
| `S4` OCI base/build image protection & offline sandboxes | `#407` (`8e90d251e54b`) | `yoke` `b7ca202e247e`, `bashy` `dc49998c85d1` | `self oci {capture,restore,build,lock-status,packs}`, nondeterministic reconstructible retention refusal, sealed `contain` egress stripping, `yoke` gate (`1m16s`) + `bashy` 3-OS gate (`2m02s`) PASS. |
| `S5` Protected Ollama profiles, evals & tier placement | `#408` (`7474cf217246`) | `yoke` `2a69236355a1`, `bashy` `00460de1dcd0` | `qwen3.5:4b` + `qwen3-embedding:0.6b` + workstation GGUF/manifest/template/tokenizer packs, 4-capability readiness evals, `keep_alive=0` memory-only unload preserving CAS weights, confinement-preserving `ResolveWorkloadTier` & `ErrOfflineFloorUnavailable` PASS. |
| `S6` Resource alarms, guarded reclamation & admission | `#409` (`bbe36dcf5a92`) | `yoke` `5a296cd7`, `bashy` `1df22027` | Disk `85/95%` or `20/10 GiB`, memory `85/95%`, 5m sustained CPU `85/95%`, inode + rebuild-reserve accounting, inactive-reconstructible-only prune, bounded `alerts.jsonl` + OTel metrics, activated Weave/limit admission gating PASS (`3m11s`). |
| `S7` Loom runners & offline self-hosting release gates | `#410` (`e47d43824892`) | `yoke` `0bc70d510997`, `bashy` `95f1df0c` | Loom backup/GC preservation of `refs/bashy/published/**`, `self runner-stage` workflow-helper archiving, `self fixed-point` + `tools/bashy-build/fixedpoint-offline.sh` 3-stage gate PASS. |
| `S8` Cross-platform recovery, contention & sealed acceptance | `#411` (`7a13a0e20dc8`) | `yoke` `257ce14714d9`, `bashy` `02fa045e`..`b5e679bb` | Surfaced and fixed 4 real-repo integration gaps (`modfile.Parse` for `go.mod` `replace` targets, nested adapter `go.mod` closure capture + sync, sealed in-process `resource`/`mod` routing, and long-only `--tag`/`--file` flags on `self oci build`); verified across Linux, Windows, and macOS below. |

## Quantitative measurements

### Binary size & certified-shell isolation (`CGO_ENABLED=0 -trimpath -ldflags="-s -w"`)

`go list -deps ./cmd/sh` verified zero imports of `coreutils`, `yoke`, `oras-go`, `bbolt`, or `goproxy` in the certified shell drop-in (`0` bytes of Sprint 654 growth across all three platforms). Full `cmd/bashy` growth between `b873a4a636d6` and candidate `6a759511dedc`/`b5e679bb3243` (spanning Sprint 654 plus concurrent `main` merges):

| Target | `cmd/sh` baseline | `cmd/sh` candidate | `cmd/sh` delta | `cmd/bashy` baseline | `cmd/bashy` candidate | `cmd/bashy` delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `linux/amd64` | `18,555,040` B | `18,555,040` B | `+0` B (`0.00%`) | `216,740,103` B | `219,164,935` B | `+2,424,832` B (`+1.12%`) |
| `windows/amd64` | `19,065,344` B | `19,065,344` B | `+0` B (`0.00%`) | `219,099,648` B | `221,429,248` B | `+2,329,600` B (`+1.06%`) |
| `darwin/arm64` | `17,362,082` B | `17,362,082` B | `+0` B (`0.00%`) | `209,054,354` B | `211,081,794` B | `+2,027,440` B (`+0.97%`) |

### Dependency closure delta (`go list -m all`)

Total modules in `bashy/go.mod` moved from `1,075` to `1,078` (`+3` permissive Go modules added by Sprint 654):
- `oras.land/oras-go/v2 v2.7.0` (Apache-2.0)
- `github.com/goproxy/goproxy v0.27.0` (MIT) and its helper `github.com/aofei/backoff v1.2.0` (MIT)
- `go.etcd.io/bbolt v1.5.0`, `golang.org/x/mod v0.42.0`, and `golang.org/x/sync v0.25.0` were reused from the existing dependency graph (`+0` transitive modules).

### Storage & wall-clock costs (full `bashy` self-host closure on the Linux gate lane)

- **Bootstrap (`self bootstrap --profile=self-host`)**: `55.79 s`, `1,381` protected roots (`1,375` external/fork Go modules across root + `toolchain`/`yoke`/`custom`/`optional`, `1` published Loom module, Go `1.27.4` SDK, `tools/productgo` overlay, source archive, and baseline binary), `3,521` CAS blobs, `1,541,024,185` B (`1.435 GiB`) on disk (`610` B reconstructible Loom `.zip`; remaining roots protected).
- **Offline digest verification (`self verify --offline`)**: `1.74 s` across all `3,521` SHA-256 blobs.
- **3-stage full `./cmd/bashy` fixed-point rebuild (`unshare -rn`, empty `GOCACHE` & `GOMODCACHE` per stage)**: `205.87 s` total (`66.84 s` Stage 0, `65.27 s` Stage 1, `65.00 s` Stage 2); peak per-stage disposable workspace (`gocache` + `gomodcache` + `productgo-cache`): `3,863,455,874` B (`3.60 GiB`, well within the `8 GiB` `RebuildReserveBytes` policy).
- **Portable ORAS archive (`self export` / clean-host `self import --seal`)**: `1,531,290,112` B (`1.426 GiB`, `3,521` blobs + `1` Loom ref, `sha256:7e2e938abb9327d39e1a618a34b3650c451e2f5b78d583aa14c415c2`); export `6.82 s`, clean-host digest-verified import + toolchain materialization + seal `81.17 s`.

## Cross-platform acceptance matrix

### 1. Linux (`linux/amd64`, claimed Windows gate host WSL2 official-image lane)

- **Venue**: Claimed `lane1` (`gate-lane check: ok`, `go1.27.4`, `304 GiB` free), isolated scratch workspace, claim released upon completion.
- **Race & integration suites**: `go test -race` passed on `yoke/pkg/artifact` (`34.87 s`), `yoke/pkg/gomod` (`10.28 s`), `yoke/pkg/prune/...` (`2.38 s`), `yoke/pkg/resources/...` (`6.23 s`, excluding pre-existing `TestProcessTreeLiveChild` noted below), `yoke/external/ollama/...` (`3.67 s`), and `yoke/external/loom` `-run TestPublished` (`1.26 s`, plus full `external/loom/...` non-race `8.64 s`); `bashy/internal/agentos` offline/resource/fixed-point/OCI/model suite passed (`60.27 s`).
- **Kernel air-gapped fixed-point self-rebuild (`unshare -rn`, `ip route == ""`)**:
  - *Negative control*: Pre-Sprint-654 `bashy` (`b873a4a636d6`) failed immediately inside `unshare -rn` attempting `Get "https://go.dev/dl/?mode=json&include=all": network is unreachable`, proving kernel air-gap enforcement.
  - *Candidate treatment*: Previous build `02fa045e4967` (`sha256:2826b111c48c9b566fe84083827fde61ec53d009738ca3032d1e619dd92aa9fc`) built `candidate_0` from `b5e679bb3243`, `candidate_0` rebuilt `candidate_1`, and `candidate_1` rebuilt `candidate_2` with empty `GOCACHE` and `GOMODCACHE` per stage and `tools/productgo` active: `candidate_0 == candidate_1 == candidate_2 == sha256:7616abcd2c90b6960470c1c29624a70dff52bed123964bed0972d5b553a41e0c` (`219,164,935` B, `fixed_point_match: true`).
  - *Zero public network attempts*: Loopback HTTP/HTTPS proxy trap (`127.0.0.1:19999`) recorded `0` connection attempts across the entire air-gapped session (offline Go `go run`, Bash# execution, fixed-point rebuild, `export`/`import`, `resources pressure evaluate`, and `self prune`).
- **Clean-host bundle restore, tamper refusal & guarded prune**: Exported `bundle.tar` (`3,521` blobs) imported cleanly into an empty `BASHY_HOME` + `artifact_root` yielding identical `manifest_digest` `sha256:67a4f2fa59dfce521e3116de826aae6214b6b2423abb27e15ab9bf2a45bc1516`; zero-byte corruption of `bundle.tar` was rejected while leaving the clean host's active sealed generation intact; `self prune --artifacts --apply` removed only the `1` reconstructible `610` B Loom `.zip` while keeping all `3,520` protected blobs verified.
- **Podman engine wipe + CAS restore + `--network=none` sandbox**: Built `localhost/s654-offline-sandbox:v1` (`--pull=never --network=none`), captured all `9` layers (`240.55 MB`, manifest `sha256:6646d015a4a65cc3b9eabdecf26ecd6b5c50b2e6face5dc798093feab5331766`) into CAS, wiped engine storage via `podman rmi -f`, restored directly from CAS via `self oci restore ... --engine=podman`, and ran `podman run --rm --network=none` -> `podman-offline-sandbox-ok:42`.
- **Canonical Bash 5.3 hermetic conformance sanity**: `scripts/test-bash-container-mode.sh` against candidate `bash` (`sha256:b649a8f6...`) and `bashy` (`sha256:26a68a37...`) passed (`test-bash-container-mode: PASS`).

### 2. Windows (`windows/amd64`, claimed Windows gate host native lane)

- **Venue**: Claimed `windows-native` lane (`Windows_NT 10.0.26300 x86_64`, `490 GiB` free), isolated `C:\Windows\Temp\s654-s8-win*` directories removed upon completion, claim released.
- **Native Win32 suites**: `yoke_artifact.test.exe` (covering `GetDiskFreeSpaceExW`, `CreateToolhelp32Snapshot` live-PID lease checks, NTFS open-handle sharing-violation deferral during `ApplyPrune`, crash journal recovery, Ollama/OCI/pressure/fixed-point), `yoke_gomod.test.exe`, `yoke_prune.test.exe`, `yoke_resources.test.exe`, and `bashy_agentos.test.exe` (`b5e679bb3243`, `sha256:472b57cdcedb31f63e6b7913c080a0de9b6f08929c57e750ee0cfbef190995a7`) all passed natively (`PASS`).
- **Native `bashy.exe` E2E**: `self bootstrap --profile=self-host` + `self seal` (`manifest_digest: sha256:e36f595bf32e56abc5a1376f631761b9bff461521ad7964b8399a229dd792459`), sealed refusal of unbootstrapped `go1.27.4` network fetch (`public network acquisition denied in sealed mode`), 3-stage `self fixed-point` (`candidate_0 == candidate_1 == candidate_2 == sha256:1cb9ddde4e9eef24f9f6bac8182a36f8cdd687cee73ac9857ef0c62eb87e3927`, `1,992,192` B, `11,069 ms`, empty `GOCACHE` & `GOMODCACHE`), `self export` (`262,610,944` B, `sha256:1bee1943739cdaad9ab4cc454df09cb4563949e11f973c61e7494cc9e9549c24`) / clean-root `self import --seal` (`manifest_digest: sha256:e36f595b...`), truncated/corrupt archive refusal preserving active seal, and `resources pressure evaluate --json` verified on NTFS.

### 3. macOS (`darwin/arm64`, dev box native verification & canonical install smoke)

- **Native `darwin/arm64` E2E**: Candidate `bashy` (`b5e679bb3243`, `sha256:5efca627fabb9d0d18e7272021d1c2dd46b83a107f53d67ff2f1a1e3214757d5`) completed `self bootstrap` -> `self seal` -> `self verify --offline` -> 3-stage `self fixed-point` (`candidate_0 == candidate_1 == candidate_2 == sha256:238369181b750e583eaf6bebb40114506f2cd421fc324ec467b8073f7acce2dd`, `7,206 ms`, empty `GOCACHE` & `GOMODCACHE`) -> `self export` (`209,520,128` B, `sha256:6e4c0497...`) -> clean-root `self import --seal` (`manifest_digest: sha256:69f958c1...`) -> `resources pressure status --json` -> sealed `model offline tier` cloud-only floor refusal, with `0` hits on the loopback proxy trap (`127.0.0.1:19998`).
- **Installed PATH smoke**: `bashy self install --source --version s654` installed `5.3.0(1)-bashy-s654 (b5e679b)` at the canonical user binary path; `bashy self status --json`, `bashy mod proxy status --json`, `bashy resources pressure status --json`, and `bashy self oci packs --json` all succeeded while preserving existing user Go module proxy state.

## Pre-existing issues & bounded scope notes

1. **`yoke/pkg/resources` `TestProcessTreeLiveChild` (`limits_test.go:117`)**: Untouched by Sprint 654 (`git diff 17bf1a1dda58..257ce14714d9 -- pkg/resources/limits_test.go` is empty). On WSL2 Linux, the polling loop breaks as soon as `u.Processes >= 1` right after `fork()` before `execve("sleep")` faults in resident pages (`RSSBytes == 0`), causing an intermittent test failure. Left unmodified per migration policy.
2. **`yoke/external/loom` `startGiteaStandIn` (`loom_test.go:993`)**: Untouched by Sprint 654 (`git diff 17bf1a1dda58..257ce14714d9 -- external/loom/loom_test.go` is empty). Calls `cmd.Wait()` from both a background goroutine and `t.Cleanup()`, triggering Go's race detector when `external/loom` is invoked with `-race`; non-race `go test ./external/loom/...` and `-race` `TestPublished*` both pass.
3. **Ollama & multi-tier runtime venues**: Full GGUF/manifest/template/tokenizer CAS capture, cache wipe + restore, 4-capability readiness evals, `keep_alive=0` memory-only unload under resource pressure, and tier-floor fallback/refusal were verified against deterministic local Ollama HTTP fixtures across Linux, Windows, and macOS (`TestSelfModelsOfflineCaptureRestoreEvalSealPruneUnloadAndTier` and `external/ollama` suites) without mutating shared GPU model stores on the Windows host.
