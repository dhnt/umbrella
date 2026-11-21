---
id: e7bf0fd79d5c
kind: bug
title: 'S8: Fix local-release-evidence.py collect KeyError GoMod on un-downloaded modules (rc.39 receipt failure)'
seq: 584
status: done
priority: p0
created: 2026-11-21T08:22:27.760352Z
weave: 106
assignee: agy-sonnet5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T10:01:57.808876Z
resolution: fixed
closed_by: muse-wonder-full
---

Repo: bashy. Root cause (recorded, docs/release-failure-ledger.md rc.39): scripts/local-release-evidence.py collect requires a go.mod digest (effective[GoMod], line ~102) for every module in go list -m all, but ~380 modules per scope are never downloaded by a build (bashy 383/1068, outpost 276/786, yoke 369/895) so they have no GoMod path -> KeyError. Class: release tooling defect. Fix where the cause lives (the collector): modules with no downloaded go.mod must be recorded honestly (digest absent/not-downloaded), not crash and not fabricate a digest. FINAL SPEC (review round 1, 2026-11-21; round-1 delivery bashy ecdab0cd already does the above and is verified): additionally verify() MUST require a non-empty h1: go_mod_sum on every un-downloaded module row (collect already records GoModSum from go list; fail closed when missing/empty/not h1:) so the receipt keeps a cryptographic go.mod identity without downloading, plus one test proving a missing/empty/non-h1 go_mod_sum on an un-downloaded row is rejected and a valid h1: row passes. Build on ecdab0cd in the same workspace. Acceptance: scripts/test-local-release-evidence.py covers the un-downloaded-module case incl. the h1 guard (fails on old code); collect runs to completion on the bashy scope in a tree where those modules are not in the module cache; run tests with PATH=/bin:/usr/bin:/opt/homebrew/bin:$PATH (pre-existing venue quirk, identical at base).
