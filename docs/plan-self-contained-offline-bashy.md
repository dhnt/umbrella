# Sprint 654 — self-contained offline bashy: master execution plan

Status: active implementation authorized by operator on 2026-11-26 (`agy-gemini4-carbon-s654`).
Sprint UUID: `e505bc2c-9f7b-5ce5-a426-7b88c6a8d198`.

## Outcome and hard guarantees

After verified bootstrap, bashy can rebuild itself, develop and run Go/Bash#
programs, create sandboxes, and perform inference and embeddings without Internet
access. New external dependencies require explicit verified import. Linux,
macOS and Windows use the supported release platform matrix; container VM assets
are part of the platform closure. Other fenced languages are configurable packs.

The bootstrap baseline and its transitive runtime AND build inputs are never
automatically deleted. Published internal source and immutable version identity
remain durable. Derived outputs are removable only when their exact promised
content can be recovered from retained inputs. When durable data exhausts
capacity, stop growth and alarm rather than destroy the rebuild guarantee.

Tier preference is configurable, initially cloud -> cluster -> sphere -> sandbox
-> workplace -> userland. The offline floor is independently configurable,
default userland. External cloud is excluded in sealed mode. Fallback must
preserve confinement, target OS and declared workload requirements; it cannot
turn a sandboxed task into an unconstrained host command. Required local model
profiles must pass hardware readiness before sealing.

## Reuse and implementation ownership

| Concern | Implementation | Bashy-specific additions |
| --- | --- | --- |
| Disk blobs | Apache-2.0 ORAS Go filesystem CAS | Catalog integration and retention eligibility |
| Metadata | Existing MIT bbolt dependency | Protected roots, publication records, recipes and leases |
| Go proxy | MIT goproxy handler/fetcher | CAS adapter, sealed acquisition rules and internal publication |
| Missing proxy mechanisms | Import or narrowly copy MIT Athens code and tests | Integration only; preserve upstream semantics |
| Module ZIPs and hashes | golang.org/x/mod | Bind exact source/version to packaging identity |
| Managed runtimes | Existing binmgr and gotoolchain | Retention roots and explicit offline resolution |
| Images and sandboxes | Existing Podman and image-library integration | Protected image recovery and sealed builds |
| Source and jobs | Existing Loom and runner interfaces | Durable publication refs and local job inputs |
| Resource control | Existing resource watcher, admission and prune packages | Policy-controlled response and retention-aware candidates |

Prefer imports. If an upstream internal package prevents reuse, copy only the
needed source and tests, preserve copyright/license/NOTICE, record upstream
revision and source paths, identify modifications and add THIRD_PARTY_LICENSES
entries. Review actual linked dependencies for permissive licensing. Keep
release code pure Go with CGO_ENABLED=0. Do not add a generic custom downloader,
blob store, database, module packager or second pruning framework.

Common engines belong in yoke; bashy owns front-door wiring and product profile
policy. No new agentic imports into the certified shell/coreutils layer.

## Story sequence and gates

| Story | ID | Depends on | Delivery and acceptance |
| --- | --- | --- | --- |
| S0 Contracts and reuse | `6b538b5383c5` | None | Freeze versioned profile/manifest contracts, publication and retention semantics; record upstream provenance, current baseline and runner compatibility |
| S1 Store/catalog service | `60d8af61317e` | S0 | ORAS CAS + bbolt; single writer; durable publication, leases, recovery and guarded prune; crash/concurrency/disk-full tests |
| S2 Go proxy/publication | `2cdd5b99ad8e` | S1 | Standard Go proxy, immutable publication from durable Loom commits, canonical ZIP regeneration with original hashes; separate clean-cache consumer |
| S3 Bootstrap/seal/recovery | `4451c946a2bd` | S1, S2 | Complete closure, capacity reserve, sealed invocation environment, status and verified import/export; fresh-cache offline rebuild |
| S4 OCI/sandbox | `8e90d251e54b` | S1, S3 | Recover engine storage, protect base/build images and VM assets, build/run Go/Bash# offline; configurable language packs |
| S5 Models/tiers | `7474cf217246` | S1, S3 | Complete pinned model/runtime packs, evaluated profiles, tier placement and floor-aware refusal/fallback |
| S6 Resource automation | `bbe36dcf5a92` | S1, S4, S5 | Retention-aware reclaim, admission, throttling, idle-model unload and local/OTel alarms under injected pressure |
| S7 Loom/release gates | `e47d43824892` | S2, S3, S4 | Durable refs, local workflow helpers, locked runner inputs and native-platform offline self-hosting fixed-point gate |
| S8 Platform acceptance | `7a13a0e20dc8` | S3–S7 | Clean-host recovery and network-denied acceptance across release matrix with raw evidence and cost/size measurements |

Execute S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> S6 -> S7 -> S8 without delegating
agents unless the operator explicitly requests it. S0–S3 are P0 bootstrap
dependencies; S4–S8 are P1. Submit each story as soon as its own acceptance and
relevant regression gates pass. Manager independently accepts; filing this plan
does not assign or start the manager seat.

## Interfaces and data flow

### Artifact service

Default root: $BASHY_HOME/artifacts, configurable on local disk. ORAS owns blob
ingestion/fetch/deletion. Large payloads stay outside bbolt. One supervised
service serializes catalog writes and reclamation; local clients use loopback,
remote clients use existing authenticated mesh/service exposure. No publicly
writable registry or new authentication system.

Versioned catalog records identify digest, size/media type, platform, immutable
logical name/version, dependency descriptors, provenance, retention roots and
regeneration recipe. bbolt owns transactional indexes and publication state.
Portable protected manifests carry the authoritative recovery identities;
volatile indexes are reconstructible. Lease records bind active operations to
their process/service instance so stale processes cannot retain authority.

Write verified ORAS payloads before committing references. An interrupted write
may leave an orphan but must not expose incomplete content. Journal and
reconcile publication/eviction transitions after restart. Readers acquire leases
before accessing reclaimable payloads; prune rechecks roots and leases at apply.
Do not run ORAS automatic GC independently of the catalog's protected graph.
Never remove a shared blob while any protected or active reference reaches it.

Prune can evict a derived payload while preserving its publication/recipe record.
Missing inputs are an explicit recovery error, never permission to fetch online.
Generated source must be retained verbatim; rerunning an LLM is not recovery.

### Go proxy and publication

Preserve `bashy go` transparent argument forwarding (`gotoolchain.NewGoCmd()`), and extend existing `bashy mod proxy` (`yoke/pkg/gomod`) to `bashy mod proxy serve/publish/status` backed by the protected artifact store.
Reuse the upstream protocol handler and fetcher. Internal publication first
persists exact source in Loom and a durable ref, then produces immutable .mod,
.info and canonical .zip records. Existing module/version content cannot change.
On a reclaimed ZIP miss, single-flight packaging rebuilds from exact retained
inputs and checks the original hashes before serving consumers.

Sealed Go invocations use the local proxy with no direct fallback and
GOTOOLCHAIN=local. Apply the same rules to Go/Bash# fences, compiled bridges,
sandbox builds and runners, including child environments. Imported public
dependencies are authenticated during acquisition; retain h1 hashes, go.sum and
trusted manifests. Public checksum-database access is disabled only within the
managed sealed environment, with local hash verification still enforced.

### Bootstrap lifecycle

Add bashy self bootstrap, seal, verify --offline, status, export and import.
Bootstrap resolves profile-v1 into a platform-specific protected manifest-v1,
collects and authenticates inputs, reserves rebuild headroom, and verifies the
selected capabilities before activation. Profiles declare tier order/floor,
languages, models, capacity and automatic-response policy. Incomplete or
unsupported profiles cannot seal and status must enumerate missing artifacts.

Capture exact source/nested siblings/replacements, Go toolchain/runtime overlay,
dependency graph, build metadata/scripts, images, managed helpers, VM bootstrap
assets, model payloads and selected language runtimes. Retain local package
archives/snapshot metadata for build-image steps that currently use apt/curl.
Runtime caches and compilation caches are disposable projections of these roots.

Seal denies Internet acquisition at both the managed fetch boundary and the
execution/network boundary appropriate to the workload. Environment variables
alone do not establish isolation. Permit explicit authenticated internal service
routes. No public DNS, registry, workflow helper, toolchain, model or telemetry
fallback is allowed. Preserve any previous unsealed installation behavior until
the profile is deliberately activated.

Use ORAS transfers/layouts for payload bundles; include protected manifests and
provenance. Verify bundle trust/digests and the whole closure before activation.
Reject traversal, escaping links, corrupt/incomplete imports and incompatible
platforms. Interrupted imports leave the current generation usable. New
generations are additive; automatic cleanup cannot retire baseline roots.

### OCI, models and local build jobs

Retain OCI baseline manifests and all layers independently of engine storage.
Restore through existing image tools. Sealed builds disallow external pulls and
network fetches, exposing only declared internal dependencies or mounted inputs.
Classify generated images as evictable only if exact identity is reproducible;
otherwise retain the payload or issue a new identity on reconstruction.

Go and Bash# are mandatory packs; other fenced languages are configurable.
Dependencies outside installed packs require import rather than network access.

Model defaults are evaluated candidates: Qwen3.5 4B plus Qwen3-Embedding 0.6B;
Qwen3.5 9B and Qwen3-Coder-Next are configurable workstation/server alternatives.
Pin every manifest/blob/template/tokenizer and inference runtime. Disable cloud
and automatic updates/downloads. Initially one request, one loaded model and 4K
context. Gate sealing on hardware and tool-call/code-edit/repair/retrieval
evaluation. Memory unloading must not delete protected weights. Optional model
eviction requires a policy-guaranteed accessible replica; weights are not
reconstructible from a model name.

Preserve Loom commits referenced by published artifacts, even if branches move.
Stage workflow actions/helpers locally. Coordinate Sprint 653 runner/build-image
changes; never bypass its official build environment or native target-OS rule.
Previous version builds candidate; candidate builds itself twice; successive
candidate-built binaries must be byte-identical with empty disposable caches.

## Resource policy

Watcher/admission/prune remain the common implementation. Local control and a
bounded emergency journal continue if OTel is unavailable. Only the activated
policy authorizes automatic mutation of bashy-owned artifacts/workloads.

| Signal | Warning | Critical |
| --- | --- | --- |
| Disk | 85% used OR below 20 GiB free | 95% used OR below 10 GiB free |
| Memory pressure | 85% | 95% |
| CPU | 85% for five minutes | 95% for five minutes |

All thresholds are configurable. Inspect relevant host and VM filesystems,
available memory, inode exhaustion and remaining rebuild reserves. Warn: remove
inactive scratch and oldest eligible derived data. Critical: block growth,
reduce concurrency and unload idle models. Disk recovery target is <=80% used
AND >=25 GiB free. Recover after three healthy samples and >=60 seconds.
Never terminate unrelated processes or delete durable inputs to satisfy a target.
If reclaim cannot reach the floor, keep admission blocked and alarm with reasons.
Emit actual reclaimed bytes, transitions, failures and fallback decisions locally
and through OTel. Preserve existing advisory-only behavior unless activated.

## Validation, evidence and integration

Do not run heavy suites on the dev host. Use registered local runners and the
official build environment, claiming shared capacity through existing lifecycle
commands. Record source SHA, profile/manifest, runtime/image identity, exact test
names, raw output and exit status. Establish baseline before changing a failing
lane; classify pre-existing failures separately. No new skip/rebaseline closes a
regression. Reuse evidence only when the relevant inputs are unchanged.

Required scenarios: pure-Go cross-build checks; every supported native platform;
empty module/build caches; offline self-hosting fixed point; module overwrite
refusal and identical ZIP recovery for a separate consumer; engine-storage loss;
new offline sandbox; inference/embeddings after restart; unavailable higher tiers;
critical pressure with only protected data left; interrupted publication/import;
corruption and disk/inode exhaustion; concurrent reads/GC/regeneration; Windows
open-file semantics; clean-host export/import recovery; public-network attempt
capture. Measure linked binary growth, module closure, protected/reclaimable
bytes, peak rebuild workspace, and rebuild/restore latency.

Commit and push producer changes inside submodules first, update consumer pins
only after producer publication, then commit umbrella gitlinks. Delivery commits
carry Sprint/Story/Story-ID trailers. Preserve foreign changes and use isolated
worktrees. This work does not authorize a release or bypass POSIX certification.

## 2026-11-26 review adjustments (against current heads)

- **Runner and build-image alignment**: Sprint 653 (`R0–R9`) closed as won't-do on 2026-11-25 in favor of registered custom runner commands (`bashy commands register`) plus the rolling official build image (`tools/bashy-build/{build.sh,run.sh,image.lock}` at Go `1.27.4`). S0, S4, S7 and S8 integrate directly with `tools/bashy-build` and registered custom runner scripts, claiming shared remote lanes via `bashy claim`.
- **Product Go startup-signal overlay**: Offline `self build` and bootstrap closure in S3/S7 retain and invoke `scripts/go-product.sh` / `tools/productgo` over Go `1.27.4` so offline self-rebuilds preserve the startup-signal contract and match rolling release binaries byte-for-byte.
- **Reuse and disambiguation**:
  - S0 uses `bashy-offline-profile-v1` and `bashy-artifact-manifest-v1` in `yoke/pkg/artifact`, registering the new guard-rail packages in `yoke/pkg/src`'s `ProtectedManifest()` and `yoke/pkg/atlas`.
  - S1 mounts top-level `bashy prune` overview (`prune.NewOverviewCommand`) and registers the `artifact` prune noun; Windows close-before-remove semantics follow `yoke/pkg/dbstore/bboltdb`.
  - S2 extends `yoke/pkg/gomod` (`bashy mod proxy serve|publish|status`), keeping `bashy go` a pure toolchain passthrough with sealed environment injection.
  - S3 folds `binmgr` tool seeds (`self seed`) into the unified ORAS portable bundle (`self export` / `self import`).
  - S6 wires `yoke/pkg/resources` (`watch.go` / `disk_floor.go`) + `yoke/pkg/prune` + `bashy/internal/agentos/{resource_admission,limit}.go` + Ollama idle-unload + `pkg/room`/OTel alerts (`yoke/pkg/admission` is turn-boundary inbox budgeting and stays untouched).
- **Triage cleanup**: Venue observation `14323dfcce0a` unlinked to standalone (`--sprint 0`); superseded intake `a73be9fa4889` closed.

## Current execution checkpoint

- 2026-11-26: Reviewed against `coreutils` `5f9da913`, `yoke` `17bf1a1d`, `bashsharp` `9d621d8c`, `outpost` `24c7e91e`, `bashy` `b873a4a6`.
- Triage cleaned (`14323dfcce0a` unlinked; `a73be9fa4889` closed) and Sprint 654 activated under `agy-gemini4-carbon-s654` with Gate A (`S0–S3`), Gate B (`S4–S6`) and Gate C (`S7–S8`).

## Research sources

- ORAS: https://github.com/oras-project/oras-go and
  https://pkg.go.dev/oras.land/oras-go/v2/content/oci
- bbolt: https://github.com/etcd-io/bbolt
- goproxy: https://github.com/goproxy/goproxy
- Athens: https://github.com/gomods/athens and
  https://docs.gomods.io/configuration/storage/index.html
- Go proxy/verification: https://go.dev/ref/mod and https://go.dev/doc/toolchain
- OCI distribution: https://specs.opencontainers.org/distribution-spec/
- Retention reference: https://nix.dev/manual/nix/2.34/package-management/garbage-collection
- Storage policy reference: https://docs.docker.com/build/cache/garbage-collection/
- Model runtime: https://docs.ollama.com/faq
