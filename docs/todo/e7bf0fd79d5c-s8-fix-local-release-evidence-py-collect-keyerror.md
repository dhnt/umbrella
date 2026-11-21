---
id: e7bf0fd79d5c
kind: bug
title: 'S8: Fix local-release-evidence.py collect KeyError GoMod on un-downloaded modules (rc.39 receipt failure)'
seq: 584
status: todo
priority: p0
created: 2026-11-21T08:22:27.760352Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. Root cause (recorded, docs/release-failure-ledger.md rc.39): scripts/local-release-evidence.py collect requires a go.mod digest (effective[GoMod], line ~102) for every module in go list -m all, but ~380 modules per scope are never downloaded by a build (bashy 383/1068, outpost 276/786, yoke 369/895) so they have no GoMod path -> KeyError. Class: release tooling defect. Fix where the cause lives (the collector): modules with no downloaded go.mod must be recorded honestly (e.g. digest absent/not-downloaded), not crash and not fabricate a digest. Acceptance: scripts/test-local-release-evidence.py covers the un-downloaded-module case (fails on old code); collect runs to completion on the bashy scope in a tree where those modules are not in the module cache. Also note the ledger companions for the worker to check, not silently expand into: govulncheck scope needs yoke ollama/podman submodule sources; dist 300s budget cold-cache (S1 territory).
