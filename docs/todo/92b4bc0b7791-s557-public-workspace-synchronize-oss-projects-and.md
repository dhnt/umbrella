---
id: 92b4bc0b7791
kind: chore
title: 'S557 public workspace: synchronize OSS projects and provide independent development and test entrypoints'
seq: 4
status: assigned
priority: p1
created: 2026-11-01T09:17:34.646235Z
weave: 2
assignee: agy-gemini3.8-flash
sprint: 557
sprint_id: f5ccf563-f5d1-5b94-8be4-9388e51ef86d
sprint_title: 'Bashy v1.0.0 preparation: split private/public development and retire qiangli/dhnt'
---

Prepare the public workspace for the official Bashy v1.0.0 release: synchronize public submodule heads, hydrate required public modules, maintain version-pinned standalone builds and an optional sibling workspace, update bootstrap/sync/CI and developer documentation. Preserve unique work. Public builds must not require private sources, credentials or licensed conformance fixtures. Record reproducible public verification commands and sanitized evidence. Keep all private coordination in the private migration record.

## Consolidated acceptance ownership — 2026-11-02

Operator-directed triage: implementation mistakes, review corrections and failed tests belong to this existing deliverable, not new stories. Superseded child records retain their original scope and evidence. Their decision closure means responsibility transferred here, NOT fixed, passed, waived or feature retirement. Keep this parent open until its acceptance is verified. New stories require genuinely independent scope.

Release constraint: RC tags only, using the existing format. Official v1.0.0 requires completed official POSIX certification and separate explicit operator approval even if every test passes. Formal certification is deferred; the migration still requires its shell-only conformance gate.

Remaining acceptance: canonical public branches and published producer revisions, independent clean-checkout/standalone builds, synchronized gitlinks and module pins, no private dependency, and preservation of unique work. Candidate pin updates and any corrections stay here. Validation may retain an immutable candidate while later documentation commits advance a branch; reconcile final gitlinks before closure.

### Transferred implementation and verification checklist

Every row retains its original acceptance and evidence in the named source record; verify disposition within this parent before closure. These rows are tasks, not additional stories.

- [ ] `17bccfc3f954` (bashy #3037): S557 align standalone release candidate with validated producer revisions. Reconcile existing evidence and any remaining verification.

## Active bounded worker assignment — 2026-11-02

Immediate bounded assignment: verify remaining publicworkspace readiness against currentcanonical roots and reconcile precise blockers. Read parentandcurrenttriage; rootisrunningruntimefixworkseparately. Readonly canonicalinventory: branch/HEAD/upstream/dirty/gitlink/moduleboundary for publicumbrella+submodules; distinguish documentation-onlypinchanges fromruntimecandidatecd91b04. Inspect remainingrun/worktreeuniquecommits without removingorresettinganything. Source/candidate modulepins maylegitimately exclude laterdocs; no blindmassgo get. Identify concrete brokenpaths/private dependencies relevantmigration. Use managedisolatedworkspace for any small neededscript/docfix, preserve originalassertions/semantics. Do not modifycanonical/frozen dhnt, inspectlicensedtrees, createcloudresources, runfullbuildsuiteorcontainers, orpush/merge. No newstories. Within5minutes send inventorysummaryandone nextaction; within twenty minutes deliver concise exactpass/blocker matrixandscopedcommitifnecessary. Useexisting557/#4/92b4bc0b7791 actualAgent. Rootowns allcleanupmutations andfinalacceptance.

All agents: subscription-backed route only; no metered/API fallback. Do not create stories for corrections; append evidence to this parent. Manager checks concrete progress every five minutes, steers and reassigns stalled work.
