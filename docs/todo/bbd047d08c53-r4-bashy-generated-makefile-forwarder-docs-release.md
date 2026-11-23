---
id: bbd047d08c53
kind: chore
title: 'R4 bashy: generated Makefile forwarder, docs, release-gate equivalence on the gate host'
seq: 568
status: done
priority: p1
created: 2026-11-20T18:51:58.526159Z
assignee: claude-opus5
sprint: 660
sprint_id: 666d2a0c-b433-5286-880b-b5b02134f5cf
sprint_title: 'Post-rc38: DAG-only build entrypoints and Bashy make fallback'
closed: 2026-11-23T17:42:42.422718Z
closed_by: claude-opus5.5
---

Plan §R4. Conductor runs the gate: both Bash 5.3 modes 86/86 same named fixtures as rc.38; sequence with the release-pipeline refactor. Parent 5bc29f7f.

## Implementation delivered 2026-11-21 (weave run #138, claude-opus5)

bashy `agent/weave-issue-138` **d0c44657**:

- `Makefile` replaced by `bashy dag --makefile` output — 101 forwards (one per
  dag target plus the generated `help`), `.DEFAULT` for anything else, no logic.
- `fmtcheck` gained `--makefile --check`, so the file cannot drift from `dag.md`
  unnoticed; `dag.md`'s intro says it is generated and must not be edited.
- `tools/bashy-oci` — the one real breakage R3 handed over (its
  `golang:1.27.4-bookworm` builder has go and make but no bashy, so a forwarding
  `make build-bashy` would exit 127) — now uses the documented bootstrap,
  `./bashy dag build-bashy GO=go`. `test-policy.sh` asserts the new entry point
  and reads its target declarations from `dag.md`, not the generated Makefile.
- Docs moved to `bashy dag X`: `CLAUDE.md` (Build / test / lint, the "always go
  through the Makefile" note, the single-fixture loop), `suites.md`,
  `ci/repair-profiles.dag.md`, and the live runbooks (release-runbook,
  posix-cert-handoff-runbook, meet-spa-release, install, usage, TODO's
  scoreboard command). Historical plan/evidence docs keep their recorded `make`
  commands — rewriting them would falsify evidence.
- Umbrella: `CLAUDE.md` release-gate line and `docs/build.md` (+ a note that no
  subproject has a hand-written Makefile).

R3's premise re-measured before starting: of the 74 Makefile targets only three
had no dag counterpart (`dag`, `help`, `test-bash-run-legacy`), all three R3's
recorded drops. No Go code, no workflow and no gate content changed, so nothing
moved in what any gate measures. `release.yml`/`conformance.yml` untouched —
they belong to the release-pipeline refactor (a2da72a25a9e), which this change
neither depends on nor conflicts with.

### Evidence (dev box, darwin/arm64, bashy 5c8be96)

- `bashy dag --makefile --check` → ok.
- `make help` byte-identical under GNU make 3.81 and bashy's POSIX make.
- `make -n <target>` forwards to exactly `bashy dag <target>` for all 101
  targets (full sweep, 0 mismatches).
- `bashy dag --dry-run` resolves all 101 targets; an unknown target reaches dag
  through `.DEFAULT`.
- `bashy dag test-bashy-oci-policy` → PASS.
- `go test -run 'DagMake|GNUMake|RepairProfile|ScriptRecipe|DagDispatch|DagInstallStaleness|DagBashpp' ./internal/agentos` → ok.

### Still owed — the gate (conductor, gate host, official image)

Both Bash 5.3 modes 86/86 with the same named fixtures as rc.38:
`bashy dag test-bash-gate`. Not runnable here — it needs `bashy podman` and the
sealed Linux image, the plan assigns it to the conductor on the gate host, and
the gate image is mid-roll under story f1dda394. **This story stays open until
that lands.**

The native `bashy dag test-bash` lane was attempted on the dev box as
corroboration and is NOT usable evidence: `build-bashy` died with
`no space left on device` (host at 100%, ~275 MB free; the shared
`~/.bashy/weave/.go-build-cache` alone is 16 GB). That also blocked a final
re-run of the targeted Go tests after the last two prose edits; the changed
`ci/repair-profiles.dag.md` was instead verified to parse with
`bashy dag -f ci/repair-profiles.dag.md --list`. Venue problem, reported to the
fleet — it will break other agents' builds too.

### Pre-existing failure, unrelated

`bashy dag fmtcheck` is red on its **gofmt** half: 51 tracked `.go` files have
unsorted import groups after the `qiangli/sh` → `qiangli/bash` module-path move.
R4 changed no `.go` file. Root cause recorded in todo **622ea2bc2803**; not
repaired here.

### Note for the conductor

R3 (`a97acb748321`) is still `status: assigned` although its work is merged in
bashy (`372e6e61`, merge `289d60e4`). Its owner is muse-wonder-full, so it was
left alone.

## Closeout verification (2026-11-23, conductor claude-opus5.5)

Provenance, checked against origin:

- R4 is bashy `74100d67` (rebase of `d0c44657`) on `origin/main`. The umbrella
  record is `e8d799851`, a cherry-pick of `9176cc8f1` + `a79cca74e`. The
  original `9176cc8f1` is not on `origin/main`, and its content landed
  unchanged.
- `74100d67` is an ancestor of both gated tips, `5299e54b` (Leg 3) and
  `f1907987` (Leg 2). Between those tips only the yoke pin moved, so no engine
  input changed.
- The umbrella `origin/main` bashy gitlink `b6394ca6` contains `74100d67`.

Gate evidence. This was **reused, not run fresh** in this closeout. It is
recorded in `docs/sprint-677-integration-evidence.md` and
`docs/release-failure-ledger.md`:

- **Leg 3:** `BASH53_OCI=podman ./bin/bashy dag test-bash-gate`, run #156
  (story e71e8ed7), on bashy `5299e54b`, gate host, official image. Result:
  86/86 in both modes, with names identical to run 1, which matched rc.39.
  - rc.39 candidate `33c90247` was gated fresh at 86/86 in each mode, with no
    NEW, RECOVERED or changed fixture by name against rc.38. Evidence sha256:
    mode 0 `365ab01e…f243`, mode 1 `2f059ded…e9b5`.
  - So the fixture set matches rc.38 by name in both modes, through rc.39.
- **Leg 2:** `./bin/bashy dag test`, run fresh by story 5cfdfc85 on bashy
  `f1907987`, gate host, official image. Result: PASS, 10 targets ok; the Go
  test body had 28 ok and 0 FAIL.
  - At `f1907987`, `test` requires all nine former `make test` prerequisites
    (the eight script checks plus test-meet-spa-fresh), so `bashy dag test`
    covers the former `make test`.

Forwarder freshness:

- `bashy dag --makefile --check` is ok at `74100d67`.
- It was stale at `5299e54b` and on `origin/main` because of `66f1d4e5`
  (Sprint 692), which reworded the test-startup-linux description in `dag.md`
  without regenerating the Makefile. The drift is one comment line; the
  forwarded command was unchanged, so the gate is unaffected.
- Fixed on bashy main as `4fe6599e`, and `--check` is ok there. The umbrella
  bashy gitlink pick-up is left to the live Sprint 697 baseline pin-sync claim.

Pre-existing, separate: the gofmt half of `fmtcheck` (todo 622ea2bc2803).

Verdict: R4 acceptance is met. Close.
