---
id: 9b565ca29f5c
kind: task
title: drop macOS Intel (darwin/amd64) from bashy releases
seq: 429
status: todo
priority: p2
created: 2026-11-17T19:53:58.26338Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Operator decision 2026-11-17: macOS Intel is no longer supported. Evidence: rc.35 bashy-darwin-amd64 0 downloads (arm64 18); fleet macOS hosts are Apple Silicon so the lane is never QA'd; the Ollama runner already treats Darwin amd64 as optional; it costs the slow macos-15-intel runner (~25 min per release). After rc.37 is promoted: remove macos-15-intel/amd64 from the release.yml native darwin matrix and any darwin/amd64 goreleaser/asset/verification/checksum references (bash, otel, outpost tool assets included), drop darwin/amd64 from the dag.md platform loop and the setup.md install table, add a CHANGELOG/release note 'macOS Intel no longer supported'. Grep the release tooling (releaseeligibility, tier kit, install scripts) for darwin-amd64 expectations. Verification = build + unit tests of touched tools; no full gate (operator rule).
