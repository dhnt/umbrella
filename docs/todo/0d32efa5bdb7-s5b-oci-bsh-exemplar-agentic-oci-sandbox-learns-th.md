---
id: 0d32efa5bdb7
kind: feature
title: 'S5b oci.bsh exemplar: agentic oci|sandbox learns the gate venue''s podman machine (bashy not on PATH inside the machine, one machine per host, claim first, caps) instead of every worker rediscovering it'
seq: 254
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:35:09.427094Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

Operator 2026-11-13: the gate venue's podman machine has no bashy on PATH, which blocked every S632 worker's runtime proof; it has been a pain many times and agents never learn. bashy/examples/agentic/exemplars/oci.bsh is the second hand-written exemplar (alias sandbox; superset face over bashy oci / bashy sandbox / bashy contain): native argv passes through (agentic oci run --rm IMG CMD, agentic oci machine start), a sentence fills slots (agentic sandbox "run the bash gate in the gate machine"). The script encodes what the kb and memory already know and keeps learning it: probe bashy oci machine list/inspect and podman info; put bashy on PATH inside the machine (copy or mount the exact candidate binary, record where), never a second concurrent machine on one host (kb one-podman-machine-per-host), never the default podman of a host that runs live services, bashy claim the venue before using it and release after, apply memory/cpu/pids caps, no make inside the VM. Each failure is a pitfall (graph observe cmd:oci --outcome failure) that refine folds into the next version. Stub-podman tests; the live check belongs to S7 on the claimed venue. Hosts by role only.
