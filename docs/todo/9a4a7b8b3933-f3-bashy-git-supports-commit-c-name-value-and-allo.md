---
id: 9a4a7b8b3933
kind: bug
title: F3 bashy git supports commit -c NAME=VALUE and --allow-empty
seq: 462
status: todo
priority: p2
labels:
    - git
    - yoke
created: 2026-11-18T18:32:34.177938Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
---

Problem: 'git -c user.name=t -c user.email=t@example.invalid commit -q --allow-empty -m init' under bashy fails: 'is not served by the native git engine; retry with --external=true ... not supported by the pure-Go implementation' (yoke/git). Sprint 655 fell back to the host git. Agents and shaping recipes (bashy/examples/shaping/hello-world/register.sh uses 'git -c user.name=... commit') rely on these forms.
Behavior: the native engine serves top-level '-c NAME=VALUE' (at least user.name/user.email) and 'commit --allow-empty', or refuses with exit 2 naming the unsupported option. Root cause first: confirm which part (global -c parsing or --allow-empty) is unsupported.
Depends on: none.
Verification: the exact command above succeeds in a fresh repo under bashy; Hello World register.sh runs without host git; existing yoke git tests green.
