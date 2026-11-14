---
id: 74018eedce9a
kind: task
title: 'S11 Inventory per owner: satellites, hosts, droplets, instances (evidence record)'
seq: 258
status: done
priority: p1
created: 2026-11-13T21:29:27.010729Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-13T21:30:55.662989Z
closed_by: claude-fable5.1-s630
---

Read-only inventory before any cleanup. Live cloud VMs: 4 DO droplets (protected site, zoo, ivy, alien) + 2 Lightsail (lern-si, zoo-aws); no orphans. Master satellite rows under the operator account: 19, of which 3 live (lern-si, zoo, zoo-aws) and 16 stale (dead endpoints or none; 2 still 'enabled' with dead endpoints and stale host assignments). Outposts dev box + both Windows test hosts legacy-paired to zoo; zoo-aws and lern-si carry outpost-profile instances. Record: dhnt-docs docs/sprint-630-cleanup-inventory.md
