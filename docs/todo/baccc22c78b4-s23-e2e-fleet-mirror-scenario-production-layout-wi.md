---
id: baccc22c78b4
kind: test
title: 'S23 e2e: fleet-mirror scenario (production layout with fake accounts/hosts) in the multisat harness, run on a temporary AWS instance, held up for manual verification'
seq: 273
status: assigned
priority: p1
labels:
    - e2e
created: 2026-11-14T11:12:39.658128Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

2026-11-15: new suite user-connect (operator + superadmin, 2 satellites, 2 outposts) GREEN with the outpost fix: probe shows sat-blue [win2], sat-green [win1, win2]; 'connect from win2 reaches win1 through sat-green (not sat-blue)' PASS. Root cause was runConnect loading attachments[0] (conf.LoadClientFile) instead of attachsel.LoadFor; fixed in outpost main (S15b). bashy yoke pin bumped to d388f95d (c37f4819): 'satellite rm' present. Security bug reported by Sprint 641 (yoke webconsole operator predicate, fix yoke b7fe0439) lands via the rc.34 yoke pin; cloudbox/outpost unaffected. Operator: clean full release, all pins to main/master.
