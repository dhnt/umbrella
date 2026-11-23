---
id: 5771d343ce2a
kind: bug
title: weave start --resume spins at >100% CPU without spawning the worker
seq: 669
status: todo
priority: p2
labels:
    - weave
created: 2026-11-23T13:33:24.324881Z
---

Observed during Sprint 696 when resuming stopped run #170 (muse-wonder): both 'bashy weave start --resume --run 170 --tool muse-wonder </dev/null' and '--pty never' spun at ~111% CPU in R+ state inside the yoke weave adapter for >6m without spawning the muse subprocess or transitioning run #170 out of state=failed.
