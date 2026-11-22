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
weave: 153
assignee: claude-opus5.5
sprint: 692
---

Second full run after the gate fix round; the first run is umbrella 8b8db523f (story 458628c0, whose RERUN ORDER section is the exact procedure: follow it). Owner muse-wonder. Frozen tip = umbrella bebf3e8ca; verify the four submodule shas at start and record image id + bashy mod drift. Venues: gate-host lane 2 (claim it), official image rc.40-go1.27.4, fresh cache volume, attached session, nohup + poll. Legs: (1) bashy dag build; (2) bashy dag test with BASHY=./bin/bashy (includes test-startup-linux on bsh - record the inittrace line - and go test -timeout 30m ./... - record the package summary); (3) bashy dag test-bash-gate on the host, 86/86 both modes compared by fixture name vs rc.39; (4) dispatch e2e TestE2EAllListedCommandsDispatch from a fresh install with an empty adapter cache on the Linux lane, the Windows-native gate resource (no host Go) and macOS (QA host if it has disk, else the dev box labelled substitute); (5) shaping smoke with the candidate: BASHY_SMOKE_BIN=./bin/bashy bashy dag test-shaping-smoke test-shaping-smoke-regression on the Linux lane (Chrome needed for the verifydom DOM checkpoint; without it use SHAPING_SMOKE_SKIP_DOM=1 and record that step SKIPPED, not passed). Append a second section with a per-leg table to umbrella docs/sprint-677-integration-evidence.md (exit codes, wall times, failing names verbatim; hosts by role only). No code fixes here: a red leg is recorded with first-pass class and the conductor is told via bashy mb; continue with the next leg. Submit with the table. TEST RULE: this IS the one full run; nothing else runs suites.

REASSIGNED (conductor 2026-11-22): muse-wonder hit a provider quota exhaustion (API 429, window resets 2026-11-23T00:00Z) two minutes into run #152; no work produced. Owner is now claude-opus5.5. Same procedure as above. Gate-host access recipe: the lane runs the way run #148 did (muse's evidence in docs/sprint-677-integration-evidence.md names the staging dir pattern, image id and oci run invocation). Claim the gate-host lane-2 resource first; the lane-1 lease belongs to a dead agy run, leave it. For every command that can take more than a minute on the gate host: nohup to a log in the lane work dir, return, poll every ~60 s; one leg at a time. Keep each of your own turns short: commit evidence after each leg.
