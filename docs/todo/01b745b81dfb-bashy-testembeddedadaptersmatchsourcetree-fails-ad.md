---
id: 01b745b81dfb
kind: bug
title: 'bashy TestEmbeddedAdaptersMatchSourceTree fails: adapterembed examples/desk/chart/chart.bsh drifted from source (pre-existing at origin main)'
seq: 728
status: todo
priority: p2
labels:
    - bashy
    - test
created: 2026-11-24T21:33:21.157657Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Seen 2026-11-24 by the Sprint 706 conductor while verifying R10: GOWORK=off go test -run TestEmbeddedAdaptersMatchSourceTree ./internal/agentos fails with 'embedded adapter examples/desk/chart/chart.bsh drifted from source tree' (adapter_dispatch_test.go:214). On origin/main the two files already differ by 3 lines; the source was last changed by 56b5b1a1 (kit and chart are published modules). Pre-existing, unrelated to 706; not repaired there. Root cause first: was the embed regenerated after 56b5b1a1? Fix: go generate ./internal/agentos/adapterembed and confirm only chart.bsh changes; unit test is the acceptance.
