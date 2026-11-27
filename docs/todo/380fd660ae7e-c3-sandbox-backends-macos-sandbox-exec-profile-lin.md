---
id: 380fd660ae7e
kind: feature
title: 'C3 sandbox backends: macOS sandbox-exec profile, Linux bashy oci; Windows fails closed'
seq: 823
status: todo
priority: p1
created: 2026-11-27T14:25:10.003983Z
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
---

Plan: docs/sprint-738-master-execution-plan.md §3 C3. One interface, two backends. macOS: generated sandbox-exec profile (writes only DIR and a private temp, HOME reads denied except the genie bundle and bashy, network only to the session socket). Linux: bashy oci with the bashy-base image, DIR and the socket bind-mounted, network none. Windows: explicit refusal naming the reason. Unit tests per backend for the profile or container spec. Code inspected 2026-11-27: bashy oci --help; agent-bench packs/spec2src/venue/guard.sb.template.
