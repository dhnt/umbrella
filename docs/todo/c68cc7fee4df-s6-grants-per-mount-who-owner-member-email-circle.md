---
id: c68cc7fee4df
kind: feature
title: 'S6 grants: per-mount {who: owner|member:<email>|circle:<name>, mode: read|write} + only: self; caller from trusted headers or --principal; trove share -> outpost apps share'
seq: 295
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:53.19821Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: codex. Example level. Vocabulary = outpost/internal/agent/grants.go (owner, member email, circle); membership/circles from the cloudbox grant copy, never redefined; NO agent: principal (agents act as the owner's principal, capped by effects and --yes). Caller: Remote-User/Remote-Groups on the web (tunnel-stamped only), --principal / BASHY_PRINCIPAL on the CLI as shape does. Owner always admitted; denied = the same not-found/no-access result on CLI and HTTP. only: self filters entries whose subject attr == caller. trove share MOUNT --member|--circle --mode shells to outpost apps share trove so app admission and mount grants never diverge. Accept: matrix test owner/member/circle/anonymous x read/write; refusals name mount and rule; CLI and HTTP identical denied result; owner path unchanged; --json parity. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
