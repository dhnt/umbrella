---
id: dd119b50aa15
kind: requirement
title: 'R0 Design: one runner registry and one way to say run this there, mapped onto the existing dag venues and Transport'
seq: 392
status: wontfix
priority: p1
created: 2026-11-17T12:12:35.616983Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
closed: 2026-11-25T09:53:10.496539Z
---

Read before designing: yoke pkg/dag venues (userland, workspace, sandbox, native, cluster, cloud), the dag Transport interface (Exec/Close) and its authorized SSH capacity dispatch, the fleet host registry, and the run, oci (--connection), sandbox and act-runner verbs. Decide the minimal model: a named runner = kind + address + capability facts (os, arch, cpu, mem, gpu, tools) + credential by vault reference + cost/effects class. Output: a short design doc and the story split; no new engine where an existing Transport fits.

Closed as won’t do with Sprint 653. The operator chose registered custom scripts for remote runner workflows.
