---
id: 5cfdfc85f668
kind: task
title: 'rc.40 candidate gate: leg 2 rerun (./bin/bashy dag test) on frozen tip bashy f1907987 / bashsharp b1a3183 / outpost a1c9307 / yoke 3eb700cd; final evidence for leg 2'
seq: 633
status: assigned
priority: p0
labels:
    - release
    - gate
created: 2026-11-22T19:32:56.961664Z
assignee: claude-opus5.5
sprint: 692
---

Gate loop rules (docs/plan-sprint-692-release-thin-bashy.md, 'Gate loop rules') apply. Only leg 2 reruns: the change since run #156 (bashy 5299e54b -> f1907987, yoke 5f136516 -> 3eb700cd) is the pkg/bus fingerprint fix + pin table, not an engine input and not the adapter path, so legs 1, 3, 4, 5 of run #156 stand as evidence for this tip (rule 2). Because this is expected to be the FINAL evidence run for the tagged tip, use a FRESH cache volume (rule 3) but a shared warm Go module cache (rule 6: no re-downloads). Owner claude-opus5.5; venue gate-host lane 2 or 3 (claim it; lane 1 has a dead agy lease), official image rc.40-go1.27.4, nohup + poll. Steps: verify the four shas at start; bashy dag build (leg 1, records as a rebuild of the same inputs); then ./bin/bashy dag test (THROUGH the candidate). Record: exit code, wall time, the inittrace line, the go test package summary and every failing name verbatim. RULE 4: if a red is TEST- or VENUE-class, record the root cause and class on this story, fix it in place, re-execute that test/target in the image, commit (Sprint/Story/Story-ID + Agent); PRODUCT-class reds are recorded and handed to the conductor via bashy mb. Append a fourth section to docs/sprint-677-integration-evidence.md stating which run covers which leg for this tip. Do not push.
