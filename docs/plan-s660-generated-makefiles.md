# Sprint 660 — replace hand-written Makefiles with generated dag forwarders (plan)

Planner: the conductor. Operator, 2026-11-20: the conductor plans; workers
implement until they prove they can plan.

Parent story: 5bc29f7f (operator, 2026-11-17: remove Makefiles; dag.md is the
only build and test source). It is amended 2026-11-20: each hand-written
Makefile is REPLACED by the generated forwarder from `bashy dag --makefile`
(Sprint 678 S1, fa9fcc8d), not deleted.

The make fallback (d9bf47e9) moved to Sprint 678.

## Precondition

Sprint 678 S1 is merged and pinned: `bashy dag --makefile` and `--check` exist.
Stories R1–R4 start only after that.

## Inventory (measured 2026-11-20)

| Repo | Makefile targets | dag.md | make used by CI/scripts | Story |
|---|---|---|---|---|
| bash | build test test-quick test-full bashpp-race-gate tidy clean help fmtcheck hooks | 20 targets | none | R1 |
| outpost | help build build-all test test-headless tidy fmtcheck hooks install clean | 11 targets | none (only comments mention make) | R1 |
| bonsai | build install test vet all smoke-as-third-party clean fmtcheck hooks | **none** | none | R2 |
| gfy | help build tidy test lint install diff clean fmtcheck hooks | **none** | none | R2 |
| nadir | help fmt vet tidy build build-onnx test test-onnx clean fmtcheck hooks | **none** | none | R2 |
| readline | all ci test examples gofmt fmtcheck hooks | **none** | none | R2 (operator may veto: upstream fork) |
| sh | as bash | 9 targets | 2 workflows | **skip**: legacy; its README points to qiangli/bash since 2026-11-12 |
| bashy | 74 targets | dag.md + suites.md + ci.dag.md | 12+ scripts, 3 workflows | R3, R4 |

bashy Makefile targets with no dag/suites/ci.dag target:
- build-bashy-oci, check-seed-bands, dag, govulncheck, help, license-gate
- smoke-airgap-container, smoke-bashy-oci, smoke-chat
- smoke-dag-{c,csharp,go,manifests,powershell,python,rust,text,typescript}
- smoke-llm-local, smoke-python-imports, smoke-quickstart,
  smoke-quickstart-container, smoke-runners
- test-awd-installed-stress, test-bash-run-legacy, test-bashy-oci-policy,
  test-group, test-groups-check, test-self-container, test-yash, test-yash-list

That is 31 targets.

bashy CI steps still calling make:
- conformance.yml: `test-bash-fixtures`, `test-bash-helpers`
- test.yml: `verify-bashy-scratch`, `test-meet-spa-fresh-regression`,
  `test-meet-spa-fresh`
- airgap-image.yml: `build`

bashy scripts calling make:
test-build-tag-matrix, s561-baseline-manifest, refresh-bashy, gosource-probe,
airgap-container-smoke, gate-fixture, posix-diff, yash-scoreboard,
vsc-tet-build, posix-parity-pty, windows-bash53-gate, campaign-distribute.

## Stories

### R1 — bash, outpost: swap in the generated forwarder (low risk)

- Port any Makefile target that dag.md lacks and that is still used, or drop it
  with a recorded reason. Candidates: bash `test-quick`, `hooks`; outpost
  `build-all`, `test-headless`.
- Replace the Makefile with `bashy dag --makefile` output.
- Add `--makefile --check` to that repo's `fmtcheck` (or lint) dag target.

Accept when:
- `make help` lists exactly `bashy dag --list`;
- `make test` and `bashy dag test` run the same body;
- `--check` passes;
- the repo's own `bashy dag test` passes (targeted; heavy suites on the test host only).

### R2 — bonsai, gfy, nadir, readline: add dag.md, then generate

- Write a minimal dag.md that mirrors each still-used Makefile target, same
  commands with no new behaviour. Drop obsolete ones with a reason (`all`,
  `clean` where trivial).
- Generate the Makefile and add `--check` as in R1. Accept as in R1.
- readline is an upstream fork (ergochat). Default: convert like the others
  and record the trade-off in its README: upstream merges will conflict on
  Makefile, and the resolution is to regenerate. If the operator vetoes,
  leave readline untouched and close its part as WONT DO.

### R3 — bashy: port what is still used; move scripts and CI off make

Split from R4 to keep each review small.

- Classify each of the 31 missing targets as one of:
  - **port**: a dag target in dag.md or suites.md with the same body;
  - **drop**: obsolete or duplicate, with the reason recorded in the plan
    appendix (for example `dag` and `help` are generated, and
    `test-bash-run-legacy` is superseded).
- Switch the 12 scripts and the 6 CI steps from `make X` to `bashy dag X`, or
  to `"$BASHY" dag X` inside dag bodies.
- No change to what any gate measures.

Accept when:
- every Makefile target is either a dag target or recorded as dropped;
- `grep` finds no `make <target>` in scripts or workflows, apart from
  POSIX-make conformance tests that deliberately exercise make;
- targeted unit tests pass, and `bashy dag --dry-run` resolves every ported
  target.

### R4 — bashy: generated forwarder, docs, release-gate equivalence (high risk)

- Replace bashy's Makefile with the generated forwarder and add `--check`.
- Update CLAUDE.md (Build / test / lint, the "always go through the Makefile"
  notes), docs/build.md and the release runbooks to `bashy dag …`.
- **Gate:** run by the conductor on the gate host in the official image.
  Both Bash 5.3 modes must be 86/86 with the same named fixtures as the rc.38
  evidence, and `bashy dag test` must cover the former `make test` checks. Any
  NEW failure blocks the change.
- Coordinate with the release-pipeline refactor: release.yml and
  conformance.yml change there too. Sequence R4 after or with it, never
  against it.

## Non-goals

- Changing any gate's content, test assertions or interpreter/runtime code.
- The sh repo (legacy).
- yoke and coreutils, which have no Makefile. yoke gets its generated
  Makefile from Sprint 678.

## Delivery

- **Worker:** muse, after Sprint 678. One story at a time: R1 → R2 → R3 → R4.
  Same brief rules: own worktree, root cause first, targeted tests only on the
  dev box, no push.
- **Conductor:** reviews, re-runs the targeted tests, merges, bumps pins, and
  runs the R4 gate.
- **Gate venue:** the gate host, claimed with `bashy claim`. Never the dev box.
- **Release:** none authorized here.
