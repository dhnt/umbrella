# Sprint 697 Evidence: Agent-Ready Sites ("The Page Is the Repo Root")

Epic: `software-shaping` · Spec: `docs/sprint-697-master-execution-plan.md` · Design: `docs/agent-ready-sites.md`

All builds and `go test` runs below were executed on the Linux gate host under a claimed lane (`GOWORK=off`). Hosts are referenced by role (`gate-host`, `dev-host`) with no private hostnames, logins, or hosted-plane internals.

---

## 1. Story #674 (`3cca0ba419a0`) — A3b: `bashy` Consumer Verbs, `skills add <url>`, and `fetch` Agent Surface

- **Assignee**: `codex-gpt6.2-sol`
- **Merged Commits**: `yoke` `bd32f1b398d9c185ddae5b2d902c308bd995dde9`, `bashy` `628f7088d0de11e780ca37856ef643b0f09f7401`, `umbrella` `0eefc405db8152ca73d86dfe73efab9d0ad729b7`
- **Independent Security Review (`claude-sonnet5.5`)**: `VERDICT: PASS` (zero blockers; recipe execution gated on explicit `--run`, restricted to `bashy fetch` on same-origin HTTP(S) URLs without credentials, 4 MiB body limit, verified admission gate enforced on `skills add <url>`).
- **Gate-Host Verification**:
  - `go test -count=1 ./cmds/fetch/... ./pkg/skills ./pkg/atlas` (`yoke`) — PASS (`cmds/fetch`, `cmds/fetch/agentwire`, `pkg/skills`, `pkg/atlas`).
  - `go test -count=1 -run 'TestSrcPinsMatchLinkedModules|TestSiteVerbs|TestCommandsCatalogSources' ./internal/agentos` (`bashy`) — PASS.
  - Cross-verification against `github.com/dhnt/site` (`v0.2.0` / `v0.2.1`):
    - `bashy site explore --json http://127.0.0.1:<port>/about` parsed `/agents.txt`, `Bashy-Shaped`, `Link` relations, and `agent:` front matter.
    - `bashy site cite http://127.0.0.1:<port>/about#mission` returned deterministic `{url, section_id, revision, section_sha256, quote}`.
    - `bashy site recipe` printed the recipe without executing by default, refused cross-origin fetch targets (`outside the page origin`), and executed same-origin `bashy fetch` lines only under explicit `--run`.
    - Graceful refusal (`not an agent-ready site`) verified against an unannounced catch-all HTTP server.

---

## 2. Story #671 (`6e09c8e7b034`) — A1: Site Template Multi-Channel Announcement, Markdown-First, and `dhnt/site` `v0.2.1`

- **Assignee**: `muse-wonder`
- **Merged Commits**: `bashy` `769c9751eabe116e25da59edbeca40b7539851e1`, `github.com/dhnt/site` `0bf648457f1a` (`v0.2.0`) + `f924301cab646099df84a8337ea119c4ad1245b2` (`v0.2.1`), `umbrella` `d450b7e130d437e1f582b1a113fc62b4215bf470`
- **Gate-Host Verification**:
  - `go test -count=1 ./...` in `examples/shaping/site/template` — PASS (`TestStandaloneDeps` stdlib-only closure + channel, negotiation, equivalence, and twin parity tests).
  - `go test -count=1 .` in `examples/shaping/site` — PASS (generator + check harness).
  - `go test -count=1 ./...` in `github.com/dhnt/site@v0.2.1` — PASS.
  - `site.bsh check` on `github.com/dhnt/site@v0.2.1` — `render-determinism: pass`, `unique-ids: pass`, `links-resolve: pass`, `stale-base: pass`.
  - Wire-level spot-checks on template & `dhnt/site@v0.2.1`:
    - `HEAD /about` and `404` responses carry `Bashy-Shaped` (configured relative/external paths, `module`, `revision`) and RFC 8288 `Link` (`alternate` `text/markdown` + `application/json`, `describedby`, `edit`, `via`, `service-doc`, `service-desc`, `canonical`, `author`, `help`).
    - `/agents.txt`, `/AGENTS.md`, `/README.md`, `/skill.md`, `/llms.txt` (with preamble), `/humans.txt`, `/robots.txt`, `/sitemap.xml`, `/feed.xml`, `/.well-known/agent-skills/index.json` (0.2.0), `/.well-known/mcp/server-card.json` (8 site tools), `/.well-known/oauth-protected-resource`, `/.well-known/agent-card.json`, `/.well-known/api-catalog`, and `/.well-known/security.txt` return `200`.
    - HTML pages include `<script id="agent-recipe" type="text/bashsharp">`, `<div hidden>`, `<noscript>`, DOM-first `<p id="agent-note" role="note">`, `<section id="agents">` (text-equivalent to hidden/noscript twins), and JSON-LD `@graph` (`WebSite` + `SoftwareSourceCode` with `codeRepository`).
    - Listing-order `Accept` tie-break (`Accept: text/markdown, text/html` -> `text/markdown`) and `agent_user_agents` Markdown-first serving verified with identical content revisions across representations.
    - `SITE_ORIGIN=http://127.0.0.1:<port>` + `bashy site recipe --run http://127.0.0.1:<port>/about` exited `0`.

---

## 3. Story #673 (`cbddad1931f9`) — A3: Site MCP Endpoint (`bashy mcp serve --tools site`) and Outpost Companion `<app>/mcp` Proxy

- **Assignee**: `claude-opus5.5`
- **Merged Commits**: `outpost` `ca3352115ca900b2fe2a8c7de7b3b73563643733`, `bashy` `0090cfe2e089663fd43ebe3528d8196793481042`, `umbrella` `0255eff9358380c14e40423f5c97269646423792`
- **Independent Security Review (`claude-sonnet5.5`)**: `VERDICT: PASS` (zero blockers; `coopauth` HMAC + relationship stamp verification with `0600` `agent.json`, dedicated 8-tool surface with zero shell/`run_tool` exposure, `outpost` expose + `require_login` ordering, and `401 WWW-Authenticate` with RFC 9728 `resource_metadata` verified).
- **Gate-Host Verification**:
  - `outpost`: `go vet ./internal/agent ./internal/agent/admincore ./internal/agent/mcpapi ./internal/agent/conf` — PASS; `go test -count=1 -tags fb_archives -run 'TestSiteMCP|TestProxy|TestHostGrants|TestApp|TestRegister|TestBashyMCP' ./internal/agent` (26/26 PASS, 0 SKIP) + `./internal/agent/{admincore,mcpapi,conf}` — PASS.
  - `bashy`: `go test -count=1 -run 'TestSrcPinsMatchLinkedModules|TestSiteMCP|TestMCP|TestSkillHelp' ./internal/agentos` — PASS (incl. `TestSiteMCPReadsRealTemplate` against merged A1 `v0.2.1` template, after refreshing unpaired `sprint.skill` golden from concurrent Sprint 652 commit `6fc9da6f41ac`).
- **Real Fleet MCP Client Acceptance (`<origin>/mcp` via `outpost` `AppRegistry.ProxyTo`)**:
  - **Claude Code 2.1.284** (`claude mcp add --transport http`): connected; verified `read_page` (`/about`) + `cite` (`/about#team` matching `sections[].sha256`); `member` `shape_undo` refused by name and tier; signed-in `owner` completed `shape_verify`, `shape_preview`, `shape_approve`, and `shape_undo` end-to-end through MCP.
  - **Codex 0.157.1**: connected via Streamable HTTP; verified `read_page` + `cite` (`/about#contact` matching `sections[].sha256`); `member` `shape_wish` refused by name and tier.
  - **OpenCode 2.2.6** (`opencode mcp add --url`): connected; verified `read_page` + `cite` (`/about#about` matching `sections[].sha256`); `member` `shape_approve` refused by name and tier.
  - **Anonymous caller**: public `list_pages` / `read_page` / `cite` allowed; `shape_undo` refused (`refused: caller anonymous (tier anonymous) is not authorized for shape_undo; owner tier required`, audit exit `126`).
  - **Gemini CLI**: binary absent on `dev-host` (scheduled on `gate-host` in A5).
