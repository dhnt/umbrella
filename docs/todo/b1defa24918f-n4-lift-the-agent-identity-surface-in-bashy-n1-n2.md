---
id: b1defa24918f
kind: task
title: N4 Lift the agent-identity surface in bashy; N1, N2 and N3 are accepted on its cert
seq: 863
status: todo
created: 2026-11-28T10:20:19.522712Z
sprint: 744
sprint_id: 934a9e36-eb10-5022-83ec-d60e76999c11
sprint_title: Unique session ids for ad hoc bashy <tool> launches
---

Operator, 11-28: accept N1 and N2 when the shapeware specs are met; start using the shapeware spec process for this work.
Today no lifted surface covers this behaviour (bashy has one surface, shapeware/shape), so nothing can be met yet. Lift a narrow surface, shapeware/agent-identity, in bashy with kb runbook shapeware-lift-app:
- features (verified, each with acceptance lines): adhoc-session-id (N1), native-session-identity (N2), front-door-identity-step with its refusal (N3);
- CONTRACT.md assertions a command line can show in a fresh HOME with the harness markers set by the judge: bashy <tool> --dry-run and --help name the per-launch id; with a vendor session id set, bashy mb and bashy inbox run with no --as, the session is told its name once, the name is <tool>-<8 hex> and is the same on the next command and different for another session id; a claim taken with no declared name is held by that name; with no session id and no harness process, a coordination verb is refused with the guidance text and a non-coordination verb runs; BASHY_ADHOC_IDENTITY=off and a self-chosen BASHY_AGENT are left alone; a caller with no harness marker is untouched;
- dag.md lifecycle and gate targets (check, cert, mutate, alone) as in shapeware/shape.
Acceptance of N1, N2, N3: conform spec check clean, and cert passes on the gate host at the delivered bashy head; the story records the PASS lines.
Known limits, tracked as sprint 742 M6 a297eccb: the live terminal session id and the harness-process key cannot be asserted by the contract, and the yoke and nested-module go tests that pin them cannot be cited yet. The contract covers what a command line shows; the rest stays on the unit tests named in N1 to N3 until M6 lands.
Code inspected: bashy shapeware/shape (SKILL.md, CONTRACT.md, dag.md, judge.sh, features.yaml), shapeware/index.bsh; umbrella docs/shapeware-spec-v0.md 4.3a, 4.3b, 6; kb page shapeware-issue-to-spec.
