---
id: 0341c7477c14
kind: refactor
title: 'M0a: core module yoke/core (move assetring, ref, CoreVerbs, builtin table); dependency ratchet + cache check'
seq: 868
status: todo
priority: p1
labels:
    - core
created: 2026-11-28T21:18:35.215532Z
sprint: 749
sprint_id: 4c411c90-8521-5bd7-bafd-25fd2c4ef4cf
sprint_title: 'Minimal stable core: core verbs = model tool agent commands help version; rest optional'
---

Plan: docs/sprint-749-minimal-core-plan.md (M0a). MOVE only, no new implementation. New nested module github.com/qiangli/yoke/core. Move yoke pkg/assetring, pkg/ref, and CoreVerbs plus the bash builtin table from pkg/src. Old paths become thin aliases, or callers are updated in the same commit. Ratchet: go list -deps modules within stdlib + bashsharp cmd/bsh graph + gopkg.in/yaml.v3, naming the offending import. Cache check on the lane: bump a non-essential pin, go test stays (cached), go build -x shows no core compile. Add to the umbrella go.work by hand. No formerly green test regresses (compare by name).
