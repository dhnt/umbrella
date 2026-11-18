---
id: e9bffaa179d1
kind: feature
title: S4 Google identity and Gmail/Drive access on the shaping host
seq: 113
status: todo
priority: p2
labels:
    - shaping
    - google
created: 2026-11-11T04:32:53.567276Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Planned vendor: claude. Requirement (b), preferred. Reuse examples/google (BYOP). First establish whether the gws loopback OAuth redirect completes inside a cloud workspace (desktop IDE forwards localhost; web IDE does not); fallback auth-import of a token minted elsewhere; record the working route per platform. up runs google auth-status and restores credentials from a platform user secret, never from the repo. No core changes. Verify: plan step 5.
