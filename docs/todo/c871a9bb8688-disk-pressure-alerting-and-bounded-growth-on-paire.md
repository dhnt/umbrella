---
id: c871a9bb8688
kind: feature
title: Disk-pressure alerting and bounded growth on paired hosts (the always-on host's 2 TB once filled from an OTel bug)
seq: 391
status: todo
priority: p1
created: 2026-11-17T12:02:01.258936Z
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
---

Operator 2026-11-17: the always-on Windows test host's 2 TB disk once filled completely because of an OTel bug (unbounded telemetry writes). Go caches are now kept there permanently by policy, so growth must be bounded and visible. Scope: outpost reports free space per volume (Windows and its WSL distros) with its heartbeat; cloudbox alerts the owner once per threshold crossing (e.g. 80%, 90%, 95%), deduplicated, with the same bashy CLI path as the offline alert; and each local store we write (OTel, logs, evidence, caches) has a declared retention or size cap, with the top growers named in the alert. Root-cause the earlier OTel fill if it isn't recorded yet. Acceptance: a fixture that writes past a threshold yields exactly one alert naming the volume and the fastest-growing directory.


### 2026-11-21 implementation acceptance

Use builds and targeted fixture unit tests for implementation closure. Long-running growth/end-to-end probes, full suites, browser/e2e, release gates, and judge or LLM grading are deferred to the epic or milestone integration gate.

Write and run fast unit tests during implementation. The operator calls the
integration gate only when an epic or one of its milestones is complete.
