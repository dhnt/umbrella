---
id: b1defa24918f
kind: task
title: N4 Lift the agent-identity surface in bashy; N1, N2 and N3 are accepted on its cert
seq: 863
status: done
created: 2026-11-28T10:20:19.522712Z
assignee: claude-fable5.2
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
closed: 2026-11-28T13:45:13.745823Z
closed_by: claude-fable5.2
---

Operator, 11-28: accept N1 and N2 when the shapeware specs are met; start using the shapeware spec process for this work.
Today no lifted surface covers this behaviour (bashy has one surface, shapeware/shape), so nothing can be met yet. Lift a narrow surface, shapeware/agent-identity, in bashy with kb runbook shapeware-lift-app:
- features (verified, each with acceptance lines): adhoc-session-id (N1), native-session-identity (N2), front-door-identity-step with its refusal (N3);
- CONTRACT.md assertions a command line can show in a fresh HOME with the harness markers set by the judge: bashy <tool> --dry-run and --help name the per-launch id; with a vendor session id set, bashy mb and bashy inbox run with no --as, the session is told its name once, the name is <tool>-<8 hex> and is the same on the next command and different for another session id; a claim taken with no declared name is held by that name; with no session id and no harness process, a coordination verb is refused with the guidance text and a non-coordination verb runs; BASHY_ADHOC_IDENTITY=off and a self-chosen BASHY_AGENT are left alone; a caller with no harness marker is untouched;
- dag.md lifecycle and gate targets (check, cert, mutate, alone) as in shapeware/shape.
Acceptance of N1, N2, N3: conform spec check clean, and cert passes on the gate host at the delivered bashy head; the story records the PASS lines.
Known limits, tracked as sprint 742 M6 a297eccb: the live terminal session id and the harness-process key cannot be asserted by the contract, and the yoke and nested-module go tests that pin them cannot be cited yet. The contract covers what a command line shows; the rest stays on the unit tests named in N1 to N3 until M6 lands.
Code inspected: bashy shapeware/shape (SKILL.md, CONTRACT.md, dag.md, judge.sh, features.yaml), shapeware/index.bsh; umbrella docs/shapeware-spec-v0.md 4.3a, 4.3b, 6; kb page shapeware-issue-to-spec.

## Delivery (2026-11-28)

bashy `80e68f8a`: `shapeware/agent-identity/` (SKILL.md, CONTRACT.md,
features.yaml, dag.md, judge.sh, examples/, evidence/), lifted with kb
runbook shapeware-lift-app from real runs of the reference built on the gate
host.

- Contract: 23 assertions (A-01 to A-24, no A-11). 20 are commands run as a
  stated caller in a fresh HOME through a `session KIND VERB` launcher; 3 are
  cited go tests in the form sprint 742 M6 delivered (yoke pkg/chat, yoke
  pkg/bus, bashy ./internal/agentos).
- Gate host, 2026-11-28: `check` clean (both surfaces PASS in the index
  check), `test` 23/23 PASS in 37 s, `cert` PASS in 3 runs with none noisy
  (contract sha256 1842377c…, 138 s). `mutate` and `alone` were started and
  their results go into evidence/README.md.
- N1 and N2 accepted on this (operator instruction). N3 is covered by the
  same cert (feature front-door-identity-step: A-04, A-05, A-14 to A-19,
  A-22) and is left for the operator to accept, as is this story.

What the real runs showed that the unit tests had not:
- The judge reads standard output before standard error, so the naming line
  follows the verb's output in an expected block.
- The judge discards bashy hint lines, so the unread-mail announcement can
  only be asserted through a cited test.
- `bashy mb` and `bashy inbox` compile their adapter from source on first
  use in a fresh HOME. Two early probes downloaded the module set into a
  throwaway HOME (about 3 GB each) before the judge was given the host's
  module and build caches; with them passed through, nothing is downloaded.
- bashy's embedded conform (0.1.1) predates sprint 742's lint rules, so
  `bashy conform spec check` does not yet apply the gotest-form rule.

Known issues recorded in the surface: KI-1 (the line a live terminal session
prints), KI-2 (harness-process naming is test-pinned only), KI-3 (the hint
names the sender by instance address, not label).

Follow-up, same day: bashy `144bbfd8` adds the remaining evidence. `mutate`:
strength 46/46 (one output and one exit mutant per assertion, all killed,
1649 s). `alone`: a lone copy outside the checkout cloned the pinned commit,
built and passed 23 of 23 (51 s). Not done: the rebuild test (a builder that
has not seen the source rebuilds the surface from the spec), which the lift
runbook lists as step 12.
