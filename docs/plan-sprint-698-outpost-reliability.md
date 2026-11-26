# Sprint 698 execution plan

Deliver master reachability parity and bounded disk pressure on paired hosts. The two P1 stories on sprint 698 set acceptance. Use the existing [transition contract](alert-transition-wire.md).

| Work | Implementation | Acceptance |
| --- | --- | --- |
| Disk pressure, c871a9bb8688 | Start first. Inventory OTel, log, evidence and cache writers and their enforced caps. Trace the earlier disk fill from incident evidence. Extend Outpost heartbeats with bounded Windows and WSL volume measurements and directory growth deltas. Expose owner alerts through the paired-host CLI. Preserve persistent Go caches. | Write across a threshold while a larger directory stays flat. Verify the notice names the correct volume and fastest grower. Repeat observations, race deliveries, restart, recover and cross again. Check each store's limit. |
| Master parity, 6210caba276e | Use the existing authenticated satellite report for an optional bounded projection. Bind each master read to the current pairing and owner. Share the projection between direct CLI status and the indexed host list. Keep evaluation and alert writes on the satellite. | Compare CLI, listing and satellite fixtures. Test missing and stale data, token scope, shared accounts, ambiguity, explicit satellite selection, and transfer or revocation between reports. Preserve the short liveness window. |

Start on current integration heads, check consumer drift, and baseline the affected packages. Run independent changes concurrently and sequence edits to shared files. Use the default two-hour window, included fleet capacity, targeted builds and fast fixtures. Checkpoint at first tested candidate and at integration. Escalate measured time or cost risk before widening the run.

Accept stories individually on the exact integrated candidate. Record public commit and fixture evidence on the cards and retain hosted details privately. Push subprojects before updating consumer and umbrella pins. Revert a faulty change by story on the integration branch. The operator calls the milestone integration gate and coordinated release separately.
