---
id: 9708bea5b1b1
kind: bug
title: 'bashy outpost adapter: ''fork/exec …/adapters/yoke/outpost: resource temporarily unavailable'' while the outpost binary itself works'
seq: 649
status: todo
priority: p2
labels:
    - adapter
created: 2026-11-23T05:52:50.682447Z
sprint: 693
---

Observed 2026-11-23 ~21:55 PST on the dev box during Sprint 693: every 'bashy outpost ssh exec <host> -- CMD' printed 'fork/exec $HOME/.cache/bashy/adapters/yoke/outpost: resource temporarily unavailable' followed by repeated 'exit status 1' lines (one per retry), while '$HOME/.local/bin/outpost ssh exec <host> -- hostname' succeeded immediately. Host had ~670 processes, ulimit -u unlimited, maxfiles 92160; several fleet workers were running. Suspects: the adapter binary's exec (EAGAIN) under process/thread pressure, or the adapter shim. Root cause before fix; record the exact errno and the adapter's spawn path. Workaround: call the installed outpost binary directly. Not gating for 693.
