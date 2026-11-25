# Sprint 719 evidence: bashy v1.0.0-rc.41 candidate

One shared evidence record for the rc.41 candidate. Hosts are named by role.

## Candidate

- **bashy**: `0665ffb3da511efd1cca7b547a65a97c37a62050` (main)
- **outpost** `764d9dfcf361d3274642f0b7afd9000204d21c0a`, **yoke** `89fc8e423b5425ab8ea4b0c88bfc18c849fcb7b3`, **ycode** `fcc970b2f4216803a32464cca474295b32bfd9a0`, **bash** `5c52281f7136ecef072e75e34156e11b5652a931`
- **Umbrella pins**: `2148f6941`
- **Official image**: `localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3`, digest `sha256:1171628e07d3e7490458d9b0b484e689fee56c4a739e3f8ad577188eceece2ff`; Go 1.27, toolchain go1.27.4
- **Venue**: gate host, WSL2 lane 3, 8 CPU / 7 GiB per container, `--init`; Windows legs on the same host's native Windows side
- **Outer runner** `bin/bashy` sha256 `e11b6dcadca4bd31c0d7624e64837414db2dd56b05f1461e312108bca6628be7` (`5.3.0(1)-bashy-dev (0665ffb)`)

## Legs

| Leg | Run | Commit | Result |
|---|---|---|---|
| 1 `bashy dag build` | 4 | 0665ffb3 | rc=0 |
| 2 `bashy dag test` (official image, candidate as runner) | 4 | 0665ffb3 | rc=0, `dag: 10 target(s) ok`, 999 s |
| 3 sealed Bash 5.3 gate, both Bash# modes | 1 | bd47b043 | 86/86 each mode; evidence sha256 mode 0 `c29c19d025af1ce86153b933d0bebca4d037246d722159a08d176d612066fe50`, mode 1 `5a855c99650dd8d3b8e196660f682ad36ec197b7a4c88ba2d71402cb06e7ca06` (reused, see below) |
| 4 dispatch e2e, Linux fresh install | 4 | 0665ffb3 | rc=0 |
| 4 dispatch e2e, native Windows, adapter cache set | 5 | 0665ffb3 | rc=0, 745 s |
| 4 dispatch e2e, native Windows, adapter cache unset (cold build into the default cache) | 5 | 0665ffb3 | rc=0, 571 s |
| 5 shaping lifecycle smoke with the browser checkpoint | 5 | 0665ffb3 | PASS, 27 checks (alice/bob revision views) |
| outpost `go test -short` (minus `internal/agent/shell`) | 4 | 764d9dfc | rc=0 |
| yoke unit tests | 3 + 4 | 89fc8e42 | green except `pkg/llmbudget` in run 3 (venue, below); `TestMultiprocess*` 5/5 alone in run 4 |
| govulncheck precheck (bashy 3 profiles, outpost, yoke) | 4 | as above | 0 reachable everywhere |
| dist | 5 | 0665ffb3 | 34 assets, complete, `checksums.txt` sha256 `f44bc45bc44ca91b3385975614e493a2ca3d5a41ce9e2edb90454e31b0c52226` |
| local release receipt (`scripts/local-release-gate.sh`) | 5 | 0665ffb3 | license pass, govulncheck pass (DB 2026-11-24T15:56Z), no override; `evidence.json` sha256 `a3dcf3d98ff9e1f8f9a150e571e662c80c70ba294458184908d3d663aa401b11` |

Windows binaries (run 4 cross-build): `bashy.exe` `69381b90ba931e9316388bb4d9e2b7c646f76c447af44c3e6c3ad58da53750b9`, `agentos.test.exe` `ed09de867b91a1b41ead9b81e3174122b59f15a72d773e2c62f0cac6d18d126b`; same hashes on the Windows side.

**Leg 3 reuse.** The gate drives `bin/bash`, built from `github.com/qiangli/bash/cmd/bash`. Between bd47b043 and 0665ffb3 no engine path (`cmd/bash`, `internal/cli`, `tools/bash53suite`, `native`) and no engine pin (bash, sh, bashsharp, coreutils, readline) changed, and `go list -deps` of `cmd/bash` resolves the identical 8-module set at both commits (none of the bumped modules is in it).

## Findings and root causes

- **Desk apps unbuildable on a fresh host** (story `292a832dded0`, product): apps pinned kit/chart versions that no proxy serves or whose go.sum hash disagreed with the published tree. Fixed in bashy 54fcfae9 with `TestDeskModuleConsumersMatchPublishedVersions`. Same commit regenerated stale embedded adapters.
- **Receipt red: 4 reachable advisories** (story `79e8295f4a48`, advisory data): otel GO-2026-6974/6975, gobwas/ws GO-2026-6940, gorilla/websocket GO-2026-6278. Fixed by dependency bumps (no override).
- **outpost build broken by the bump** (product, introduced and fixed in this sprint): otelgin v0.72.0 needs quic-go v0.63.0, which webtransport-go v0.11.1 does not build against. Held otelgin v0.69.0 / quic-go v0.60.0.
- **Venue reds** in run 2 and run 3, reproduced green alone: `test-startup-linux` under concurrent load; govulncheck OOM under the 7 GiB container cap; `pkg/llmbudget` meter lock 5 s timeout under load.
- **macOS QA host** (story `eca66cccda36`, venue): uptime past the 49.7-day TCP timer wrap froze TIME_WAIT and refused outbound connects. Rebooted with operator approval; TIME_WAIT 47, outbound HTTPS 200.

## Release

- `v1.0.0-rc.41-dev`: one release.yml run, 45641994904, published 34 assets as a pre-release (target 0665ffb3).
- Tier verdict `release/tier-verdicts/0665ffb3.json` (bashy d14a9c7c): PASS on Linux, Windows and macOS. QA refs `refs/qa/v1.0.0-rc.41/{linux,darwin,windows}` and umbrella tag `candidate/bashy-v1.0.0-rc.41` (cd977f0e3).
- Promoted on the operator's go, 2026-11-25 09:33 PST: bare tag `v1.0.0-rc.41` -> 0665ffb3. promote.yml run 45665724813 created the Latest release with 28 assets (the 6 `-dev`-versioned Linux packages are not promoted, as with rc.37). Its `checksums.txt` is identical to the -dev release's (`f44bc45b…`).
- Release registration failed in both runs: the script required a darwin/amd64 outpost, which is not built (story `a0f0c4aadb31`). Fixed after promotion in bashy 33eb4197 with a regression test. rc.41 is published but not registered, so outposts do not auto-update to it.
