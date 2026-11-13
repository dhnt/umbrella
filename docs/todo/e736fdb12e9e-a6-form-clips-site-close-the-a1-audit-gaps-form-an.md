---
id: e736fdb12e9e
kind: bug
title: 'A6 form, clips, site: close the A1 audit gaps (form answer/join help drift and any missing rows)'
seq: 241
status: done
priority: p2
labels:
    - parity
    - app
created: 2026-11-13T17:39:23.66674Z
weave: 72
assignee: agy-gemini3.8-flash
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:42:59.418199Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md. form, clips and site already have action verbs; this story closes whatever A1 finds missing for them. Known so far: examples/desk/form/form.bsh --help advertises append but not join while the case statement does the reverse (help drift); bashy/docs/ui-cli-parity.md:172,193 still lists the form respondent answer verb as proposed (verify whether reply/answer closes it). Add any missing verb the way A2 does (--json, --dry-run on writes, page-equivalent denied result), fix the help text, and update the rows. Targeted unit tests only. Done when the three apps have no open gap rows and their help matches their verbs. If A1 finds nothing beyond the help drift, fold this into A1 and close it with that evidence.
