---
id: e12a4244b8b0
kind: bug
title: 'outpost adapter re-enters itself until fork fails (EAGAIN): bashy outpost/peer/sphere unusable on the dev box and the gate host since the 2026-11-23 adapter rebuild'
seq: 680
status: todo
priority: p0
labels:
    - outpost
    - adapter
created: 2026-11-23T18:21:02.779778Z
---

Symptom (dev box, 2026-11-23 ~18:00 UTC): any 'bashy outpost ...' or 'bashy peer ...' prints 'fork/exec ~/.cache/bashy/adapters/yoke/outpost: resource temporarily unavailable' followed by ~60 stacked 'exit status 1' lines: the adapter invokes itself recursively until fork returns EAGAIN. The real service binary (outpost supervisord/start/connect under ~/.local/bin) keeps running; direct ssh to the gate host works. Same symptom reported independently on the gate host by the Sprint 697 A3b worker at 17:55 UTC ('bashy outpost adapter recursively re-entered and exhausted process slots'). Timing: the outpost adapter binary was rebuilt 2026-11-23 09:50 PST, right after the baseline pin bumps (bashy 847f7032, yoke 4bafb600); earlier adapters date from 11-21/11-22. Dev-box process count is normal (590 of 4000), so the limit hit is the recursion, not host load. Hypothesis (unverified): the standalone outpost adapter resolves its self path to the bashy launcher or to itself instead of the outpost service executable; same family as the closed 677 bug 22d478f94d2a (BASHY_SELF reaching child binaries) and the yoke pkg/chat shim-target fix ba95983e. ROOT CAUSE BEFORE FIX: bisect the adapter source between the 11-22 and 11-23 builds; reproduce with 'bashy outpost peers status'. Blocks any sprint using the outpost route (697 workers, 682 gate run). Filed by conductor claude-fable5.1; unowned.
