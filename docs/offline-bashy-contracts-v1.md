# Offline bashy contracts, reuse boundaries and baseline evidence (v1)

Authoritative interface and compatibility contract for Sprint 654 (`S0`, story
`6b538b5383c5`). Code contract package: `github.com/qiangli/yoke/pkg/artifact`.

## 1. Versioned schemas

### `bashy-offline-profile-v1` (`artifact.ProfileV1`)

Operator/product input resolved by `bashy self bootstrap`:

- `schema_version`: `"bashy-offline-profile-v1"`
- `name`: logical profile identifier (traversal-safe)
- `platform`: `<goos>/<goarch>` target coordinate
- `tier_order`: ordered preference slice over the closed six-tier vocabulary
  (`cloud`, `cluster`, `sphere`, `sandbox`, `workplace`, `userland`); default
  `[cloud, cluster, sphere, sandbox, workplace, userland]`
- `offline_floor`: lowest permitted fallback tier when offline; default
  `userland` (`cloud` is rejected as an offline floor and excluded whenever
  sealed)
- `languages`: mandatory `["go", "bashsharp"]`, plus optional fenced packs
  (`python`, `typescript`, `rust`, `c`, `cpp`, `java`, `zig`)
- `models`: required coding/general (`qwen3.5:4b`, 4K context, concurrency 1,
  1 loaded model, evals `tool-call`, `code-edit`, `repair`) and embedding
  (`qwen3-embedding:0.6b`, eval `retrieval`) profiles; larger workstation
  candidates (`qwen3.5:9b`, `qwen3-coder-next`) configurable
- `capacity.rebuild_reserve_bytes`: minimum reserved disk headroom (default
  8 GiB, strictly `> 0`)
- `resources`: warning/critical thresholds and recovery hysteresis matching
  `yoke/pkg/resources.DefaultWatchConfig` (`85%`/`95%` used or `20 GiB`/`10 GiB`
  free disk, recovery `<=80%` used AND `>=25 GiB` free across 3 samples and
  `>=60s`; `85%`/`95%` memory; `85%`/`95%` 5m CPU; `activated: false` by default
  so advisory observation is preserved until explicitly enabled)

### `bashy-artifact-manifest-v1` (`artifact.ManifestV1`)

Platform-specific protected closure resolved from `ProfileV1`:

- `schema_version`: `"bashy-artifact-manifest-v1"`
- `generation`: monotonically increasing positive integer; additive across
  upgrades so automatic cleanup never retires baseline generations
- `platform`, `profile_name`, `profile_digest` (`sha256:<64hex>`)
- `go_toolchain_version` (`1.27.4`), `product_overlay_sha` (`scripts/go-product.sh`
  + `tools/productgo` startup-signal overlay digest), optional `build_image_digest`
- `rebuild_reserve_bytes`
- `roots`: canonical sorted slice of `RootDescriptor` entries (`source`,
  `gotoolchain`, `gooverlay`, `gomod`, `binmgr`, `oci-image`, `podman-vm`,
  `ollama-model`, `lang-pack`), each pinned by `sha256:<64hex>` digest, byte
  size, media type, and dependency digests

### `bashy-artifact-record-v1` and `bashy-module-publication-v1`

- `CatalogRecordV1` stores digest, size, media type, logical name/version,
  dependency digests, provenance, `retention` (`protected`, `reconstructible`,
  `scratch`), `retention_roots`, and optional deterministic `RegenerationRecipe`
  (`gomod-zip-v1`, `oci-reproducible-v1`, `derived-cache-v1`). Non-deterministic
  regeneration (such as re-running an LLM) is forbidden by validation.
- `PublicationRecord` binds `(module, version)` immutably to its 40-hex commit,
  durable Loom ref `refs/bashy/published/<escaped-module>/<escaped-version>`,
  `.info`/`.mod`/`.zip` SHA-256 digests, and `go.sum` `h1:` hash. Identical
  re-publish is a no-op; divergent content returns
  `ErrImmutablePublicationConflict`.

## 2. Lease, GC authority and Windows file-lock rules

- Single supervised catalog writer over `bbolt`; ORAS filesystem CAS holds raw
  blobs outside `bbolt`. Payloads are written and digest-verified in ORAS before
  committing `bbolt` references.
- `Lease` records bind active readers/builders to `(service_epoch, holder_pid,
  holder_start_id, expires_at)`. Stale epochs and recycled PIDs lose authority
  immediately.
- `artifact.CanEvict` refuses deletion of any blob reachable from a protected
  root or dependency closure, any reconstructible record missing a retained
  recipe input, or any blob covered by an active lease.
- On Windows, mmap/open handles (`bbolt` and CAS readers) must close before
  rename or `os.Remove` (matching `yoke/pkg/dbstore/bboltdb` drop semantics).

## 3. Confinement-preserving tier placement and failure semantics

- `artifact.SelectTier` walks `profile.TierOrder` down to `profile.OfflineFloor`.
- In sealed mode, `cloud` is always excluded (`ErrSealedNetworkDenied` at fetch
  boundaries; skipped during tier selection).
- Fallback preserves workload confinement, target OS/arch, GPU and memory needs:
  a workload with `RequireSandbox=true` cannot fall through from `sandbox` to
  unconstrained `workplace` or `userland` (`ErrConfinementViolation`).
- When every tier down to `OfflineFloor` is unavailable, placement fails closed
  with `ErrOfflineFloorUnavailable` and per-tier reasons.

## 4. Permissive reuse boundaries and provenance

No bespoke downloader, blob store, KV database, Go module packager or second
prune framework is permitted:

| Concern | Upstream module | Baseline / target revision | License | Boundary |
| --- | --- | --- | --- | --- |
| CAS blob layout & OCI bundles | `oras.land/oras-go/v2` | `v2.x` (pinned in S1 `go.mod`) | Apache-2.0 | Direct Go import (`content/oci`, `oras.Copy`) |
| Transactional catalog & leases | `go.etcd.io/bbolt` | `v1.5.0` (existing in `yoke/go.mod`) | MIT | Direct Go import |
| Go module proxy HTTP protocol | `github.com/goproxy/goproxy` | latest permissive tag (pinned in S2) | MIT | Direct Go import behind `yoke/pkg/gomod` |
| Proxy single-flight & storage tests | `github.com/gomods/athens` | narrow attributed files if needed in S2 | MIT | Preserved copyright/license + `THIRD_PARTY_LICENSES.md` |
| Canonical module ZIP & `h1:` hash | `golang.org/x/mod` | `v0.42.0` (existing in `yoke/go.mod`) | BSD-3-Clause | Direct Go import (`modfile`, `module`, `zip`, `dirhash`) |
| OCI registry & container engine | `qiangli/zot` (`v2.1.22`), `qiangli/podman` | existing `external/zot`, `external/podman` | Apache-2.0 | Existing `binmgr` / engine wrappers |
| Guarded deletion CLI contract | `github.com/qiangli/yoke/pkg/prune` | existing `yoke` `17bf1a1d` | MIT | Register `artifact` `prune.Noun` + mount `bashy prune` |
| Host resource watch & floors | `github.com/qiangli/yoke/pkg/resources` | existing `yoke` `17bf1a1d` | MIT | Wire `watch.go` + `disk_floor.go` + `agentos/{resource_admission,limit}.go` |

Trust-root protection: `yoke/pkg/artifact` is registered in
`yoke/pkg/src.ProtectedManifest()` so shaped skills cannot weaken offline seal
or retention enforcement.

## 5. Coexistence with `tools/bashy-build` and runner workflows

- Sprint 653 (`R0–R9` built-in runner registry/pools and PID-1 reaper) closed as
  won't-do on 2026-11-25 in favor of registered custom runner commands
  (`bashy commands register`) and the rolling official build image
  (`bashy/tools/bashy-build`).
- Current `bashy/tools/bashy-build/image.lock` baseline:
  - `bashy_version=v1.0.0-rc.40`
  - `go_version=1.27.4` (`amd64` `7226736c2339719cda28fbf3a54d71aa63bcefe376e98cef00034268dab24840`,
    `arm64` `3392582988a273a87ab5043ee1b2c9c17a2c3c00580bf9326c47a2e0aaaeac92`)
  - `apt_snapshot=20260821T190000Z`
  - `image_digest=sha256:1171628e07d3e7490458d9b0b484e689fee56c4a739e3f8ad577188eceece2ff`
- Product builds on Unix apply `bashy/scripts/go-product.sh` (`tools/productgo`
  startup-signal `runtime.fwdSig` overlay). Offline `self build` and S7's
  self-hosting fixed-point gate preserve and invoke this product overlay rather
  than raw `go build`.
- Shared remote test lanes on the Windows gate host, Linux podman gate host, and
  macOS QA host are coordinated via `bashy claim` before running heavy suites.

## 6. Recorded baseline inputs and failure ledger (2026-11-26)

- Synchronized source baseline at Sprint 654 start:
  - `coreutils`: `5f9da9132e14`
  - `yoke`: `17bf1a1dda58` (`yoke/test/known-failures.txt`: 0 known failures)
  - `bashsharp`: `9d621d8cdd7e`
  - `outpost`: `24c7e91e39b1`
  - `bashy`: `b873a4a6`
- Pre-existing venue/release observations tracked outside Sprint 654:
  - `14323dfcce0a` (unlinked standalone P3 observation): `bashy` invoked as `sh`
    with empty `PATH` on `echo` (venue fixed in `bashy` `5544f40c`).
  - Gate-host WSL idle termination when no `wsl.exe` session remains attached
    (tracked in Sprint 677 `K1` `73dbfa3a`; mitigated by keeping runner sessions
    attached during container gates).
  - Pre-existing `yoke/scripts/crossvet.sh` cross-OS `go vet` failure reproduced
    on untouched `yoke` `17bf1a1dda58` from macOS (`proglottis/gpgme` cgo-only
    files excluded under cross-OS `CGO_ENABLED=0` without
    `-tags containers_image_openpgp`, plus `external/podman/src/pkg/util/rlimit.go`
    on `GOOS=windows`). Touched Sprint 654 packages (`./pkg/artifact/...`,
    `./pkg/atlas/...`, `./pkg/src/...`, `./pkg/gomod/...`, `./pkg/prune/...`,
    `./pkg/resources/...`) are individually gated across `GOOS=windows`,
    `GOOS=linux`, and `GOOS=darwin` alongside `scripts/fmtcheck.sh`.
  - Historical release/test races and venue notes remain catalogued in
    `docs/release-failure-ledger.md`.
