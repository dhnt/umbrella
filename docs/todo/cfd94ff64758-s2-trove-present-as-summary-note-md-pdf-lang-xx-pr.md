---
id: cfd94ff64758
kind: feature
title: 'S2 trove present --as summary|note|md|pdf|lang:XX: presenters hook, render cache with provenance, oss route first, --yes for paid, --dry-run plan'
seq: 291
status: wontfix
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.628182Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:11.564035Z
---

Planned vendor: glm. Example level. Order: canned render on the entry/mount -> generate via service doors (text role via examples/agentic/summarize.bsh or the configured rod, translate rod, pdf.read/lens) -> cache under $BASHY_HOME/trove/renders/<sha256(ref+as+presenter)>/ with provenance.json {role, provider, route, inputs sha256, cost_class, run ref}; sources are never written. Presenters = presenters/<as>.bsh (one .bsh = verb + ~~~skill) + presenters.json (audience variants, language, length) exposed as shaped.json properties = THE shaping hook. Accept: --dry-run names rod/route/cost class and runs nothing; second call is a cache hit; a presenters.json override changes the output; a canned render serves with no model call; paid routes refused without --yes. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
