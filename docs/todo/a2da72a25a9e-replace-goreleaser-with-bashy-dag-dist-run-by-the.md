---
id: a2da72a25a9e
kind: task
title: replace goreleaser with bashy dag dist run by the previous release (rc.37 builds rc.38); go build budget 5 min
seq: 431
status: done
priority: p1
created: 2026-11-17T20:07:01.948965Z
assignee: s575-codex-manager
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-20T12:03:28.524156Z
closed_by: s575-codex-manager
---

Operator 2026-11-17: drop the goreleaser stage; build release artifacts with bashy dag, executed by the immediately previous release (rc.37 is the first self-rebuilding release; bashy caef5293 locks the rc.37 build image as the builder for the next version). Rule: a Go build longer than 5 minutes needs a recorded reason. Measured rc.37 goreleaser: 21 min for 18 links (bashy x4, bashy-scratch x2 duplicate, bash x4, sh x4, outpost x4) on a cold 4-vCPU runner + serial per-target hooks. Plan: extend dag.md 'dist' (exists, dag.md:252) to: one bashy link per target (bash/sh = argv[0] personalities, no separate links; bashy-scratch = the linux bashy, no rebuild), outpost per target, archives + checksums.txt + linux packages, SBOMs; targets linux/{amd64,arm64}, darwin/arm64 (CGO_ENABLED=0 cross-build; drop darwin/amd64 per 9b565ca2), windows/{amd64,arm64}; run in the locked builder image on the gate host with a warm GOCACHE/GOMODCACHE; each target's build timed and failed past budget without a recorded reason. GitHub only receives one 'gh release create' with the files. Fold with b4cdd7cf (local release build) and 189c6439. Verification: dist completes within budget on the gate host and artifacts match goreleaser's file list; unit tests of any new tooling; no full gate (operator rule).

## Verified build infrastructure delivery (2026-11-20 reconciliation)
Later operator separation requirements supersede the original combined argv-personality optimization: independent Bash/sh artifacts remain; the full Bashy product is built separately. Delivered distribution driver b88c94d4c15b7d5f2dad4b25ca0c8428df37dbe2 retains five platforms and 34 assets. Nine current build/distribution/package/test scripts match that tested revision, and the DAG dist body is unchanged (SHA256 d95a69bee02662d2dee4d70ffabd909b6199785468f957950670025ee321ed28). Retained official-image fixture/asset/package checks passed; exact b88 warm benchmark completed in 195.591 s inside OCI and 227 s including host orchestration,8 CPUs,2 target jobs,4 package workers. Cold cache preparation took 1141 s and was excluded/disclosed. Upload was NOT measured. These receipts qualify delivered infrastructure at b88, not today's candidate or an end-to-end sub-five-minute release. Remaining frozen-candidate security/build/upload/signing/publish acceptance is tracked by b4cdd7cf47f7; operator hold remains. No new build/tag/release performed.
