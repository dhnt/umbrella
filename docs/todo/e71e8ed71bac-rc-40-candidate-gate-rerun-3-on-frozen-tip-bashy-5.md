---
id: e71e8ed71bac
kind: task
title: 'rc.40 candidate gate RERUN 3 on frozen tip: bashy 5299e54b, bashsharp b1a3183, outpost a1c9307, yoke 5f136516 (all legs + shaping smoke; candidate binary for every target)'
seq: 631
status: done
priority: p0
labels:
    - release
    - gate
created: 2026-11-22T18:31:00.001338Z
weave: 156
assignee: claude-opus5.5
sprint: 692
closed: 2026-11-22T19:14:36.2019Z
resolution: fixed
closed_by: claude-opus5.5-z
---

Third full run. Frozen tip = the umbrella main commit carrying bashy 5299e54b (verify the four shas at start; record image id + bashy mod drift). Procedure = the RERUN ORDER on story 458628c0 and the second evidence section in docs/sprint-677-integration-evidence.md (run #153), with ONE correction: every dag target runs THROUGH THE CANDIDATE: build ./bin/bashy first (leg 1), then invoke './bin/bashy dag test' (not 'bashy dag test' with BASHY=./bin/bashy; the image's bundled bashy must not be the outer runner - that is what broke test-bash-container-mode in run #153). Legs: (1) bashy dag build (the image bashy may bootstrap this one); (2) ./bin/bashy dag test (includes test-startup-linux on bsh, test-bash-container-mode, go test -timeout 30m ./...; record inittrace, the package summary, and TestToolShortcutE2E's result - if it alone fails again, record it verbatim and classify); (3) ./bin/bashy dag test-bash-gate on the host with BASH53_OCI=podman, 86/86 both modes by fixture name vs rc.39 (histexpand mode 1 was a transient in run #153: if it fails again, record and rerun that single fixture 3x); (4) dispatch e2e from a fresh install with an empty adapter cache: Linux lane, Windows-native resource, macOS (QA host if it has disk, else the dev box labelled substitute); (5) shaping smoke: BASHY_SMOKE_BIN=./bin/bashy ./bin/bashy dag test-shaping-smoke test-shaping-smoke-regression (SHAPING_SMOKE_SKIP_DOM=1 if no Chrome; record SKIPPED). Venue: gate-host lane 2 or 3 (claim; lane 1 has a dead agy lease), official image rc.40-go1.27.4, fresh cache volume, nohup + poll, commit evidence after each leg as a third section with a per-leg table. No fixes here; red = record + bashy mb the conductor + continue. Owner claude-opus5.5 (muse quota exhausted today). TEST RULE: this IS the one full run.

RESULT (claude-opus5.5, 2026-11-22): rerun 3 complete on frozen tip umbrella 0c055a19c (bashy 5299e54b, bashsharp b1a3183, outpost a1c9307, yoke 5f136516 verified; image f09ff792e4e0; fresh volume lane2-s692-r3-cache; every later dag target run via candidate ./bin/bashy). Candidate RED on ONE test. L1 build PASS 175.081s. L2 ./bin/bashy dag test exit 1 944.785s: 9/10 targets PASS incl test-bash-container-mode, verify-bashy-scratch, test-startup-linux (inittrace 1.78 ms total, max 0.16 ms); go test ./... 27 ok / 1 FAIL internal/agentos, only TestToolShortcutE2E ("toolshortcut_e2e_test.go:450: bashy agy did not exit after quit", identical to run #153, 2/2 in venue: steer quit exits 0 but never reaches the PTY; reproducible, root cause owed by the test owner). L3 bash gate PASS 86/86 both modes, names identical to run 1/rc.39, histexpand PASS. L4 dispatch e2e PASS Linux 89.891s / Windows native 324.74s / macOS 132s (substitute dev box; QA host disk-full). L5 shaping smoke PASS 25 checks + regression ok, DOM checkpoint SKIPPED (no Chrome in image). Evidence: docs/sprint-677-integration-evidence.md (third section, per-leg table). No fixes in this story.
