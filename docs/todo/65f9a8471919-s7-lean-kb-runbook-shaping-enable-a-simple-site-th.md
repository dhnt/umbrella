---
id: 65f9a8471919
kind: doc
title: 'S7 lean kb runbook: shaping-enable a simple site (the steps that ran)'
seq: 116
status: assigned
priority: p2
labels:
    - shaping
    - docs
created: 2026-11-11T04:32:53.947998Z
weave: 82
assignee: muse-conductor
sprint: 615
sprint_id: 899fe465-c505-558d-a1f3-44a74a977e92
sprint_title: Shaping host on free cloud workspaces
---

Planned vendor: muse. Write the standard steps as umbrella doc docs/shaping-enable-a-website.md for the site OWNER: what you get (the four visitor tiers and what the site learns from each); what you need (a static site, a GitHub account, a cloudbox account, a satellite, one OpenAI-compatible route: GitHub Models, Gemini free, Groq, OpenRouter free, or bashy llm on your own machine); the steps: website.bsh assess, enable into a PRIVATE companion repo, edit site.json and fields/*.md (audience front matter, fail closed), open in a Codespace with three secrets (BASHY_PAIR_CODE, SHAPING_SATELLITE, SITE_AI_KEY) or run shaping-host up + website serve on your own machine, register for owner shaping (bashy shape), and add the one link to the static site; then verify and graduate. Sources of truth, read them and do not invent: bashy/examples/shaping/website/{README.md,website.bsh,template/site.json,template/.devcontainer/devcontainer.json}, bashy/examples/shaping-host/shaping-host.bsh (its skill face), outpost/docs/cooperative-web-apps.md (relationship section). Add one line to docs/INDEX.md and an abstract to docs/README.md. Generic names only: say 'your site', example.com, never the operator's site or hosts. After the live run (S14) the conductor will amend it with what actually happened. COMMIT RULES: commit only docs/shaping-enable-a-website.md, docs/INDEX.md, docs/README.md in the umbrella with trailers Sprint: #615 / Story: #116 / Story-ID: 65f9a8471919 (plus your Agent trailer); never git add -A; do not push. Run script/scrub-gate.sh before committing.
