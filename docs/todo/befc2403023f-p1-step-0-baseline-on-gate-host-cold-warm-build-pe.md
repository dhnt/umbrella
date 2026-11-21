---
id: befc2403023f
kind: chore
title: 'P1: Step 0 baseline on gate host - cold+warm build, per-OS sizes, package counts, whole-bashy rebuild-verify time'
seq: 587
status: assigned
priority: p0
created: 2026-11-21T09:22:07.427138Z
weave: 109
assignee: ycode-cascade-x3
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

P1 baseline, SMALLEST SET FIRST (relaunch spec 2026-11-21). Frozen start commit: bashy 5c8be965 - WAIT: origin bashy main has since advanced with S8/S8b script-only changes (ecdab0cd, 1bd504d6) which do not affect build measurements; measure at umbrella HEAD and RECORD the exact bashy sha measured (must be pre-A toolchain go1.27.2). Venue: claim ONE shared gate lane, official image ONLY via bashy oci, LAUNCHING SESSION ATTACHED (foreground, never detached - WSL idle-reboots kill detached containers, see root cause below). MEASURE IN THIS ORDER, committing results to this story file in your workspace AFTER EACH item so a kill loses nothing: (1) clean cold bashy dag build time, (2) warm dag build time, (3) per-OS binary sizes from the builds you already produced, (4) package counts (go list -deps). Record image id with the first commit. DEFERRED until gate-host keep-alive: whole-bashy rebuild-verify cycle and any long measurement. Propose P3/P4 thresholds only from recorded numbers.

HISTORY: run #105 (ycode-cascade-x4) KILLED by wrapper max-runtime 48m0s (killed_by field, exit -1), 0 commits, clean tree - watchdog, not manual kill, not resume collision. Its silence root cause was ENVIRONMENT: gate-host WSL idles/reboots (6 boots 01:35-02:01 PST, 20s-6min), killing detached lane containers. Worker exonerated. Manager interim deadline dropped as invalid.

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
