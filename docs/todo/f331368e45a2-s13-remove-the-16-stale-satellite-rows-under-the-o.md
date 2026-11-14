---
id: f331368e45a2
kind: chore
title: S13 Remove the 16 stale satellite rows under the operator account
seq: 260
status: done
priority: p1
created: 2026-11-13T21:29:27.738847Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-13T22:13:10.372455Z
closed_by: claude-fable5.1-s630
---

After S12 is live. Candidates (ids in the inventory record): 10 lost + 6 enabled-without-live-endpoint; never the 3 live ones (lern-si, zoo sat-d8c80c18f5ef, zoo-aws). Dry-run first, then one bashy satellite rm per id, then satellite list shows exactly 3 rows. Per owner: only the operator account; other owners' rows are not touched.
