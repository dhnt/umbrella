---
id: 9caa1cafb9ec
kind: feature
title: 'R6 Runner pools: several instances per runner, automatic load balancing and failover'
seq: 398
status: todo
priority: p1
created: 2026-11-17T12:13:53.80562Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
---

Operator 2026-11-17: once runners are defined, tests and builds are not concerned with host choices. A runner is a pool of one or more instances (e.g. the always-on Windows host's WSL, a podman gate machine, a second desktop, a throwaway cloud instance). bashy places each run on the instance with spare capacity: slots, CPU and memory headroom, free disk, cache warmth, using the existing dag capacity facts. It spreads concurrent runs and the packages or tests of one suite across instances, retries a run whose instance drops on another, and never falls back to the dev box for heavy work. An instance that is unreachable leaves the pool with a reason (raises the Sprint 652 alert) and rejoins on recovery. Desktop-class instances that may be shut down are preferred last. Acceptance: two instances registered; a full suite started twice concurrently from the dev box runs one on each; killing one instance mid-run moves its work to the other and the run still reports one result; callers never pass a host name.
