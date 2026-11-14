---
id: 511be6bb2e52
kind: feature
title: S5 Promotion remote for registered shaped apps (lift the six-repo allowlist for configured upstreams)
seq: 285
status: todo
priority: p1
labels:
    - shaping
    - core
created: 2026-11-14T22:42:22.613655Z
sprint: 638
sprint_id: 88e86a75-5c83-5528-8a5c-44cc29c43030
sprint_title: 'Website shaping: Shape badge, engine-hosted site, shaping levels (dhnt.io dogfood)'
---

Planned vendor: codex. Core, small. yoke pkg/src/repos.go remoteFor, upstream.go ConfiguredTier/SetTier accept a repo whose managed checkout ($BASHY_HOME/src/<name>) is a registered shaped app; acquisition allowlist unchanged; read release_private_test.go first. Accept: shape remote set upstream <private URL> works for the website app, still refused for an unregistered name; shape push --to upstream --pr reaches gh pr create or prints the compare URL. Spec: docs/sprint-638-master-execution-plan.md; design: docs/website-shaping-integration.md
