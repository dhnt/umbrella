---
id: 4e88e4a28531
kind: bug
title: 'Sealed Bash gate mode 1: fixture histexpand FAIL (85/86) on frozen tip bebf3e8ca; mode 0 86/86; first run and rc.39 had it PASS'
seq: 630
status: assigned
priority: p0
labels:
    - bashy
    - gate
    - release
created: 2026-11-22T18:10:01.757599Z
weave: 155
assignee: codex-gpt5.6-sol
sprint: 692
---

Gate rerun leg 3 (umbrella bfd843f28, docs/sprint-677-integration-evidence.md second section): BASH53_OCI=podman bashy dag test-bash-gate on the gate host at bashy 1762e12c: mode 0 (BASH53_BASHPP=0) 86/86; mode 1 (BASH53_BASHPP=1) 85/86 with 'FAIL histexpand'. By fixture name this is the ONLY change vs the first run (bashy 9dd37bb2, 86/86 both) and vs rc.39. Inputs that changed between the two tips: bashy go.mod pins (bashsharp 621e369d -> b1a3183: only cmd/bsh + external/runewidth + docs commits in that range, none in the linked bashsharp packages; yoke 908e590c -> 5f136516: gotoolchain GOROOT pin + DefaultVersion 1.27.4), adapter_dispatch.go (48d7c818), test files. ROOT CAUSE FIRST on the gate host (claim lane 3 or the host-level podman resource as the gate does): rerun ONLY the histexpand fixture in mode 1 three times at 1762e12c (BASH53 fixture filter per bashy/CLAUDE.md 'Bash 5.3 gate' section) to establish whether it is deterministic; capture the fixture's expected vs actual output; then bisect by rebuilding bin/bash at 9dd37bb2 and at 1762e12c with each go.mod pin reverted in turn (bashsharp, yoke) to name the input. Classify (product / test / venue) and fix where the cause lives; the sealed gate is never weakened or re-baselined. If the cause is in the frozen engine or bashsharp Bash# front, the fix is a separate baseline-proven commit (migration policy) and the conductor reruns the full gate. Owner codex-gpt5.6-sol, --repo . TEST RULE (operator 2026-11-22): root cause recorded on this story BEFORE the fix; build + smallest targeted tests only; the full rerun is the conductor's. Start on current origin main; Sprint/Story/Story-ID + Agent trailers; do not push; nohup + poll for anything long on the gate host; hosts by role only.
