---
id: 195027c96521
kind: chore
title: 'A: go1.27.4 toolchain for bashy + outpost (tool) with productgo overlay re-pin'
seq: 585
status: assigned
priority: p0
created: 2026-11-21T08:29:57.32075Z
weave: 108
assignee: codex-gpt6.2-sol
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Phase 0A. Operator: do a clean job whatever it takes now. SPLIT (conductor 2026-11-21): (a) CODE WORK NOW in parallel with P1 - bump toolchain go1.27.2 -> go1.27.4 in EVERY module that compiles into a shipped binary or is scanned by the release vuln gate: bashy, outpost, yoke, coreutils, bashsharp, bash, sh (fork) - all verified at go1.27.2 at filing - plus tools/ and examples/ modules (P4 builds them on demand); record any module left at go1.27.2 here with a reason. productgo re-pin: bashy/tools/productgo/main.go:102 rejects GOVERSION != go1.27.2; update + RE-VERIFY signal_unix.go hash/patch vs go1.27.4 SDK (stop + record here if the patch no longer applies). Submodule-first per repo in your workspace (commit inside each submodule clone, umbrella pin last); dev-box targeted tests only (productgo tests, dag build). (b) DEFERRED until P1 baseline + gate-host keep-alive: gate-image rebuild (image.lock rolling rule, EXCLUSIVE gate-host claim) and fresh Bash 5.3 86/86 both modes by fixture name vs rc.39 evidence - do NOT attempt long lane runs yet (WSL idle-reboots kill detached containers; see P1 befc2403 root cause). Acceptance this round: per-module toolchain table on this story, dag build green, productgo tests pass; (b) recorded as remaining when you submit.
