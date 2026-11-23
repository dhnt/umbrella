---
id: 7e1330837e36
kind: doc
title: 'A6 Docs: index the design; kb runbook ''make your site agent-ready''; bashy README and skill section on agent-ready sites and the MCP endpoint'
seq: 677
status: done
priority: p2
created: 2026-11-23T13:51:46.371639Z
assignee: muse-wonder
sprint: 697
closed: 2026-11-23T20:28:19.857101Z
closed_by: agy-gemini4-carbon
---

docs/agent-ready-sites.md indexed (INDEX/README); kb runbook for site owners (template verbs, what to publish, how to set the MCP endpoint, how agents will behave); bashy README 'For agents' and the bashy skill gain the convention so an agent that knows bashy treats any agent-ready page correctly and vice versa; scrub gate clean. Plan: docs/sprint-697-master-execution-plan.md (vendor proposal agy-gemini4-carbon; reassigned to muse-wonder per Finding 7 and Directive #1). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.

WAVE 1 CONTRACT & FILE DISJOINTNESS (binding):
- DISJOINT FILES: Touch ONLY `bashy/README.md`, `bashy/skills/bashy/SKILL.md`, `umbrella/docs/agent-ready-sites.md` (aligning the stories table and reserved decisions list with the Sprint 697 card per Finding 8), `umbrella/docs/kb/**` (authoring the `make-your-site-agent-ready` runbook via `bashy kb` verbs — NEVER edit `docs/kb/pages/*.md` or `graph.jsonl` by hand!), and `umbrella/docs/INDEX.md` + `umbrella/docs/README.md` (coordinate with any active Sprint 682 edits before staging `INDEX.md`/`README.md`). Do NOT touch `bashy/examples/**`, `bashy/internal/**`, `yoke/**`, or `outpost/**`.
- CONTRACT TO DOCUMENT (must match shipped code, never invent flags or env vars — verify against `--help` and A1/A3/A3b):
  * Channels: `/agents.txt` (`key: value` header + prose block), `Bashy-Shaped` header, `Link` relations (`alternate`, `describedby`, `edit`, `via`, `service-doc`, `service-desc`, `canonical`, `author`, `help`), `<script type="text/bashsharp">` + `<div hidden>`/`<noscript>` equivalence with visible `## For agents {#agents}`, DOM-first `<p id="agent-note" role="note">`, Markdown-first serving with listing-order `Accept` tie-break and `agent_user_agents`, `/AGENTS.md`, `/skill.md`, `/llms.txt`, `/.well-known/agent-skills/index.json` (0.2.0), `/.well-known/mcp/server-card.json`, `/.well-known/oauth-protected-resource`.
  * MCP endpoint: same-origin `<origin>/mcp` Streamable HTTP proxy (`POST` + SSE `GET`, no redirect) to `bashy mcp serve --transport http --tools site` (`list_pages`, `read_page`, `cite`, and owner-gated `shape_wish`, `shape_verify`, `shape_preview`, `shape_approve`, `shape_undo`).
  * Consumer verbs: `bashy site explore|attach|cite|shape|recipe <url>`, `bashy skills add <url>`, `bashy fetch`.
- VENUE & PROVENANCE: Run `script/scrub-gate.sh` and `bashy kb doctor` before submitting. Branch `s697-7e1330837e36`; commit with `BASHY_AGENT=muse-wonder` and trailers `Sprint: #697` / `Sprint-ID: 5d15f9ec-14ca-5581-9c41-4d7163843b82` / `Story: #677` / `Story-ID: 7e1330837e36` / `Agent: muse-wonder`. Public scrub rule: describe hosts by role only, never machine names, logins, IPs, or home paths.

agy-gemini4-carbon rejected story 7e133083: Wave 1 draft clean; returning for Wave 3 final alignment post-A3/A4: document --site-app|--site-dir on bashy mcp serve --tools site, document A4 bashy site key + --sign + site.json trusted_bot_keys/trusted_key_directories/trusted_origins + Decision 3 settled, and index docs/sprint-697-evidence.md in INDEX.md + README.md.

WAVE 3 FINAL ALIGNMENT (Conductor 697 — post-A1/A3/A3b/A4 merge):
Your Wave 1 draft commits are preserved on GitHub branch `s697-7e1330837e36` in both `umbrella` (`d14e8c0ec`) and `bashy` (`350eb4dc`). Note: in a weave outer workspace, fetch `umbrella` directly via `git fetch git@github.com:dhnt/umbrella.git main:refs/remotes/gh/main s697-7e1330837e36:refs/remotes/gh/s697-7e1330837e36` (cherry-pick `d14e8c0ec` onto `gh/main`), and in `bashy` run `git fetch origin && git checkout -B s697-7e1330837e36 origin/s697-7e1330837e36 && git rebase origin/main`. Apply these final contract alignments against shipped code:
1. **`bashy mcp serve --tools site` required target flag**:
   - In `docs/kb/pages/make-your-site-agent-ready.md` (via `bashy kb edit make-your-site-agent-ready ...` — NEVER hand-edit `docs/kb/pages/*.md`!), `docs/agent-ready-sites.md`, `bashy/README.md`, and `bashy/skills/bashy/SKILL.md`: note that `bashy mcp serve --transport http --tools site` takes `--site-app <app>` (or `--site-dir <dir>`) and `--outpost` when fronted by outpost's `<app>/mcp` reverse proxy.
2. **A4 Identity & Web Bot Auth verbs/config (now merged on `main`)**:
   - Document `bashy site key [--json]` (prints the outpost Ed25519 public key JWK + RFC 7638 `keyid` for `site.json`), `--sign` (`BASHY_SIGN_REQUESTS=1`) and `--signature-agent <https-url>` (`BASHY_SIGNATURE_AGENT`) on `bashy fetch` and `bashy site` verbs, and `site.json`'s optional `trusted_bot_keys`, `trusted_key_directories`, and `trusted_origins` (emitting `Bashy-Verified-Agent` while never gating or altering page content).
   - In `docs/agent-ready-sites.md` (`## Decisions`) and `docs/README.md`: update Decision 3 to settled (`A4` landed optional RFC 9421 Web Bot Auth signing + `site.json` verification alongside stable `bashy-fetch/<version>` and `bashy-site/<version>` user agents).
3. **Index `docs/sprint-697-evidence.md`**:
   - Add `sprint-697-evidence.md` to `docs/INDEX.md` and `docs/README.md`.
4. Run `bashy kb doctor`, `bashy ./script/scrub-gate.sh --all`, keep `s697-7e1330837e36` branch commits clean (do NOT bump `umbrella` submodule pins or push `main`), and submit!

DELIVERY & GATE VERIFICATION:
- Commits merged linearly: `bashy` `9446986ebe2d129fea85580adaa5de71a2bb7392`, `umbrella` `28c9dfacff4c17bc9819748cfcf26723ee5cfc86` (pin bump `acff3132ff8b88955212bccc86385ff1ea2d4ce5`).
- Verification: `bashy kb show make-your-site-agent-ready` OK; `bashy kb doctor` clean; `script/scrub-gate.sh --all` exit 0; gate-host `go test -count=1 -run 'TestSkillHelp|TestCommandsCatalogSources' ./internal/agentos` PASS; all flags/verbs verified against shipped `A1`/`A3`/`A3b`/`A4` source.
