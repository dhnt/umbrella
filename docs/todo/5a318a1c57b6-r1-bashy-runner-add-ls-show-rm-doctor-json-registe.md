---
id: 5a318a1c57b6
kind: feature
title: 'R1 bashy runner add|ls|show|rm|doctor --json: register remote runners (outpost, ssh, oci, github, aws)'
seq: 393
status: wontfix
priority: p1
created: 2026-11-17T12:12:35.770271Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
closed: 2026-11-25T09:53:12.248151Z
---

One registry for every remote place work can run. Kinds: outpost (a paired host, reached LAN or mesh first, never relayed through the cloud satellite unless no direct path), ssh, oci (a bashy oci connection), github (a hosted or self-hosted runner) and aws (a provisioned throwaway instance). Each entry records capability facts, discovered by doctor (os, arch, cpu, mem, gpu, toolchains, free disk), a credential by vault reference only, and an effects/cost class. doctor reports reachability with a reason. Acceptance: register the always-on Windows host and a macOS outpost; ls --json shows both with facts; rm refuses while a run is active.

Closed as won’t do with Sprint 653. The operator chose registered custom scripts for remote runner workflows.
