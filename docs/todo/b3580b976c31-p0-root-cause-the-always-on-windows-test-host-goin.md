---
id: b3580b976c31
kind: bug
title: P0 Root-cause the always-on Windows test host going unreachable (2026-11-16/17)
seq: 387
status: done
priority: p0
created: 2026-11-17T11:51:11.076315Z
assignee: codex-gpt6.2-sol
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
closed: 2026-11-21T11:15:19.635454Z
closed_by: codex-gpt6.2-sol
---

Root cause first (repo rule): name it, check the venue, find what changed, record the cause; no fix before that. Evidence from the Sprint 641 release run (times PST): 2026-11-16 ~19:10 a long ssh session to the host's WSL was cut with 'Connection closed by remote host'. Minutes later ssh to the host's LAN port 2222 timed out on every address (link-local and both global IPv6), and ping got 0 replies (Windows drops ICMP, so ping alone proves nothing). 2026-11-17 02:14 still timed out. The cloud-relayed outpost exec path answered 'elevation required', so it was not tried with elevation. 2026-11-17 ~03:40 plain ssh answered again. Context: another sprint said the operator reserved the host for a class session for about 2 hours (from ~19:40 11-16), which may or may not be related. Nobody was alerted; it was found only because a test run needed the host. Investigate: Windows event log (Kernel-Power 41/42 sleep or reboot, network adapter resets, Windows Update restarts), the outpost daemon log and its upgrade ledger, sshd listener state (tunnel-only vs LAN), mDNS/IPv6 address changes, WSL shutdown, and power/sleep policy. Classify as product, configuration or environment, and fix it where the cause lives.

## Read-only investigation, 2026-11-21

**Classification:** Confirmed LAN SSH reachability outage from the reporting workstation while the Windows test host and Outpost daemon continued to operate. The initiating cause remains undetermined among product listener behavior, host or client configuration, and the network path. Separately confirmed a configuration problem in incident evidence retention: the circular Windows System log overwrote the requested period. P0 remains open.

All timestamps here are Pacific Standard Time unless labeled UTC. The exact Windows event query used 2026-11-17 03:00–12:00 UTC, corresponding to November 16 19:00 through November 17 04:00 PST. The native Windows lane was claimed for collection. No service, logging, adapter, firewall, sleep policy or WSL state was changed.

| Evidence | Observation and significance |
| --- | --- |
| Last good, first bad and recovery | Sprint 641's existing connection dropped about 19:10. The LAN SSH endpoint subsequently timed out, including at 02:14, and the workstation could connect again around 03:40. The host daemon recorded a public-key SSH acceptance at 03:46:23, then again at 03:59:36. A cloud-side elevation rejection at 02:14 occurred before any host authentication and leaves tunnel reachability unmeasured. |
| Outpost daemon and mDNS | The daemon logged 5,462 entries across all 565 minutes of a slightly wider 18:55–04:19 window. It measured the reporting workstation in the reverse direction with a LAN-tier result at 19:10:04 and at 02:14:01 and 02:14:55. Those peer probes use a different protocol from inbound SSH. The 283 successful mDNS refreshes match the two-minute timer in the deployed source `55b2fdd`, before, during and after the outage. A mesh reconnect was logged at 23:58:02. These observations rule out a continuous whole-host, daemon or two-way LAN outage across the interval. They leave the specific inbound SSH listener, firewall and client path unresolved. |
| Upgrade and supervisor history | The last recorded binary swap before the outage was November 16 20:01:56 UTC with healthy confirmation at 20:04:57 UTC. The next swap was November 17 20:14:21 UTC. The supervisor log has a start at 12:14:25 PST on November 17, after SSH recovery. The observed post-recovery shell working-directory change remains a useful clue, but the historical ledger provides no time-aligned upgrade or supervisor restart. |
| Windows power and boot | The 20 MiB circular System log had about 6 h 25 min of coverage at collection and begins November 21 03:19:16 UTC. There was no retained System archive in the standard event-log directory. Kernel-Power 41/42, System restart events and adapter-level System entries from the incident window cannot be checked. The retained Diagnostics-Performance and Kernel-Boot operational queries returned no event in that window. Current Balanced policy reports AC and DC sleep-after and hibernate-after as zero with S0 low-power idle available. That is present-day configuration only. |
| Windows updates and graphics reports | The retained Windows Update channel shows searches and a download at 23:41 and 01:10, with no install or restart event in the window. WER 1001 entries at 20:49 and 00:57 report LiveKernelEvent 141 but reference the same two watchdog dumps named for November 12 and 13. They are re-reports of earlier events, so their reporting timestamps cannot date a new GPU failure in this incident. The earlier Windows resets tracked in `ab6b9b872ac1` are also outside this window. |
| Network, listener and WSL records | Retained NetworkProfile, WLAN, DHCP and DHCPv6 channels show no matching events. TCP/IP, NDIS and DNS operational channels were disabled at collection. No historical port-matched Security WFP event was found and the main firewall log no longer covers the interval. The Hyper-V Compute operational log records VM creation/start activity at 03:59:36, near an accepted SSH session, and contains no event establishing a WSL shutdown at onset. The dedicated WSL channels were absent. The current Outpost SSH listener is on a wildcard bind and Outpost owns the mDNS sockets. Current IPv6 and adapter observations cannot establish their historical state. |

Private source capture used native Windows event XML timestamps, bounded file seeks, and a compact daemon summary. The four-file evidence manifest SHA-256 is `86924ddc20808847bc369a1c8fad9a94f2ce0cb913782fe0e8c89a1c029b2ebd`. The missing discriminator is a contemporaneous inbound LAN SSH observation from another client, listener/firewall telemetry, or archived System events for the onset. A full classification of the initiating defect requires evidence from one of those sources. Escalate the findings to the supervising conductor before any remediation.

## Operator-approved diagnostic logging, 2026-11-21

The Windows test host's native lane was claimed for the change. The System
channel maximum increased from 20 MiB (20,971,520 bytes) to 256 MiB
(268,435,456 bytes), retaining circular mode. OpenSSH/Operational was already
enabled at readback and remains enabled, circular, at 1,052,672 bytes. No
listener restart or power, firewall, adapter, WSL, or Podman change was needed.

The `Outpost-ListenerBindingAudit` scheduled task runs every five minutes
without an end date under the local system account, with overlapping launches
ignored and a two-minute execution limit. The protected
`%ProgramData%\Outpost-ListenerAudit` directory is writable only by System
and Administrators. Each JSONL record captures UTC time and listening address,
port, PID, and process name for ports 22 and 2222, including an empty list if
neither is listening. The active and previous files each have a 4 MiB cap
(8 MiB total). Both a manual run and the first scheduled run exited 0 and
recorded the active LAN SSH listener. Values and samples were saved privately.

To revert from an elevated PowerShell session, stop and unregister the task and
restore the previous System limit. OpenSSH was already enabled and its settings
remain the same. Export any System events needed before shrinking the log.

```powershell
Stop-ScheduledTask -TaskName 'Outpost-ListenerBindingAudit'
Unregister-ScheduledTask -TaskName 'Outpost-ListenerBindingAudit' -Confirm:$false
wevtutil.exe sl System /ms:20971520
Get-WinEvent -ListLog System,'OpenSSH/Operational' |
  Select-Object LogName,IsEnabled,MaximumSizeInBytes,LogMode
```

The generated audit files can remain for incident comparison after disabling the
task. The initiating cause remains unresolved because contemporaneous evidence
expired. Logging is now configured to help diagnose a recurrence. The paired
listener and tunnel recovery work is tracked in
[465e11058196](465e11058196-outpost-self-recovery-keep-lan-sshd-and-the-tunnel.md).
