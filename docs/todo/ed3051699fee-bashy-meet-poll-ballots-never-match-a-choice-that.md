---
id: ed3051699fee
kind: bug
title: 'bashy meet poll: ballots never match a --choice that carries a description after the colon (room 46 round 3: 5/5 votes invalid)'
seq: 234
status: todo
priority: p1
labels:
    - meet
created: 2026-11-13T15:19:52.437018Z
---

Observed 2026-11-13 in meeting 2026-11-13-commercializing-bashy-software-shaping-product-a-f067, round 3 poll by the facilitator. Every seat (codex-gpt5.6-sol, claude-opus5.5, agy-gemini3.8-flash, muse-spark1.3, codex-shaping-business-review) answered with the key, e.g. 'classroom-satellites', and every vote is recorded status=invalid; the tally will report no clear result.

Root cause (code read, yoke/pkg/meet/poll.go normalizeChoice): the head-line match requires head == choice or head has prefix choice+' ', and the whole-reply fallback splits the reply into [a-z0-9-_] fields and compares each field to the whole lowercased choice. A choice such as 'classroom-satellites: turnkey hosted satellites for educators and bootcamps, from lern-si' can therefore only be matched by a reply that reproduces the entire string. Classification: product defect (matcher), with a facilitator-usage component (long choices).

Candidate fix, not applied: match on the choice key (text before the first ':' or whitespace) as well as the full string, and have the poll prompt tell agents to answer with the key. Also consider: a roster seat that is a live session gets a headless proxy at poll time (codex-shaping-business-review's ballot contradicted its own live contribution); document or skip. No fix without a story; see docs/bash53-gate-79-86-findings.md rule.
