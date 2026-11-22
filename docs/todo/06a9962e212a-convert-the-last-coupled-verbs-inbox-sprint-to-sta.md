---
id: 06a9962e212a
kind: refactor
title: Convert the last coupled verbs (inbox, sprint) to standalone yoke/ adapters by duplicating their glue
seq: 612
status: done
priority: p0
created: 2026-11-21T20:17:29.34057Z
weave: 133
assignee: agy-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T20:49:18.383884Z
closed_by: muse-wonder-full
---

Conductor review 2026-11-21 of bashy yoke/COUPLED-EXCEPTIONS.md: inbox and sprint were kept in internal/agentos because of in-process couplings (inbox: session relays + turn delivery; sprint: active conductor loop + monitor + attachSprintWatch + inbox-ack + await). Operator rule: no non-internal command depends on another, EVEN IF IT MEANS DUPLICATE CODE. Do: give each its own adapter entry under yoke/ that builds alone, duplicating the needed glue into that command's own package (no import of another command's package); bashy's case calls the adapter; same flags/args/output/exit codes. Acceptance: builds alone GOWORK=off; AssertStandaloneDeps clean; unit tests incl. existing inbox/sprint tests; update COUPLED-EXCEPTIONS.md. Start on current heads; unit tests only.
