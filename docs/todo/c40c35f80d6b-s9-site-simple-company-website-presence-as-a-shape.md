---
id: c40c35f80d6b
kind: feature
title: 'S9 site: simple company website/presence as a shapeable custom command'
seq: 217
status: todo
priority: p2
labels:
    - shaping
created: 2026-11-13T11:41:34.072356Z
assignee: agy-gemini3.8-flash
sprint: 631
sprint_id: c3371fe2-016d-501e-8cf4-fb570a3cca03
sprint_title: 'Shapeable apps: fork-or-build first batch'
---

READ docs/shapeable-apps-worker-brief.md FIRST (rules, shaping contract, done means). Scope: Linux + web UI only this sprint. Fork-or-build rule: permissive license only (LICENSE read, no open-core), >=1k stars, maintained -> fork + make shapeable; else build. Custom command in bashy/examples/site/, never core; job-only public wording. Base: gohugoio/hugo (Apache-2.0, Go) generator + sveltia/sveltia-cms (MIT) editor at /admin; optional puck (MIT) / GrapesJS (BSD-3) drag-and-drop. Serve output via the existing site app type; share via outpost or GitHub Pages (as examples/vlog). Done = shaping demo (e.g. add a pricing section only on my copy) + license re-verified.

NEW/START A NEW SITE option (operator, 2026-11-13): fork firecrawl/open-lovable (MIT, 28.9k stars, TS/Next.js; LICENSE read 2026-11-13) as the chat-to-generate starting point for a brand-new site. The site command offers it as a "start a new site" option next to the Hugo template. Self-hosting patches in our fork: replace the hosted sandbox provider (Vercel/E2B) with the local bashy oci sandbox (podman), route LLM calls through our configured gateway or provider (no vendor key required), and make the Firecrawl site-cloning feature optional and off by default. Scope: Linux + web UI.

REWORK (conductor review 2026-11-13, run #45 rejected, tip preserved at refs/salvage/abandoned-45 = bashy a558cbab): (1) sample/static/admin/index.html loads Sveltia CMS from unpkg.com at runtime - vendor the pinned MIT build locally (no-phone-home gate must be clean). (2) Do not commit Hugo build output (sample/public/). (3) The chat/open-lovable option is MOVED to story S9b; remove the --template chat stub and open-lovable.md, which described a fork (qiangli/open-lovable) and patches that do not exist - never document work that was not done. Keep the Hugo template + Sveltia + shaping demo; start from the salvaged tip.
