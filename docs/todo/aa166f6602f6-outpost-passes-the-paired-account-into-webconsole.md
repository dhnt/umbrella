---
id: aa166f6602f6
kind: bug
title: Outpost passes the paired account into webconsole Options.Operators so remote admin through the tunnel is recognized (follow-up to yoke b7fe0439)
seq: 367
status: todo
priority: p2
created: 2026-11-15T17:32:15.401266Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
---

After d871ac00b808 a cloud caller is an operator only when Options.Operators names their vouched identity; no embedder passes Operators yet, so remote administration through the outpost tunnel falls back to the on-host path (fails safe). Fix: outpost passes the paired account into Options.Operators. Done when an outpost unit test proves the paired owner is an operator through the tunnel and a sharee is not.
