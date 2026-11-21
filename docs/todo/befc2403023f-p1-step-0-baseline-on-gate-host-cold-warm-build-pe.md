---
id: befc2403023f
kind: chore
title: 'P1: Step 0 baseline on gate host - cold+warm build, per-OS sizes, package counts, whole-bashy rebuild-verify time'
seq: 587
status: assigned
priority: p0
created: 2026-11-21T09:22:07.427138Z
weave: 113
assignee: agy-gemini4-carbon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

P1 baseline, SMALLEST SET FIRST (relaunch spec 2026-11-21, run 3: agy-gemini4-carbon). START FROM the existing gate-host lane1 scripts /root/lanes/lane1/s677-p1/measure.sh + lane.sh (already written by prior runs) - do not rewrite the harness; run it, fix only what blocks execution. Frozen start commit: bashy 5c8be965 - WAIT: origin bashy main has since advanced with S8/S8b script-only changes (ecdab0cd, 1bd504d6) which do not affect build measurements; measure at umbrella HEAD and RECORD the exact bashy sha measured (must be pre-A toolchain go1.27.2). Venue: claim ONE shared gate lane, official image ONLY via bashy oci, LAUNCHING SESSION ATTACHED (foreground, never detached - WSL idle-reboots kill detached containers, see root cause below). MEASURE IN THIS ORDER, committing results to this story file in your workspace AFTER EACH item so a kill loses nothing: (1) clean cold bashy dag build time, (2) warm dag build time, (3) per-OS binary sizes from the builds you already produced, (4) package counts (go list -deps). Record image id with the first commit. FIRST COMMIT WITHIN 15 MINUTES (image id + first number or a blocker note) - two prior runs died with zero commits. DEFERRED until gate-host keep-alive (K1 73dbfa3a): whole-bashy rebuild-verify cycle and any long measurement. Propose P3/P4 thresholds only from recorded numbers.

HISTORY: run #105 (ycode-cascade-x4) KILLED by wrapper max-runtime 48m0s (killed_by field, exit -1), 0 commits, clean tree - watchdog, not manual kill, not resume collision. Its silence root cause was ENVIRONMENT: gate-host WSL idles/reboots (6 boots 01:35-02:01 PST, 20s-6min), killing detached lane containers. Worker exonerated. Manager interim deadline dropped as invalid.

RUN #109 FAILURE RECORD (2026-11-21, conductor claude+2 + manager verification): WORKER-CAPABILITY failure, NOT environment this time. Conductor gate-host evidence: NO container running (podman ps empty), /root/lanes/lane1/s677-p1/measure.sh last written 02:19 PST, WSL continuously up 44m (idle-shutdown cause excluded). Manager evidence: 44m elapsed, ZERO commits against the commit-after-each-item spec, workspace clean at base 4139ac45, no PTY/steer channel, lane lease lapsed; run stopped by manager (weave kill) / terminal state failed, head 4139ac45, 0 commits salvaged (nothing to salvage). ycode-cascade-x3-e produced gate-host scripts in an earlier attempt but never executed a measurement in run #109. P1 reassigned to agy-gemini4-carbon per conductor + operator agy preference.

OPERATOR RULE 2026-11-21: no long-running tests during implementation. Already consistent here: whole-bashy rebuild-verify cycle stays DEFERRED (now: deferred to the milestone integration gate .bashy/gate.final, conductor-called, per operator rule 2026-11-21; integration runs at epic/milestone completion only). This run measures builds/sizes/counts only.

## Measured Baseline (2026-11-21, weave #113, `agy-gemini4-carbon`)

### Venue, Official Image & Source Identity

- **Venue**: Windows `amd64` gate host, WSL2 Ubuntu 24.04 shared gate lane 1 (`8` CPUs, `7` GiB RAM, claimed lease epoch 4), foreground-attached `bashy oci run --rm --init --cpus 8 --memory 7g -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 -e BUILD_ID=5c8be965 --entrypoint /usr/bin/dash`.
- **Official build image (`tools/bashy-build/image.lock`)**:
  - Tag: `localhost/bashy-build:v1.0.0-rc.37-go1.27.2-c99fcb7318b2`
  - Image ID: `980ae8d4b8789bf9693ea86491bf4c6b70515228a9e1bbcd7a49f225e47eacd5` (`980ae8d4b878`)
  - Image digest: `sha256:c99fcb7318b23ed06b3775368ee3966795a5498fb9a050a92d6f21866680b7ba`
  - Toolchain: `go1.27.2` (`GOTOOLCHAIN=local`), image `/bashy` `v1.0.0-rc.37`
- **Measured `bashy` source SHA**: `5c8be9655657a782b443d28415f749f1f0fdf381` (`5c8be965`, pre-A `toolchain go1.27.2`, `go.mod` SHA-256 `26d5ecd0b5f436e297958c6b35d5de54513d7f357f466b2023807862d61c8997`).
  - Provenance note: pre-A umbrella base `4139ac45` pinned `bashy` `1bd504d6` (`5c8be965..1bd504d6` touches only `scripts/local-release-evidence.py` and `scripts/test-local-release-evidence.py`, with identical `go.mod`/`go.sum`/Go build inputs); workspace umbrella `HEAD` `33b30c5ba` subsequently merged Phase 0A `go1.27.4` (`fbeccbea`) + C (`00b9edcc`), so the pre-A `5c8be965` source staged in lane 1 `measure.sh` was measured per the pre-A `go1.27.2` requirement.

### (1) Clean Cold `bashy dag build` Time

- **Cache state**: Fresh empty OCI volume (`GOMODCACHE`, `GOCACHE`, and `GOTMPDIR` empty; `305` `go: downloading` module lines; `bin/` absent).
- **Command**: `rm -rf bin && /bashy dag build && ls -l bin` (executes `build-bash` + `build-bashy` including `elfaudit --bashy-signal` and `releaseeligibility` + `build`).
- **Result**: **`136.468s`** (`137s` integer wall seconds, `2m 16.5s`), exit `0` (`dag: 3 target(s) ok`).

### (2) Warm `bashy dag build` Time

- **Cache state**: Same OCI volume (`lane1-s677p1-cold`) immediately after Stage 1 (`GOMODCACHE` and `GOCACHE` warm; zero source edits).
- **Command**: `rm -rf bin && /bashy dag build -B && ls -l bin` (matches `measure.sh` Stage 2).
- **Result**: **`26.011s`** (`26s` integer wall seconds), exit `0` (`dag: 3 target(s) ok`).
  - Bottleneck observation in container (`GOROOT=/usr/local/go` outside `GOMODCACHE`): even without copying the SDK tree, `tools/productgo` writes `signal_unix.go` + `overlay.json` into a fresh `os.MkdirTemp` directory per invocation (`build-bash` + `build-bashy`), invalidating the `runtime` overlay path and relinking `bin/bash.real` + `bin/bashy`, followed by `go run ./tools/elfaudit` and `scripts/go-tool.sh releaseeligibility` recompiling in a fresh `mktemp -d` (`GOWORK=off`).

### (3) Per-OS Binary Sizes (Default Lean Worker `dag build` Profile)

Produced inside the locked official build image (`go1.27.2`, `-trimpath`, `bash` linked with `-s -w`, `bashy` linked with `-w` without `-s`):

| Target (`GOOS/GOARCH`) | Artifact | Exact Size (bytes) | Size (MB / MiB) | SHA-256 | Notes |
|---|---|---:|---:|---|---|
| `linux/amd64` | `bin/bash` | `16,896` | `0.02 MB` / `0.02 MiB` | `28d1e291a72c7ef90c2a9d32558845a72c5eccbc5212e839e24821540eadeffb` | Native C signal-forwarding launcher (`native/siglaunch.c.in`) |
| `linux/amd64` | `bin/bash.real` | `18,604,295` | `18.60 MB` / `17.74 MiB` | `6690a448d4a2a9387e95378ededd6ad0e2f0cfa502f9b3f24bc78729a3a84286` | Pure drop-in shell (`github.com/qiangli/bash/cmd/bash`, `-s -w`) |
| `linux/amd64` | `bin/bashy` | `291,439,456` | `291.44 MB` / `277.94 MiB` | `08bac3e516bdbe16e326ff22b37fc0f7270b927872b4d0112a82be2f97387e0b` | AgentOS shell (`./cmd/bashy`, `-w`, retains ELF `SHT_SYMTAB` + `runtime.fwdSig`) |
| `darwin/arm64` | `bin/darwin-arm64/bash` | `17,362,098` | `17.36 MB` / `16.56 MiB` | `9b81bbc9eaea78efba62b0b730e0018c1b125f638c95fa9e0913c7798e5827ac` | Cross-built (`CGO_ENABLED=0`, `-s -w`) |
| `darwin/arm64` | `bin/darwin-arm64/bashy` | `222,082,754` | `222.08 MB` / `211.80 MiB` | `60262cb61aded0cc7f90d99499db2c839164cf42b440c915a64adacc6fddc7ba` | Cross-built (`CGO_ENABLED=0`, `-w`, unstripped Mach-O; cold cross-compile `92.816s`) |
| `windows/amd64` | `bin/windows-amd64/bash.exe` | `19,064,832` | `19.06 MB` / `18.18 MiB` | `fbce314b9e38d06609832529d4a5aab74c0b0bcf422f97b3fea0872b7fa3846c` | Cross-built (`CGO_ENABLED=0`, `-s -w`) |
| `windows/amd64` | `bin/windows-amd64/bashy.exe` | `232,139,264` | `232.14 MB` / `221.39 MiB` | `ef46fb8e7e2961a09b7a7dddcf597e52a2b89b6aeefbd15ac020a3307b066748` | Cross-built (`CGO_ENABLED=0`, `-w`, unstripped PE; cold cross-compile `87.136s`) |

### (4) Package Counts (`go list -deps`)

Measured in the locked official build image (`go1.27.2`, wall `7.971s`):

| Target / Build Tags | `GOOS/GOARCH` | Transitive Packages (`go list -deps`) | Notes |
|---|---|---:|---|
| `./cmd/bashy` | `linux/amd64` | **`2,283`** | Default lean worker build |
| `./cmd/bashy` | `darwin/arm64` (`CGO_ENABLED=0`) | **`2,283`** | Cross-build graph (`2,284` on native Darwin with CGo/`go.work`) |
| `./cmd/bashy` | `windows/amd64` (`CGO_ENABLED=0`) | **`2,275`** | Windows cross-build graph |
| `./cmd/bashy -tags bashy_scratch` | `linux/amd64` (`CGO_ENABLED=0`) | **`2,277`** | Static scratch container profile |
| `./cmd/bashy -tags bashy_core` | `linux/amd64` | **`917`** | Pre-P2 core tag (includes **`23`** leaked `github.com/qiangli/yoke*` packages) |
| `github.com/qiangli/bash/cmd/bash` | `linux/amd64` | **`207`** | Pure Bash 5.3 + Bash# drop-in (`build-bash` target; `0` `yoke`, `0` `coreutils`) |
| `./cmd/sh` | `linux/amd64` | **`207`** | Pure strict POSIX `sh` (`build-sh` target) |

Module-family breakdown inside `GOOS=linux GOARCH=amd64 go list -deps ./cmd/bashy` (`2,283` total):
- `github.com/qiangli/yoke*`: **`245`** packages (`23` of which currently leak into `-tags bashy_core`)
- `github.com/qiangli/coreutils*`: **`177`** packages
- `github.com/qiangli/bash*`: **`30`** packages
- `github.com/bashsharp/bashsharp*`: **`4`** packages
- `k8s.io/*` + `sigs.k8s.io/*` + `github.com/google/gnostic*`: **`283`** packages (`268` `k8s.io/*`, `10` `sigs.k8s.io/*`, `5` `gnostic*`)
- `github.com/gtsteffaniak/filebrowser*` + `github.com/swaggo/*`: **`37`** packages
- `github.com/odvcencio/gotreesitter*`: **`2`** packages
- `github.com/tiktoken-go/*`: **`2`** packages

Harness execution notes (fixing only what blocked execution in `measure.sh` without rewriting the harness):
1. Stage 3 in `measure.sh` wrote all cross-builds to default `bin/bashy`, which overwrites `linux/amd64` with `darwin/arm64`; passing `BIN_DIR=bin/<os>-<arch>` preserved all three OS pairs independently.
2. Stage 4 in `measure.sh` invoked `go list -deps ./cmd/bash`, which does not exist as a local directory under `bashy/cmd/` (`cmd/` contains `bashy` and `sh`, while `dag.md`'s `build-bash` compiles `github.com/qiangli/bash/cmd/bash`); queried `github.com/qiangli/bash/cmd/bash` and `./cmd/sh`.

### Deferred Items (Blocked on Gate-Host Keep-Alive `K1` `73dbfa3a` / `K1b` `ffd48cc9`)

- Whole-`bashy` edit -> rebuild -> full-gate-verify cycle time (including full `bashy dag test` + sealed Bash 5.3 conformance gate in both modes) and any other long-running gate-host measurements remain **deferred** until supervised WSL keep-alive (`K1` `73dbfa3a`) is active on the gate host.

### Proposed P3 & P4 Thresholds (Derived Strictly from Recorded Baseline Numbers)

1. **P3 (`d3989b11` + `S1` `d49c099b` — catalog-driven dispatch, generated mains, on-demand slot builds, build caches)**:
   - **Warm `bashy dag build` time (8-CPU gate-host official image)**: **`<= 12s`** (>2x reduction vs recorded **`26.011s`** warm `dag build -B`, and within the Sprint 677 `< 15s` target once `tools/productgo` overlay temp-dir busting and `scripts/go-tool.sh` disposable `releaseeligibility` recompilation are cached).
   - **Single-command pilot warm slot build (`go build` of generated `main` into `yoke/pkg/shape/slot`)**: **`<= 10s` warm** on an 8-CPU gate-host lane (>2.5x faster than recorded **`26.011s`** warm monolith `dag build -B`), and **`< 0.1s` (zero compile)** on a tree-hash cache hit.
   - **Single-command pilot cold-`GOCACHE` build (`GOMODCACHE` warm, `GOCACHE` empty)**: **`<= 45s`** (<50% of recorded **`87.136s`–`92.816s`** cold-`GOCACHE` monolith compilation).
   - *Whole-`bashy` edit -> full-gate-verify cycle threshold (minutes)*: **deferred** until the whole-`bashy` rebuild-verify baseline is recorded after `K1` (`73dbfa3a`) lands.

2. **P4 (`P4a` `ee056056` -> `P4b` `52a3c08d` -> `P4c` `5b9440a0` — full command externalization to generated-main slot binaries)**:
   - **Entry `./cmd/bashy` transitive package count (`GOOS=linux GOARCH=amd64 go list -deps ./cmd/bashy`)**:
     - From recorded **`2,283` packages** -> **`<= 2,150`** after `P4a` (`yoke/cmds/*` applets + GNU-only `coreutils`) -> **`<= 1,800`** after `P4b` (standalone verbs; specifically **`0` `k8s.io/*`** vs recorded **`268`**, **`0` `filebrowser`/`swaggo`** vs recorded **`37`**, **`0` `gotreesitter`** vs recorded **`2`**, **`0` `tiktoken`** vs recorded **`2`**) -> **`<= 950` packages** after `P4c` (all switch verbs externalized; >58% reduction from **`2,283`**, converging to the recorded **`917`** `-tags bashy_core` neighborhood minus the **`23`** `yoke` leak packages).
   - **Entry `bin/bashy` per-OS binary sizes (default lean worker profile, combined with `S2` `-s -w` off Linux)**:
     - After `P4b`: drop by **`>= 55 MB`** across targets relative to recorded baselines (`linux/amd64` **`<= 235 MB`** vs **`291.44 MB`**; `darwin/arm64` **`<= 165 MB`** vs **`222.08 MB`**; `windows/amd64` **`<= 175 MB`** vs **`232.14 MB`**).
     - After `P4c` (thin `bashy` entry complete): `darwin/arm64` **`<= 45 MB`** (vs recorded **`222.08 MB`**, >=80% reduction), `windows/amd64` **`<= 45 MB`** (vs recorded **`232.14 MB`**, >=80% reduction), and `linux/amd64` **`<= 60 MB`** retaining ELF `SHT_SYMTAB` + `runtime.fwdSig` (vs recorded **`291.44 MB`**, ~80% reduction; bounded below by recorded **`18.60 MB`** `bash.real` + POSIX `coreutils` + thin dispatcher), with warm `cmd/bashy` entry rebuild **`<= 5s`** on the 8-CPU gate-host lane (vs recorded **`26.011s`**).
