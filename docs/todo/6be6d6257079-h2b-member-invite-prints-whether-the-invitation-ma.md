---
id: 6be6d6257079
kind: enhancement
title: H2b member invite prints whether the invitation mail went (sent / not sent / skipped)
seq: 736
status: done
priority: p1
labels:
    - cli
    - members
created: 2026-11-25T05:03:29.413553Z
assignee: codex-gpt6.2-sol
sprint: 710
sprint_id: 063b46d6-77e0-5d5b-8dc0-2fd08f8234a2
sprint_title: 'Owner sharing: apps and suites to circles and members, public apps, invites that arrive'
closed: 2026-11-25T05:54:00.142953Z
closed_by: claude-opus5.5
---

Sprint 710 H2b (CLI half of cloudbox e22d0e55, which is approved: cloudbox 1a2cd47). Cloudbox POST /api/v1/members now answers 201 (new) or 200 (existing pending, re-invited) with body {member, resent, email_sent, email_status: sent|not_sent|skipped, email_error?, invitation?} and header X-Invitation-Email. An already-active member gets 200, email_status skipped, no invitation.

Code inspected: yoke/pkg/fleet/member_cmd.go:137-147 (invite -> write helper :59-81) prints only the member row and ignores delivery.

Do: after the member line, print one line: 'invitation mail sent', 're-sent invitation mail', 'invitation mail NOT sent: <email_error>', or 'already a member; no mail'. Use exit 0 for all of these (the call succeeded). --json passes the body through unchanged. Mirror the new response fields in yoke/pkg/fleet/cloudboxfake (POST members: pending re-invite returns 200 with email_status). Tests: member_cmd tests against the fake for new / re-invite / active / not configured. Run go test for pkg/fleet only (GOWORK=off), in the foreground. No ssh, no e2e. One yoke commit with Sprint/Story/Story-ID/Agent trailers; the conductor bumps the consumer pins.
