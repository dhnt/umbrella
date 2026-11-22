---
id: e71e8ed71bac
kind: task
title: 'rc.40 candidate gate RERUN 3 on frozen tip: bashy 5299e54b, bashsharp b1a3183, outpost a1c9307, yoke 5f136516 (all legs + shaping smoke; candidate binary for every target)'
seq: 631
status: assigned
priority: p0
labels:
    - release
    - gate
created: 2026-11-22T18:31:00.001338Z
assignee: claude-opus5.5
sprint: 692
---

Third full run. Frozen tip = the umbrella main commit carrying bashy 5299e54b (verify the four shas at start; record image id + bashy mod drift). Procedure = the RERUN ORDER on story 458628c0 and the second evidence section in docs/sprint-677-integration-evidence.md (run #153), with ONE correction: every dag target runs THROUGH THE CANDIDATE: build ./bin/bashy first (leg 1), then invoke './bin/bashy dag test' (not 'bashy dag test' with BASHY=./bin/bashy; the image's bundled bashy must not be the outer runner - that is what broke test-bash-container-mode in run #153). Legs: (1) bashy dag build (the image bashy may bootstrap this one); (2) ./bin/bashy dag test (includes test-startup-linux on bsh, test-bash-container-mode, go test -timeout 30m ./...; record inittrace, the package summary, and TestToolShortcutE2E's result - if it alone fails again, record it verbatim and classify); (3) ./bin/bashy dag test-bash-gate on the host with BASH53_OCI=podman, 86/86 both modes by fixture name vs rc.39 (histexpand mode 1 was a transient in run #153: if it fails again, record and rerun that single fixture 3x); (4) dispatch e2e from a fresh install with an empty adapter cache: Linux lane, Windows-native resource, macOS (QA host if it has disk, else the dev box labelled substitute); (5) shaping smoke: BASHY_SMOKE_BIN=./bin/bashy ./bin/bashy dag test-shaping-smoke test-shaping-smoke-regression (SHAPING_SMOKE_SKIP_DOM=1 if no Chrome; record SKIPPED). Venue: gate-host lane 2 or 3 (claim; lane 1 has a dead agy lease), official image rc.40-go1.27.4, fresh cache volume, nohup + poll, commit evidence after each leg as a third section with a per-leg table. No fixes here; red = record + bashy mb the conductor + continue. Owner claude-opus5.5 (muse quota exhausted today). TEST RULE: this IS the one full run.
