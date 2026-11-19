# Sprint 675: investigate S575 residuals and prepare POSIX certification

Sprint UUID: `9b07aedb-77af-52d5-8af3-8035a213774c`.
State: planned backlog; manager unassigned; no execution or resource claim.

## Outcome and current evidence

Investigate every retained non-pass in the separated-source baseline and prepare
the evidence, manual reviews, authority questions and readiness handoff needed
for POSIX certification. Reuse the seven unfinished S571 stories and existing
S355/S371/S377/S385 packets; preserve their identities and decision history.
S571's older documentation-delivery story R8 remains a historical record there.

Current source marker: `posix-baseline/s575-2026-11-19`, published in the
umbrella, Bash and Coreutils repositories at these tested revisions:

| Role | Commit |
| --- | --- |
| Umbrella approval snapshot | `295cd32d032fb94dda2c032c26109032bd5af4b8` |
| Bash | `7855c2f038f2c8ccba1baf8478b0b8fb3dcd8cd2` |
| Coreutils | `c656935287fa4bff4920b08e41156d13d7c5702f` |
| Shared CLI dependency | `4141cc07cfdc6c0a838825485ef41e54a55fa9a0` |
| Private harness | `6966bc6458e862d7ae03a4a01e7044ab842399ba` |

The full unchanged Profile D run completed on 2026-11-19: **117 targets and
117 journals, 9,337 execution TPs, 9,270 PASS group, 4 FAIL, 54 UNRESOLVED,
9 INSPECT; zero UNINITIATED, UNREPORTED or capped targets**. PASS group includes
the original applicable UNSUPPORTED, UNTESTED and NOT IN USE results.

Residual counts and observed families match S561. Matching counts are not a
substitute for reconciling individual TP identities and evidence. The shell
scenario and mailx/at/batch/crontab completed without their earlier orchestration
blockers. The original parser excluded 178 build/setup records separately.

Original retrieval, independent parser recomputation, artifact/input integrity
checks and archive readback passed. The owned disposable venue was retired;
provider API absence was verified. Restricted journals and correspondence remain
private. Sealed evidence archive SHA256:
`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`.
Artifact manifest SHA256:
`6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138`.

Full identities, build flags and closeout:
[S575 engineering baseline](../bashy/docs/s575-posix-engineering-baseline.md).
Historical comparison:
[S561 results](../bashy/docs/s561/a4-licensed-results.md) and
[earlier S571 plan](plan-s571-posix-certification-readiness.md).

## Reused stories and order

| Story | Preserved ID | Current investigation/preparation scope |
| --- | --- | --- |
| R1 | `4088102f4f39` | Reconcile all 67 exact residual identities and inherited ownership against the S575 evidence |
| R2 | `ef9df1f844cd` | Investigate 53 empty-symlink setup results; refresh the existing authority packet |
| R3 | `52d169ab8c3b` | Investigate the `man:4` command-count precondition; prepare the supported resolution question |
| R4 | `c02bdd0e36cc` | Investigate `more` TPs 130/132/133/134 and prepare scope/authority recommendations |
| R5 | `bf5e89e38c78` | Assemble and review evidence for nine exact-journal manual INSPECT decisions |
| R6 | `60e864ce9f7a` | If a defect is established, propose the smallest causal repair and affected verification plan |
| R7 | `2f848bba27c7` | Consolidate the certification-readiness matrix, prepared packets and operator handoff |

R1 is the P0 entry point. R2-R5 can proceed independently after the ledger is
checked. R6 is conditional, not permission to redesign or implement changes.
R7 collects findings and clearly distinguishes prepared packets, unanswered
questions, received rulings, manual decisions and actual submission readiness.

## Investigation rules

- Start from the preserved journal and exact source/artifact inputs. Compare
  named TP identities with the old baseline before claiming no regression.
- For each result, record observed failure, venue, relevant source/fixture
  behavior, confirmed cause or remaining uncertainty, decision owner and next
  action. Do not assume all residuals are harmless or outside product code.
- The 53 empty-symlink results and `man` inventory precondition require their
  existing questions to be checked against this run. Do not invent utility
  names, add host utilities or weaken a prerequisite to satisfy the suite.
- Inspect the actual `more` locale/helper diagnostics for all four IDs.
  Historical final-EOF/editor questions are context, not a proven explanation
  of these observations. Determine the applicable required/optional scope.
- Review the nine INSPECT items individually: `stty` seven, `df` one, `locale`
  one. Prior manual PASS decisions do not transfer without applicable evidence
  and a qualified reviewer. Keep raw codes and any supported decisions separate.
- Preserve the declared 102-provider base: 92 Go utilities and 10 shell
  commands, zero external utility providers; keep original optional applicability.
  Separately recorded native harness/build tools are infrastructure.
- Reuse evidence only with explicit source, linked-input, artifact and venue
  identity. A changed tag or matching aggregate count is insufficient.

## Boundaries and completion

This is investigation and preparation. Creating the sprint does not authorize
production code changes, engine refactoring, expanded licensed coverage, a new
full run, altered tests/oracles/limits, result reclassification, sending external
correspondence, official submission, fees or certification claims. Necessary
repairs and invalidated verification must be proposed concretely before work
beyond the authorized scope. RC38 tagging/release remains on operator hold.

Reuse the existing licensed kit, runbook, approval and evidence mechanisms.
No replacement runner, new gate framework or blanket freeze on other work.
Reserve only the specific resource needed for an authorized bounded action.

Completion means a reviewed 67-identity ledger, evidence-backed cause or precise
remaining uncertainty for every family, prepared authority/manual packets,
any minimal repair proposals with verification impact, and an honest readiness
handoff. Required external decisions can remain listed as blockers; prepared
questions are not rulings, and engineering closure is not certification.

At handoff, verify the current certification program/profile, licensed-kit
terms, supported configuration and submission requirements against official
sources. Use the [Profile D runbook](../bashy/docs/kb/pages/full-profile-d-posix-runbook.md)
for the existing kit application links and repeatability references.
