# Sprint 656 — RC38 release pipeline and QA follow-ups

Next-session release continuity: [RC38 handoff](sprint-656-release-handoff.md).

## Reconciliation — 2026-11-20

RC38 tagging and publication are **on operator hold**. This latest instruction
supersedes the earlier conditional go-ahead recorded on the card. No build,
test, upload, tag or release was started by this administrative reconciliation.

Three delivered infrastructure stories are now accepted against their existing
qualified evidence; that acceptance is not current-candidate release approval:

| Story | Delivered work and evidence |
| --- | --- |
| 428 / `189c6439f049` | Local strict gate and candidate-bound offline preflight, published at Bashy `4581ef30`. Current workflow/collector/gate/verifier/tests match the qualified snapshot. Retained official-image contracts cover positive preflight and tampering, red verdict, wrong source and stale-database rejection. |
| 429 / `9b565ca29f5c` | Darwin Intel platform removal, published at `4581ef30`, with corrected verifier `3507caa1`. Platform/tool/fixture identity and retained build/unit/contract/asset evidence checked. |
| 431 / `a2da72a25a9e` | Distribution infrastructure at `b88c94d4`; nine script blobs and the DAG dist body still match. Exact old warm measurement: 195.591 s inside OCI, 227 s including orchestration, five platforms and 34 assets. |

The warm build/package measurement excludes upload. Cold cache preparation took
1,141 s and is disclosed separately. It does not prove a later candidate or an
end-to-end five-minute release. Later separation requirements preserve independent
Bash/sh artifacts alongside the full Bashy product; the original combined-personality
optimization proposal below does not override that requirement.

The existing local-release request `b4cdd7cf47f7` is now tracked in this sprint
for remaining **frozen-candidate security/build/upload/signing qualification and
held publication**. The last recorded strict security gate was red; no passing
current-candidate security receipt or measured upload is claimed. The S575
POSIX engineering evidence is retained separately under its published baseline.

These nine other stories remain genuinely open:

| Story | Missing delivery |
| --- | --- |
| 426 / `89a3f6f8e2fe` | SDK diagnostics off stderr and endpoint-validation regression |
| 427 / `682535e811d9` | Venue-change lifecycle policy; operator design review before implementation |
| 432 / `5ebd65af3b15` | Nonblocking daemon startup and upgrade-confirmation window proof |
| 433 / `2e98378d13ad` | Download stall limit and ownership-safe candidate cleanup |
| 434 / `37c88c751e66` | Positional SCP port parsing and regression |
| 435 / `34f89e7e18b3` | Named Windows interpreter-panic reproduction and regression |
| 437 / `ab6b9b872ac1` | Installed reboot autostart with venue readback evidence |
| 438 / `9deb591a820c` | Correct absent-Podman-socket capability/health behavior and tests |
| 440 / `e4b4085b0474` | System-log retention/readback and supervisor timestamp evidence |

No matching delivery evidence was established for those stories. They are not
closed because nearby token-redaction fixes landed; those belong to Sprint 658.
Do not start new fixes or move unrelated work merely to make this board green.

## Original rc.37 venue plan — historical context

Primary goal: the rc.37 native tier smoke can run unattended and with clean
command output on all three QA lanes.

Background: on 2026-11-17, while the `v1.0.0-rc.37` tier kit was being staged,
two venue problems showed up:

- Every command that outpost ssh runs on the gate host prints the OTel SDK
  error `parse url "127.0.0.1:31416"`. That host runs the linux lane in WSL. The
  same symptom on the first Windows QA host on 11-15 came from a user-level
  registry variable that the outpost daemon inherited (outpost todo
  `c84bb044`). Tier probes that parse command output break on these lines.
- outpost ssh to the macOS QA host asks for a password and has no TTY to read
  it from, so the darwin lane cannot run unattended.

## Rules

- Root cause before any fix (`CLAUDE.md`). Name the source, check the venue,
  and record the cause on the story.
- A venue problem is fixed in the venue, never in product code. bashy and
  outpost source stays frozen until rc.37 is promoted.
- Public text names hosts by role only. Do not touch the gate host's default
  podman or the gate image.

## Stories

| Story | Priority | Kind | Fix lives in |
|---|---|---|---|
| `43d7f0b2` gate host OTel env source | p1 | venue | host env + daemon restart |
| `b93cd467` macOS QA host ssh auth | p1 | venue | host auth config or the tier kit |
| `89a3f6f8` SDK diagnostics off the user's stderr | p2 | product | bashy, after rc.37 is promoted |

## Acceptance

1. The cause of each venue story is recorded, with evidence of where the value
   or the auth path comes from.
2. On the gate host, `outpost ssh … -- <native shell>` and the WSL root route
   print zero stray stderr lines.
3. The tier kit's darwin `remote()` route runs non-interactively.
4. The rc.37 tier smoke passes on linux, darwin and windows. That run is the
   gate for the venue stories.
5. `89a3f6f8` lands after promotion, with a regression test.
