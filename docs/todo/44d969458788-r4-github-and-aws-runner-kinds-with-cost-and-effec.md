---
id: 44d969458788
kind: feature
title: R4 GitHub and AWS runner kinds with cost and effects gating
seq: 396
status: wontfix
priority: p2
created: 2026-11-17T12:12:36.21466Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
closed: 2026-11-25T09:53:17.663382Z
---

github: dispatch to a hosted or self-hosted runner only when a step needs it (e.g. the final public release upload), recording run ids, never as the default. aws: provision a throwaway instance from a declared image, run, collect, then tear down, within a per-run cost cap (effect: spend, which needs approval). Both report the route used. Acceptance: a dry-run plan shows the instance and cost before anything is created; teardown is verified.

Closed as won’t do with Sprint 653. The operator chose registered custom scripts for remote runner workflows.
