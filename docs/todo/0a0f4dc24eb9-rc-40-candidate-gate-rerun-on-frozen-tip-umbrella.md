---
id: 0a0f4dc24eb9
kind: task
title: 'rc.40 candidate gate RERUN on frozen tip umbrella bebf3e8ca (bashy 1762e12c, bashsharp b1a3183, outpost a1c9307, yoke 5f136516): all legs + shaping smoke'
seq: 628
status: assigned
priority: p0
labels:
    - release
    - gate
created: 2026-11-22T16:53:38.383874Z
assignee: muse-wonder
sprint: 692
---

Second full run after the gate fix round; the first run is umbrella 8b8db523f (story 458628c0, whose RERUN ORDER section is the exact procedure: follow it). Owner muse-wonder. Frozen tip = umbrella bebf3e8ca; verify the four submodule shas at start and record image id + bashy mod drift. Venues: gate-host lane 2 (claim it), official image rc.40-go1.27.4, fresh cache volume, attached session, nohup + poll. Legs: (1) bashy dag build; (2) bashy dag test with BASHY=./bin/bashy (includes test-startup-linux on bsh - record the inittrace line - and go test -timeout 30m ./... - record the package summary); (3) bashy dag test-bash-gate on the host, 86/86 both modes compared by fixture name vs rc.39; (4) dispatch e2e TestE2EAllListedCommandsDispatch from a fresh install with an empty adapter cache on the Linux lane, the Windows-native gate resource (no host Go) and macOS (QA host if it has disk, else the dev box labelled substitute); (5) shaping smoke with the candidate: BASHY_SMOKE_BIN=./bin/bashy bashy dag test-shaping-smoke test-shaping-smoke-regression on the Linux lane (Chrome needed for the verifydom DOM checkpoint; without it use SHAPING_SMOKE_SKIP_DOM=1 and record that step SKIPPED, not passed). Append a second section with a per-leg table to umbrella docs/sprint-677-integration-evidence.md (exit codes, wall times, failing names verbatim; hosts by role only). No code fixes here: a red leg is recorded with first-pass class and the conductor is told via bashy mb; continue with the next leg. Submit with the table. TEST RULE: this IS the one full run; nothing else runs suites.
