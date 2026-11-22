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

## Root cause and classification (2026-11-22)

**Venue/scheduling transient; no changed product or test input.** On the
claimed gate-host Podman resource, the exact mode-1 `histexpand` fixture at
bashy `1762e12c` passed three isolated sealed repetitions: 0.068 s, 0.105 s,
and 0.072 s. The failed full run's retained comparison is:

```text
first diff at line 202
want: "echo a"
got:  "b"
```

That line is the `histexp4.sub` process-substitution case
`cat < <(echo !!)`. The expected context is `a`, the expanded command
`cat < <(echo echo a)`, then `echo a`, then `b`; the one failed run lost the
process-substitution output at the scheduling boundary. The raw full actual
file was not retained because that run did not set `BASH53_DEBUG_DIR`; the
runner's first-difference record above is the complete preserved mismatch.

The requested input bisect did not reproduce a failure:

| candidate | isolated mode-1 `histexpand` | built `cmd/bash` SHA-256 |
| --- | --- | --- |
| bashy `9dd37bb2` | PASS, 0.081 s | `7b66c4b0530f115785d22442d6156589667c3f692479ff3784fdb8eecad58ceb` |
| bashy `1762e12c` | PASS x3 | `91341c4aeef263ffa1a2315bc130df33ad7805612b9e2e1a32a805fe62b368bb` |
| `1762e12c`, bashsharp reverted to `621e369d` | PASS, 0.066 s | `7b66c4b0530f115785d22442d6156589667c3f692479ff3784fdb8eecad58ceb` |
| `1762e12c`, yoke reverted to `908e590c` | PASS, 0.088 s | `91341c4aeef263ffa1a2315bc130df33ad7805612b9e2e1a32a805fe62b368bb` |

All four binaries have the same executable `.text` SHA-256,
`78f3cab927aed5591e5e6d3bf24f3541ee8fe5465948bde36f4c63cc7a1e79e0`.
Yoke is absent from the binary module graph. Reverting bashsharp makes the
whole binary byte-identical to `9dd37bb2`; the remaining difference at the
new pin is module metadata, because none of the changed bashsharp packages is
linked into the shell executable. Thus neither changed pin names a product
input capable of causing this output change.

This fixture shape already has a recorded one-off 85/86 followed by an
isolated PASS and a clean full rerun
(`bashy/docs/agent-shell-eval/results-2026-07-01-current-baseline.md`). The
authoritative three-run reproduction and byte-level bisect establish the same
non-deterministic venue result here. No product, fixture, harness, skip, or
baseline change is justified. The host-level resource was claimed for the
targeted investigation; the conductor owns the required full sealed rerun.
