# Sprint 652 Outpost reliability and host alerts

Sprint 677 has priority for shared test resources. Sprint 652 starts with read-only incident diagnosis on the native Windows test host. The runtime and alert work follows the operator's review of the findings.

| Order | Story | Acceptance |
| --- | --- | --- |
| P0 first | `b3580b976c31` Windows test host outage | Correlate the last good connection, outage, and recovery with retained Windows events, Outpost logs and upgrade history. Check the current listener and power policy separately. Record a product, configuration or environment classification, or identify the evidence gap that prevents one. Bring the findings to the supervising conductor before any fix. |
| P0 next | `daa99f1f5a8e` Host reachability alerts | Distinguish offline, degraded and reported asleep states. Show the last observation and send one owner alert per transition and one recovery notice. Verify equivalent Bashy CLI and UI state. |
| P1 | `465e11058196` Outpost listener and tunnel recovery | Restore failed host-side services with backoff and record what caused the interruption. Use an isolated fixture to verify the reason and recovery. Track client elevation expiration separately from host availability and verify the distinction. |
| P1 | `c871a9bb8688` Disk pressure and bounded growth | Report volume use, deduplicate threshold crossings, and name the fastest-growing directory in the fixture alert. Record retention or size limits for the local stores and correlate the earlier telemetry growth before changing its policy. |

The first investigation covers November 16, 2026, 19:00 through November 17, 04:00 Pacific Standard Time (03:00–12:00 UTC on November 17). Claim the native Windows lane for read-only collection. Correlate boot, sleep and resume events, adapter and address changes, Windows Update, WSL lifecycle records, and Outpost process, listener, log and upgrade evidence. Note each log's retention and access limits. Use current listener, mDNS, IPv6 and power state as context for the historical timeline. Preserve raw evidence privately and use role names in the public story.

Design outage and disk notifications together with Sprint 688 story `49cd45d9`, sharing state transition and deduplication behavior. Cloudbox implementation belongs in its private repository. Public notes describe the wire protocol and observable behavior. Cloudbox deployment requires operator approval.
