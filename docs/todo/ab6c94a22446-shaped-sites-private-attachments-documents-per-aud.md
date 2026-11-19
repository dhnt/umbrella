---
id: ab6c94a22446
kind: feature
title: 'Shaped sites: private attachments (documents) per audience, e.g. degree or certificate copies'
seq: 507
status: todo
priority: p2
labels:
    - shaping
    - website
    - privacy
created: 2026-11-19T06:20:31.460312Z
sprint: 665
sprint_id: 482ac62d-1c0e-5e38-9236-c7c5893f895c
sprint_title: 'Website shaping, part 2: access requests, visitor BYOK, owner outpost/satellite, more generators'
---

Operator 2026-11-18: a résumé owner wants to attach copies of degrees and certificates that only chosen circles can open. Generic for any shaped site: fields/*.md may reference attachments kept in the private companion repo (or the owner's trove), with the same audience front matter (circles, groups, emails, signed_in; none = owner only). The engine serves them only to admitted callers, under no-store, never through the static host. The panel lists them with the field. Add an optional watermark or expiry per view for documents that leave the page. Getting files in is agent work: the owner hands a file (drop, Drive, a path) and the agent adds it; no manual repo editing. The owner may also shape it in by wish.
