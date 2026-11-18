---
id: 189c6439f049
kind: task
title: 'release.yml: drop license-gate + govulncheck jobs; verify local-gate evidence bound to the tagged commit instead'
seq: 428
status: assigned
priority: p2
created: 2026-11-17T19:48:41.108992Z
assignee: s575-codex-manager
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Operator 2026-11-17: license-gate and govulncheck must NOT run on GitHub; run them once in the local full build on the frozen candidate. Today they cost ~8.5 min per release run and block the build jobs. Plan: the local gate (bashy dag, official build image, gate host) writes a committed evidence record {commit, go.sum hash, license verdict, govulncheck verdict, vuln DB date}; release.yml preflight only verifies the record names the tag's commit + go.sum hash, verdicts pass, and the DB date is within an agreed window (e.g. 7 days); build jobs start right after preflight. After rc.37 is promoted; verification = build + unit tests of the verifier + one dry-run of the preflight step locally.

Also (operator question 2026-11-17): the 'publish public FROM-scratch image' job spends ~5 of its 7 min recompiling the two linux scratch binaries that goreleaser also builds; consume goreleaser's linux artifacts instead (~1 min job).

Operator decision 2026-11-17: stop publishing ghcr.io/qiangli/bashy-scratch. Install bashy first; 'bashy self image' builds the FROM-scratch image locally from the checksum-verified bashy-scratch-linux-<arch> release asset. Remove the 'publish public FROM-scratch image' job from release.yml and the image byte-promotion from promote.yml; update docs that tell users to docker pull the GHCR image (point them to install bashy, then bashy self image). Keep the bashy-scratch-linux-* binaries as release assets. Supersedes the 'reuse goreleaser artifacts' note above.

Operator 2026-11-17 ('31 min for a go build is too long'): measured rc.37 goreleaser = before hooks 27 s; building binaries 21m06s = 18 full links (bashy x4, bashy-scratch x2 duplicate, bash x4, sh x4 — same engine, outpost x4) on a cold 4-vCPU runner, plus per-bashy-target hooks run serially (signal-artifact verify, releaseeligibility via go run with module downloads, meet SPA smoke, SBOM ~2 min each); archives 2m34s; linux packages 1m28s; release upload 2m31s. Fixes: one bashy build per target with bash/sh as argv[0] personalities (copies/links, -8 builds); drop bashy-scratch duplicate builds (-2); move SBOM + eligibility hooks to the local gate; warm cache via local release build (b4cdd7cf). Target: a few minutes.
