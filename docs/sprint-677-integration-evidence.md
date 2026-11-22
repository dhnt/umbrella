# Sprint 677 Integration Run Evidence: Leg 1 of 5 (`bashy gate.final`)

Sprint 677 integration run, Leg 1 of 5: `bashy gate.final` on the gate host.

- **Umbrella base**: `32904ad26`
- **Bashy source SHA**: `802a78f8ae13b063bed529d9316a3af8e3ef8e20` (`802a78f8`, all adapters landed)
- **Bashsharp pin**: `621e369d910d049fb5e028f6a89e19fc5e358701` (`621e369`)

## 1. Setup State & Provenance

### Venue & Access Method
- **Venue**: Gate host WSL2 Ubuntu 24.04, shared lane 1 (8 CPU / 7 GiB RAM, manager lease epoch active).
- **Execution Mode**: Session attached (foreground; WSL idle-shutdown kills detached containers).
- **Staging Directory**: `/root/lanes/lane1/s677-integration/bashy`
- **Staging Method**: Direct clone of `bashy@802a78f8` into the lane workdir `/root/lanes/lane1/s677-integration/bashy`, maintaining a standalone `.git` worktree for build provenance inspection (`git rev-parse HEAD` resolving to `802a78f8ae13b063bed529d9316a3af8e3ef8e20`).

### Official Build Image
- **Image specification**: `tools/bashy-build/image.lock`
- **Tag**: `localhost/bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2`
- **Image ID**: `980ae8d4b8789bf9693ea86491bf4c6b70515228a9e1bbcd7a49f225e47eacd5` (`980ae8d4b878`)
- **Image Digest**: `sha256:c99fcb7318b23ed06b3775368ee3966795a5498fb9a050a92d6f21866680b7ba`
- **Toolchain**: Go 1.27.2 (`GOTOOLCHAIN=local`), entrypoint `/usr/bin/dash`
- **Container Invocation Pattern**:
  ```bash
  bashy oci run --rm --init --cpus 8 --memory 7g \
    -v lane1-s677-p1-cache:/var/cache/bashy-build:U \
    -v /root/lanes/lane1/s677-integration/bashy:/work:U -w /work \
    -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 \
    --entrypoint /usr/bin/dash \
    localhost/bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2 -c '<commands>'
  ```

### `bashy mod drift` Verbatim Output
```
cycle    github.com/qiangli/bashy -> bashsharp v0.0.0-20261121121200-5848aff449cd pinned 5848aff449cd, HEAD 621e369d910d
in-sync  github.com/qiangli/bashy -> coreutils/third_party/goawk v0.0.0-20261121101804-c5832f99ccf6 
in-sync  github.com/qiangli/bashy -> readline v0.1.4-0.20261121101804-6ed12265d8dd 
in-sync  github.com/qiangli/bashy -> gotreesitter v0.0.0-20261121101804-5522e72a297d 
in-sync  github.com/qiangli/bashy -> yoke/external/ollama/src v0.0.0-20261016181410-b0d0bbba93ab 
in-sync  github.com/qiangli/bashy -> bash v0.0.0-20261121101805-42efe30317c4 
in-sync  github.com/qiangli/bashy -> bonsai v0.0.0-20261121101804-e25a870a0d4a 
in-sync  github.com/qiangli/bashy -> coreutils v0.0.0-20261121101804-c5832f99ccf6 
in-sync  github.com/qiangli/bashy -> gfy v0.0.0-20261121101804-aab4f6fad5be 
in-sync  github.com/qiangli/bashy -> outpost v0.14.38-0.20261121105637-c643f4029e70 
in-sync  github.com/qiangli/bashy -> ycode v0.3.1-dev.0.20261121101805-4c6cee72ad8a 
in-sync  github.com/qiangli/bashy -> ycode/examples/genie v0.0.0-20261121101805-4c6cee72ad8a 
in-sync  github.com/qiangli/bashy -> yoke v0.0.0-20261121110346-da4b02a4d244 
in-sync  github.com/qiangli/bashy -> yoke/external/otel v0.0.0-20261121110346-da4b02a4d244 
in-sync  github.com/qiangli/bashy -> yoke/pkg/llmgw v0.0.0-20261121110346-da4b02a4d244 
in-sync  github.com/qiangli/bashy -> yoke/pkg/oci v0.0.0-20261121110346-da4b02a4d244 
in-sync  github.com/qiangli/bashy -> yoke/pkg/provider v0.0.0-20261121110346-da4b02a4d244 
in-sync  github.com/qiangli/bashy -> yoke/external/podman/src v6.0.0-20261013004941-fa029d9c82fb 
```

## 2. Pipeline Execution Plan (`bashy/.bashy/gate.final`)
1. `bashy dag build`
2. `bashy dag test`
3. `bashy dag test-bash-gate`

## 3. Results Summary

| Target | Exit Code | Wall Time | Pass Count | Fail Count | Status |
|---|---|---|---|---|---|
| `bashy dag build` | 1 | 12.739s | 0 | 1 | FAILED |
| `bashy dag test` | 1 | 169.577s | 7 | 1 | FAILED |
| `bashy dag test-bash-gate` | - | - | - | - | Pending |

## 4. Execution Details & Failure Analysis

### 4.1 Target 1: `bashy dag build`
- **Exit Code**: `1`
- **Wall Time**: `12.739s`
- **Output Verdict**: FAILED (`dag: 1/1 targets failed`)
- **Failing Target**: `build-bash` (prerequisite for `build`)
- **Error Summary**:
  ```
  ==> build-bash
  dag: effect cap: target "build-bash": "go-product.sh" needs unknown not in Effects: cred,exec,net,read,write
  productgo: requires go1.27.4, found go1.27.2
  exit status 1
  Error: exit status 1
  ==> build-bash FAILED (exit 1)
  dag: 1/1 targets failed
  ```
- **Root Cause Hypothesis**:
  - In Sprint 677 Phase 0A (commit `fbeccbea`), `bashy/tools/productgo` and `bashy/go.mod` were bumped to require Go toolchain `go1.27.4` (`const toolchainVersion = "go1.27.4"` in `tools/productgo/main.go:23`).
  - However, the locked official build image specified in `tools/bashy-build/image.lock` remains `localhost/bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2`, which ships Go toolchain `go1.27.2`.
  - When `scripts/go-product.sh` runs `go run ./tools/productgo linux amd64 1 build -o bin/bash.real ...`, `productgo` probes `go env -json GOVERSION` and verifies `cfg.GOVERSION == toolchainVersion`. It detects `go1.27.2` instead of expected `go1.27.4`, failing closed with `productgo: requires go1.27.4, found go1.27.2`.
  - Per sprint standing directives and user instructions, no code changes or skips are made in this integration story; proceeding to remaining pipeline lines.

### 4.2 Target 2: `bashy dag test`
- **Exit Code**: `1`
- **Wall Time**: `169.577s` (`2m 49.6s`)
- **Output Verdict**: FAILED (`dag: 1/8 targets failed`)
- **Targets Executed**: 8 targets
  - **Passed (7)**:
    1. `test-meet-spa-fresh-regression` (7/7 checks verified)
    2. `test-meet-spa-fresh` (fresh build matched tracked artifact using bashy-provisioned pnpm)
    3. `test-build-fail-closed`
    4. `test-isolated-lanes`
    5. `test-release-qa-lane`
    6. `test-build-tag-matrix`
    7. `test-bash-container-mode`
  - **Failed (1)**:
    1. `verify-bashy-scratch` (via failed sub-target `build-bashy-scratch`)
- **Error Summary**:
  ```
  ==> verify-bashy-scratch
  dag: effect cap: target "verify-bashy-scratch": "verify-bashy-scratch.sh" needs unknown not in Effects: cred,exec,net,read,write
  ==> build-bashy-scratch
  building static linux/amd64 Bashy at /proc/self/fd/3/bin/scratch/bashy-linux-amd64 ...
  productgo: requires go1.27.4, found go1.27.2
  exit status 1
  Error: exit status 1
  ==> build-bashy-scratch FAILED (exit 1)
  dag: 1/1 targets failed
  ==> verify-bashy-scratch FAILED (exit 1)
  dag: 1/8 targets failed
  ```
- **Root Cause Hypothesis**:
  - Exactly identical to `Target 1 (bashy dag build)`. Target `verify-bashy-scratch` invokes `build-bashy-scratch` to compile a static `linux/amd64` binary using `tools/productgo` (`./tools/productgo linux amd64 0 build -tags bashy_scratch ...`).
  - `tools/productgo/main.go` enforces `toolchainVersion = "go1.27.4"`.
  - The locked official build image provides `go1.27.2`.
  - `productgo` fails closed with `productgo: requires go1.27.4, found go1.27.2`, causing `build-bashy-scratch` and `verify-bashy-scratch` to exit 1.
  - All preceding prerequisite test suites (including meet SPA regression/freshness, build failure isolation, release QA, build tags matrix, and container modes) succeeded.

## Appendix: Verbatim Failure Output

### `bashy dag build` Log
```
==> build-bash
dag: effect cap: target "build-bash": "go-product.sh" needs unknown not in Effects: cred,exec,net,read,write
productgo: requires go1.27.4, found go1.27.2
exit status 1
Error: exit status 1
==> build-bash FAILED (exit 1)
dag: 1/1 targets failed
```

### `bashy dag test` Log (Failure Excerpt)
```
==> verify-bashy-scratch
dag: effect cap: target "verify-bashy-scratch": "verify-bashy-scratch.sh" needs unknown not in Effects: cred,exec,net,read,write
==> build-bashy-scratch
building static linux/amd64 Bashy at /proc/self/fd/3/bin/scratch/bashy-linux-amd64 ...
productgo: requires go1.27.4, found go1.27.2
exit status 1
Error: exit status 1
==> build-bashy-scratch FAILED (exit 1)
dag: 1/1 targets failed
==> verify-bashy-scratch FAILED (exit 1)
dag: 1/8 targets failed
```

---

# Sprint 692 rc.40 candidate gate (story 458628c0): THE ONE full run

Frozen tip verified at start. Owner muse-wonder. All legs on claimed venues;
hosts named by role only. No code fixes in this story: a red leg is recorded
with failing names verbatim and first-pass classification, then the next leg
continues.

## Frozen tip & venue setup

- **Umbrella**: `fde3c59308a0e500602fdee4d22b9d13516e9de2` (carries the pins below; verified with `git log` at start)
- **bashy**: `9dd37bb28686a6f1dd9924f43372cbe96c1671db` (P5 thin core + import boundary; adapter fixes; dag-test fixes; startup gate on bsh; dag capacity services; kubectl env tests; dependency bumps with the override retired; yoke/outpost pins bumped)
- **bashsharp**: `cc848210379216f2b73665d610e801c07bf45d5a` (umbrella pin; descendant of `ed6ca933`, the bsh commit named in the Wave 2 order — `ed6ca93` is its immediate parent)
- **outpost**: `a1c93072a28afac25c59f53d83f0f369ba53d45e`
- **yoke**: `908e590c1113a8ef8252f77775bed4dc602ab281`
- **Venue**: the gate host, WSL2 Ubuntu 24.04, lane-2 resource (claimed, lease epoch 8; lane 1 left untouched). Windows-native gate resource and the macOS QA host also claimed for leg 4.
- **Staging**: `/root/lanes/lane2/s692-rc40/bashy`, fresh clone checked out at `9dd37bb28686a6f1dd9924f43372cbe96c1671db` (`git rev-parse HEAD` verified). Fresh cache volume `lane2-s692-rc40-cache`.
- **Official image**: `localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3`, image ID `f09ff792e4e0c1e84cd592472ba98d1d69ba3f501fbd15cf29f3ec4a6191ec18`, digest `sha256:1171628e07d3e7490458d9b0b484e689fee56c4a739e3f8ad577188eceece2ff` per `tools/bashy-build/image.lock` in the staged checkout (`bashy_version=v1.0.0-rc.40`, `go_version=1.27.4`). In-image `go version` = `go1.27.4 linux/amd64` (the rc.37 toolchain wall is gone).
- **Invocation**: attached session, `bashy oci run --rm --init --cpus 8 --memory 7g -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 --entrypoint /usr/bin/dash <image> -c '<commands>'`; long legs launched with `nohup` to a log under the lane work dir and polled.

### `bashy mod drift` verbatim (dev box, at the frozen tip)

```
cycle    github.com/qiangli/bashy -> bashsharp v0.0.0-20261121160731-621e369d910d pinned 621e369d910d, HEAD cc8482103792
stale    github.com/qiangli/bashy -> coreutils/third_party/goawk v0.0.0-20261121101804-c5832f99ccf6 pinned c5832f99ccf6, HEAD 47dbc82478bc
in-sync  github.com/qiangli/bashy -> readline v0.1.4-0.20261121101804-6ed12265d8dd
in-sync  github.com/qiangli/bashy -> gotreesitter v0.0.0-20261121101804-5522e72a297d
in-sync  github.com/qiangli/bashy -> yoke/external/ollama/src v0.0.0-20261016181410-b0d0bbba93ab
in-sync  github.com/qiangli/bashy -> bash v0.0.0-20261121101805-42efe30317c4
in-sync  github.com/qiangli/bashy -> bonsai v0.0.0-20261121101804-e25a870a0d4a
stale    github.com/qiangli/bashy -> coreutils v0.0.0-20261121101804-c5832f99ccf6 pinned c5832f99ccf6, HEAD 47dbc82478bc
in-sync  github.com/qiangli/bashy -> gfy v0.0.0-20261121101804-aab4f6fad5be
in-sync  github.com/qiangli/bashy -> outpost v0.14.38-0.20261122144618-a1c93072a28a
cycle    github.com/qiangli/bashy -> ycode v0.3.1-dev.0.20261121101805-4c6cee72ad8a pinned 4c6cee72ad8a, HEAD 3ef72c8114d3
cycle    github.com/qiangli/bashy -> ycode/examples/genie v0.0.0-20261121101805-4c6cee72ad8a pinned 4c6cee72ad8a, HEAD 3ef72c8114d3
in-sync  github.com/qiangli/bashy -> yoke v0.0.0-20261122144618-908e590c1113
stale    github.com/qiangli/bashy -> yoke/external/otel v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 908e590c1113
stale    github.com/qiangli/bashy -> yoke/pkg/llmgw v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 908e590c1113
stale    github.com/qiangli/bashy -> yoke/pkg/oci v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 908e590c1113
stale    github.com/qiangli/bashy -> yoke/pkg/provider v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 908e590c1113
in-sync  github.com/qiangli/bashy -> yoke/external/podman/src v6.0.0-20261013004941-fa029d9c82fb
```

Drift note: the `cycle` lines are the known bashy<->sibling cycles; the `stale`
lines name pins older than the dev-box submodule HEADs. The candidate under
gate is the frozen tip itself (bashy `9dd37bb2` as staged), so the legs below
measure exactly that tree. Legs follow.

## Leg 1: `bashy dag build`

- **Exit code**: `0`
- **Wall time**: `169.351s`
- **Verdict**: PASS — `dag: 3 target(s) ok` (`build-bash`, `build-bashy`, `build`)
- **Artifacts**: `bin/bash`, `bin/bash.real`, `bin/bashy` (candidate at `./bin/bashy` for leg 2)
- The effect-cap lines (`needs unknown not in Effects`) are the runner's advisory report; the targets ran and passed.

## Leg 2: `bashy dag test` (candidate `./bin/bashy`) — RED, one target

- **Exit code**: `1`
- **Wall time**: `307.173s`
- **Verdict**: FAILED — `dag: 1/9 targets failed`
- **Passed (8)**: `test-meet-spa-fresh-regression`, `test-meet-spa-fresh`, `test-build-fail-closed`, `test-isolated-lanes`, `test-release-qa-lane`, `test-build-tag-matrix`, `test-bash-container-mode`, `verify-bashy-scratch`
- **Failed (1), verbatim**: `test-startup-linux`
- **Failure evidence (verbatim, 4 of 4 runs including 3 standalone reruns)**:
  ```
  inittrace: 14.05 ms total (309 packages); max 12.00 ms (github.com/mattn/go-runewidth)
  inittrace: 21.39 ms total (309 packages); max 14.00 ms (github.com/mattn/go-runewidth)
  inittrace: 15.23 ms total (309 packages); max 13.00 ms (github.com/mattn/go-runewidth)
  inittrace: 14.19 ms total (309 packages); max 12.00 ms (github.com/mattn/go-runewidth)
  ==> test-startup-linux FAILED (exit 1)
  ```
  The gate in `scripts/test-startup-linux.sh` fails when any single package init exceeds 5 ms (or total exceeds 15 ms). The measured binary is now `bsh` (built from the pinned bashsharp module); its `github.com/mattn/go-runewidth` init costs 12–14 ms on this venue every run.
- **Effect on the leg**: the `test` target's own body (`go test ./...`) did not run, because its prerequisite failed. A separate candidate `go test ./...` run was launched for classification (result appended below when it lands).
- **First-pass classification**: test/venue boundary, not a product crash — the 5 ms per-package budget was calibrated for the previous binary; `bsh` deterministically exceeds it via `go-runewidth` init on the gate host's CPU (4/4 runs, 12–14 ms, low variance, so not load flake). No fix in this story per orders; the conductor was notified on the board and the run continues with leg 3.

### Leg 2 diagnostic: candidate `go test ./...` (separate run, for classification)

- **Exit code**: `1`; **wall time**: `650.271s`; 26 packages `ok`, 2 packages `FAIL`
- **Failed packages**: `github.com/qiangli/bashy/cmd/bashy` (464.125s), `github.com/qiangli/bashy/internal/agentos` (600.429s, 10-minute panic timeout)
- **Failing tests, verbatim**:
  - `TestSourceRoute/go_extension`, `TestSourceRoute/go_flag_no_op`, `TestSourceRoute/go_flag_txt`, `TestSourceRoute/go_flag_no_extension`, `TestSourceRoute/go_module_directory`, `TestSourceRoute/non-main_refusal`, `TestSourceRoute/flag_beats_python_extension` — all with `bashy: resolve Go toolchain: mkdir /var/cache/bashy/bin/go/1.27.2: permission denied`
  - `TestRepairHermeticStrippedPathRunsThroughBashyRuntime` — `go-version: pass=false reason="exit status 1" tail="Error: mkdir /var/cache/bashy/bin/go/1.27.2: permission denied"`
  - `TestACPHelpIsHeraldACPHelpByteForByte` — `` `bashy acp --help` did not finish: context deadline exceeded `` (120.91s)
  - `TestACPProcessLevelInitializeSessionPrompt` — `` `bashy acp` did not complete the ACP handshake: ... "context deadline exceeded" `` (123.72s); the same run logged a module-cache embed error: `embed baseline/adapters/docker-ps.yaml: open /var/cache/bashy-build/tmp/.../yoke@.../pkg/fleet/baseline/adapters/docker-ps.yaml: no such file or directory`
  - `internal/agentos`: no individual `--- FAIL`; the package died with `panic: test timed out after 10m0s` (`TestPromotionStatusLineUnconfigured` among the running tests at 43s)
- **First-pass classification**: venue-leaning. The `permission denied` cluster writes to `/var/cache/bashy/...` inside the container, outside the mounted build-cache volume — an environment path the image does not provision for test subprocesses. The ACP timeouts and the agentos 10-minute panic occurred on a heavily loaded 8-CPU venue (sibling packages took 375–600s each). None of these names is recorded as fixed here; they are handed to root-cause on their owning stories, and legs 3–4 proceed.

## Leg 3: `bashy dag test-bash-gate` (gate host, `BASH53_OCI=podman`) — PASS

- **Exit code**: `0` (`dag: 1 target(s) ok` for each mode)
- **Wall time**: not captured by the wrapper (its exit/wall echo lost its variables through the nested shell quoting; the run itself is timed by its evidence files, both modes completing 07:45–07:48 gate-host time)
- **Mode 0** (`BASH53_BASHPP=0`): `Results: 86 passed, 0 failed, 0 skipped, 0 timed out`; evidence `bin/bash53-evidence-0.json`, sha256 `ebac53d7ea36405fb6a226d5cd57fac2c548dc4272ccf3b539f4f04f74c9ab8a`
- **Mode 1** (`BASH53_BASHPP=1`): `Results: 86 passed, 0 failed, 0 skipped, 0 timed out`; evidence `bin/bash53-evidence-1.json`, sha256 `d41fbec376529a9250e98bb8435d958b33bcaea40cacd30b809d1b0fa35fd9f9`
- **Fixture-name comparison vs rc.39**: rc.39 evidence (mode 0 `365ab01e…f243`, mode 1 `2f059ded…e9b5`) sealed the same 86-fixture set. Both modes here pass all 86 with no failures, skips, or timeouts, so by fixture name there are no NEW, RECOVERED, or changed fixtures: 86/86 both modes, matching rc.39.

## Leg 4: 3-OS dispatch e2e (`TestE2EAllListedCommandsDispatch`, fresh install, empty adapter cache)

Each OS ran the candidate from a fresh install with `BASHY_ADAPTER_CACHE` pointing at an empty directory, so every adapter cold-built on first use.

### 4a Linux (gate-host lane-2, official image) — PASS

- **Exit code**: `0`; **wall time**: `73.138s` (test itself `ok ... 50.261s`)
- Fresh `bin/bashy` + `bin/bash` copied to a fresh directory, fresh `HOME`, empty adapter cache. Full listed-command dispatch passed, including the cold adapter builds (the first-use defects `42f79daa`/`3dd8b4ec` do not reproduce here).

### 4b Windows native (gate host, Windows-native resource) — RED, one assertion

- **Exit code**: `1`; **wall time**: `43s` (test `41.46s`)
- **Failing name, verbatim**: `TestE2EAllListedCommandsDispatch` — `commands_e2e_test.go:274: sprint help does not carry the owner-accountability contract`, with `got: "go: go.mod file not found in current directory or any parent directory; see 'go help modules' Error: exit status 1"`. Every other listed verb passed; this is the only failure in the log.
- **First-pass classification**: product-leaning. On a cold adapter cache, `sprint --help` on native Windows reaches a `go` invocation outside any module instead of serving the adapter's help, so the accountability text never appears. The Windows host carries no Go toolchain or source tree by design (the test's `BASHY_E2E_BIN` escape hatch exists for exactly that host shape), so a dispatch path that needs `go` there is a product gap, not a venue gap. No fix in this story; handed to root-cause.

### 4c macOS (QA host claimed; substitute venue) — PASS with a venue note

- **Venue note**: the macOS QA host was claimed (lease epoch 165), but it is disk-full (`460Gi` volume, `110Mi` available), so the 600 MB test payload could not be staged there and nothing on that host was deleted to make room. The macOS leg therefore ran on the dev box (also macOS arm64) with the same fresh-install, empty-cache setup, and is labeled a substitute venue, not QA-host evidence.
- **Exit code**: `0`; **wall time**: `74s`; verdict `PASS`

## Per-leg summary

| Leg | Command | Exit | Wall | Result |
|---|---|---|---|---|
| 1 | `bashy dag build` | 0 | 169.351s | PASS (3 targets ok) |
| 2 | `bashy dag test` (`BASHY=./bin/bashy`) | 1 | 307.173s | RED: `test-startup-linux` only (8/9 pass); diagnostic `go test ./...` exit 1, 650.271s (venue-leaning names above) |
| 3 | `bashy dag test-bash-gate` (`BASH53_OCI=podman`) | 0 | not captured (see leg) | PASS 86/86 both modes, matching rc.39 by fixture name |
| 4a | dispatch e2e, Linux lane, fresh install, cold cache | 0 | 73.138s | PASS |
| 4b | dispatch e2e, Windows native, fresh install, cold cache | 1 | 43s | RED: `sprint --help` cold-cache `go` failure (product-leaning) |
| 4c | dispatch e2e, macOS, fresh install, cold cache | 0 | 74s | PASS on substitute venue (QA host disk-full) |


---

# Sprint 692 rc.40 candidate gate RERUN (story 0a0f4dc2): second full run after the gate fix round

Follows the RERUN ORDER on story 458628c0 (first run: umbrella `8b8db523f`, section above).
Owner: claude-opus5.5 (reassigned by the conductor from muse-wonder, whose run #152
hit a provider quota before producing work). No code fixes in this story: a red leg is
recorded with failing names verbatim and a first-pass class, the conductor is told,
and the next leg runs. Hosts are named by role only.

## Frozen tip & venue setup

- **Umbrella frozen tip**: `bebf3e8ca9fe8448406122635e97c515b887252f`. Gitlinks verified at start with `git ls-tree bebf3e8ca` and each submodule's `git rev-parse HEAD`:
  - **bashy**: `1762e12c5254d52557daf81796e0be3baded62b1`
  - **bashsharp**: `b1a3183b426d3da50c562db18c4b970f3d91e2dc` (bsh lazy runewidth tables)
  - **outpost**: `a1c93072a28afac25c59f53d83f0f369ba53d45e`
  - **yoke**: `5f1365166f791be20e20f6bcc3c8e1804cd996d8` (managed GOROOT pin)
- **Venue**: the gate host, WSL2 Ubuntu 24.04, lane-2 resource. The lane-2 lease was still held by muse-wonder for this same story; after a claim request to the holder and a note to the conductor went unanswered, and with the lane verified idle (no containers), the lease was taken over (epoch 11) and announced. The lane-1 lease was left alone.
- **Staging**: `/root/lanes/lane2/s692-rerun/bashy`, a fresh clone checked out at `1762e12c5254d52557daf81796e0be3baded62b1` (`git rev-parse HEAD` verified). Fresh cache volume `lane2-s692-rerun-cache`, created for this run.
- **Official image**: `localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3`, image ID `f09ff792e4e0c1e84cd592472ba98d1d69ba3f501fbd15cf29f3ec4a6191ec18`, digest `sha256:1171628e07d3e7490458d9b0b484e689fee56c4a739e3f8ad577188eceece2ff`, matching `image`/`image_digest` in the staged `tools/bashy-build/image.lock` (the same image as the first run).
- **Invocation**: same driver as the first run: `bashy oci run --rm --init --name lane2-s692rr-<step> --cpus 8 --memory 7g -v lane2-s692-rerun-cache:/var/cache/bashy-build:U -v <staging>:/work:U -w /work -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 --entrypoint /usr/bin/dash <image> -c '<commands>'`. Each leg runs detached on the gate host as a transient systemd unit (log and exit/wall meta under the lane's `results/`) and is polled about every 60 s; a bounded WSL keepalive holds the distro up.

### `bashy mod drift` verbatim (dev box, bashy at the frozen tip)

```
in-sync  github.com/qiangli/bashy -> bashsharp v0.0.0-20261122160840-b1a3183b426d
stale    github.com/qiangli/bashy -> coreutils/third_party/goawk v0.0.0-20261121101804-c5832f99ccf6 pinned c5832f99ccf6, HEAD 47dbc82478bc
in-sync  github.com/qiangli/bashy -> readline v0.1.4-0.20261121101804-6ed12265d8dd
in-sync  github.com/qiangli/bashy -> gotreesitter v0.0.0-20261121101804-5522e72a297d
in-sync  github.com/qiangli/bashy -> yoke/external/ollama/src v0.0.0-20261016181410-b0d0bbba93ab
in-sync  github.com/qiangli/bashy -> bash v0.0.0-20261121101805-42efe30317c4
in-sync  github.com/qiangli/bashy -> bonsai v0.0.0-20261121101804-e25a870a0d4a
stale    github.com/qiangli/bashy -> coreutils v0.0.0-20261121101804-c5832f99ccf6 pinned c5832f99ccf6, HEAD 47dbc82478bc
in-sync  github.com/qiangli/bashy -> gfy v0.0.0-20261121101804-aab4f6fad5be
in-sync  github.com/qiangli/bashy -> outpost v0.14.38-0.20261122144618-a1c93072a28a
cycle    github.com/qiangli/bashy -> ycode v0.3.1-dev.0.20261121101805-4c6cee72ad8a pinned 4c6cee72ad8a, HEAD 3ef72c8114d3
cycle    github.com/qiangli/bashy -> ycode/examples/genie v0.0.0-20261121101805-4c6cee72ad8a pinned 4c6cee72ad8a, HEAD 3ef72c8114d3
in-sync  github.com/qiangli/bashy -> yoke v0.0.0-20261122161039-5f1365166f79
stale    github.com/qiangli/bashy -> yoke/external/otel v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 5f1365166f79
stale    github.com/qiangli/bashy -> yoke/pkg/llmgw v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 5f1365166f79
stale    github.com/qiangli/bashy -> yoke/pkg/oci v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 5f1365166f79
stale    github.com/qiangli/bashy -> yoke/pkg/provider v0.0.0-20261121163358-be872cc5a395 pinned be872cc5a395, HEAD 5f1365166f79
in-sync  github.com/qiangli/bashy -> yoke/external/podman/src v6.0.0-20261013004941-fa029d9c82fb
```

Drift note: the bashsharp pin is now `in-sync` (it was `cycle` in the first run).
The `cycle` lines are the known bashy<->ycode cycle; the `stale` lines (coreutils,
goawk, the yoke subpackages) are unchanged from the first run. The candidate under
gate is the frozen tip as staged.

## Leg 1: `bashy dag build`

- **Exit code**: `0`
- **Wall time**: `167.421s`
- **Verdict**: PASS — `dag: 3 target(s) ok` (`build-bash`, `build-bashy`, `build`)
- **Artifacts**: `bin/bash`, `bin/bash.real`, `bin/bashy` (candidate at `./bin/bashy` for the later legs)

## Leg 2: `BASHY=./bin/bashy bashy dag test` — RED, one target

- **Exit code**: `1`
- **Wall time**: `248.738s`
- **Verdict**: FAILED — `dag: 1/7 targets failed`
- **Passed (6)**: `test-meet-spa-fresh-regression`, `test-meet-spa-fresh`, `test-build-fail-closed`, `test-isolated-lanes`, `test-release-qa-lane`, `test-build-tag-matrix`
- **Failed (1), verbatim**: `test-bash-container-mode`
  ```
  ==> test-bash-container-mode
  bashy dag: adapter yoke/dag/dag.bsh not found
  test-bash-container-mode: target test-bash-container failed
  ==> test-bash-container-mode FAILED (exit 1)
  dag: 1/7 targets failed
  ```
- **Comparison with the first run**: `test-bash-container-mode` PASSED in the first run (bashy `9dd37bb2`). Since then bashy gained three commits: `bd4f47de` (bashsharp pin bump), `48d7c818` (`fix(adapters): bootstrap cold help from pinned source`, story 11b75a7e, touching `internal/agentos/adapter_dispatch.go`) and `1762e12c` (test fixes). The error is printed by `internal/agentos/adapter_dispatch.go:307`. The script `scripts/test-bash-container-mode.sh` runs the candidate (`$BASHY`) as `bashy dag test-bash-container` inside a hermetic scratch repo (`PATH=<fakebin>:/usr/bin:/bin`, fake `go`), where the candidate's `dag` verb now does not find its `yoke/dag/dag.bsh` adapter.
- **First-pass classification**: product-leaning regression. `48d7c818` is the bisect candidate (not yet bisected; no fix in this story). The conductor was notified on the board.
- **Effect on the leg**: the dag stopped after this failure, so `verify-bashy-scratch`, `test-startup-linux` and the `test` body (`go test -timeout 30m ./...`) did not run under `dag test`. They ran next as continuations of this leg, with the same candidate and the same venue.

### Leg 2 continuation: `BASHY=./bin/bashy bashy dag test-startup-linux verify-bashy-scratch` — PASS

- **Exit code**: `0`; **wall time**: `65.799s`; `dag: 2 target(s) ok`
- **`verify-bashy-scratch`**: PASS (static linux/amd64 ELF with no INTERP or NEEDED entries, no purego, `bashy --version` / `supervisord --help` / retired-form refusal smoke)
- **`test-startup-linux`** on `bsh`: PASS. Verbatim:
  ```
  inittrace: 1.95 ms total (309 packages); max 0.18 ms (github.com/qiangli/bash/polyglot)
  bashy -c true: 4.93 ms/process (20 runs)
  100x /bin/true & wait $!: 0.56 s
  ```
  In the first run the max package init was 12–14 ms (`github.com/mattn/go-runewidth`) against the 5 ms budget. The lazy runewidth tables in bashsharp `b1a3183` remove it: `go-runewidth` is no longer the max, and the max is 0.18 ms.

### Leg 2 continuation: the `test` body, `./bin/bashy go test -timeout 30m ./...` — RED, one package

- **Exit code**: `1`; **wall time**: `820.958s`
- **Package summary**: 27 `ok`, 1 `FAIL`, 8 `[no test files]`. The failing package is `github.com/qiangli/bashy/internal/agentos` (775.414s). It ran to completion inside the new 30-minute budget, with no timeout panic. `cmd/bashy` is `ok` (331.507s): the first run's `TestSourceRoute/*`, `TestRepairHermeticStrippedPathRunsThroughBashyRuntime` and both ACP tests no longer fail.
- **Failing tests, verbatim**:
  - `TestSrcPinsMatchLinkedModules` — `src_mount_test.go:13: yoke: src: yoke pin is out of sync with the linked module version v0.0.0-20261122161039-5f1365166f79`
  - `TestSynergyDAGCheckAndList` (56.95s) — `testing.go:1619: TempDir RemoveAll cleanup: unlinkat /var/cache/bashy-build/tmp/TestSynergyDAGCheckAndList…/001/go/pkg/mod/go.yaml.in/yaml/v2@v2.4.4/apic.go: permission denied`
  - `TestSynergyDAGBoundedFixture` (60.31s) — `synergy_dag_test.go:288: dag --json envelope: unexpected end of JSON input`, `exit=1`, empty stdout, stderr starting `go: downloading github.com/qiangli/coreutils v0.0.0-20261121101804-c5832f99ccf6 … go: downloading github.com/qiangli/yoke v0.0.0-20261121163358-be872cc5a395`
  - `TestSynergyDAGRejectsEmptyImplementation` (59.05s) — `synergy_dag_test.go:514: failed DAG envelope: invalid character 'g' looking for beginning of value`, stderr `go: downloading github.com/qiangli/yoke v0.0.0-20261121163358-be872cc5a395 …`
  - `TestToolShortcutE2E` (32.09s) — `toolshortcut_e2e_test.go:450: bashy agy did not exit after quit`
- **First-pass classification**:
  - `TestSrcPinsMatchLinkedModules`: product/repository consistency defect. bashy `1762e12c` bumped `go.mod` to yoke `5f136516`, but the matching `src` pin was not moved. The test caught a real mismatch.
  - The three `TestSynergyDAG*`: product-leaning, the same cluster as the `test-bash-container-mode` failure. The candidate's `dag` verb now cold-builds its `yoke/dag` adapter with `go` from a yoke pin (`be872cc5`, the stale subpackage pin in the drift listing). The `go: downloading` output then breaks the `--json` envelope, and the read-only module cache left in the test's TempDir makes cleanup fail. The bisect candidate is again `48d7c818`.
  - `TestToolShortcutE2E`: undetermined, venue-leaning (an interactive `agy` session quit under a headless container). It is not comparable with the first run, whose `internal/agentos` package died at the 10-minute timeout before it reported individual results.

## Leg 3: `BASH53_OCI=podman bashy dag test-bash-gate` (gate host, staged checkout) — RED, one fixture in mode 1

- **Exit code**: `1`; **wall time**: `315.154s`; `==> test-bash-gate FAILED (exit 1)`, `dag: 1/1 targets failed`
- **Mode 0** (`BASH53_BASHPP=0`): `Results: 86 passed, 0 failed, 0 skipped, 0 timed out`; evidence `bin/bash53-evidence-0.json`, sha256 `ec4391bc0993fd12be904417ebaed40b888f58b7a4e109a6b4b24e8d4043ff86`
- **Mode 1** (`BASH53_BASHPP=1`): `Results: 85 passed, 1 failed, 0 skipped, 0 timed out`; evidence `bin/bash53-evidence-1.json`, sha256 `5bbf53f8d0317b3b9c1b6a2aa6f636399003119dc9eb59e5df884e460afd9fb8`; `bash53evidence: sealed gate requires 86/86 with no failures, timeouts or skips`
- **Failing fixture, verbatim**:
  ```
    FAIL  histexpand
          output differs from histexp.right
          first diff at line 202
          want: "echo a"
          got:  "b"
  ```
- **Fixture-name comparison**: each fixture's verdict, keyed by (mode, name), was compared with the first run's leg-3 log. The first run was 172/172 PASS and matched rc.39 by name (rc.39: mode 0 `365ab01e…f243`, mode 1 `2f059ded…e9b5`, 86/86 each). The comparison found one change: `mode 1 histexpand PASS -> FAIL`. Mode 0 has no NEW, RECOVERED or changed fixture. The fixture set is the same 86 names in both modes.
- **First-pass classification**: product-leaning regression in the `BASH53_BASHPP=1` engine path. The engine inputs changed between the runs only through the bashsharp pin (`cc848210` -> `b1a3183`, bashy `bd4f47de`, the bsh lazy runewidth tables), so that is the bisect candidate. Not rerun: there is one full run per the test rule, and a single deterministic text diff gives no flake signal. The conductor was notified.

## Leg 4: 3-OS dispatch e2e (`TestE2EAllListedCommandsDispatch`, fresh install, empty adapter cache)

### 4a Linux (gate-host lane 2, official image) — PASS

- **Command** (same script as the first run): fresh `bin/bashy` + `bin/bash` copied to `/tmp/fresh/bin`, then `HOME=/tmp/fresh/home BASHY_ADAPTER_CACHE=/tmp/fresh/adapter-cache BASHY_E2E_BIN=/tmp/fresh/bin/bashy ./bin/bashy go test -tags e2e -run '^TestE2EAllListedCommandsDispatch$' ./internal/agentos -count=1 -timeout 20m`
- **Exit code**: `0`; **wall time**: `93.966s` (test `ok github.com/qiangli/bashy/internal/agentos 59.052s`)

### 4b Windows native (gate host, Windows-native resource, no host Go) — PASS

- **Build** (lane 2, official image): `GOOS=windows GOARCH=amd64 BIN_DIR=bin/win BASHY=./bin/bashy bashy dag build-bashy` plus `GOOS=windows GOARCH=amd64 ./bin/bashy go test -c -tags e2e -o bin/win/agentos.test.exe ./internal/agentos`; exit `0`, `165.689s`. `bashy.exe` sha256 `3427c252a82de47b9e5f5cb850dbcc061fe1840dc83a03ef00f368ec5b5e3a44`, `agentos.test.exe` sha256 `3e00fea5f8da94d5d9577a658bc23a50e59209a2a8b3da06461803d168d426d1`.
- **Run**: a fresh directory on the Windows side with a fresh `HOME`/`USERPROFILE`, an empty `BASHY_ADAPTER_CACHE` (0 entries at start) and `BASHY_E2E_BIN=<fresh>\bin\bashy.exe`; `agentos.test.exe -test.run "^TestE2EAllListedCommandsDispatch$" -test.count=1 -test.timeout 20m -test.v`. `where go` on that host: `INFO: Could not find files for the given pattern(s).` (no host Go).
- **Exit code**: `0`; **wall time**: `321.89s` (`--- PASS: TestE2EAllListedCommandsDispatch (321.68s)`)
- **Comparison with the first run**: the first run's only failure, `sprint help does not carry the owner-accountability contract` (`go: go.mod file not found …`), does not reproduce. The cold adapter cache now gets a managed `toolchain\go.exe` and cold-builds the yoke adapters (`sprint.exe`, `dag.exe`, `weave.exe`, …) with no host Go. The wall time went from 43s to 322s because of those cold builds.

### 4c macOS — PASS on a SUBSTITUTE venue (the dev box)

- **Venue note**: the macOS QA host was claimed (lease epoch 166) and checked first. It is still disk-full (`/System/Volumes/Data` 461G, 110M available, 100%; its own telemetry spool reports `no space left on device`). Nothing could be staged there, nothing on it was deleted, and the claim was released. The leg ran on the dev box (macOS arm64, 33G free) and is labelled a substitute venue, not QA-host evidence.
- **Build**: a fresh clone at `1762e12c5254d52557daf81796e0be3baded62b1` in a temp directory; `GOWORK=off bashy dag build-bash build-bashy` (host Go `go1.27.4 darwin/arm64`), exit `0`, `52s`. Candidate `bin/bashy` sha256 `6def6a784950f861351869623601c9f09cbf50f47dc42fffea1e1c77d9629683`.
- **Run**: fresh `bin/` copy, fresh `HOME`, empty `BASHY_ADAPTER_CACHE`, `BASHY_E2E_BIN=<fresh>/bin/bashy`; `./bin/bashy go test -tags e2e -run '^TestE2EAllListedCommandsDispatch$' ./internal/agentos -count=1 -timeout 20m`
- **Exit code**: `0`; **wall time**: `143s` (test `ok github.com/qiangli/bashy/internal/agentos 62.821s`)
