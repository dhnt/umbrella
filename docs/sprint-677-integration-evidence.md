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
| `bashy dag build` | - | - | - | - | Pending |
| `bashy dag test` | - | - | - | - | Pending |
| `bashy dag test-bash-gate` | - | - | - | - | Pending |

## 4. Execution Details & Failure Analysis

*(To be populated as each DAG line completes)*

## Appendix: Verbatim Failure Output

*(To be populated as each DAG line completes)*
