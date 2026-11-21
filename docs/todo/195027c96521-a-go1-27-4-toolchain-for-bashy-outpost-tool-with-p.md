---
id: 195027c96521
kind: chore
title: 'A: go1.27.4 toolchain for bashy + outpost (tool) with productgo overlay re-pin'
seq: 585
status: todo
priority: p0
created: 2026-11-21T08:29:57.32075Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Phase 0A (runs AFTER P1 baseline, which must measure today first). Operator: do a clean job whatever it takes now. Bump toolchain go1.27.2 -> go1.27.4 in EVERY module that compiles into a shipped binary or is scanned by the release vuln gate: bashy, outpost, yoke, coreutils, bashsharp, bash, sh (fork) - all verified at go1.27.2 today - plus tools/ and examples/ modules (P4 builds them on demand). Record any module left at go1.27.2 here with a reason. productgo re-pin: bashy/tools/productgo/main.go:102 rejects GOVERSION != go1.27.2; update + RE-VERIFY signal_unix.go hash/patch vs go1.27.4 SDK (stop + record if patch no longer applies). Submodule-first: bump+commit+push inside each submodule, then consumer repins, then umbrella pin. Gate-image rebuild follows the image.lock rolling rule (previous release builds the next) and needs the EXCLUSIVE gate-host claim (resource name via bashy resource list); then fresh Bash 5.3 86/86 both modes by fixture name vs rc.39 evidence. Acceptance: dag build green, productgo tests pass, per-module toolchain table + image id + 86/86 evidence on this story.
