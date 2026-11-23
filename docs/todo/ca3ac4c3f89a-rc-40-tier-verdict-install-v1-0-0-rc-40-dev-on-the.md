---
id: ca3ac4c3f89a
kind: task
title: 'rc.40 tier verdict: install v1.0.0-rc.40-dev on the three QA lanes from the LAN copy, run tier1/tier2/tier3 per OS with the rc.37 tier-smoke kit, fold tier-all-native, write release/tier-verdicts/<c8>.json'
seq: 645
status: assigned
priority: p0
labels:
    - release
created: 2026-11-23T04:44:58.243594Z
weave: 162
assignee: claude-opus5.5
sprint: 692
---

Owner claude-opus5.5 (orchestrates from the dev box; the checks run ON the lane hosts, nothing heavy runs on the dev box). RELEASE: v1.0.0-rc.40-dev is published (pre-release, 34 assets) at bashy 6c36c0a7 (outpost a1c9307, yoke 3eb700cd, bashsharp b1a3183). LANES: ~/.bashy/release-hosts on the dev box lists linux-wsl, windows, darwin as user@host:port (private; never copy host names into committed text, say 'the Linux lane', 'the Windows lane', 'the macOS QA host'). KIT: ~/projects/poc/tier-kit-s692 (docs/tier-smoke.dag.md + script/tier-smoke-lib.sh, the rc.37 kit; PUBLIC_ROOT=../umbrella; TIER_REMOTE_EXEC defaults to ssh -o BatchMode=yes; run from that dir: bashy dag docs/tier-smoke.dag.md tier1 OS=linux HOST=<entry> etc.; DRY_RUN=1 first to see the steps). INSTALL (rule 6, no internet downloads): the verified assets are on the dev box at ~/Downloads/bashy-rc40-candidate (checksums.txt verified); scp the matching archive to each lane (bashy-linux-amd64.tar.gz to the Linux lane's root user; bashy-darwin-arm64.tar.gz to the macOS QA host, 30 GB free now, no bashy installed there; bashy-windows-amd64.zip to the Windows lane), verify sha256 on the host, unpack, install so that 'ssh HOST bashy --version' reports 5.3.0(1)-bashy-v1.0.0-rc.40 on the login PATH (the kit runs 'ssh HOST bashy -s'); keep the previous binary beside it as .prev. Never replace a bashy that is currently serving a lane job. RUN per OS: tier1, tier2, tier3 (OS=linux|windows|darwin HOST=<entry>; tier3 needs the host's podman/oci and a pinned FROM-scratch image built on the host with bashy dag build-image per the kit text; if a host cannot build it, record INCOMPLETE with the reason, never PASS), then tier-all-native OS=<os> folds. Evidence root .gfy-out/tier-smoke in the kit dir. VERDICT FILE: model = bashy release/tier-verdicts/fc55b280.json (schema dhnt.tier-smoke/v1, record release-tier-verdict, scope native, folds per OS, folds_required, not_run, commit = 6c36c0a734af7e00755aa9a7d2f5e8dee45a920d, release v1.0.0-rc.40-dev, sprint 692, story this id, umbrella = a PUSHED umbrella commit; the conductor tags it candidate/bashy-v1.0.0-rc.40). Name it release/tier-verdicts/6c36c0a7.json, verdict PASS only if every fold PASS; commit on bashy main on top of 6c36c0a7 (Sprint/Story/Story-ID + Agent trailers, do not push: the conductor pushes = verdict commit V). A red probe: root cause recorded here (venue/test/product), fix only venue in place, product -> tell the conductor via bashy mb and stop that lane. Long remote commands: nohup+poll on the host; never block one command over a minute. Scrub: hosts by role only in every committed file.

## Run record (claude-opus5.5, 2026-11-23)

Verdict: **FAIL**. Record `bashy release/tier-verdicts/6c36c0a7.json` in bashy
commit `23e5a05b` (branch `s692/tier-verdict-6c36c0a7`, parent = bashy
origin/main `6226a196`, which contains 6c36c0a7; NOT pushed — conductor pushes
it as V). `releaseeligibility --tier-verdict` rejects it (FAIL), as it should.
Umbrella in the record: `1ec2434b` (pushed; pins bashy 6c36c0a7, outpost
a1c9307, yoke 3eb700cd; every leaf `drift=false`).

| fold | verdict | cause class |
|---|---|---|
| tier-all-native-linux | PASS (tier1, tier2, tier3 PASS) | - |
| tier-all-native-windows | FAIL (tier1 FAIL; tier2/tier3 not run) | product |
| tier-all-native-darwin | INCOMPLETE (no leaf run) | venue |

Install: archives sha256-verified on the dev box and again on each host, copied
over the LAN (no internet download). The Linux lane (WSL root) and the macOS QA
host report `5.3.0(1)-bashy-v1.0.0-rc.40` on the login PATH, previous binary
kept as `bashy.prev` (macOS: appended `~/.local/bin` to the login PATH via
`~/.zshenv`; the homebrew/outpost bashy that serves the host was not touched).

Root causes:

1. **Windows, venue (install).** The login-PATH `bashy` is outpost's managed
   copy. Swapping in rc.40 was rolled back by outpost supervisord within 10 s
   (`bashy version mismatch with outpost; rolling to match`), which restarted
   its service tree (sshd down about 40 s). Only an outpost upgrade changes that
   copy, which this story does not authorise. The probes therefore ran the
   verified rc.40 `bashy.exe` by absolute path from a scratch dir through a
   `TIER_REMOTE_EXEC` wrapper (scratch bin first on PATH).
2. **Windows, product (the FAIL).** rc.40 Go adapters cannot cold-build. With
   no Windows `HOME`, bashy sets `HOME=/c/Users/<user>`; the adapter template
   (`optional/mktemp/mktemp.bsh` lines 8 and 12, the same in every Go adapter)
   passes `$HOME/.cache/bashy/adapters/...` to native `go.exe build -o`. Go
   writes it under `C:\c\Users\...`, and the `mv` that follows cannot stat it.
   This breaks mktemp, jq, seq, dag, weave, sprint, sdlc, loom, podman/oci and
   curl. Proof: the same verb with `BASHY_ADAPTER_CACHE` in drive form builds
   and runs (rc=0). tier1: `commands` FAIL (no temp file from `bashy mktemp`),
   `inspect` FAIL (`bashy jq` failed). Reported to conductor:692; lane stopped.
3. **macOS QA host, venue.** The host's TCP ephemeral ports are exhausted
   (about 39k sockets in TIME_WAIT across 49152-65535). Every new connect fails
   with EADDRNOTAVAIL, loopback included, and the problem was there before this
   run. Churn comes from host services this story does not own; none were
   touched. The rc.40 adapters fetch their source on first use, that fetch
   fails, and every adapter verb fails. Reported to conductor:692.
4. **Dev box, venue (orchestrator only).** The dev box's login `bashy` (a dirty
   dev build) and the rc.40 binary both route `jq` to an adapter. That adapter
   resolves a stale `~/.bashy/src/bashy` tree, which has no `optional/jq`, so
   it fails with `go: go.mod file not found`. The kit was orchestrated with the
   dev box's published rc.27 bashy, which has jq in-process. The leaves always
   ran the candidate on the hosts.

Observed, pre-existing, not blocking: under `bashy -s` with the script on a
pipe (ssh), the rest of a command list after an external child that inherits
stdin is lost (`/bin/true; echo x` prints nothing). The dev 653c13a bashy does
the same; GNU bash does not. The kit is immune because it runs probes with
`</dev/null`. Track separately.

Host state after the run: claims released. The scratch outpost and scratch
podman service on the Linux lane are stopped. Scratch dirs `tier-smoke-rc40`
stay on each host. The images `localhost/bashy:v1.0.0-rc.40-dev-linux-amd64`
(Linux lane) and the rc.40 login-PATH installs stay in place. The Windows
outpost dir is unchanged (rc.37).
