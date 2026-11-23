# Sprint 697 evidence

Agent-ready sites: shipped-contract record. Design of record:
`agent-ready-sites.md`; plan: `sprint-697-master-execution-plan.md`.

## Landed on the integration branch

- **A1 (template channels):** `/agents.txt`, `Bashy-Shaped` header, `Link`
  relations, visible `## For agents {#agents}` + hidden twins with
  `site check` equivalence, `agent:` front matter, `/AGENTS.md`,
  `/skill.md`, `/llms.txt`, Markdown-first serving (listing-order `Accept`
  tie-break + `agent_user_agents`).
- **A3 (MCP endpoint):** same-origin `<origin>/mcp` Streamable HTTP proxy
  (`POST` + SSE `GET`, no redirect) to
  `bashy mcp serve --transport http --tools site --site-app <app>`
  (or `--site-dir <dir>`; `--outpost` behind outpost's `<app>/mcp` proxy);
  tools `list_pages`, `read_page`, `cite`, owner-gated `shape_wish`,
  `shape_verify`, `shape_preview`, `shape_approve`, `shape_undo`.
- **A3b (consumer verbs):** `bashy site explore|attach|cite|shape|recipe
  <url>`, `bashy skills add <url>`, `bashy fetch` surfacing the agent block.
- **A4 (identity):** `bashy site key [--json]` (Ed25519 JWK + RFC 7638
  `keyid`), `--sign` (`BASHY_SIGN_REQUESTS=1`) + `--signature-agent`
  (`BASHY_SIGNATURE_AGENT`) RFC 9421 Web Bot Auth on `bashy fetch` /
  `bashy site`, stable `bashy-fetch/<version>` / `bashy-site/<version>`
  user agents, `site.json` `trusted_bot_keys` /
  `trusted_key_directories` / `trusted_origins` answering
  `Bashy-Verified-Agent` without gating content. Decision 3 settled.
- **A6 (docs):** `agent-ready-sites.md` aligned with the card, kb runbook
  `make-your-site-agent-ready`, `bashy` README + skill convention sections.

## Verification

- `bashy kb doctor` and `script/scrub-gate.sh` run before submit (see the
  story submission note for the recorded output).
