---
id: "282834655193"
kind: task
title: 'Release v1.0.0-rc.41: affected legs, dist, local release gate receipt, -dev tag, one release.yml run, tier verdict, QA refs, promote on the operator''s go'
seq: 624
status: assigned
priority: p0
labels:
    - release
created: 2026-11-22T13:43:36.816088Z
assignee: claude-opus5.5
sprint: 719
sprint_id: 049a8467-4736-5eab-9ce8-52274347d7a0
sprint_title: Release bashy v1.0.0-rc.41 (thin bashy; rc.40 never promoted)
---

Owner: conductor claude-fable5.1 (no worker). Runs ONLY after the candidate gate 458628c0 is green on the frozen tip. Steps per bashy/docs/release-runbook.md and the bashy-release-promotion memory: (1) CHANGELOG.md entry for v1.0.0-rc.40 with the public-claim checks (docs/public-claims-evidence.md); (2) scripts/local-release-gate.sh in the official image on a claimed gate-host lane, GOWORK=off, strict license + all vulnerability profiles, NO override (D2) - a red finding blocks; (3) record the receipt as a Git note under refs/notes/bashy-local-gates, push it, note the immutable notes commit; (4) push tag v1.0.0-rc.40-dev at the frozen commit, dispatch release.yml ONCE with evidence_commit; (5) tier verdict: native tier smoke on the three QA lanes (Linux lane, Windows gate host, macOS QA host), commit release/tier-verdicts/<c8>.json with umbrella tag candidate/bashy-v1.0.0-rc.40; (6) refs/qa/v1.0.0-rc.40/{linux,darwin,windows}; (7) on the operator's typed go: bare tag v1.0.0-rc.40 + promote.yml with the pinned tier_verdict URL; checksums.txt identical to -dev. No retries on half-diagnosed failures: root cause first. Hosts by role only.

PROCEDURE (conductor, 2026-11-22; gate loop rules 6-8 apply: everything builds and tests on the gate host, one shared warm module cache, one GitHub run). Candidate commit C = bashy main after the rc.40 CHANGELOG entry (docs-only on top of the gated tip; the evidence doc records that build inputs are unchanged vs the leg runs). Pins: bashsharp b1a3183, outpost a1c9307, yoke 3eb700cd, bash/coreutils as pinned in bashy go.mod.
1. CHANGELOG.md [Unreleased] -> 1.0.0-rc.40 section (draft prepared; apply docs/public-claims-evidence.md checks: version from bashy --version, Bash 5.3, Go 1.27 / toolchain go1.27.4, no percentages). Commit on bashy main = C. Bump umbrella pin.
2. Gate-host lane 3 venue /root/lanes/lane3/s692-release: DIST_SOURCE_ROOT with clean checkouts bashy@C, bash@pin, outpost@pin, yoke@pin and dist-inputs.json {"tag":"v1.0.0-rc.40-dev","sources":{role:{"path","commit"}}}; scripts/prepare-dist-rpm.sh "$ROOT/build-tools" on the WSL host (Ubuntu 24.04 amd64; downloads 8 debs once - reuse the staged build-tools from the rc.38 venue if still present); then BASHY_BUILD_CACHE_VOLUME=bashy-build-cache bashy tools/bashy-build/run.sh "$ROOT" -- 'cd /work/bashy && DIST_SOURCE_ROOT=/work /usr/bin/dash scripts/dist.sh' (300 s budget, warm caches; dist/assets 34 files + dist/release-assets.json). Record elapsed and cache state.
3. Local release gate in the image on the same venue: BASHY_BUILD_RUN=1 BASHY_BUILD_IMAGE=<lock image> LOCAL_DIST_MANIFEST=dist/release-assets.json scripts/local-release-gate.sh -> bin/local-release-gate/evidence.json (license strict + govulncheck all profiles, no override; the DB must be < 7 days old; 2026-11-11 DB is fine today). Review, then git notes --ref=refs/notes/bashy-local-gates add -F evidence.json C; push the notes ref; N = notes commit.
4. Shaping smoke with the DOM checkpoint: on the gate host in localhost/e2e-shaping:py312 (Chromium) per the S670 recipe (/root/s670-shape staging, --network host, SHAPING_SMOKE_DOM_TEST prebuilt verifydom binary) against the candidate binary from dist/assets; 27/27, no SKIP. Record in the evidence doc.
5. Tier verdict (native tier smoke on the three QA lanes from ~/.bashy/release-hosts: linux-wsl + windows on the gate host, darwin on the macOS QA host - needs its disk freed first): the rc.37 kit (docs/tier-smoke.dag.md + script/tier-smoke-lib.sh) lives only in the dev-box archive cleanup-20261119/rc37-tier-kit; stage it in a scratch dir beside the umbrella and run tier-all-native against the candidate; write release/tier-verdicts/<c8>.json (schema dhnt.tier-smoke/v1, commit C, verdict PASS, umbrella field = a pushed umbrella commit tagged candidate/bashy-v1.0.0-rc.40); commit to bashy main after C (verdict commit V). Rule 8: no tier lane on the dev box.
6. Draft upload + preflight offline: create the GitHub draft release targeted at C with dist/assets + release-assets.json (gh release create --draft --target C); then COMMIT=C LOCAL_GATE_EVIDENCE_COMMIT=N scripts/verify-local-release-gate.sh on the candidate checkout (read-only preflight). Everything the workflow checks has now passed locally.
7. ONE GitHub run: push tag v1.0.0-rc.40-dev at C; gh workflow run release.yml -f evidence_commit=N (~2-3 min publish-only). On a GitHub-side failure: root cause first, no retry.
8. QA refs refs/qa/v1.0.0-rc.40/{linux,darwin,windows} -> V; on the OPERATOR'S TYPED GO: push bare tag v1.0.0-rc.40 at C; gh workflow run promote.yml -f version=v1.0.0-rc.40 -f tier_verdict=https://raw.githubusercontent.com/qiangli/bashy/V/release/tier-verdicts/<c8>.json; checksums.txt identical to -dev. Then sprint end 692 --gate.
Disclosures for the go decision: macOS legs ran on the dev box as a substitute until the QA host has disk; the DOM checkpoint moves from SKIPPED to run in step 4.

CARRY-OVER to Sprint 694 (conductor claude-fable5.1, 2026-11-23): DONE in 692 — changelog
rc.40 section, 34-asset dist, local release gate receipt (override retired), note ref,
`v1.0.0-rc.40-dev` published as a pre-release (two release.yml runs: the first failed on a
preflight token permission, fixed in release.yml), tier verdict recorded
(bashy release/tier-verdicts/6c36c0a7.json = FAIL). NOT DONE — promotion: the tier verdict
failed on Windows (product defect 5cb66dcf, fixed on bashy main 802c5f40) and the macOS
lane did not run (host venue, since cleared). Remaining for the next candidate (rc.41):
rerun the affected legs (dispatch e2e 3-OS + agentos tests; full dag test if main carries
new product code), dist, receipt, one release.yml run, tier verdict PASS on three lanes,
QA refs, bare tag + promote.yml on the operator's typed go. Update the outpost on the
Windows lane first (its supervisor rolls a foreign bashy back to its own release).

## rc.41 tier verdict run record (claude-opus5.5, 2026-11-25)

Verdict: **PASS**. Record `bashy release/tier-verdicts/0665ffb3.json` in bashy
commit `d14a9c7c` (branch `s719/tier-verdict-0665ffb3` off origin/main, which
contains 0665ffb3; NOT pushed). `releaseeligibility --tier-verdict`: PASS.
Umbrella in the record: `cd977f0e` (pushed; pins bashy 0665ffb3, outpost
764d9dfc, yoke 89fc8e42; every leaf `drift=false`).

| fold | tier1 | tier2 | tier3 | verdict | cause class |
|---|---|---|---|---|---|
| tier-all-native-linux | PASS | PASS | PASS | PASS | - |
| tier-all-native-windows | PASS | PASS | PASS | PASS | - |
| tier-all-native-darwin | PASS | PASS | PASS | PASS | - |

Install: archives sha256-verified on the dev box and again on each host,
copied over the LAN. The Linux lane runs rc.41 on its login PATH (rc.40 kept as
`bashy.rc40`, rc.37 `bashy.prev`). The Windows lane and the macOS QA host run
the verified candidate from a scratch dir by absolute path. On Windows,
outpost pins its managed login-PATH copy. On the macOS QA host, the login-PATH
bashy serves running jobs and stays rc.40. tier3 per host: image built from the
verified `bashy-scratch-linux-<arch>` asset with `bashy self image`; denial
served by a scratch rc.41 outpost on loopback. The podman machines on the
Windows lane and the macOS QA host were started for the run and stopped after.
Scratch outposts were stopped on all three. Adapter cold builds on Windows
pass with no adapter cache set, so the rc.40 product defect is fixed.
