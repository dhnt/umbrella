---
id: dd91ed52ca2b
kind: test
title: 'S16 Validate cleanup + reattach: fast tests, affected e2e scenarios, lern-si member door check; bugs filed with root cause'
seq: 263
status: done
priority: p1
created: 2026-11-13T21:29:29.145463Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
closed: 2026-11-14T01:36:30.34347Z
closed_by: claude-fable5.1-s630
---

After S13-S15: cloudbox fast in-process tests (TestGrantPath etc.), affected e2e scenarios only (attach, share, admit, door), one member door call through lern-si. Every failure: todo with root cause before any fix. Note: bashy paired-host ls lists only tunnel-paired hosts (V1ListHosts under ssh:read); satellite-paired hosts show in the satellite record's hosts array. Not a defect under standalone; re-check after S10/S15.

CLEAN SEPARATION (operator 2026-11-13: 'there could be mixed records'): verify per owner and per satellite that records are not mixed. Checks: (1) for each satellite (zoo, zoo-aws, lern-si under the gmail account; alien under the novigens account) list its host rows with owner — each host appears under exactly one owner (its machine owner); the dev box is one host row under the gmail account attached to zoo AND alien, never a second row under the novigens account; (2) for each outpost, outpost satellite list shows exactly the intended attachments and no legacy profile instance remains; (3) grants/shares on each host reference only emails or circles of the host owner's members; (4) master satellite_host_index and assignments carry no rows for removed satellites or stale local outposts; (5) the two accounts' member lists are mutual and nothing else leaked (no cross-account tokens, suites, or admit rules). Needs an owner token for the novigens account in the vault (mint via console, agentic path todo). Record the before/after tables in the inventory doc.
