---
id: 80fdf675b24f
kind: feature
title: 'S6 App family: apps expose actions as conforming commands'
seq: 419
status: todo
priority: p2
labels:
    - yoke
created: 2026-11-17T18:49:46.89734Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: our apps (Klatch, the file browser, the cloudbox/satellite consoles, shaped catalog apps) have actions reachable only or first through web UIs.
Behavior: each app exposes its actions as contract-conforming commands; the web UI is a view over them and never holds a capability the commands lack (UI->CLI parity, made normative and measured). UI->CLI parity is scored in the gate.
Depends on: S0.
Verification: per-app action inventory vs command coverage scored in the gate; gaps listed by name.
