---
id: 14d2d8b5af97
kind: feature
title: 'A4 bashy identity for sites: distinct user agent + optional signed requests (Web Bot Auth shape, outpost key); site-side verification; MCP auth as the reliable cooperative-agent signal'
seq: 675
status: todo
priority: p2
created: 2026-11-23T13:51:46.069345Z
assignee: claude-opus5.5
sprint: 697
---

Design: docs/agent-ready-sites.md Layer 2 (identity). bashy fetch and the site verbs send a stable user agent and, when the owner enables it, sign requests with the outpost identity in the HTTP Message Signatures (RFC 9421) Web Bot Auth shape with a public key directory; the template verifies signatures and may unlock agent-only affordances for verified bashy agents only; the MCP endpoint's authentication is the primary signal. Detection never gates content (no cloaking). Plan: docs/sprint-697-master-execution-plan.md (vendor proposal claude-opus5.5; the conductor assigns). WORKER RULES: branch off the repo's integration branch; commit with trailers Sprint: #697 / Sprint-ID: <uuid on the card> / Story: #<seq> / Story-ID: <id> / Agent: <your name>; targeted tests only, builds on the gate host; do not bump umbrella pins or push umbrella; submit with bashy sprint submit 697 <id> --as <your name> -m '<verify commands, results, commit SHA>'.

DEPENDS (story review 2026-11-23, finding 6): starts after A3b and A3. The acceptance line 'the MCP endpoint refuses an unauthenticated shape call' is A3's deliverable, kept here as the cross-check, not as A4's own work.

WAVE 2 INTERFACE & DELIVERY CONTRACT (Conductor 697 — post-A1/A3/A3b merge):
1. Prerequisites merged on `main`:
   - `A1` (`6e09c8e7b034`): `bashy/examples/shaping/site` (`v0.2.1` channels, `DefaultAgentUserAgents` already includes `"bashy-fetch"` and `"bashy-site"`, `TestStandaloneDeps` enforces Go stdlib-only in `examples/shaping/site/template` — NEVER add external module dependencies to `examples/shaping/site/template`!).
   - `A3b` (`3cca0ba419a0`): `yoke/cmds/fetch` (`bashy fetch`) and `bashy/internal/agentos/site_verbs.go` (`site explore|attach|cite|shape|recipe`).
   - `A3` (`cbddad1931f9`): `bashy mcp serve --tools site` + `outpost` `<app>/mcp` same-origin proxy (`outpost/internal/agent/apps.go`).
2. Required deliverables across `yoke`, `outpost`, `bashy`, and `bashy/examples/shaping/site/template`:
   - **Stable User-Agent**:
     * `yoke/cmds/fetch` sends a stable `bashy-fetch/<version>` (or `bashy-fetch` when version is unset; keep `bashy-fetch` prefix so `IsAgentUserAgent` matches) unless overridden by `--user-agent`.
     * `bashy/internal/agentos/site_verbs.go` (`siteGet`) and `yoke/pkg/skills` HTTP skill fetches send a stable `bashy-site/<version>` (keeping `bashy-site` prefix).
   - **Optional RFC 9421 Web Bot Auth request signing + Outpost public key directory**:
     * Key material: reuse outpost's persistent Ed25519 host key (`<UserConfigDir>/matrix/ssh_host_ed25519`, `outpost/internal/agent/hostkey.go`, OpenSSH Ed25519 private key format; support an env/path override for hermetic tests so tests never touch a real user config dir).
     * Public key directory: expose `GET /.well-known/http-message-signatures-directory` (`Content-Type: application/http-message-signatures-directory+json`, JWK Set `{ "keys": [{ "kty": "OKP", "crv": "Ed25519", "x": "<base64url-pub>", "kid": "<jwk-sha256-thumbprint>" }] }`, optionally signed with `Signature`/`Signature-Input` over `@authority`) on outpost's public/app ingress (and provide a helper/CLI verb or flag so a site owner can export their public JWK / key-id into `site.json` or configure a key directory URL).
     * Signing opt-in (owner-enabled, off by default unless requested): support `--sign` flag and/or env/config opt-in (`BASHY_SIGN_REQUESTS=1` / `--sign` + optional `--signature-agent <https-directory-url>`) on `bashy fetch` (`yoke/cmds/fetch`) and `bashy site` verbs (`bashy/internal/agentos/site_verbs.go`). When enabled, sign outbound HTTP requests using RFC 9421 HTTP Message Signatures (`alg="ed25519"`, `keyid="<kid>"`, `tag="web-bot-auth"`, `created=<unix>`, `expires=<unix>`, `nonce="<random>"`, covering `@authority` — plus `@method`, `@target-uri`, and `signature-agent` when `Signature-Agent` is set — emitting `Signature-Input: sig1=(...)` and `Signature: sig1=:<base64>:` headers).
   - **Template-side verification (`bashy/examples/shaping/site/template`, Go stdlib ONLY — `crypto/ed25519` is stdlib)**:
     * Extend `site.json` (`Config`) with optional bot-verification trust config (e.g., `trusted_bot_keys` static Ed25519 public keys / JWKs by `kid`, and/or `trusted_key_directories` allowlisted origins for `Signature-Agent` — strictly SSRF-safe: only allowlisted origins, bounded timeout/body, never arbitrary open-world SSRF on untrusted `Signature-Agent` headers!).
     * Verify RFC 9421 Ed25519 `web-bot-auth` signatures (`created`/`expires` window check, `alg="ed25519"`, `tag="web-bot-auth"`, signature base reconstruction).
     * **No cloaking rule (load-bearing)**: Detection and verification NEVER gate or alter page content (`HTML`, `Markdown`, `JSON`, `ETag`/revision must remain 100% identical between signed, unsigned, and browser requests so `site check` and caches stay clean!). Instead, when a request carries a valid verified signature from a trusted bashy key, surface verification + agent-only affordance metadata cleanly via response header (e.g. `Bashy-Verified-Agent: keyid="<kid>"; shape="<origin>/?shape=open"; mcp="<origin>/mcp"`) and/or a dedicated verification/handshake endpoint if needed, while invalid/expired signatures are NOT marked verified and still receive normal public content (never 401/403 on public pages).
   - **Acceptance & gate-host verification**:
     * First `git fetch origin && git checkout -B s697-14d2d8b5af97 origin/main` in each touched submodule (`yoke` >= `8278811066ba`, `outpost` >= `ca3352115ca9`, `bashy` >= `0090cfe2e089`) so your branch starts on the merged Wave 1 heads.
     * Run all builds and `go test` on the gate host under a claimed gate-host lane (never on the dev box). Tip: stream `COPYFILE_DISABLE=1` `.tar.gz` archives over stdin to the registered gate-host WSL helper (`*_WSL_VIA=ssh` `BatchMode=yes` mode) to avoid interactive elevation prompts, run Go via `/usr/local/go/bin/go` (`GOWORK=off`), and always release the claimed lane on exit.
     * Prove `TestStandaloneDeps` still passes in `examples/shaping/site/template` (stdlib only!).
     * Prove end-to-end: (a) a signed `bashy fetch` (and `bashy site explore --sign`) against the template server is cryptographically verified (`Bashy-Verified-Agent` present), (b) an unsigned `bashy fetch` receives the exact same page body & `ETag` without `Bashy-Verified-Agent`, (c) tampered/expired/untrusted-key signatures are rejected for verification while still serving identical public content, and (d) cross-check against A3's `bashy mcp serve --tools site`: unauthenticated `shape_*` call is refused while MCP auth remains the primary cooperative-agent signal.
     * Keep commits clean on `s697-14d2d8b5af97` in each touched repo (`yoke`, `outpost`, `bashy`) with required trailers (`Sprint: #697`, `Sprint-ID: 5d15f9ec-14ca-5581-9c41-4d7163843b82`, `Story: #675`, `Story-ID: 14d2d8b5af97`, `Agent: claude-opus5.5`). Do NOT push `main` or bump `umbrella` pins (manager repins and merges linearly).
