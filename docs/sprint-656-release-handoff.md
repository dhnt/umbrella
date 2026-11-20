# Sprint 656 — RC38 handoff, 2026-11-20

RC38 build and publication are left to the operator's next TUI session. No
RC38 tag, upload or publication was started during this closeout. The current
publication hold remains in force; the next session should follow the operator's
release instruction there. This handoff does not authorize publication itself.

The remaining release task is **#386 / `b4cdd7cf47f7`** in Sprint 656. Read its
card and the [current sprint plan](sprint-656-master-execution-plan.md) first.
Sprint 656 has 7 of 17 stories closed; ten remain open. Do not mark the sprint
complete or close unrelated QA stories to make the release board green.

## Delivered work and limits of its evidence

Stories 428, 429 and 431 are accepted for delivered infrastructure. Bashy
`4581ef30` supplies the local strict security gate and candidate-bound evidence
verification; `3507caa1` corrects the platform verifier. Darwin amd64 is removed.
The supported release targets are Linux amd64/arm64, Darwin arm64, and Windows
amd64/arm64. GitHub verifies local evidence and uploaded assets rather than
repeating local scans and builds.

The distribution implementation at `b88c94d4` has retained evidence of a
**full Bashy** warm build/package: 195.591 seconds inside the official image,
227 seconds including orchestration, five platforms, 34 assets and 33 checksums.
It includes independent Bash/sh, Outpost, telemetry and scratch assets, packaging
and SBOMs. It is not a shell-only build. That benchmark's Linux Bashy executable
was 267,200,472 bytes. The current candidate may differ.

Upload was **not measured**. Cold cache preparation took 1,141 seconds separately.
Consequently an end-to-end release under five minutes, or that timing on current
HEAD, has not been established. Preserve the independent Bash/sh artifacts;
do not restore combined personalities to reduce build time.

The last actual security lane was red: the license check passed for 388 entries,
but vulnerability findings remained across the default, embedded, engine,
Outpost and Yoke profiles. Infrastructure tests passing is not a passing release
security receipt. The recorded builder/toolchain is Go 1.27.2, image digest
`sha256:c99fcb7318b23ed06b3775368ee3966795a5498fb9a050a92d6f21866680b7ba`.
No qualified Go 1.27.4 replacement image or current-candidate green security
receipt is established by this handoff. Host tool installation is not image
qualification. Investigate exact findings before proposing minimal remediation;
do not waive or disable the strict gates.

## Resume the existing release procedure

1. Freeze the exact current full Bashy commit and all producer pins. Sources
   continued evolving after the benchmark; neither `b88c94d4` nor the POSIX
   harness's syntax-only Bashy is an automatic release candidate. Preserve other
   agents' work and establish clean, pushed inputs before qualification.
2. Verify the candidate includes the database regression fix and Sprint 658's
   credential-redaction fixes. The retained token tests passed without skips
   against Outpost `634af55` and Yoke `a39ad14`; bind any reuse to exact source
   identities. Resolve the database fix and its regression receipt from actual
   history/current pins rather than assuming a scratch directory is the fix.
3. Follow [Bashy's release runbook](../bashy/docs/release-runbook.md), its current
   DAG and builder lock. Use the qualified official image and narrow resource
   claims. The local gate requires both `BASHY_BUILD_RUN=1` and an authentic
   `BASHY_BUILD_IMAGE`, clean sources, strict license mode and all vulnerability
   profiles. Do not invent an image identity or use a host build as evidence.
4. Build and verify the full asset family, signing/provenance and immutable
   source/dependency/asset receipts. Collect candidate-bound local gate evidence;
   bind it to the final asset manifest. Retain scanner database freshness and
   disclose cold/warm conditions and actual build/package/upload elapsed time.
5. When instructed to release in the new session, use the existing complete-dev
   and promotion routes: `v1.0.0-rc.38-dev` to `v1.0.0-rc.38`. Publish the reviewed
   evidence Git note under `refs/notes/bashy-local-gates`, pass its immutable
   notes commit as workflow `evidence_commit`, and verify assets and provenance
   before promotion. Read the current scripts rather than reconstructing the
   publisher or replaying old process IDs and resource claims.

The other nine open QA/design stories and their missing delivery evidence are
listed in the sprint plan. In particular, venue lifecycle policy requires its
recorded operator design review. This closeout starts none of those changes.

## Separation and POSIX evidence are preserved

Repo/package separation is delivered; Bashy/Yoke can develop against pinned
lower layers. Bash and Bashsharp still share the engine/CLI. Their deeper engine
split is future work, and shared-code changes require both regression suites.
Sprint 575 retains two standalone receipt gaps (Ycode `180afb01a609` and
Bashsharp-tests `d072b174e090`); they are not silently accepted as green.

The completed POSIX engineering baseline is independently tagged
`posix-baseline/s575-2026-11-19`. It recorded 117 targets, 9,337 test purposes,
four FAIL, 54 UNRESOLVED and nine INSPECT, with no timeouts, UNINITIATED or
UNREPORTED results. This is not formal certification. The private retained
archive SHA-256 is
`63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1`.
The owned test droplet was deleted and absence verified. Do not recreate a paid
runner or rerun the full suite merely for this handoff.

Sprint 675 contains the seven follow-up investigation/readiness stories. The
[public full-profile-D runbook](../bashy/docs/kb/pages/full-profile-d-posix-runbook.md)
and [baseline closeout](../bashy/docs/s575-posix-engineering-baseline.md) are
published and scrubbed. Licensed kit access and private receipts remain private;
do not substitute an unproven runner or external utility providers.

## Session exit

Own documentation and story reconciliation are committed and pushed. Manager
continuity is recorded through `bashy sprint handoff` for 575 and 656; unfinished
work remains open. Foreign dirty work and unpublished histories are preserved.
Old worker claim records that reject release through session fencing are not
forcibly cleared. No worker is stopped by releasing the manager seats.
