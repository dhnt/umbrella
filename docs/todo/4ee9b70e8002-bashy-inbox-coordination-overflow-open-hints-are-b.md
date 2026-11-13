---
id: 4ee9b70e8002
kind: task
title: 'bashy inbox: coordination-overflow open hints are broken (''inbox --id X --peek'' is an unknown flag; ''inbox read --as NAME role:conductor:...'' hung >120s)'
seq: 224
status: todo
created: 2026-11-13T13:34:08.616576Z
---

Seen 2026-11-13 in Sprint 631 manager session. The overflow block for bus:411137 / role:conductor:631:411137 printed open="bashy inbox --as NAME --id bus:411137 --peek" (fails: unknown flag --id) and open="bashy inbox read --as NAME role:conductor:631:411137" (no output, ran past 120s, killed). Workaround: the message body was visible on the sprint thread (bashy sprint show). Expected: the hint names a working command that prints the single record and returns.

Working read for mb records: `bashy mb show <N>` (e.g. mb:13722). The hint should print that.
