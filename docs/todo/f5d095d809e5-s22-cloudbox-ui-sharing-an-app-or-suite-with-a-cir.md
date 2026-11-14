---
id: f5d095d809e5
kind: bug
title: 'S22 cloudbox UI: sharing an app or suite with a circle answers invalid_request (dialog still sends the pre-S619 body)'
seq: 271
status: done
priority: p1
labels:
    - ui
created: 2026-11-14T04:19:39.679697Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T04:48:47.462839Z
closed_by: claude-fable5.1-s630
---

Operator 2026-11-14: as the gmail account, sharing an app on lern-si with circle team2027 -> invalid_request. Root cause: the console's share dialogs (host app share, suite share) still POST the legacy audience body {app, circle}|{email}; since S619 the contract is a grant rule {app, circles[], groups[], emails[]} decoded strictly (DisallowUnknownFields), so the legacy key is rejected with 400 invalid_request. The share lists also still read the legacy row fields email/circle, so existing rows rendered with a blank audience (the 'blank audience' klatch share seen in S619 may be this). Reproduced with the API: {app, circle} -> 400, {app, circles:[team2027]} -> 201 (row deleted again). Fix: suite-store.ts builds the rule body from the chosen audience and types rows as circles/groups/emails; host-sharing-panel and suite-card render the rule (shareLabel). ui.zip rebuilt.
