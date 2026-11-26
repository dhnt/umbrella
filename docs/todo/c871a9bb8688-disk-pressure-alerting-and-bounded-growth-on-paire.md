---
id: c871a9bb8688
kind: feature
title: Disk-pressure alerting and bounded growth on paired hosts (the always-on host's 2 TB once filled from an OTel bug)
seq: 391
status: done
priority: p1
created: 2026-11-17T12:02:01.258936Z
assignee: codex-gpt6.2-astra
sprint: 698
sprint_id: 3da6b228-61d4-5302-931a-565e4862813b
sprint_title: 'Outpost reliability follow-up: master reachability parity and disk pressure'
closed: 2026-11-26T05:00:17.217175Z
closed_by: codex-gpt6.2-sol
---

Operator 2026-11-17: the always-on Windows test host's 2 TB disk once filled completely because of an OTel bug (unbounded telemetry writes). Go caches are now kept there permanently by policy, so growth must be bounded and visible. Scope: outpost reports free space per volume (Windows and its WSL distros) with its heartbeat; cloudbox alerts the owner once per threshold crossing (e.g. 80%, 90%, 95%), deduplicated, with the same bashy CLI path as the offline alert; and each local store we write (OTel, logs, evidence, caches) has a declared retention or size cap, with the top growers named in the alert. Root-cause the earlier OTel fill if it isn't recorded yet. Acceptance: a fixture that writes past a threshold yields exactly one alert naming the volume and the fastest-growing directory.


### 2026-11-21 implementation acceptance

Use builds and targeted fixture unit tests for implementation closure. Long-running growth/end-to-end probes, full suites, browser/e2e, release gates, and judge or LLM grading are deferred to the epic or milestone integration gate.

Write and run fast unit tests during implementation. The operator calls the
integration gate only when an epic or one of its milestones is complete.

## Sprint 698 implementation evidence

Outpost `06dbb8befe87` passed targeted local and Linux builds, Windows cross-builds, and native Windows heartbeat and supervisor fixtures. The merged hosted fixtures crossed a real write threshold, identified the fastest grower, deduplicated delivery, fenced transfers, and notified again after recovery and a fresh crossing. The CLI fixture replayed the actual owner response for two WSL distros with identical grower labels. Their display labels and stable volume IDs distinguished both filesystems. Public reports use store labels for growth and omit directory paths.

The supported WSL build wrapper refused a missing cache ceiling before running a compiler. With an actual 8 MiB mounted filesystem, a write after admission returned `ENOSPC` and existing cache data remained intact. The fixture verified the configured filesystem cap. Live WSL cache provisioning remains a separate operator step.

Yoke's historical incident evidence recorded approximately 1.324 TB of abandoned telemetry rotation scratch and a 584 MB active spool. The exact trigger that orphaned the scratch remains unverified. Yoke `d1a8a0a1` implements bounded admission and in-place compaction. Historical coreutils `b069850` established an earlier spool cap.
