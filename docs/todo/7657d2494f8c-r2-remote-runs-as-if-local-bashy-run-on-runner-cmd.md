---
id: 7657d2494f8c
kind: feature
title: 'R2 Remote runs as if local: bashy run --on RUNNER -- CMD (and a default runner policy)'
seq: 394
status: wontfix
priority: p1
created: 2026-11-17T12:12:35.922784Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
closed: 2026-11-25T09:53:14.052689Z
---

Any bashy command (a build, go test, make, a skill-script) runs on a registered runner with the same command line, exit code, stdout/stderr and artifacts as a local run. Workspace transfer is a git bundle over the LAN (never re-cloning from the internet), with only declared outputs copied back. Remote caches persist per runner (Go modules and builds), so nothing is downloaded twice. A policy file can make heavy work default to a runner (e.g. full suites go to the always-on host), so callers need not say --on. Acceptance: bashy run --on <always-on host> -- go test ./... from the dev box reports the same result as running it there, transfers no module from the internet when the remote cache has it, and leaves the dev box idle.

Closed as won’t do with Sprint 653. The operator chose registered custom scripts for remote runner workflows.
