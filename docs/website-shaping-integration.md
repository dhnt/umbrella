# Website software-shaping integration: design of record

Status: design and plan only, written 2026-11-14 for Sprint 638
(`88e86a75-5c83-5528-8a5c-44cc29c43030`). No code. The sprint card and its
stories are authoritative; this document records the review of what exists,
the research, the decision and the reasons. Execution plan:
`sprint-638-master-execution-plan.md`.

## Goal

Let the owner of an **existing live website**, hosted wherever it is hosted
today, make it shapeable with bashy in one step that is close to zero change,
and let owner, members and visitors each get exactly the degree of change the
owner allows. The first site is the company website itself (dogfood).

Software shaping is defined in bashy `docs/software-shaping.md`: anyone tells
an agent in plain words how a running tool should work and gets their own
verified, reversible version, while everyone else keeps theirs. This document
does not redefine it; it decides how a website that bashy does not serve joins
that loop.

## What exists today (reviewed 2026-11-14)

The engine shapes only source that bashy hosts itself.

| Piece | What it does | Where |
|---|---|---|
| `bashy shape` CLI | wish, show, diff, verify, preview, approve, reject, history, undo, restore, submit; promotion `remote`, `outgoing`, `push`, `incoming`, `pull`; `--page`/`--element` on `wish` | bashy `internal/agentos/shape.go`, `shape_promotion.go` |
| App registry | one YAML per app; `type: shaped` needs an absolute `source`; import copies a directory (dropping `.git`) or clones a git URL into the managed checkout; unknown YAML keys are refused | yoke `pkg/fleet/apps.go`, `shaped_import.go` |
| Per-principal versions | one managed git checkout per app, one ref line per principal; a request with no principal is served the base revision, full stop | yoke `pkg/src/activate.go`, `pkg/webconsole/shaped.go` |
| Static web kind | `public/` served straight from the principal's active commit at `/<app>/`; previews at `/shape/<app>/preview/<id>/`; no fallback for extensionless paths | yoke `pkg/webconsole/shaped.go` |
| Server kind | `shaped.json` `server.main` is built with `go build` per active revision; a Node server is not run by the engine | yoke `pkg/webconsole/shaped_server.go` |
| Verifier | `contract.bsh` effect cap and `checks/*.bsh` frozen from the base; candidates and verifier runs are isolated clones with a scrubbed environment; a per-app protected-path list refuses candidates that touch it; declared `properties` may not be removed or renamed | yoke `pkg/shape/verify`, `pkg/shape/appserver/manifest.go` |
| Protected-page requests | a wish filed from a protected page is recorded as a request for the maintainers; nothing is built | yoke `pkg/webconsole/shaped_candidate.go` |
| Genie button | injected server-side into pages the console serves; same-origin REST with polling; `/_shape/genie.js` is the one open asset; element picker records a tag/id/class path plus a text snippet | yoke `pkg/webconsole/genie.go`, `artifact/genie.js` |
| Shape page | `/shape/<app>/` with the wish form; the server accepts `page` and `element` in the wish body but the page does not read them from the URL | yoke `artifact/shape.js` |
| Promotion remotes | `push`/`pull` only for six hard-coded open-source repos | yoke `pkg/src/repos.go` |
| Reach | the console is published through outpost as the `apps` app, so a shaped app is reachable through the hosted relay at `/matrix/h/<host>/app/apps/<app>/`; identity arrives as the documented `Remote-User` family of headers | outpost `docs/cooperative-web-apps.md` |

Gaps that matter for a website: nothing lets a page the console does not
serve carry the Shape entry point (the proxied-app case is the open S527
follow-up); the Shape page cannot be deep-linked with the page the wish is
about; only Go servers can be shaped; promotion cannot reach a site's own
repo; and no policy says what a non-owner may change.

## Research: how others reach existing websites (2026)

1. **One-line script widgets that patch the DOM.** A script tag added to the
   site, edits described in plain English and applied client-side, one-click
   reversal, owner-only. Positioned as a surgical tool, not for structural
   change ([Microedits](https://microedits.com/)).
2. **Per-user AI userscripts in a browser extension.** The user describes a
   change for any site, an AI writes a small script, the extension re-applies
   it on every visit; Greasemonkey-compatible libraries of thousands of tweaks
   ([Tweeks](https://www.tweeks.io/), MIT Media Lab
   [Personal UI](https://www.media.mit.edu/projects/personal-ui/overview/),
   [Browser Code](https://dev.to/tumf/browser-code-teaching-ai-to-grow-userscripts-3npj)
   on the `chrome.userScripts` API, which needs a per-extension user toggle and
   re-registration on update
   ([Chrome docs](https://developer.chrome.com/docs/extensions/reference/api/userScripts))).
3. **Click an element, change the source.** Visual-edit modes that attach the
   selected element to the prompt and patch the code: Lovable Visual Edits
   ([docs](https://docs.lovable.dev/features/design)), stagewise (AGPL-3.0,
   toolbar over a locally running app, any MCP agent;
   [launch](https://www.ycombinator.com/launches/O3M-stagewise-the-frontend-coding-agent-for-production-codebases)),
   Onlook (Apache-2.0, build-time `data-oid` attributes, AST-level write-back;
   [repo](https://github.com/onlook-dev/onlook)); Vite source-locator plugins
   that stamp `data-source-location` on elements
   ([example](https://www.npmjs.com/package/@builder.io/vite-plugin-jsx-loc)).
4. **Zero-change injection at the edge.** A reverse proxy rewrites HTML
   responses to add a snippet, origin untouched: Cloudflare Workers
   HTMLRewriter ([example](https://dev.to/irrelevantspace/one-worker-to-track-them-all-injecting-analytics-scripts-into-multiple-websites-with-cloudflare-workers-1j5b)),
   Caddy `replace-response` ([module](https://github.com/caddyserver/replace-response)),
   Traefik rewrite-body plugins ([plugin](https://github.com/traefik/plugin-rewritebody)).
5. **Agent-callable site tools.** WebMCP: a page registers tools with
   `document.modelContext` (Chrome 146+, W3C working group with Mozilla and
   Apple) so agents act through declared tools instead of scraping
   ([status](https://dev.to/ai-agent-economy/webmcp-in-2026-which-browsers-support-navigatormodelcontext-complete-compatibility-status-1oe4)).
6. **Widget hygiene.** Shadow DOM or a sandboxed cross-origin iframe for
   isolation, async loaders, nonce-based CSP, Trusted Types compliance, a
   narrow `postMessage` allow-list, CORS scoped to registered origins
   ([CSP Embedded Enforcement](https://www.w3.org/TR/csp-embedded-enforcement/),
   [widget isolation](https://dev.to/dhinesh_ks_9db13f15d64f7/building-a-new-gen-chat-widget-css-and-javascript-isolation-with-cross-origin-iframes-4ag6)).

What the research says about "fool-proof": every failure mode of the runtime
approaches (1, 2, 4) is in the integration layer itself: content security
policies and Trusted Types reject injected code, third-party cookies no longer
carry identity, selectors break when the site changes, single-page apps undo
the patch on re-render, and the agent edits the rendered DOM rather than the
source, so nothing can be promoted back. The products that live there are
owner-only cosmetic editors. The approaches that change source (3) are the
ones that match shaping's promises: verified, on the same history, promotable.

## Decision: engine-hosted copy plus a link badge

**The site stays where it is. The engine hosts the shaped copy. The page
carries one link.**

- The **engine** is a bashy console behind outpost or a satellite, where the
  site's source is registered as an ordinary `type: shaped` app. Every member
  sees their own verified version at the engine; approval, undo, history and
  verification are the existing lifecycle, unchanged.
- The **badge** on the public page is a plain anchor with the Flow mark that
  deep-links to the engine's Shape page for the current page. The site makes
  no call to the engine. Visitors are untouched by construction: the public
  page is unchanged, and an anonymous request at the engine is served the
  base revision.
- **Members** log in at the engine with the identity they already have through
  outpost or the satellite. No new identity system, no cookies on the site.
- **Promotion** is the existing path: `shape submit`, then `shape push --to
  upstream --pr` opens a pull request on the site's own repo; the site's own
  deploy ships it to everyone.

This adopts the operator's suggestions (engine separate, link only, dhnt.io
first) because the review and the research point the same way, not because
they were given.

### The badge, two tiers

| Tier | What | Properties |
|---|---|---|
| **0, the floor** | `<a href="<engine>/shape/<app>/?page=<path>">` with the inline `flow.svg` and the wording from the design archive: action **Shape**, accessible name **Shape this app**, capability badge **Shapeable with Bashy** | no JavaScript, no new CSP entry, nothing for an ad blocker to block; works in a no-JavaScript fallback and in a README |
| **1, optional** | `badge.js`, vendored into the site, never loaded from the engine | renders the button in a Shadow DOM, offers the element picker (a port of the Genie's `describe()`), composes the same link, opens the engine in a new tab with `noopener`; no fetch, no cookies, no storage; builds DOM with `createElement` only so Trusted Types pass; `?shape=off` kill switch; idempotent re-mount if the page re-renders |

The engine does not serve `badge.js` to visitors. Behind outpost the console
is one `require_login` app, so a visitor's cross-origin script request would
be refused at the edge; vendoring is the robust path and keeps the floor (the
anchor) working if the script fails.

### Public link contract

Query names reuse the engine's own JSON: `page` (app-relative path and query,
at most 256 characters, the Genie's existing cap) and `element` (the picker's
description string). Today's reachable form is the relay path
`https://<relay>/matrix/h/<host>/app/apps/shape/<app>/?page=…&element=…`.
Proposed stable door: `https://tessaro.sh/shape/<host>/<app>/?page=…&element=…`,
rewritten by the hosted plane to the form above. The routing is a hosted-plane
ticket outside this repository, through the public wire contract only; the
badge takes the engine base as data, so either form works.

### Hosting a built site on the engine

The company website is a Vite/React single-page app in a private repository.
Facts that shape the plan:

- the engine builds only Go servers, so the built `dist/` is committed as
  `public/` and a check rebuilds it and fails on a diff, which makes the
  committed output verifiable;
- Vite must build with a relative `base` so assets resolve under `/<app>/`
  and under the relay prefix;
- `checks/`, `contract.bsh`, `shaped.json` and `public/` live at the tree
  root, and a directory import drops `.git`, so a sub-folder of a larger repo
  cannot feed the pull-request path. **The website should be its own repo**
  (a subtree split; the larger project consumes it). A manifest `root` key is
  a medium engine change and not recommended for this slice;
- history-routed pages need a small engine change (serve `index.html` for an
  extensionless miss); hash routing avoids it.

## Shaping levels and invariants

What a person may change is stated per level in an owner-owned **shape
policy**, enforced by the verifier and the wish intake, never by the model's
goodwill. Three default levels; the set is owner-defined (the same lesson as
circles), so the policy is a list, not a closed enumeration.

**Invariant at every level, never shapeable:** the engine and the signed core;
the protected rows (`genie.js`, `shape.js`, the badge, `checks/`,
`contract.bsh`, `shaped.json` including the policy); the effect cap, which
never escalates silently; declared properties, which a candidate may not
remove or rename; activation, which stays per principal or per host.

| Level | Who (default) | Mode | May change | Mechanism |
|---|---|---|---|---|
| **owner / admin** | the principals the policy names | `shape` | anything the invariants allow, including the policy | existing lifecycle; the policy is a protected path for everyone else |
| **member** | principals or a circle the owner lists, or any authenticated principal | `shape` within an allow-list, or `request` | owner-defined: path allow and deny globs (for example `public/**` and `content/**` allowed, `api/**` and `checks/**` denied), an effect subset such as `read`, listed properties, example wishes | the level's deny list joins the app's protected list, which the existing candidate check already enforces; the verifier caps effects to the subset; `request` reuses the protected-page flow: the wish is recorded for the owner and nothing is built |
| **public** | anonymous visitors | `personalize` or `off` | presentation only, from an owner-declared property schema: layout and density, background and theme, text size, mobile or desktop text variants, language, favorites, settings | typed property declarations in the policy extend today's property name list; preferences live in the visitor's browser and the site's own property hooks apply them; the owner shapes those hooks in at level one. **No code candidate is ever created for the public level, so "no functionality changes" holds by construction** |

Policy location: `shaped.json` `levels`, because the manifest is already the
operator-owned contract frozen from the base. Resolution happens at wish
intake: principal, then level, then mode. The Shape page and the badge show
the caller's level and what it may change; `bashy shape status --json`
reports the same. The cloud tier header (`admin` or `user`) stays advisory;
the policy names principals.

Public personalization in plain words ("make it calmer") would need an
anonymous, rate-limited, origin-allowlisted engine endpoint that maps words to
property values. That is a follow-up; the first public panel is schema-driven
and needs no model and no engine call.

## Dogfood: the company website

1. The website becomes its own repository (operator decision) and a one-time
   pull request adds the scaffold: `checks/build.bsh`, `contract.bsh`,
   `shaped.json` with a three-level policy, the committed `public/`, the
   tier-0 badge in the no-JavaScript fallback and in the page footer.
2. The engine host registers it: `bashy app add website --type shaped
   --source <git URL>` with a repository token in the environment, then
   `bashy shape remote set upstream <git URL>`.
3. A member opens the public page, clicks Shape, lands on the engine with the
   page prefilled, makes a wish, verifies, previews, approves, sees their own
   version at the engine, undoes it, and the owner submits and pushes a
   revision as a pull request.
4. Logged out, the Personalize panel offers only the declared properties and
   changes only that browser.

The exact steps and checks are in the execution plan.

## Risks

- **CSP and Trusted Types.** Tier 0 adds nothing to the policy. Tier 1 is a
  vendored same-origin script that builds DOM without string HTML.
- **Re-render.** A framework may unmount an inserted button; the anchor is
  rendered in the page's own tree and `badge.js` only enhances it, with a
  mutation observer as the fallback.
- **Login round-trip.** Whether `?page=` survives the edge login redirect is
  outside this repository; the dogfood records the answer.
- **Credentials on the engine host.** A repository token for import and the
  `gh` login for pull requests live in the host environment, never in the app
  record.
- **Committed build output.** Lockfile and pinned Node keep the rebuild check
  deterministic; history retention on the engine bounds growth.
- **Prefixes.** Relative asset base and extensionless routes under `/<app>/`
  and the relay prefix.
- **An unshapeable badge.** On the engine the asset is embedded and listed in
  the protected manifest; on the site it sits outside the shaped tree.

## Follow-ups, noted not planned

- **Sites without source.** Snapshot the live pages into `public/` and
  register the result; same badge, same levels.
- **Per-user overlay carrier.** A snippet that applies a member's approved
  presentation on the real site needs origin-allowlisted CORS and bearer-token
  acceptance in the console gate (cookie-only today) and a preview mode for an
  external page.
- **Browser-extension carrier.** For sites the user does not own; the existing
  live-browser extension is the injection point.
- **Agent-callable site tools.** A shaped site may register WebMCP tools so
  agents act through declared tools; the policy would list them per level.
- **Proxied apps.** The console's proxied and static `site` apps still get no
  Genie (S527).
