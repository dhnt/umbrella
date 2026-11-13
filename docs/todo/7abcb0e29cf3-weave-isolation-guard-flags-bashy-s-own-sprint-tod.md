---
id: 7abcb0e29cf3
kind: bug
title: weave isolation guard flags bashy's own sprint/todo store writes, which silently disables worker story auto-submission
seq: 191
status: todo
priority: p1
labels:
    - weave
    - sprint
created: 2026-11-13T00:47:37.574367Z
---

Evidence 2026-11-12 (Sprints 626/627): every active weave run was marked ISOLATION VIOLATED with escaped paths only under docs/todo/ — written in the live checkout by the mandated lifecycle verbs (sprint claim/assign by managers, todo add) while runs held workspaces. Detector: yoke pkg/weave/weave_isolation.go fingerprints `git status --porcelain --untracked-files=all` over the whole live root; its design note assumes a false positive costs one --force. Actual cost is larger: pkg/weave/weave_worker_story.go weaveSubmitWorkerStories returns nil (silently) when it.IsolationViolated, so worker story submission is skipped for every sprint run; managers had to relay submissions by hand ("Recorded by conductor from weave run ...", blank verify fields) and commit on workers' behalf (attribution check bypasses on M6/M1/M2), and routine --force on weave pull erodes the guard (real escapes hide in noise). Classification: product defect (bashy's own store writes are not escapes). Fix direction (discuss before implementing; not mid-sprint): exclude writes made by bashy's todo/sprint store from the fingerprint (e.g. the store journals the paths it writes, or exclude the committed todo store dir docs/todo/), and make the skipped auto-submission loud (say why) instead of returning nil. Verify: weave_isolation_test + a test where sprint claim during a run leaves the run unflagged and auto-submission proceeds; an out-of-store write still flags.
