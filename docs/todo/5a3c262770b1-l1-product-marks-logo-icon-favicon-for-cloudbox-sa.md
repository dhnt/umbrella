---
id: 5a3c262770b1
kind: doc
title: 'L1 product marks: logo/icon/favicon for cloudbox, satellite, outpost, bashy'
seq: 169
status: assigned
priority: p1
labels:
    - software-shaping
created: 2026-11-12T19:29:38.851664Z
assignee: claude-opus5.5
sprint: 622
sprint_id: 03e47ab4-d1a0-5152-97e2-eee6dcb08395
sprint_title: 'Software Shaping one theme: definition, READMEs, qiangli/bash, product marks'
---

One geometric family of squares + circles; concept board then operator pick (like S564 H6 B Flow). cloudbox = square in a circle. satellite = a clearly distinct variant of cloudbox, obvious to humans at 16px in monochrome (options: orbit dot/arc, square rotated 45 deg, smaller square + second ring, orbit ellipse). outpost = two small slanted stacked squares (3-4 variants: offset, angle, gap, fill). bashy = four squares in a circle, app-grid, top-right square different (rotated, #6D4AFF accent, outlined, or smaller/offset = the one you shaped). Must sit beside the B Flow shaping badge without clashing. Deliverables per mark: hand-authored SVG master, mono + color on light/dark, PNG 16/32/48/180/192/512, favicon.ico, SHA256SUMS. Locations: umbrella docs/brand/ (board, family README), bashy/docs/brand/, outpost/docs/brand/; cloudbox/satellite masters copied to the private repo. Wire favicons into bashy web console and outpost admin UI. Verify: 16/32px legibility, blind cloudbox-vs-satellite tab-strip check, sha256sum -c, /favicon.ico hash smoke. Planned worker: claude-opus5.5 (design/SVG), codex-gpt6-sol (favicon wiring).
