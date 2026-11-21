---
id: 7b93710358be
kind: bug
title: 'S8b: verify() requires h1 go_mod_sum on un-downloaded rows (S8 review round 1)'
seq: 592
status: done
priority: p0
created: 2026-11-21T10:01:40.537771Z
weave: 107
assignee: agy-sonnet5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T10:05:17.478347Z
resolution: fixed
closed_by: agy-sonnet5.5-c
---

Repo: bashy. Follow-up to S8 e7bf0fd7 (merged bashy ecdab0cd, umbrella 6badf1e4). Tightening only: in scripts/local-release-evidence.py verify(), require a non-empty h1: go_mod_sum on every un-downloaded module row (go_mod_downloaded=false; collect already records GoModSum from go list). Fail closed (ValueError) when missing/empty/not h1:. Add one test in scripts/test-local-release-evidence.py: missing/empty/non-h1 go_mod_sum on an un-downloaded row is rejected, valid h1: passes (add h1: go_mod_sum to existing un-downloaded fixtures where needed to stay valid). Base already contains ecdab0cd - do NOT redo the collect fix. Run: PATH=/bin:/usr/bin:/opt/homebrew/bin:$PATH python3 scripts/test-local-release-evidence.py must print OK. Trailers: Sprint #677, this story Story/Story-ID, Agent = your assigned binding name.
