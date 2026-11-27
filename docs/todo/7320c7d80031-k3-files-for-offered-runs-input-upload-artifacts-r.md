---
id: 7320c7d80031
kind: feature
title: 'K3 inputs and outputs by reference: bashy:// URIs in, artifact URIs out; refuse host paths from peers'
seq: 831
status: todo
priority: p1
created: 2026-11-27T15:34:19.372087Z
sprint: 739
sprint_id: 2a232332-0066-5763-8821-db4148f8dd1e
sprint_title: 'Commands and folders as a service: offer bashy commands and designated folders to your trusted group'
---

Plan: docs/sprint-739-master-execution-plan.md §4 K3. Pre-existing hazard: a peer-supplied json-file or path-shaped arg is read from the door host's filesystem (fleet toolcommand.go:358-375). Refuse host paths from peer/member callers; accept bashy:// URIs, fetched into the run's scratch dir by the offerer (member token, F2). Artifacts (Result.Artifacts, output file:<glob>, print.go:276-311) move into the offerer's output share <bashy-home>/shared/offers/ (app files-offers, same audience as the offer; F1) and return as URIs with size + sha256; small text stays inline. Depends on F2. Code inspected 2026-11-27 (revised after review): yoke pkg/toolcmd toolcmd.go print.go peer.go, pkg/cligw slash.go:261-277, pkg/fleet toolcommand.go.
