---
id: 4dcd6f0ffdaf
kind: bug
title: A2b Satellites must not serve the operator's public site pages (agents.txt, skill.md, server card, sitemap...) introduced by 697 A2
seq: 747
status: assigned
priority: p0
labels:
    - release
    - hosted-plane
created: 2026-11-25T07:27:41.605859Z
weave: 266
assignee: codex-gpt6.2-astra
sprint: 699
sprint_id: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a
sprint_title: 'Release train 1: one hosted-plane deploy for Sprints 682/697 + live verification'
---

Root cause (release manager, 2026-11-25; recorded on the hosted todo 376365ab): same-venue bisect of the satellite route table test (build tag cloudbox_satellite) is green before 697 A2's first hosted commit and red from it onward (419 -> 451 routes). The 32 added routes are the public site pages and their HEAD twins (/agents.txt, /skill.md, /AGENTS.md, /llms.txt, /index.md|json, /about.*, /humans.txt, /robots.txt, /sitemap.xml, /feed.xml, /.well-known/{mcp/server-card.json, agent-card.json, agent-skills/index.json, api-catalog, security.txt}). So every owner's satellite would serve the operator's own site and agent block. That contradicts the signed-out satellite page fix in this same train (satellites show only a minimal sign-in page). Classification: product defect. Not visible in A2's own gate, which refreshed only the master and standalone route goldens.
FIX (smallest): register the public site paths only on the primary and standalone roles, never on a satellite. The satellite route golden must then equal the pre-A2 route set plus only intended later changes (diff reviewed line by line, not blindly regenerated). Satellite /health, /readyz and /.well-known/matrix/client stay.
ACCEPT: satellite-tagged and default go test for the hub server package green on a gate lane with Node >= 24 first on PATH; the satellite golden diff vs pre-A2 is empty or explained per line; a locally built satellite answers 404 (or the SPA shell where it did before A2) for /agents.txt and /skill.md. Lands after A2a (same route-registration area), before the 699 freeze. No deploy.
WORKER RULES: as on A2a 141bc34d (worktree off cloudbox origin/dev, one commit, trailers Sprint: #699 / Sprint-ID: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a / Story: <seq> / Story-ID: <this id> / Agent: <name>, gate-host lane tests, no cloudbox source in public repos).


## Constraint from the 710 conductor (2026-11-25): keep H3 at "/"

710 H3 (hosted dev 89a5932, in train 1) already changed what a satellite serves at "/". In the public-paths loop of the route registration, on a satellite, GET/HEAD "/" no longer serves the public landing: a signed-in visitor gets 302 to /periscope/, and a signed-out visitor gets the SPA index (the minimal sign-in page) with Cache-Control private, no-cache. KEEP that behaviour and its tests (the satellite landing test and the version-mode test). Gate only the REMAINING public paths (agents.txt, skill.md, AGENTS.md, llms.txt, twins, .well-known/*, sitemap, feed, robots, humans and their HEAD twins) off the satellite role.
