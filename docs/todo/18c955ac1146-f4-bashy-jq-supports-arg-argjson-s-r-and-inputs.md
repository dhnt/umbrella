---
id: 18c955ac1146
kind: enhancement
title: F4 bashy jq supports --arg, --argjson, -s, -R and inputs
seq: 463
status: todo
priority: p2
labels:
    - jq
    - yoke
created: 2026-11-18T18:32:34.328216Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
---

Problem: bashy's jq (yoke/cmds/jq, pure-Go gojq) accepts only -c -e -n -r; '--arg' fails ('jq: unknown flag: --arg') and 'inputs' is a compile error ('input(s)/0 is not allowed'). Sprint 655's checker had to pass values through env.X and count values in shell. These are the most common jq forms in agent scripts.
Behavior: support --arg NAME VALUE, --argjson NAME JSON, -s/--slurp, -R/--raw-input and the input/inputs builtins with GNU jq semantics (gojq already implements them). Anything still unsupported keeps failing with exit 2.
Depends on: none.
Verification: per-form tests matching GNU jq output; examples/command-check simplified to use them and its test.sh still PASS; existing jq tests green.
