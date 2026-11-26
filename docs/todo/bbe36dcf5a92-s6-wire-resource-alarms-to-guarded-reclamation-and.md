---
id: bbe36dcf5a92
kind: feature
title: S6 Wire resource alarms to guarded reclamation and admission
seq: 409
status: done
priority: p1
created: 2026-11-17T18:00:05.165828Z
assignee: agy-gemini4-carbon-s654
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
closed: 2026-11-26T21:23:17.742279Z
closed_by: agy-gemini4-carbon-s654
---

Depends on S1, S4 and S5. Extend watcher/admission/prune; local decisions and bounded alert journal independent of OTel backend. Configurable disk 85/95 percent or 20/10 GiB, memory 85/95 percent, CPU 85/95 percent sustained five minutes. Account host/VM filesystems, inode exhaustion and rebuild reserve. Cleanup only inactive reconstructible artifacts; queue/throttle managed work and unload idle models. Acceptance: pressure/recovery tests preserve protected data and leases; unsatisfied floor blocks growth and alarms.
