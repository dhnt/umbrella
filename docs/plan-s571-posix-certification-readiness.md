# Sprint 571: residual resolution and POSIX certification readiness

Sprint UUID: `74f43bab-7fb6-58b1-97e0-94c52ed5986c`.
State: planned backlog; manager unassigned. Stories and card are authoritative.

## Outcome and baseline

Resolve the 67 residual test purposes from Sprint 561 and deliver an
independently reviewed, submission-ready POSIX certification dossier.
Sprint 561 closed engineering with no regression; it did not establish full
certification readiness. Its exact frozen candidate is bashy `f1bcd711`,
sh `74586fde`, coreutils `211789fa`, harness `0b2b185d`.

Profile B: 493/493 PASS. Profile D: 117 sets, 9,337 test purposes,
9,270 PASS-group, 4 FAIL, 54 UNRESOLVED and 9 INSPECT. The residual total
is 67, not the earlier prose total of 62. Public evidence is in
`bashy/docs/s561/a4-licensed-results.md`, `a4a-results.md`, `a3d-results.md`
and `candidate-manifest.json`. Restricted raw evidence and prepared packets
remain in the private harness kit. No current raw result changes by planning.

## Story sequence

| Story | Identity | Work |
| --- | --- | --- |
| R1 | `4088102f4f39` | Reconcile the 67 residual identities and inherited decision ownership |
| R2 | `ef9df1f844cd` | Obtain and apply VSC rulings for 53 symlink setup results |
| R3 | `52d169ab8c3b` | Resolve the man:4 command inventory prerequisite |
| R4 | `c02bdd0e36cc` | Resolve four more failures and their certification scope |
| R5 | `bf5e89e38c78` | Apply supported manual decisions to the nine current INSPECT results |
| R6 | `60e864ce9f7a` | Implement and verify repairs required by residual decisions |
| R7 | `2f848bba27c7` | Verify the resolved candidate and prepare the POSIX certification dossier |
| R8 | `18eec4b91f9e` | Reconcile public POSIX test status and certification references across submodules (operator-requested documentation follow-up) |

R1 is the P0 entry gate. Once its ledger and ownership are reviewed, R2-R5
can proceed independently. R6 handles only evidence-supported repairs, as
findings arise. R7 depends on all required resolutions and verified repairs.
R8 updates public references now; it does not resolve test outcomes or start
the licensed/authority execution lanes.
R1 must reconcile existing S371/S385 external-decision ownership with the
S355 packets and S377 decisions, avoiding duplicate authority cases.

## Decision and evidence rules

- R2 owns 53 symlink setup UNRESOLVED identities; R3 owns `man:4`;
  R4 owns four `more` failures; R5 owns nine INSPECT (`stty` 7, `df` 1,
  `locale` 1). Every identity retains its raw verdict and a separate disposition.
- Prepared or sent packets are not rulings. Record authoritative replies,
  their applicability and verified application. Pending required rulings block
  readiness. Resolve optional-target scope explicitly; exclusion is not PASS.
- S377 decisions must be checked against this exact journal. A historical
  manual PASS cannot be copied without applicable current-arm evidence and
  a reviewer. Missing evidence requires a bounded, specifically approved replay.
- Current triage found decision issues, not confirmed product defects.
  If evidence establishes a defect, R6 makes the smallest causal repair and
  proves it without weakened assertions, skips or fabricated outcomes.
- Preserve original candidate and artifact identities. Source-closure equality
  alone does not prove artifact equality. Reuse unchanged evidence explicitly;
  identify and rerun invalidated required lanes under the supported approval.
- Review actual certification program/profile/version, application requirements
  and supported configuration before declaring the dossier ready. Include the
  exact environment, source/build/dependency/fixture identities, raw evidence,
  scope matrix, rulings, manual decisions, result accounting and reviewer signoff.

## Execution boundaries and completion

The user requested creation and preparation of this sprint. It is not started;
manager appointment and host/resource reservations happen at execution time.
Prepare exact correspondence for operator-authorized transmission. New licensed
runs require the supported specific approval. Keep restricted fixture text,
raw journals, private addresses and correspondence outside public Git.

Close only when all required decisions are resolved, repairs verified, evidence
complete and regression-free, and the dossier independently reviewed. An external
wait remains a blocker; an engineering-only closure cannot substitute for this
sprint's readiness gate. Official submission, certification fees, certification
claims and releases require separate operator authorization. No blanket freeze
on other sprints is imposed; coordinate only affected inputs and shared resources.
