---
id: baccc22c78b4
kind: test
title: 'S23 e2e: fleet-mirror scenario (production layout with fake accounts/hosts) in the multisat harness, run on a temporary AWS instance, held up for manual verification'
seq: 273
status: assigned
priority: p1
labels:
    - e2e
created: 2026-11-14T11:12:39.658128Z
assignee: claude-fable5.1-s630
sprint: 630
sprint_id: 106504a0-f6e4-55e5-9736-d8f2bd1ef052
sprint_title: 'S619 follow-up: signed identity, master mode, outpost URL path, rc.34'
---

2026-11-14 run 10 (4 vCPU, two at a time, cloudbox f2b8b48): 8/11 — the whole-fleet slice came up (103 checks, 101 ok, rm BLOCKED): only the S15b connect check red, plus a model gap (a circle share appears on the master's Hosts page only after the member signed in on that satellite; product observation, model fixed). user-two-satellites and user-partner: the SECOND satellite of the slice died at cluster start ('failed to start wrangler controllers: cache sync failed for informer Addon', level=fatal) while the neighbouring slice started its clusters (load 26-38). Product observation: an embedded-cluster start failure is fatal for the whole satellite. Venue: fleet defaults to one slice at a time; run 11 launched serially.
