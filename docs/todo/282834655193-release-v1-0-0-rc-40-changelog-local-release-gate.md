---
id: "282834655193"
kind: task
title: 'Release v1.0.0-rc.40: changelog, local release gate receipt (override retired), -dev tag, one release.yml run, tier verdict, QA refs, promote on the operator''s go'
seq: 624
status: assigned
priority: p0
labels:
    - release
created: 2026-11-22T13:43:36.816088Z
assignee: claude-fable5.1
sprint: 692
---

Owner: conductor claude-fable5.1 (no worker). Runs ONLY after the candidate gate 458628c0 is green on the frozen tip. Steps per bashy/docs/release-runbook.md and the bashy-release-promotion memory: (1) CHANGELOG.md entry for v1.0.0-rc.40 with the public-claim checks (docs/public-claims-evidence.md); (2) scripts/local-release-gate.sh in the official image on a claimed gate-host lane, GOWORK=off, strict license + all vulnerability profiles, NO override (D2) - a red finding blocks; (3) record the receipt as a Git note under refs/notes/bashy-local-gates, push it, note the immutable notes commit; (4) push tag v1.0.0-rc.40-dev at the frozen commit, dispatch release.yml ONCE with evidence_commit; (5) tier verdict: native tier smoke on the three QA lanes (Linux lane, Windows gate host, macOS QA host), commit release/tier-verdicts/<c8>.json with umbrella tag candidate/bashy-v1.0.0-rc.40; (6) refs/qa/v1.0.0-rc.40/{linux,darwin,windows}; (7) on the operator's typed go: bare tag v1.0.0-rc.40 + promote.yml with the pinned tier_verdict URL; checksums.txt identical to -dev. No retries on half-diagnosed failures: root cause first. Hosts by role only.
