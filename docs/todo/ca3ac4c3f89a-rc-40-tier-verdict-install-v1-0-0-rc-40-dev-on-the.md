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
