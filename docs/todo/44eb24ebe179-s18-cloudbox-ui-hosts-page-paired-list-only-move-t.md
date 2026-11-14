---
id: 44eb24ebe179
kind: bug
title: 'S18 cloudbox UI: Hosts page = paired list only; move the per-satellite attached-hosts block to the Satellites page'
seq: 266
status: done
priority: p2
labels:
    - ui
created: 2026-11-14T02:45:11.542302Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T03:16:38.501712Z
closed_by: claude-fable5.1-s630
---

Operator 2026-11-14: 'minor change if data are correct: just move the block of hosts with satellites to the satellites page'. Scope: (1) Hosts page shows only the account's pair-once identity rows (one per machine) plus the shared-with-me section; drop the 'Satellite hosts' section there; render a pair-once row as 'paired once' with no cluster strip in master mode. (2) Satellites page: under each owned/admitted satellite list the hosts attached to it (from the same satellite host index rows: name, owner, online, last report). Data is correct already (identity rows + attachments); this is presentation. Ships with S17 in the next cloudbox release (ui.zip rebuild required).
