# Plan — Sprint 677: Fast build, small core binary, and shapeable Yoke CLI modularization

Sprint 677 (`334e4662-d75c-5c5f-8671-7b62ea882de1`). Planning-only record established 2026-11-20. The sprint card and its stories in `docs/todo/` are authoritative.

## Gap & Measured Baseline

Profiling `make build` / `make install` and `bin/bashy` on the dev host (`darwin/arm64`) established two coupled bottlenecks:

1. **Build Time (~45–60s warm `make install`)**:
   - `tools/productgo` copies the entire ~500 MB Go 1.27.2 SDK (`os.CopyFS`) into a fresh random temporary directory (`os.MkdirTemp("", "bashy-runtime-overlay-")`) on every invocation when `GOROOT` lives inside `GOMODCACHE`, and writes the overlay replacement (`signal_unix.go`) inside that random directory. Because the replacement path changes every run, Go invalidates the `runtime` package cache and spends ~6.4s copying/deleting the SDK per binary (`build-bash` + `build-bashy` = ~13s of pure copy + cache-busting overhead).
   - `scripts/go-tool.sh` builds `tools/releaseeligibility` from scratch in a disposable `mktemp -d` with `GOWORK=off` on every build (**9.73s** to run a 5ms `debug/buildinfo` check).
   - `scripts/build-meet-spa.sh optional` unconditionally runs `pnpm install --frozen-lockfile` + `tsc -b && vite build` (**4.39s**) even when `yoke/pkg/meet/web` has not changed relative to `yoke/pkg/meet/artifact`.

2. **Binary Size & Startup Footprint (`241.71 MB` unstripped / `221.36 MB` stripped, `2,284` transitive packages)**:
   - **Non-Linux symbol table (`20.36 MB`)**: `BASHY_LDFLAGS` omits `-s` globally because Linux ELF builds require `runtime.fwdSig` in `SHT_SYMTAB`. Darwin and Windows use the `bashy_runtime_snapshot` overlay / `debug/buildinfo` and do not use ELF `SHT_SYMTAB`, so omitting `-s` on Darwin/Windows carries 20.36 MB of unused Mach-O/PE symbol tables.
   - **Tree-sitter embedded grammar blobs (`20.37 MB` raw data, `~22.7 MB` total)**: `gotreesitter/grammars` embeds all 201 `grammar_blobs/*.bin`, whereas `yoke/pkg/treesitter` and `gfy/pkg/extract` use 22 languages (~9.2 MB, or ~3.1 MB without `swift.bin` and `kotlin.bin`).
   - **File Browser + Swagger UI (`16.09 MB` embedded + ~2 MB image/exif deps)**: `filebrowser/backend/fbembed` embeds `dist.zip` (7.52 MB) and transitively imports `swaggo/http-swagger` + `swaggo/files` (8.57 MB of Swagger UI assets never served by `bashy`).
   - **Kubernetes `client-go` (`~11.7 MB` code/data + reflection/pclntab = `~18–22 MB` total, 247 packages)**: imported solely by `bashy/internal/agentos/dks_scope.go` (240 lines) to edit one YAML field in `~/.kube/config` and make two REST calls (`GET /api/v1/namespaces` and `POST /apis/authorization.k8s.io/v1/selfsubjectaccessreviews`).
   - **Tiktoken BPE static maps (`9.64 MB` rodata + init overhead)**: `github.com/tiktoken-go/tokenizer/codec` initializes 4 large BPE vocabularies (`o200k_base`, `cl100k_base`, `p50k_base`, `r50k_base`) as Go literal maps at startup for `yoke/cmds/tokens`.
   - **Monolith vs. Core + Companion Architecture**:
     - Pure `bsh` (Bash 5.3 + Bash# + `--source=go` + `transpile`): **205–212 packages, 17.35–19.41 MB, 0.24–0.29s warm build**.
     - `bashy_core` (Bash 5.3 + Bash# + 116 in-process POSIX Coreutils + `commands` catalog): **44.70 MB (915 pkgs) today, ~29 MB (~500 pkgs) once the `yoke/pkg/fleet` import leak is severed, 0.64s warm build**.
     - Furthermore, Software Shaping (`bashy shape`, `internal/agentos/shape_slot.go`, `yoke/pkg/shape/slot`) already dispatches CLI-kind apps through content-addressed side slots (`~/.bashy/shape-host/<app>/artifacts/<sha256>/<app>`) via `shapedRegisteredArgv`. Keeping Yoke commands/apps welded into the 241 MB `bashy` monolith prevents live-activating individual command shapes without re-execing or rebuilding the entire monolith.

## Scope & Bounded Stories

### Phase 1 — Build Pipeline Speed & Zero-Risk Linker Diet (`bashy`)

- **S1 (`bashy`): Deterministic content-addressed SDK overlay cache in `tools/productgo` and cached tool binaries in `scripts/go-tool.sh` + incremental `build-meet-spa.sh optional`**
  - Cache the relocated Go 1.27.2 SDK and patched `signal_unix.go` + `overlay.json` in a deterministic user-cache directory keyed by `(GOVERSION, sourceHash, patchHash)`, verifying the hash of `signal_unix.go` on every run (fail-closed) without busting Go's build cache or copying 500 MB per build.
  - Cache compiled `tools/<name>` binaries in `scripts/go-tool.sh` (or `bin/.tools/<name>`) instead of recompiling in a fresh `mktemp -d` on every invocation.
  - In `scripts/build-meet-spa.sh optional`, skip `pnpm install` + `vite build` when `yoke/pkg/meet/artifact` is already present and newer than `yoke/pkg/meet/web` inputs (`required` and `check` modes continue to build fresh unconditionally).
  - *Acceptance*: Warm `make build` / `make install` drops from ~50s to <15s; `make test-build-fail-closed` and `make test-meet-spa-fresh-regression` pass.

- **S2 (`bashy`): Strip symbol table (`-s -w`) on non-Linux `cmd/bashy` builds**
  - Apply `-s -w` in `BASHY_LDFLAGS` (and `scripts/build-bashy-artifact.sh`, `dist`, Darwin/Windows release scripts) when target `GOOS != linux`, while preserving `-w` (retaining `SHT_SYMTAB` and `runtime.fwdSig`) when `GOOS == linux`.
  - *Acceptance*: Darwin `bin/bashy` size drops by ~20.4 MB; `elfaudit --bashy-signal`, `releaseeligibility`, and `bashysignalprobe` pass on Darwin and Linux ELF artifacts.

### Phase 2 — High-Leverage Dependency & Embed Diet (`bashy`, `gotreesitter`, `yoke`)

- **S3 (`bashy`): Replace `k8s.io/client-go` in `internal/agentos/dks_scope.go` with direct kubeconfig YAML + REST calls**
  - Replace the 6 `k8s.io/*` imports in `internal/agentos/dks_scope.go` (and `dks_scope_test.go`) with lightweight YAML kubeconfig parsing (`gopkg.in/yaml.v3`) + standard `net/http` / `crypto/tls` client calls for `GET /api/v1/namespaces` and `POST /apis/authorization.k8s.io/v1/selfsubjectaccessreviews`.
  - Prune `k8s.io/client-go`, `k8s.io/api`, `k8s.io/apimachinery`, and `github.com/google/gnostic-models` from `bashy/go.mod`.
  - *Acceptance*: All `dks_scope_test.go` tests pass; 247 `k8s.io/*` and `gnostic-models` packages are removed from `go list -deps ./cmd/bashy`; binary size drops by ~18–22 MB.

- **S4 (`gotreesitter`, `yoke`, `bashy`): Tree-sitter grammar tiering for `bashy` (`grammar_set_bashy`)**
  - Complete the tracked item in `bashy/docs/TODO.md` §Tree-sitter grammar tiering: add a build tag or curated embed tier in `gotreesitter/grammars` covering only the 22 languages wired by `yoke/pkg/treesitter` and `gfy/pkg/extract`, with clean fallback or on-demand external blob loading for unembedded long-tail grammars.
  - *Acceptance*: `yoke/pkg/treesitter`, `yoke/cmds/ast`, and `gfy/pkg/extract` tests pass; embedded grammar payload shrinks by ~11–16 MB; `pkg/atlas/localfirst_test.go` remains green (no network effect on first loop-verb use).

- **S5 (`yoke`): Trim unused `swaggo/files` from `filebrowser/backend/fbembed` and lazy-load compressed `tiktoken` vocabularies in `yoke/cmds/tokens`**
  - Decouple or build-tag `github.com/swaggo/http-swagger` + `github.com/swaggo/files` (8.57 MB of unused Swagger UI assets) out of the `fbembed` route used by `yoke/pkg/webconsole`.
  - Replace `github.com/tiktoken-go/tokenizer/codec`'s 9.64 MB static init-time Go literal maps in `yoke/cmds/tokens` with lazily decoded compressed vocabulary data (loaded only when `tokens` runs without `--fast`).
  - *Acceptance*: `yoke/pkg/webconsole` and `yoke/cmds/tokens` tests pass; binary size drops by ~16–18 MB and process startup no longer runs `codec.init()` map allocations.

### Phase 3 — Core Shell (`bsh` / `bashy_core`) + Shapeable Yoke CLI Companion Architecture (`bashy`, `yoke`, `coreutils`)

- **S6 (`bashy`, `coreutils`, `yoke`): Sever `yoke` import edges from `internal/core` (`bashy_core`) and add `bsh` entry point**
  - Extract the pure command-catalog record/schema reader needed by `bashy/internal/core/commands.go` so `cmd/bashy -tags bashy_core` links zero `github.com/qiangli/yoke/*` packages (emptying `coreImportAllowlist` in `cmd/bashy/core_imports_test.go`).
  - Support `bsh` as a recognized Bash#-default entry point / alias alongside `bash`, `sh`, and `bashy`.
  - *Acceptance*: `TestCoreImportBoundary` passes with an empty `coreImportAllowlist`; `cmd/bashy -tags bashy_core` builds in <1s to ~29 MB with full in-process Bash 5.3, Bash#, `--source=go`, and 116 POSIX Coreutils applets.

- **S7 (`bashy`, `yoke`): Companion Yoke CLI executable + shapeable command-slot dispatch (`shapedRegisteredArgv`)**
  - Build the AgentOS/Yoke command surface (`weave`, `sprint`, `dag`, `kb`, `inbox`, `mb`, `meet`, `webconsole`, `ast`, `graph`, `db`, `browser`, `shape`, `ycode`) as a companion multicall executable (`bashy-agentos` / `yoke`) installed alongside `bashy`.
  - Wire the lean `bashy` core front-door and `registeredHandler` to dispatch non-core AgentOS verbs through `shapedRegisteredArgv` and `slot.Store` (`~/.bashy/shape-host/<cmd>/`), so individual Yoke commands and registered CLI apps can be shaped (`bashy shape wish <cmd>`), verified, previewed, activated in side slots, and rolled back (`bashy shape undo <cmd>`) independently in seconds without rebuilding or re-execing the core shell.
  - Retain a single-binary build tag (`-tags bashy_monolith` / `bashy_scratch`) for `FROM scratch` offline container images.
  - *Acceptance*: `installbashy` surface verification, `TestE2EAllListedCommandsDispatch`, `make test-bash-gate`, and CLI-kind `shape` lifecycle tests (`wish`, `verify`, `preview`, `approve`, `undo`, `restore`) pass with 100% UX parity.

## Non-Goals

- No use of Go's standard `plugin` (`-buildmode=plugin`, `.so`) package: it breaks `CGO_ENABLED=0`, fails on Windows, disables linker dead-code elimination, and prevents symbol stripping.
- No changes to Classic Bash 5.3 or POSIX Coreutils semantics, and no weakening of the 86/86 Bash 5.3 gate or VSC certification profiles.
- No implementation edits in this planning step; each story executes in its own weave workspace with targeted tests and root-cause/size evidence.

## Risks & Rollback

- **Linux inherited-signal contract**: Linux ELF binaries must retain `runtime.fwdSig` in `SHT_SYMTAB` unless using the runtime snapshot accessor; S2 restricts `-s` strictly to `GOOS != linux` and stays gated by `tools/elfaudit --bashy-signal`.
- **Single-file container / airgap builds**: `make build-bashy-scratch` and `smoke-airgap-container` require a single static Linux executable; S7 preserves the static monolith tag for `bashy_scratch` while local/host installs use the fast core + shapeable companion split.
- **Rollback**: Each story is self-contained and independently revertable (`git revert`); side-slot shaping always retains the immutable `Release` artifact and recovers via `bashy shape undo` / `restore release`.
