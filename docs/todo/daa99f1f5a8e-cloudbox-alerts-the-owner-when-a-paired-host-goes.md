---
id: daa99f1f5a8e
kind: feature
title: Cloudbox alerts the owner when a paired host goes offline or unreachable
seq: 388
status: assigned
priority: p0
created: 2026-11-17T11:51:11.253915Z
assignee: codex-gpt6.2-sol
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
closed_by: codex-gpt6.2-sol
---

A host the owner marks always-on (or any paired host, by owner policy) that misses heartbeats or tunnel presence for longer than a threshold raises an alert to the owner through the existing notification channels, with one bashy CLI path (status, ack, mute, threshold) and no web-only control. It must distinguish offline (no tunnel), degraded (tunnel up, LAN sshd or apps down) and asleep (reported power state), say when the host was last seen, and clear itself on recovery. No alert storms: one alert per state change, deduplicated per host. Acceptance: a host stopped for longer than the threshold produces exactly one alert and one recovery notice, and bashy reports the same state the UI shows.

## Approved public contract, 2026-11-21

Use the existing authenticated `POST /api/v1/host/heartbeat` for daemon liveness and
additive optional health fields. Keep independent times for accepted heartbeats and
positively observed tunnel presence. A heartbeat can prove that the daemon is alive when
the tunnel is down. A successful request through the tunnel can prove the tunnel is up
when heartbeat delivery is late. Use a tunnel presence signal independent of the app
health check so a failed app check can be reported as degraded. Report a server-observed
`last_seen_at` from the latest positive heartbeat or tunnel observation, or no value if
neither has ever been seen.

Report separate `up`, `down`, `disabled` and `unknown` values for LAN SSH and configured
app health. Add an optional explicit `sleeping` or `awake` power observation with its
observation time. Accept only fresh, ordered observations for state decisions. Missing
fields in old clients mean unknown and intentionally disabled checks are excluded. An
enabled sleep policy and a missing heartbeat cannot establish sleep. No optional fields
are required for pairing or for existing heartbeats.

Start monitoring when the owner enables always-on for a host or enables a policy for all
paired hosts. Propose 15 minutes as the default threshold because the standard heartbeat
interval is 5 minutes. Start the offline grace window at the latest of monitoring
start, evaluator start, and the most recent tunnel observation. Show a fresh,
explicit sleep observation as informational `asleep` until a newer wake observation
or expiry. Report `offline` when tunnel absence crosses the threshold and `degraded`
when the tunnel is present and a required service is observed down for the threshold. Return to
healthy on fresh positive evidence for the checks that caused the incident. Incomplete
or stale evidence can show unknown without closing an active incident. A daemon-side
allowlisted reason can explain a transition in the status response. Client authorization
events such as `client_elevation_expired` stay local.

Use the paired-owner status response for the Bashy status, ack, timed mute and
threshold commands. The existing web host indicators read the same state. Sprint 652
defines the [alert transition and delivery contract](../alert-transition-wire.md) for
reachability, disk pressure and Sprint 688 watermarks. Sprint 688 can adopt it later.

Acceptance uses a controlled clock and a paired host fixture. Stop observations past
threshold, repeat and race evaluations, restart the evaluator, then restore the host and
verify exactly one outage and one recovery. Cover tunnel down with fresh heartbeat,
tunnel up with an explicit service failure, positive sleep and wake, old-client
omissions, stale evidence, ack/mute expiry, and authorization boundaries. Compare Bashy
and web JSON-equivalent state and effects from the same test fixtures. Coordinate the
shared transition design with S688 on its existing story. Cloudbox deployment requires
operator approval.

## Verification

The first Linux fixture observed one delivered notice while the wire status
still returned `attempted`. The corrected candidate reports `sent` after the
delivery receipt. The standalone and satellite fixture suites on the official
Linux image passed. Concurrent evaluations and a new evaluator over the same
observations produced one outage notice and one recovery. Tests also checked
owner and scope isolation, owner policy inheritance, idempotent acknowledgement,
mute expiry, degraded and reported-asleep evidence, and the same state in Bashy
JSON and the existing host display.

The Bashy command group passed its authenticated HTTP fixture, and the rebuilt
Bashy executable exercised status, acknowledgement, mute and threshold against
the same wire. Outpost heartbeat tests passed, including immediate suspend/resume
observations, and the heartbeat package compiled for Linux and Windows. Positive
native suspend/resume observations are currently sourced from Linux logind.
Other platforms omit power when there is no observation. The existing web bundle built.

For an email channel without transport idempotency, a delivery that cannot be
confirmed is reported as attempted or uncertain. The service does not replay
that transition automatically. The public wire and source candidates are ready
for review. Deployment requires operator approval.

## Review corrections

The reviewer found that suspend could emit both a sleep and an offline notice,
startup could treat the service's own downtime as host downtime, and an
uncertain email receipt could suppress recovery. The displayed online dot also
used the longer alert threshold. Power without a platform event source must be
unknown, and host-bound credentials and ineligible host rows must use the same
authorization and visibility rules across the CLI and the existing web display.
Regression fixtures will cover those cases, including power clock skew.

The corrected candidate passed the standalone and satellite gates in the
official Linux image. The fixtures covered long sleep and its exact mail count,
evaluator downtime beyond the threshold, recovery after an uncertain or missing
receipt, mail re-enablement, bounded clock skew, host-bound credentials with
ordinary names, and the eligibility of CLI and web reachability projections.
The UI test verified that a stale tunnel clears the dot even while the alert
state remains healthy. Both server route checks passed with the rebuilt UI
bundle.

The Outpost heartbeat tests passed on Linux and the dev box, including inhibitor
completion and timeout fixtures and omission of missing power evidence. The
heartbeat package cross-compiled for Windows. Live host suspend was outside this
fixture run. Native power-event follow-ups are Windows `0f7159d16115` and macOS
`3d1b394227fa`. The conductor approved the re-review before integration.

### Non-blocking heartbeat follow-up

If a queued sleep event reaches the heartbeat worker after its send deadline,
the worker can still attempt the post with an expired context and enter one
heartbeat backoff. The follow-up is to skip the expired send before posting while
preserving the next observation and normal heartbeat cadence. The conductor
accepted this as a follow-up on the approved candidate.

## Integration evidence

The approved Outpost changes merged as `c643f40`. The merge retained the
independently landed Go 1.27.4 toolchain pin. Targeted heartbeat and CLI
fixtures passed on the exact merge commit in the official Linux image with
`GOWORK=off` and `fb_archives`. The run log SHA-256 is
`f405c4cce1b87b939884f0a0fc1b75419761ac9d4206cdfecab3871f511126bd`.
The gate lane was released.

The approved Cloudbox candidate passed the standalone and satellite tests and
was integrated into its private integration branch. The operator approved deployment separately. Yoke CLI commit `615fb3c8`
merged on Yoke main as `da4b02a4`. Bashy retained the reviewed watermark
pointer and pinned the Yoke module and source mount in `00b9edcc`. The
official Linux image passed Yoke's fleet short suite, both Bashy help
snapshots, source-pin checks, and authenticated Bashy binary fixtures for
status, acknowledgement, mute and threshold. The help goldens matched.

### 2026-11-21 release gate evidence

The exact integrated candidate passed the affected WSL release gate
(master-attach 83 s, multi-attach 103 s, desktop-journey 87 s). The Linux
image-build job then failed before checkout and smoke. Git rejected the
isolated clone's reference because the previous release checkout is a linked
worktree. The prior release reused that checkout directly. The Git common
directory is present, and neither image publication nor deployment started.
Classification: release-script venue setup. The recovery is to seed the
isolated checkout from the native Git common repository, keeping the exact
candidate and the release gates.

The native smoke, full Linux suite, Postgres gate, and master image
publication then passed for this exact tag. The satellite image built
locally, but its first registry authentication returned HTTP 403 before
any satellite image upload. A read-only replay with the configured
credential from the dev box returned HTTP 401 at GitHub and HTTP 403 at
the registry, isolating the failure from WSL, the image and the candidate.
Classification: release credential unavailable. The replacement is a
valid package-write credential from the operator. The independently
verified master image can deploy with the additive schema migration
while the satellites remain on the previous version.


### 2026-11-21 implementation acceptance

The live stop/recovery drill and interactive browser check are deferred to the epic or milestone integration gate. The exact candidate already passed the affected release, Linux and Postgres gates before this policy change. No repeats are required to close the implementation.

Write and run fast unit tests during implementation. The operator calls the
integration gate only when an epic or one of its milestones is complete.

The master reached v0.18.81 (f80ec51) and is ready. All three satellites
accepted the target and remain ready on v0.18.80. The signed updater
retrieved the new target and started its pull, but its manifest requests
returned HTTP 502 at the production bootstrap relay. An independent
authenticated read from the package registry returned the published
v0.18.81 manifest and expected digest. Classification: release venue
relay or its upstream credential, not the missing master parity route
or missing satellite image. The relay suppresses upstream error detail,
so this evidence does not distinguish authentication from transport.
Production credential or relay changes await the operator. A satellite
owner session was verified against the paired host listing. The temporary
verification token was revoked and no host was stopped.

### Operator pause and rollback, 2026-11-21

Reset all three satellite targets to v0.18.80 and rolled the master back
to v0.18.80. The migration-only override was removed after rollback.
The active deployment restored the exact prior spec. All four hubs
reported v0.18.80 (8032ef5cf3), ready and HTTP 200 health. The satellite
manifest relay failure remains unresolved. Rollout and integration work
are paused until Sprint 677 completes.
