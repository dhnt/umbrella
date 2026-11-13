---
id: c2025b8b2d8a
kind: task
title: 'script/no-phone-home.sh fails open under bashy''s grep: \b unsupported -> grep exit 2 swallowed by ''|| true'' -> false ''clean'''
seq: 225
status: done
priority: p1
created: 2026-11-13T14:27:33.983869Z
assignee: claude-opus5.5-s631
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
closed: 2026-11-13T14:30:33.470486Z
closed_by: claude-opus5.5-s631
---

Root cause (verified 2026-11-13 during the S6 gate): no-phone-home.sh line 34 runs grep -rniE with a \b pattern and appends '|| true'. In an agent shell where grep is bashy's pure-Go grep, \b fails ('word-boundary escape \b is not supported by the locale byte substrate'), grep exits 2, the error is swallowed, and the script prints 'no-phone-home: clean'. The same tree (bashy examples/table) gives 23 hits with system grep (PATH=/usr/bin:/bin). Classification: test-tool defect (fails open) plus a product gap (bashy grep lacks \b). Fix in the script: treat grep exit >=2 as a scan error (exit 2), never 'clean'. Separately, a bashy todo for \b support in grep. Re-verify: any S631 'no-phone-home clean' evidence produced inside a bashy shell (S3, S7, S8, S9, S9b, S2b) must be re-run with system grep.
