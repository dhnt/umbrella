---
id: eea4f787fdba
kind: bug
title: 'S15b outpost: connect/ssh pick the attachment whose satellite hosts the target instead of attachments[0]'
seq: 270
status: done
priority: p1
labels:
    - outpost
created: 2026-11-14T04:12:59.048102Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-15T07:45:00.505051Z
closed_by: claude-fable5.1-s630
---

ROOT CAUSE 2026-11-15 (fleet user-connect probe): the satellites answer correctly (sat-blue lists [win2], sat-green lists [win1, win2] for the attachment token) but cmd/outpost/connect.go runConnect still loaded agent.json with conf.LoadClientFile (attachments[0]); only the cookie-only keep-alive and the ssh paths used attachsel.LoadFor. Fix in outpost (uncommitted, verifying on the fleet): runConnect -> attachsel.LoadFor; and attachsel now returns an error naming the satellites when they answered and none serves the host, falling back to attachments[0] only when no satellite answered (tests TestLoadForRefusesAHostNoSatelliteServes, TestLoadForFallsBackWhenNoSatelliteAnswers PASS).
