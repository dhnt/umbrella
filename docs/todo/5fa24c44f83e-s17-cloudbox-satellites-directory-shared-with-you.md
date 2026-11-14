---
id: 5fa24c44f83e
kind: bug
title: 'S17 cloudbox: Satellites directory ''shared with you'' keyed on legacy login grants, not on admission rules'
seq: 265
status: done
priority: p1
created: 2026-11-14T02:15:37.029246Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T03:16:37.802437Z
closed_by: claude-fable5.1-s630
---

Operator 2026-11-14: as the gmail account the Satellites page lists ivy (another owner's satellite) as 'shared with you' while alien (whose admit rule now admits circle team, and whose owner is a mutual member) is missing. Root cause (code, SatellitesAPI.ListDirectory): the shared list is a JOIN on satellite_login_grants rows for the caller; those rows are legacy delegated-login grants (created when a member signed in under the pre-S619 model; a transfer clears them). Since S619 S8 the boundary is the admit rule set evaluated against mutual membership, so the directory disagrees with what sign-in would allow: a stale grant shows a satellite that may refuse the caller, and a satellite that admits the caller by rule is hidden until the caller has signed in once. Fix: shared = enabled+active satellites of other owners where the caller is a mutual member AND the admit rules admit them (same evaluator as sign-in); legacy grant rows alone no longer list a satellite. Test: rule-admitted without grant -> listed; grant without rule/mutual -> not listed; owner's own -> owned only.
