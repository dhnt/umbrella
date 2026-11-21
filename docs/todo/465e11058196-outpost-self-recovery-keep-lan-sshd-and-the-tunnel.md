---
id: 465e11058196
kind: feature
title: 'Outpost self-recovery: keep LAN sshd and the tunnel up and report why they dropped'
seq: 389
status: done
priority: p1
created: 2026-11-17T11:51:11.42001Z
assignee: codex-gpt6.2-sol
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
closed: 2026-11-21T10:17:10.095463Z
closed_by: codex-gpt6.2-sol
---

Follows the P0 root cause. Outpost should notice when its LAN sshd listener, mesh link or cloud tunnel drops and restore it with backoff, and record the reason (sleep, network change, upgrade re-exec, crash) in a local log cloudbox can read, so an outage explains itself. An always-on host should be able to declare that, so a sleep policy that would defeat it is reported at pairing or doctor time (bashy outpost doctor --json). Acceptance: killing the sshd listener or bouncing the network adapter recovers without operator action, and the recorded reason matches.

## Design, 2026-11-21

Keep each existing owner of recovery. The LAN SSH service reconciler already detects `ServeLANSSH` exit, cycles the in-process capability, and keeps firewall-only degradation published. Preserve that behavior and add capped, jittered retry timing for failed LAN SSH binds, clearing it after a successful bind or changed declaration. Log the observed unexpected listener exit and successful bind using stable reason fields. Keep operator disable and daemon cancellation quiet. Verify recovery with a real loopback listener that is closed unexpectedly and then reopens through reconciliation. Use a deliberately occupied port to verify backoff without modifying any host adapter.

Mesh rendezvous already redials disconnected known peers with per-peer backoff. Preserve those retries and record transitions at the existing sweep owner, distinguishing first discovery from loss of a previously established connection. The tunnel already backs off and reconstructs an exited FRP service. Record early exits and rebuild failures there and use the existing proxy status to identify observable tunnel down/up transitions, including reconnects inside FRP where the status exposes them. Preserve the current reconnect owners and keep client authorization separate from host health.

Use the existing timestamped local Outpost logs, with stable `component`, `state` and `reason` fields and bounded/safe metadata. Reasons should describe direct evidence: listener exit or bind failure, mesh disconnect/redial, transport loss, explicit upgrade re-exec, and client-side elevation expiry. Attribute network change, sleep or process crash only when the platform reports evidence; otherwise record the observed failure with cause unknown. On November 21 the public peer-ticket route returned an explicit expired-elevation 401 and the noninteractive relay could not re-elevate. Record `client_elevation_expired` locally at the Outpost client edge when the wire response indicates expiry, retaining existing fallback and credential handling. A generic 401 or plain no-TTY failure is insufficient to diagnose expiry on its own. Log no cookies, credentials or raw authorization response bodies.

Reuse platform sleep readback in `outpost doctor`, offer an explicit `--always-on` expectation and a `--json` report reflecting the same diagnostic checks. Report known sleep-enabled policy as a warning for that expectation and keep unknown/readback failure distinct. Read-only diagnostic. Use targeted tests on the development host. Any Windows-native or multi-host validation needs the native Windows lane and a disposable fixture. The historical issue's initiating cause remains unresolved and changes to the actual Windows host's retention or power policy await the operator.

### Approved additions

Keep a private `recovery.json` in the existing Outpost cache. It retains at most 64 recent state transitions and at most 16 KiB, discarding oldest records first. Readers use `outpost doctor --json` to get the same checks as the human view and a structured `recovery` array with UTC time, component, state and reason. A later Cloudbox story can forward daemon-side records over the public heartbeat protocol. Client credential events stay local. Cover the killed-listener and network-bounce cases with fixtures that demonstrate both unattended recovery and matching reasons. No live adapter bounce is needed when fixture evidence is sufficient.

Development build finding: the first targeted dev-box build failed in `cmd/outpost/service.go` before test execution because `service status --verbose` still called the old zero-argument `runDoctor`. Comparing the baseline and candidate signatures isolated a product integration error introduced by the doctor output refactor. Keep the verbose entry point wired to the same plain report.

## Verification

Outpost candidate `9f81132` on `s652/465e1105`. Standalone dependencies (`GOWORK=off`) and the shipping `fb_archives` tag were used on the development host. Targeted packages passed for the Outpost CLI, agent tunnel, mesh, peer ticket exchange, post-install readback, journal, supervisor and service reconciler.

- `TestSSHDRecoversFromKilledListener` closes a real loopback SSH listener and observes the existing service reconciler reopen it without operator action. It waits for a new SSH banner and checks the recorded `lan_sshd` down and recovered events both carry `listener_exit`.
- `TestTunnelRecoversFromNetworkBounce` interrupts the TCP relay carrying the live FRP connection while the client and server run, asserts the origin is unreachable, restores the path, and verifies traffic resumes through FRP automatically. The tunnel down and recovered records both carry `transport_lost`.
- Additional targeted tests covered occupied-port backoff, mesh discovery versus reconnect, the explicit expired-elevation marker versus generic authorization errors, power readback, doctor JSON, service publication, and the 64-event/16-KiB journal cap.

Fixture evidence sufficed. No Windows-native or multi-host run, host adapter or policy change, or Cloudbox deployment was performed.

### Merge gates

The final source tree `4457ae8888357e032ede3ce21c45c5467a5cc92e` passed
`GOWORK=off go test -short -tags fb_archives` on the WSL gate host in
the official rc.39 image
(`sha256:c7e19f271086e3a20fd7ade71ad41afba36700cfba3c90e064117e5c0359e3a2`).
Lane 2 ran attached and selected every package except the explicitly
excluded TTY-dependent `internal/agent/shell`. All 60 packages with tests
passed and eight had no test files. Go reused unaffected passing results
from the same lane. The gate log SHA-256 is
`71630a77ec2099db5cd3951e42021b9a76183b0fdec2ac18e58758f70dbc156f`.

The pre-existing registration guard test issue is tracked separately in
`9e8d04ff97f4`.

Dev-box cross-builds of `./cmd/outpost` from final commit `159a4f9`
passed with Go 1.27.2, `GOWORK=off`, `CGO_ENABLED=0` and
`fb_archives`. The recorded VCS revision matched the final commit.
Artifact SHA-256 values were
`d513ccc2d0552f94fb4b2f28108ce87882f032af3cbcf472a3cdd285871924a8`
for Windows amd64 and
`1098804046649d6fcdcf45aff76d4d1752b55125acc72891ab8b84c3c80b91c7`
for Darwin arm64. Outpost main was fast-forwarded and pushed to `159a4f9`.
