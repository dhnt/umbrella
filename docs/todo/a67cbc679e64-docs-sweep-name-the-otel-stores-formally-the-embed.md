---
id: a67cbc679e64
kind: chore
title: 'Docs sweep: name the OTel stores formally; the embedded engine''s vendor name stays only in identifiers'
seq: 96
status: todo
priority: p2
labels:
    - docs
created: 2026-11-10T20:20:27.356724Z
sprint: 611
sprint_id: 7de44c27-d277-58b6-b42d-e5fabc9d668f
sprint_title: 'OTel logs signal: wire outpost''s slog bridge and drain the bashy span spool into the OTel log store'
---

Delivered 2026-11-10. Zero prose occurrences of the vendor name across umbrella, bashy, yoke and outpost docs; identifiers in code font retained (upstream module paths, fork repo names, binary names, release tags, Go symbols, URLs). Commits: umbrella 945b3b54 + 005c2856 (pin bumps), bashy bb7d20a6, yoke 8bb3a1d1, outpost e6f422a. Scrub gate and provenance hook passed on each. Card corrected via sprint edit; story titles/notes via todo edit. Closure pending: accept requires the sprint to be started (claim refuses on a backlog sprint); run, once the sprint starts: bashy sprint claim 611 a67cbc679e64 --owner <manager> && bashy sprint submit 611 a67cbc679e64 --as <manager> -m "see note" && bashy sprint accept 611 a67cbc679e64 --no-rating
