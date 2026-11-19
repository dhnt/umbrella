---
id: 18c955ac1146
kind: enhancement
title: F4 bashy jq supports --arg, --argjson, -s, -R and inputs
seq: 463
status: wontfix
priority: p2
labels:
    - jq
    - yoke
    - superseded
created: 2026-11-18T18:32:34.328216Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
closed: 2026-11-19T14:02:26.53848Z
---

Problem: bashy's jq (yoke/cmds/jq, pure-Go gojq) accepts only -c -e -n -r; '--arg' fails ('jq: unknown flag: --arg') and 'inputs' is a compile error ('input(s)/0 is not allowed'). Sprint 655's checker had to pass values through env.X and count values in shell. These are the most common jq forms in agent scripts.
Behavior: support --arg NAME VALUE, --argjson NAME JSON, -s/--slurp, -R/--raw-input and the input/inputs builtins with GNU jq semantics (gojq already implements them). Anything still unsupported keeps failing with exit 2.
Depends on: none.
Verification: per-form tests matching GNU jq output; examples/command-check simplified to use them and its test.sh still PASS; existing jq tests green.

## Superseded by Sprint 669

Operator-authorized consolidation, 2026-11-19. Replacement sprint UUID: 2f346ac0-20ce-5354-88b9-b74ef3f567a9. Deferred outside the replacement MVP; historical requirement retained, no new deferred story created. General jq feature expansion is not an MVP dependency; existing checker can be reused without it.

This record is retired as wontfix by supersession, not accepted as delivered. Original scope and evidence are preserved above. Existing private disclosure, release and filing restrictions remain in force. The replacement master plan holds the complete triage; no product coding was performed in this planning session.
