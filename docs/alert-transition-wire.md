# Alert transitions and delivery keys

Sprint 652 owns this contract. Host reachability is its first producer.
Disk pressure and Sprint 688 spend watermarks can implement the same contract
with their existing state and notification channels.

## Producer interface

A producer supplies a canonical principal, condition kind, durable subject ID,
categorical state, and observation time. Scope the subject to its pairing or
account generation when a transfer or replacement invalidates earlier state.
Use bounded reason codes and typed details. Credentials, raw errors and endpoint
addresses stay out of observations and notices.

```text
Observe(principal, condition_kind, subject_id, state, observed_at, reason)
  -> current_state, transition_id
Deliver(transition_id, destination, notice)
  -> delivery_result
```

Repeated or older observations of a state reuse the recorded state. An atomic
change of actionable state assigns a new opaque transition ID. Recovery is a
transition to a confirmed healthy state. It follows an outage delivery attempt
even if its receipt is missing or uncertain. Unknown and grace-period observations
keep an open incident until there is evidence of recovery or another actionable
state. An acknowledgement refers to one alert ID. A timed mute holds the current
adverse notice and suppresses recovery notices during the mute. On expiry only
an unsent notice for the still-active adverse state may be delivered.

Derive the delivery key from the transition ID and stable destination ID. Both
form an ordered tuple. All workers and delivery retries use the same tuple;
delivery history at a destination must deduplicate it. A transport without
idempotent delivery may make one durably claimed attempt and expose ambiguous
delivery. Automatic replay in that case could duplicate an accepted notice.
Keep current state and bounded delivery records per subject. An alert evaluated
while delivery is disabled is never replayed merely because delivery was enabled.

## Host reachability

Outpost sends optional `reachability` on the existing authenticated
`POST /api/v1/host/heartbeat`. Fields `lan_ssh` and `apps` accept `up`,
`down`, `disabled`, and `unknown`. `power` accepts `awake` or `sleeping`
and requires `power_observed_at` (UTC RFC 3339). Old or absent fields mean
unknown. Modest clock skew up to 30 seconds ahead of the server is clamped to
receipt time for freshness. Source timestamps still order the observations. The service independently observes tunnel presence. Heartbeat
acceptance and tunnel presence are separate evidence. The latest positive
observation is `last_seen_at`. `tunnel_seen_at` records the last positive tunnel
observation. The existing online dot uses a two-minute tunnel window.
An explicit sleep event is informational. Prolonged tunnel absence can produce
one offline notice and one recovery for the same interruption. The offline
grace period starts at the latest of monitoring start, evaluator start, and the
last tunnel observation.

Read `GET /api/v1/hosts/{host}/reachability` with an account token scoped
for host reads. Write the same path with PATCH and an account token scoped
for host writes. Authorization is scoped to the paired owner. PATCH takes one
of `ack_alert_id`, `mute_seconds` (zero clears), or `threshold_seconds`
(zero disables alerting, minus one resets a host to the owner policy).
`/api/v1/hosts/~all/reachability` reads and sets the owner policy for all
inbound paired hosts that have no override. Bashy uses `@all` for that
selector. A newer host inherits the policy when it pairs. An already acknowledged ID is harmless. A stale ID
cannot acknowledge its replacement. The default timeout is 900 seconds.

Both methods return the same status object with `host`, `state`
(`unknown`, `pending`, `healthy`, `offline`, `degraded` or `asleep`),
`state_since`, `last_seen_at`, `tunnel_seen_at`, `reason`, `threshold_seconds`,
`monitoring`, `alert_id`, `acknowledged`, `delivery`, and `mute_until`. Timestamps and
alert details can be omitted when unknown or inapplicable. An existing web
host state display consumes the same status projection. The management surface
is `bashy paired-host reachability {status,ack,mute,threshold}`.

Use the Cloudbox origin where the host is paired. For an attached host,
select its server with the existing CLI endpoint and account options.

### Master reachability reads

The master accepts the same owner-scoped status GET for hosts indexed from
satellite reports. Use `?satellite=SATELLITE_ID` to select a reporting
satellite. Omitting the selector yields a conflict when the caller owns
multiple current pairings with the same host name. Bashy passes the selector
from `paired-host reachability status HOST --satellite SATELLITE_ID`.

The master checks the current owner and pairing before returning the
projection. Missing or older projections produce unknown state. Stale
projections keep their observation timestamps and omit alert details. The
existing host list uses the same projection and
`bashy paired-host ls --json` preserves it. The owning satellite handles
alert evaluation, delivery and policy changes.

## Paired-host disk pressure

Outpost can include a `disk` observation in the authenticated host
heartbeat. Each observation supplies `observed_at` and up to 32
`volumes`. A volume reports a stable `id`, `used_bytes`, `total_bytes`
and up to three `growers`. Each grower supplies a fixed directory label
and a positive `delta_bytes` from consecutive complete measurements.

The optional `display_name` identifies the volume for the owner. For
example, a Windows volume can appear as `C:` and WSL roots can appear as
`WSL Fixture-A /` and `WSL Fixture-B /`. Distinct filesystems and
distros retain distinct IDs when their growth labels match. Notices
include the recorded label, the stable ID and the fastest observed
growers. Raw measurement paths stay local to Outpost.

The owning satellite evaluates 80%, 90% and 95% used-space thresholds
per volume and uses the transition delivery contract above. The owner
reads the observations and active alerts at
`GET /api/v1/hosts/{host}/disk-pressure` with an account token scoped for
host reads. In Bashy use `paired-host reachability disk-pressure HOST`
with the owning satellite's endpoint and account options.
