---
id: 18eec4b91f9e
kind: doc
title: R8 Reconcile public POSIX test status and certification references across submodules
seq: 20
status: todo
priority: p1
created: 2026-11-05T04:21:37.584271Z
sprint: 571
sprint_id: 74f43bab-7fb6-58b1-97e0-94c52ed5986c
sprint_title: Resolve S561 residuals and prepare POSIX certification
---

Operator-requested documentation synchronization after S561 engineering closure and creation of S571. Audit current status, claims, handoff and test-profile references in bashy, bashsharp, coreutils, bashsharp-tests and other relevant submodules. Publish exact frozen-candidate counts (B493/493; D9337 total,9270 PASS-group,4 FAIL,54 UNRESOLVED,9 INSPECT=67), distinguish classic shell certification evidence from Bash# language/public tests, link S571 ownership, remove stale freezes and unsupported certified claims. Preserve historical records with explicit dates/supersession. No product/test changes or new certification result. Validate links, consistency and public scrub; commit/push submodules before umbrella pins.

## Delivery evidence

Documentation delivered and pushed: bashy `012782cc`, bashsharp `45ae8e2`,
bashsharp-tests `ce2ab974`, coreutils `eb3f31c0`, yoke `2c22ccb6`.
Updated current results and ownership, historical-status labels, the lifted
S561 freeze, required versus optional provider scope, and certification/release
claim boundaries. No product source, test, manifest or raw result changed.
Validation: staged whitespace checks and public scrub passed in all five
repositories; 34 newly added local documentation links resolve.
The documentation work is complete; formal story acceptance remains with the
future S571 manager because the sprint is still unassigned in backlog.

S561-only cleanup: runs 17/18 were already disposed through weave with tips
preserved; no eligible weave residue remains. Removed merged sh branches
`s561-a3b-sh` and `s561/a3b-self-signal`. Retained coreutils
`s561/a3c-date-gnu-parity` and bashy `archive/s561-run-18` because they contain
unique commits. No other sprint resources were removed.
