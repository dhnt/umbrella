# Sprint 693: dhnt.io navigation and shaping for people and agents

Sprint UUID: `cdef0a9b-7ae4-54d0-bd26-139ef3609d4a`. Epic: software-shaping.
State: **backlog, planning only** (filed 2026-11-22, reviewed and rescoped
2026-11-22 against the state of the art; operator decisions recorded the same
evening, see below; ready for a conductor). The sprint card and its stories are
authoritative; this document records the review, the research, the decisions
and the order of work.

## Primary goal (unchanged)

Prove on the live homepage and `/about` that a visitor and an agent follow the
same links, read the same content, and can hand a specific section, at a
specific revision, to the owner for reshaping; the owner and Bashy then review
the same verified candidate, approve and undo it on the shaped copy, while the
public page keeps serving its published revision.

## What the live site showed (probed 2026-11-22)

- `dhnt.io` and `www.dhnt.io` answer `301` to `ai.dhnt.io` with the path kept.
  The company pages are served by the hosted plane behind an edge CDN.
- `/` and `/about` return the **same** single-page shell (about 3.8 KB). The
  content a visitor sees is rendered in the browser; the shell carries one
  no-JavaScript fallback block, identical for both paths, whose prose is a
  second copy of the About text kept in the application bundle.
- Section anchors (`#team`, `#contact`) exist only in the browser-rendered page;
  the fallback block has none. There is no revision identifier anywhere.
- `Accept: text/markdown` and `Accept: application/json` are ignored (HTML is
  returned); no `Vary`, no `ETag`, no `Link` header, no `<link rel=alternate>`.
- `/robots.txt`, `/llms.txt`, `/sitemap.xml` are `404`.
- "Shape this page" links to `/?shape=open`: the per-visitor **presentation**
  panel (look, voice, with history and undo). It does not shape the content.

Consequence: today a server-side agent (which never executes JavaScript) reads
the fallback prose on both paths, while a visitor sees a sign-in launcher on `/`
and the company page on `/about`. Visitor and agent do **not** see the same
thing; that is the gap S1 must close, before any alternate format.

## What the code showed

- The shaping engine already has what S3 needs: `bashy shape wish --page
  --element`, isolated candidates, `checks/*.bsh` frozen from the base, preview
  at `/shape/<app>/preview/<id>/`, per-principal activation (an anonymous
  request is served the base), approve, history, undo. No engine change is
  required for this sprint.
- `bashy fetch -H 'Accept: text/markdown'`, `bashy fetch --md` (HTML to
  Markdown), `bashy browser --mode solo` (headless Chrome: rendered text and
  links) and `bashy browser eval` are the agent clients we control.
- The skills catalog (`bashy skills list|add|export`) is the "existing Bashy
  catalog": a `SKILL.md` folder admitted through the verified gate.
- `website.bsh` (bashy `examples/shaping/website`) and the owner guide
  `shaping-enable-a-website.md` are the existing existing-site workflow; the
  companion-layer model is also the existing-site contract of Sprint 669 (M4,
  M5). Sprint 693 is a thin pilot that reuses that contract and produces
  evidence for it; it does not start 669.

## State of the art, Nov 2026 (what carries weight)

Two research passes on primary sources; details and URLs at the end.

| Mechanism | Status | Verdict for this sprint |
|---|---|---|
| Server-rendered semantic HTML with explicit section ids | Stable; the observation space of every browser agent and the only thing no-JavaScript fetchers see | **Required.** The two pages render their content server-side from one source |
| `Accept: text/markdown` negotiation, `.md` twin URLs, `Vary: Accept`, strong `ETag` per representation | Measured senders: Claude Code, Cursor, OpenCode, Brave; the edge CDN sells it as a zone toggle (GA 2026-11-09, plan-gated, drops ETag); every major docs platform ships it | **Required, at the origin.** Our own deterministic renderer; the zone toggle is not a substitute (no revision, no JSON, converts the shell) |
| `robots.txt` (RFC 9309) | Honored by the fetchers | **Required** (missing today; trivial) |
| `llms.txt` v2, `rel="alternate" type="text/markdown"`, `rel=canonical`, `Link` header | Trivial; 97% of llms.txt files are never fetched; no agent auto-follows `rel=alternate` | **Cheap, non-gating.** Publish because the renderer emits them for free; record whether any client used them |
| Section identity | Explicit ids plus a per-section hash are the stable form (Sanity `_key`/`_rev`, Google `requiredRevisionId`); derived heading slugs renumber; no standard combines section id and revision in one URL | **Adopt**: declared ids, page revision = content hash, citation record `{url, section_id, revision, section_sha256, quote}` |
| Owner approval loop | Best shipped loop: immutable candidate with its own URL cut from a named base; preview gated by identity, not obscurity; atomic promote with a stale-base check; undo = logged pointer move; public reads one published pointer | **Already the `bashy shape` model.** Add only a stale-base check and the revision in the wish provenance |
| WebMCP (`document.modelContext.registerTool`) | W3C community-group draft; API renamed twice in 2026; declarative form removed 2026-10-27; Chrome origin trial 149–162 only; WebKit opposed; one shipped consumer (a desktop chat app's browser) | **Out of the gate.** Keep as a p2 feature-detected probe, or drop |
| Agent cards, MCP server cards, api-catalog, Web Bot Auth, Content-Signal, RSL | Either need a server we do not run here, or are unhonored by any agent | **Follow-ups** (as the card already says) |

## Decision: one content module, two deployments, one renderer

The pattern is generic, and dhnt.io is only its first instance: **every site
owner gets a `<owner>/site` repository** generated from one bashy template,
the way `website.bsh` already scaffolds a companion layer for an existing
static site. The template (a `site.bsh` skill-script with an embedded skill
and a `template/` tree, in bashy next to the website example) writes the
content files, a self-contained stdlib Go renderer and server, and the
shaped-app face. bashy is the only tool needed to create, render, check, serve
and shape a site; the hosted plane and outposts are themselves built on bashy.

`github.com/dhnt/site` is the first repository generated this way. It holds
the home and About content with explicit section ids and the renderer that
turns them into an HTML fragment, Markdown and JSON with one revision
identifier. It is consumed twice:

1. **Live.** The hosted plane imports the module at a pinned version. It
   renders the two pages' content and shared navigation server-side into the
   shell (one fallback block per page, with ids), negotiates `Accept`, serves
   the `.md` and `.json` twins, sets `Vary: Accept` and `ETag` = revision, and
   emits the `Link` and `<link>` alternates, `robots.txt` and `llms.txt`. The
   browser application renders the same JSON instead of its own copy of the
   prose, so there is one text, not two.
2. **Engine.** The same repository is a registrable shaped app (stdlib Go
   server, `shaped.json`, `contract.bsh`, `checks/`), registered on the owner's
   always-on engine host with the existing website workflow. The owner shapes
   it; the candidate preview serves the same three representations at the
   candidate's revision, so the owner (HTML, browser) and Bashy (Markdown or
   JSON, CLI) inspect identical content by construction.

Publishing an approved candidate to the live site is a pull request on the
module, a pin bump and a hosted-plane release: a **follow-up**, exactly as the
acceptance requires ("the public page continues to serve its published
revision").

The live update is dogfood on the real company site and must not break it:
the sign-in launcher, the signed-in redirect, OAuth, the presentation panel
(`/?shape=open`) and every existing route behave exactly as before, and a
Markdown or JSON request never changes what a browser receives.

Alternatives considered: keeping the prose inside the hosted plane and
snapshotting it for the engine (two sources, drift, the candidate is not the
live renderer); the edge's Markdown toggle alone (no revision, no JSON, converts
the shell, plan-gated, vendor-dependent). Both rejected.

### Contracts

- **Paths.** `/` and `/about` (HTML by default). Twins: `/index.md`,
  `/index.json`, `/about.md`, `/about.json`. `/robots.txt`, `/llms.txt`.
- **Negotiation.** `Accept` preferring `text/markdown` returns Markdown;
  preferring `application/json` returns JSON; anything else returns HTML.
  Every response carries `Vary: Accept` and a strong `ETag` equal to the page
  revision; `Link: </about.md>; rel="alternate"; type="text/markdown"` and the
  JSON twin likewise; HTML carries `<link rel="alternate">` for both,
  `<link rel="canonical">`, and `<meta name="revision">`.
- **Content.** Markdown source per page with front matter: `title`,
  `path`, sections with declared `id`s. Rendered JSON:
  `{path, title, revision, nav:[{label, href}], sections:[{id, heading, html,
  markdown, sha256}]}`. Markdown output starts with front matter
  `path`, `revision`, `alternates`, then the navigation as labeled links, then
  the sections with `{#id}` headings. Revision = short SHA-256 of the canonical
  content document; a copy change changes it, a rendering change does not.
- **Citation.** `{url, section_id, revision, section_sha256, quote}`; the
  human form is `https://ai.dhnt.io/about#team @ <revision>`.
- **Home content (design settled by the conductor).** Title "DHNT"; one
  paragraph: dhnt turns the computers you already own into one self-hostable,
  agent-operable mesh; bashy is the foundation; cloudbox and outpost are built
  on bashy. Sections `#what` (what dhnt is, links to the dhnt and bashy
  repositories), `#start` (install in one line; the README is the agent skill;
  bashy is all you need), `#shape` (the existing "Shape this page" link).
  Navigation Home / About / GitHub, shared with `/about`, which keeps
  `#about`, `#team`, `#contact`. Short on purpose: the pilot proves the
  mechanism, not the copy.
- **Wish provenance.** `bashy shape wish site --page /about --element
  'section=team revision=<rev>' "<copy edit>"`. A frozen check fails the
  candidate when `revision` is not the base revision of the page ("stale,
  re-read"), the compare-and-set of the shipped products.

## Stories

Dependency order. Vendor is a proposal (the operator assigns).

| # | Story | Tag | Vendor | Acceptance |
|---|---|---|---|---|
| S0 | **Generic site template in bashy** (new, p1): `examples/shaping/site/site.bsh` (`init`, `render`, `serve`, `check`; `--dry-run`, `--json`) with `template/`: content Markdown with declared section ids; renderer to HTML fragment, Markdown, JSON with revision and per-section hashes; stdlib server with negotiation, twins, `Vary`, `ETag`, `Link`, `robots.txt`, `llms.txt`; `shaped.json`, `contract.bsh`, `checks/` (render determinism, unique ids, links resolve, stale-base); the `<owner>-site` skill emitted per instance | bashy, example | codex or claude | script tests and `GOWORK=off go test` in the template on the gate host; `init` on a sample yields a repo whose `bashy shape verify` passes in the verifier's scrubbed environment; the three representations list the same links and section ids |
| S0b | **`dhnt/site`, the first instance** (new, p1): generated with the template; home and About content; nothing dhnt-specific in the template | public repo | claude | `go test ./...` green; `bashy shape verify` passes; a second owner can generate `<other>/site` from the same template with different content |
| S1 | **Live publication** on `ai.dhnt.io` (rescoped): the hosted plane serves `/` and `/about` from the module (server-rendered block per page, shared nav), the twins, negotiation and headers above, `robots.txt`, `llms.txt`; the browser application renders the module's JSON; **non-breaking** for every existing route and flow | hosted plane, release | claude (private repo) | Through the live edge: `curl` with `Accept: text/markdown`, `application/json` and default each return the right body with `Vary: Accept` and the same `ETag`; a Markdown fetch followed by an HTML fetch of the same URL returns HTML (no variant bleed); the no-JavaScript HTML of `/about` and the rendered page show the same sections and ids; from `/about` both a visitor (headless browser) and an agent (`bashy fetch`) reach `/`, return, and cite `about#team @ <rev>` identically |
| S2 | **Agent discovery evidence + Bashy site skill** (rescoped, WebMCP removed): a cataloged skill `dhnt-site` (how to read the pages: header, twins, citation record) admitted with `bashy skills add` and exported; the discovery matrix run on the live site, each client started with only the page URL | evidence, skill | agy | Matrix recorded for at least the clients bashy works with: the fleet's agent CLIs (claude, codex, gemini/agy, opencode) reading the page with their own fetch tool, `curl` default (`*/*`), `bashy fetch` with and without `--md`, `bashy browser --mode solo` (rendered text and links), and one third-party fetcher we can observe; for each: representation received, whether it found a structured format by itself, or needed the direct twin or the skill. Whether anything fetched `llms.txt` or followed `rel=alternate` is recorded, not assumed |
| S3 | **Owner shaping round trip on the engine** (rescoped; depends on S0b, not on S1): register the module as a shaped app on the owner's engine host; wish from `/about#team` at the observed revision with a reversible copy edit; stale-base check; verify; preview; the owner (browser, signed in) and Bashy (CLI) read the candidate's HTML and Markdown or JSON and find the same candidate revision; approve; undo; isolation and live stability checked | engine, evidence | claude | Candidate HTML, `.md` and `.json` carry one new revision and the edited copy; a stale revision in the wish is refused by name; after approval the owner's `/site/about` shows the edit, an anonymous request and a second principal see the base; `bashy shape undo` restores the base and history lists both; the live `ai.dhnt.io/about` `ETag` is unchanged before and after |

Removed from scope versus the filed stories: the WebMCP tool (operator
decision 2026-11-22: dropped; story 2ab6237d wontfix, goal retired), "new
gateway tools", OpenAPI, a standalone Linkset (all already follow-ups on the
card).

## Order and critical path

```
S0 ──► S0b ──► S1 (live release) ──► S2
         └───► S3 (engine; needs only S0b)
```

S3 no longer waits for the live release, which is the only step with an
external approval gate (a hosted-plane release, go given 2026-11-22). S0 and
S0b are the new artifacts; S0 is reusable by every later site.

## Gates and venues

- Per story: its own acceptance plus the relevant unit tests; builds and
  `go test` on the gate host or the second build host, never the dev box.
  Browser legs (`bashy browser`) run on the gate host.
- Live checks are plain `curl`/`bashy fetch` through the public edge, from any
  host; raw request and response headers are kept as evidence.
- S1 ships in an ordinary hosted-plane release with the operator's go; no
  release is implied by this plan.
- Evidence: `docs/evidence/sprint-693-dhnt-io-navigation.md`, wire-level only
  (URLs, headers, bodies, candidate and revision ids); hosts by role; no
  hosted-plane internals.
- Close: S0, S0b, S1, S2, S3 accepted with evidence; `dhnt-site` skill
  exported; pins bumped where the module is consumed.

## Operator decisions (2026-11-22)

1. **Content home**: `dhnt/site`, as the first instance of the generic
   `<owner>/site` pattern; every other site gets its own `<owner>/site` from
   the same bashy template.
2. **WebMCP**: dropped (story wontfix, goal retired).
3. **Live update**: yes, as long as nothing breaks; dogfood on the real site.
   One hosted-plane release for S1; the edge's Markdown zone toggle stays off.
   Discovery evidence covers at least the clients bashy works with.
4. **Vendors**: as proposed above unless reassigned at start.
5. **Home design**: left to the conductor; settled in the contracts section.
   Cloudbox and outpost are built on bashy; bashy is all you need, so the
   template, the skill and the shaping workflow are bashy verbs, not new
   tooling.

## Not doing

Publishing an approved candidate to the live site; WebMCP; MCP or A2A cards;
an MCP server for the site; Web Bot Auth or Content-Signal policies; changing the
`dhnt.io` to `ai.dhnt.io` redirect; the presentation panel (`/?shape=open`)
stays as it is; any Sprint 669 milestone.

## Research notes and sources

Content negotiation: the edge CDN's "Markdown for Agents" was announced
2026-02-12 and reached GA 2026-11-09 as an opt-in zone setting on paid plans;
it adds `Vary: accept`, drops `ETag`/`Last-Modified`, and the token-count
headers were removed 2026-10-09
(<https://developers.cloudflare.com/fundamentals/reference/markdown-for-agents/>).
Measured senders of `Accept: text/markdown`: Claude Code
(<https://code.claude.com/docs/en/tools>), Cursor, OpenCode, Brave; consumer
chat fetchers do not send it
(<https://www.checklyhq.com/blog/state-of-ai-agent-content-negotation/>).
`@vercel/agent-readability` and the docs platforms (Mintlify, Fern, GitBook,
Stripe, Anthropic) ship the same pattern with `.md` twins and
`Link: rel="alternate"` (<https://vercel.com/docs/agent-resources/markdown-access>,
<https://www.mintlify.com/docs/ai/markdown-export>).

llms.txt: spec v2 2026-08-10 (<https://llmstxt.org/changes.html>); a 137k-domain
study found 97% of files never requested and no AI bot probing for it where
absent; Google states it does not use it.

WebMCP: W3C WebML CG draft 2026-11-19
(<https://webmachinelearning.github.io/webmcp/>); API moved from
`navigator.modelContext` to `document.modelContext`, `provideContext` removed,
declarative form removed 2026-10-27; Chrome origin trial 149–162
(<https://chromestatus.com/feature/5117755740913664>); WebKit position
opposed; one shipped consumer.

Section and revision identity: Sanity `_key` + `_rev` and history by revision;
Google Docs `revisionId` + `requiredRevisionId`; GitHub slugger renumbers
duplicate headings; W3C Web Annotation `TextQuoteSelector` as the robust
fallback; RFC 9110 strong `ETag` + `If-Match`; an individual I-D proposes one
ETag across HTML and JSON projections
(<https://datatracker.ietf.org/doc/html/draft-jurkovikj-httpapi-agentic-state-01>).

Owner approval loops: Vercel staged production and Instant Rollback (pointer
move that pauses auto-assignment), Netlify lock and publish-deploy, Lovable
Drafts (accept/reject, visitors keep the previous version), GitHub PR as the
approval unit with `Agent-Logs-Url` trailers, Notion suggested-edit MCP verbs,
WordPress.com MCP `revisions.restore`. No product ships propose, preview,
approve and rollback together; `bashy shape` already does.

Browser agents read the accessibility tree or DOM of the rendered page and
present a stock browser identity; server-side fetchers do not execute
JavaScript and read the HTML as served. No published test shows any agent
using `llms.txt`, `rel=alternate`, well-known cards or WebMCP when handed a
bare URL.
