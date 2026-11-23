---
id: 7e1330837e36
kind: doc
title: 'A6 Docs: index the design; kb runbook ''make your site agent-ready''; bashy README and skill section on agent-ready sites and the MCP endpoint'
seq: 677
status: todo
priority: p2
created: 2026-11-23T13:51:46.371639Z
assignee: muse-wonder
sprint: 697
---

docs/agent-ready-sites.md indexed (INDEX/README); kb runbook for site owners (template verbs, what to publish, how to set the MCP endpoint, how agents will behave); bashy README 'For agents' and the bashy skill gain the convention so an agent that knows bashy treats any agent-ready page correctly and vice versa; scrub gate clean. Plan: docs/sprint-697-master-execution-plan.md (vendor proposal agy-gemini4-carbon; reassigned to muse-wonder per Finding 7 and Directive #1). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.

WAVE 1 CONTRACT & FILE DISJOINTNESS (binding):
- DISJOINT FILES: Touch ONLY `bashy/README.md`, `bashy/skills/bashy/SKILL.md`, `umbrella/docs/agent-ready-sites.md` (aligning the stories table and reserved decisions list with the Sprint 697 card per Finding 8), `umbrella/docs/kb/**` (authoring the `make-your-site-agent-ready` runbook via `bashy kb` verbs — NEVER edit `docs/kb/pages/*.md` or `graph.jsonl` by hand!), and `umbrella/docs/INDEX.md` + `umbrella/docs/README.md` (coordinate with any active Sprint 682 edits before staging `INDEX.md`/`README.md`). Do NOT touch `bashy/examples/**`, `bashy/internal/**`, `yoke/**`, or `outpost/**`.
- CONTRACT TO DOCUMENT (must match shipped code, never invent flags or env vars — verify against `--help` and A1/A3/A3b):
  * Channels: `/agents.txt` (`key: value` header + prose block), `Bashy-Shaped` header, `Link` relations (`alternate`, `describedby`, `edit`, `via`, `service-doc`, `service-desc`, `canonical`, `author`, `help`), `<script type="text/bashsharp">` + `<div hidden>`/`<noscript>` equivalence with visible `## For agents {#agents}`, DOM-first `<p id="agent-note" role="note">`, Markdown-first serving with listing-order `Accept` tie-break and `agent_user_agents`, `/AGENTS.md`, `/skill.md`, `/llms.txt`, `/.well-known/agent-skills/index.json` (0.2.0), `/.well-known/mcp/server-card.json`, `/.well-known/oauth-protected-resource`.
  * MCP endpoint: same-origin `<origin>/mcp` Streamable HTTP proxy (`POST` + SSE `GET`, no redirect) to `bashy mcp serve --transport http --tools site` (`list_pages`, `read_page`, `cite`, and owner-gated `shape_wish`, `shape_verify`, `shape_preview`, `shape_approve`, `shape_undo`).
  * Consumer verbs: `bashy site explore|attach|cite|shape|recipe <url>`, `bashy skills add <url>`, `bashy fetch`.
- VENUE & PROVENANCE: Run `script/scrub-gate.sh` and `bashy kb doctor` before submitting. Branch `s697-7e1330837e36`; commit with `BASHY_AGENT=muse-wonder` and trailers `Sprint: #697` / `Sprint-ID: 5d15f9ec-14ca-5581-9c41-4d7163843b82` / `Story: #677` / `Story-ID: 7e1330837e36` / `Agent: muse-wonder`. Public scrub rule: describe hosts by role only, never machine names, logins, IPs, or home paths.
