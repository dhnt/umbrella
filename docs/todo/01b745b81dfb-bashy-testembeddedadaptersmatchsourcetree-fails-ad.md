---
id: 01b745b81dfb
kind: bug
title: 'bashy TestEmbeddedAdaptersMatchSourceTree fails: adapterembed examples/desk/chart/chart.bsh drifted from source (pre-existing at origin main)'
seq: 728
status: todo
priority: p1
labels:
    - bashy
    - test
created: 2026-11-24T21:33:21.157657Z
sprint: 713
sprint_id: 867b4689-21ed-53db-93f9-b2a926b28de6
sprint_title: 'Known reds triage after train 1: decide fix or won''t do for each pre-existing test red'
---

Seen 2026-11-24 by the Sprint 706 conductor while verifying R10: GOWORK=off go test -run TestEmbeddedAdaptersMatchSourceTree ./internal/agentos fails with 'embedded adapter examples/desk/chart/chart.bsh drifted from source tree' (adapter_dispatch_test.go:214). On origin/main the two files already differ by 3 lines; the source was last changed by 56b5b1a1 (kit and chart are published modules). Pre-existing, unrelated to 706; not repaired there. Root cause first: was the embed regenerated after 56b5b1a1? Fix: go generate ./internal/agentos/adapterembed and confirm only chart.bsh changes; unit test is the acceptance.

## Unlinked to the backlog (2026-11-24, operator: close Sprint 703)

A known failing test is tracked, never closed as won't do (root-cause rule). It is not on the MVP path; fix it when it blocks a release gate, with the root cause recorded here.
