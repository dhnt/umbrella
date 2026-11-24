---
id: 76eac0eace23
kind: task
title: 'T1 Deploy train 1: one hosted-plane release carrying Sprint 697 A2 (and anything merged to dev after v0.18.82); pre-release gate once, operator GO, deploy, live checklist'
seq: 684
status: todo
priority: p0
labels:
    - release
    - hosted-plane
created: 2026-11-23T21:56:00.762617Z
sprint: 699
sprint_id: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a
sprint_title: 'Release train 1: one hosted-plane deploy for Sprints 682/697 + live verification'
---

Operator 2026-11-23: a release went out this morning (v0.18.82, Sprint 693); do not roll another per sprint. Coordinate tests and deploy as one train. CONTENTS of the next train (hosted plane dev beyond v0.18.82, by story): Sprint 697 A2 d80f551b7d18 (agent-ready public pages + same-origin /mcp auth dispatch, dhnt/site v0.2.1; merged to dev, verified on the gate host, security re-review PASS, NOT live); the standalone Accept tie-break follow-up 60b2b1007498 (absorbed by A2). Add every later hosted change here as it merges to dev. PROCEDURE: (1) per change: unit/targeted tests on the gate host under a lane, no deploy; (2) once per train: the cloudbox pre-release gate (container unit suite, desktop-journey e2e with BASHY_TAG at the latest promoted bashy, go vet/build primary + satellite) on the frozen dev commit; (3) operator GO; (4) tag vNEXT, build/push images, deploy master on App Platform, satellites, live smoke; (5) LIVE CHECKLIST after deploy: A2 curl matrix through the live edge (Bearer -> gateway, cookie/anonymous -> 401 or proxy), /agents.txt and headers on dhnt.io, Sprint 697 A5 live-site rows (fleet CLIs, browser, chat fetcher), satellite upgrade 403/502 check (cloudbox todo 4af1cde, REGISTRY_GITHUB_TOKEN rotation). OPEN: PUBLIC_SITE_MCP_UPSTREAM stays unset until an owner site MCP endpoint is published; set it in a config change after. Timing of the train: operator's call (with the next hosted feature, e.g. S691, or on cadence). Owner: conductor of the sprint that triggers the train.

Precondition recorded 2026-11-24 (after Sprints 684/685): before the freeze, the tag or any release cut, confirm the pins are at heads: `bashy mod drift` shows no stale row (bashy and ycode trailed bashsharp; umbrella gitlinks for bashsharp, coreutils, yoke and outpost trailed their heads while Sprint 675's pin sync was in flight), every umbrella gitlink equals its repository head, forward only. Carry the two known red tests as recorded failures (ycode bug 08ee6df70b5d, bashy/yoke/fetch bf5c8c71f65e) unless Sprint 703 fixed them; any other failure blocks. Detail: docs/sprint-699-master-execution-plan.md, section 'Before any tag or release cut'.
