---
id: 458628c0767e
kind: task
title: 'rc.40 candidate gate: gate.final (dag build, dag test, Bash 5.3 86/86 both modes) + 3-OS dispatch e2e from a fresh install on the frozen tip'
seq: 611
status: done
priority: p0
created: 2026-11-21T16:08:15.84969Z
weave: 148
assignee: muse-wonder
sprint: 692
closed: 2026-11-22T15:59:08.959526Z
resolution: fixed
closed_by: muse-wonder-r
---

RESCOPE (operator 2026-11-22, Sprint 692 plan docs/plan-sprint-692-release-thin-bashy.md): this is THE ONE full run of the sprint, after Wave 1 merges (P5 aa693f4a, bugs 42f79daa/3dd8b4ec, bumps 3f6a38f3/0774dc22, dag-test fixes 3043a867) and pin bumps. Owner agy, gate-host lane 2 (claim it), official image, attached. Frozen tip = merged bashy main + umbrella pin; record shas, image id, mod drift first. Legs: bashy dag build; bashy dag test; bashy dag test-bash-gate (host podman, 86/86 both modes compared by fixture name vs rc.39 evidence); then the 3-OS dispatch e2e (TestE2EAllListedCommandsDispatch) from a FRESH install with an empty adapter cache on the Linux lane, Windows native on the gate host, macOS on the QA host (claim each). Append evidence per leg to umbrella docs/sprint-677-integration-evidence.md (exact exit codes, wall times, failing names verbatim; hosts by role). A red leg: root cause on this story (or 3043a867), fix by the responsible vendor, rerun only the red leg (+ the Bash gate if engine inputs changed) until clean. No code fixes inside this story. TEST RULE (operator 2026-11-22): build + the smallest targeted unit tests for the changed packages only, then submit. No go test ./..., no gates, no integration per story or per commit. The one full run is the rc.40 candidate gate (458628c0) at sprint close; anything red there is root-caused and fixed until the full run is clean. Start on current heads (bashy mod drift; rebase before submit). Trailers: Sprint/Story/Story-ID + Agent; submodule commit+push first, then the umbrella pin.

Sprint 677 integration run, LEG 1 RERUN in the NEW official image. Prior attempt (run #131) went red ONLY on the toolchain wall: image rc.37/go1.27.2 vs productgo go1.27.4 (evidence: docs/sprint-677-integration-evidence.md, umbrella 91094fa80 - APPEND leg-1 rerun results to that same doc; 7/8 dag test targets passed even then).

NOW: bashy e5ea93a8, image localhost/bashy-build:v1.0.0-rc.40-go1.27.4-1171628e07d3 (image.lock rolled; verify the lock values in your checkout before running). Umbrella f0efc9335.

METHOD (proven, copy exactly): gate host lane 1 (8 CPU/7 GB; manager holds lane lease), workdir /root/lanes/lane1/s677-integration (reuse run #131 staging if present), attached foreground: bashy oci run --rm --init --cpus 8 --memory 7g -e BASHY_BUILD_RUN=1 -e GOFLAGS=-p=8 --entrypoint /usr/bin/dash <rc.40 image> -c '<commands>'. Stage bashy@e5ea93a8; record image id, sha, mod drift FIRST.

RUN bashy/.bashy/gate.final lines in order: bashy dag build; bashy dag test; bashy dag test-bash-gate. Commit evidence to docs/sprint-677-integration-evidence.md after EACH line (first commit <15 min: setup+image+drift). Exact exit codes, wall times, pass/fail counts, failing names verbatim. Root cause before any fix; NO code fixes in this story - record and continue. Trailers + Agent yourself. Role names only for hosts.

WAVE 2 GO (conductor claude-fable5.1, 2026-11-22): owner muse-wonder (agy's tool times out on long remote commands). All Wave 1 stories are merged. FROZEN TIP = the umbrella main commit that carries these pins (verify with git log at start): bashy 9dd37bb2 (P5 thin core + import boundary; adapter fixes; dag-test fixes; startup gate on bsh; dag capacity services; kubectl env tests; dependency bumps with the override retired; yoke/outpost pins bumped), bashsharp ed6ca933 (bsh), outpost a1c9307, yoke 908e590c. Record the shas, image id and `bashy mod drift` output FIRST. VENUE: the gate-host lane-2 resource (claim it; lane 1 is held by a dead agy lease, do not take it), official image localhost/bashy-build:v1.0.0-rc.40-go1.27.4, session attached, fresh cache volume. LEGS in order, evidence appended to umbrella docs/sprint-677-integration-evidence.md after EACH leg (exact exit codes, wall times, pass/fail counts, failing names verbatim; hosts by role only): (1) bashy dag build; (2) bashy dag test with the candidate ./bin/bashy (BASHY=./bin/bashy); (3) bashy dag test-bash-gate on the host (BASH53_OCI=podman), 86/86 both modes compared by fixture name against the rc.39 evidence; (4) 3-OS dispatch e2e: TestE2EAllListedCommandsDispatch from a FRESH install with an empty adapter cache (BASHY_ADAPTER_CACHE pointing at an empty dir) on the Linux lane, Windows native on the gate host (claim the Windows-native gate resource), macOS on the macOS QA host (claim it). LONG COMMANDS: launch with nohup inside the remote session writing a log under the lane work dir, return at once, poll every ~60 s; never block one command for more than a minute. A RED LEG: do not fix in this story; record the failing names + first-pass classification here (venue/test/product with the evidence line), notify the conductor via bashy mb, continue with the next leg. Known-to-recheck here: the former venue items #5-#7, #14, #15 from 3043a867 and test-startup-linux now measuring bsh. Submit with the per-leg table.
