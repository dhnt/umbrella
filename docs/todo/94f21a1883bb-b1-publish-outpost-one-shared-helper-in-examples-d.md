---
id: 94f21a1883bb
kind: feature
title: 'B1 publish-outpost: one shared helper in examples/desk/kit puts any catalog app on outpost''s app list (login-required by default)'
seq: 242
status: done
priority: p1
labels:
    - app
    - outpost
created: 2026-11-13T17:39:23.811656Z
weave: 66
assignee: claude-opus5.5
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:28:29.359272Z
closed_by: claude-fable5.1-s632
---

READ docs/shapeable-apps-worker-brief.md and outpost/docs/cooperative-web-apps.md. bashy's app registry (yoke/pkg/fleet/apps.go; console serves /<name>/ on CONSOLE_PORT, default 22749) and outpost's (conf.AppConfig; outpost apps add|rm|list|share) are separate; today only site (examples/site/site.bsh:150-156 publish-outpost) and vlog bridge them, each with its own copy of `outpost apps add NAME --url http://127.0.0.1:22749/NAME/`.

Build ONE shared Bash# helper in examples/desk/kit (the common-verbs home) and wire a `publish-outpost` / `unpublish-outpost` verb into every catalog app's .bsh (notes, form, clips, site, board, whiteboard, table; files is outpost built-in Go, record N/A). Behaviour: `bashy <app> publish-outpost [--public] [--icon URL] [--json] [--dry-run]` registers the console path of the app with the paired outpost (`outpost apps add NAME --url http://127.0.0.1:$CONSOLE_PORT/NAME/ --require-login`, plus --icon from the app's fleet record), idempotent on re-run; --public is opt-in and also sets `app set NAME --auth public` the way site does today (site keeps its current public default, vlog likewise); unpublish runs `outpost apps rm`. These are "just for me" apps: default is login-required, never public. Print the outpost URL the owner can open.

Depends on B0 (todo ce971c6f): outpost drops the URL path today, so the registered target would hit the console root. Do not work around it in the helper; wait for the outpost fix and pin bump.

Tests: targeted unit tests for the helper (argument handling, dry-run manifest, idempotence) with a stubbed outpost. Runtime proof only on the claimed gate venue: `outpost apps list` shows the app; opening the tile through outpost's ingress (post-S2a, login-required) reaches the app under its console prefix. Done when all seven apps expose the verb through the one helper, site and vlog no longer carry their own copy, tests pass, commits carry the provenance trailers.
