---
id: a6aa6915f508
kind: feature
title: 'muse seed: add Muse Wonder and Muse Wonder Full (Meta flagships) with muse bindings'
seq: 548
status: todo
priority: p2
labels:
    - agents
created: 2026-11-19T20:48:15.131096Z
---

Follow-up from Sprint 671 T5/T6: the T5 research recorded Muse Spark 1.3 (2026-09-02) as Meta's newest model and missed Muse Wonder and Muse Wonder Full (2026-10-12, Meta's flagships; Spark is the smaller tier) and Muse Ember (2026-11-09). Vendor ids muse-wonder-1.0 and muse-wonder-full-1.0 (Meta launch coverage; public boards list them). muse publishes no model list and 'muse model-profile show' accepts any string, so the ids are verified only by a live probe. Shape: models/muse-wonder.yaml + muse-wonder-full.yaml (declared prior inherited from muse-spark1.3, L4), agents muse-wonder + muse-wonder-full, pinned in seeds_test, then 'bashy agent verify --live' on both (operator-approved 2026-11-19).
