---
id: 6210caba276e
kind: feature
title: Expose paired-host reachability through the master CLI and host listing
seq: 598
status: done
priority: p1
created: 2026-11-21T11:16:39.414412Z
assignee: codex-gpt5.6-sol
sprint: 698
sprint_id: 3da6b228-61d4-5302-931a-565e4862813b
sprint_title: 'Outpost reliability follow-up: master reachability parity and disk pressure'
closed: 2026-11-26T05:00:14.104056Z
closed_by: codex-gpt6.2-sol
---

Follow-up to daa99f1f. Direct master status for a paired host and the master indexed host listing must expose the same owner-scoped state, last observation, and alert projection as the paired satellite. Use authenticated owner boundaries, stale/unknown semantics and one-way CLI-to-existing-UI parity, including transferred/revoked pairings. Operator approved the current release with satellite verification while this remains separate.

## Design, 2026-11-21

Add the owner-scoped reachability status GET to the master. Use the
same status response and token checks as the satellite, and keep
mutating alert commands on the owning satellite. The same projection
feeds the existing master host UI. The master reads a reported alert
state and does not evaluate transitions or send mail. When a host is
paired to more than one satellite, the caller can select the satellite
explicitly. An unqualified ambiguous lookup returns a conflict.

Use the existing authenticated host reports for the bounded, optional
status projection. Include only eligible inbound pairings. Validate the
projection and tie it to the current owner and pairing. Stop serving a
projection after revocation, transfer, or its freshness window. Older
reports without a projection produce unknown, and stale reports produce
unknown without showing an old alert ID. Accounts that only share or
administer the satellite do not see the host owner's alert fields. The
existing short liveness window still drives the dot.

Cover owner and token checks, duplicate-name and multi-satellite
selection, report and CLI/UI equivalence, missing and stale projections,
and transfer and revocation before the next report. A later candidate
and deployment are separate from v0.18.81.


### 2026-11-21 implementation acceptance

Use a build and targeted master/satellite unit tests for implementation closure. Browser/e2e, full role suites, release gates, judge or LLM grading are deferred to the epic or milestone integration gate.

Write and run fast unit tests during implementation. The operator calls the
integration gate only when an epic or one of its milestones is complete.

## Sprint 698 implementation evidence

The targeted master and satellite builds and fixtures passed on the merged hosted candidate. An authenticated satellite report populated the same owner-scoped projection on the master status endpoint and the indexed host list. The fixtures covered expired reports, explicit eligibility, token scopes, revoked membership, pairing transfer, and an explicit selector for ambiguous lookups.

Yoke `ada7e452af17` added the satellite selector and retained the optional reachability projection in the host listing. The published Bashy executable and standalone adapter passed loopback requests for the selector and listing. Hosted source and raw fixture evidence are recorded in the sprint thread.
