# Agent-ready sites: the page is the repo root

Design of record, written 2026-11-23 after Sprint 693 (dhnt.io served for
people and agents) and a state-of-the-art review of how agents actually find
site instructions. Planning only; the stories live on Sprint 697 (backlog). The sprint card and its stories are authoritative.

## The goal, in the operator's words

bashy is designed for agents, and so is software shaping. When an agentic tool
is given a repository, local or on GitHub, it knows how to explore it and act
on a request, because the repository carries `AGENTS.md` or `CLAUDE.md` at a
place the tool looks by convention. A shaping-enabled website should feel the
same: given any page URL, the tool should know how to explore the site, find
its instructions, fetch what it needs (including bashy itself), read the pages
as structured content, cite them, and propose or shape changes.

## What the evidence says (2026-11-23)

Two measurements decide the design: the live discovery matrix of Sprint 693
(`sprint-693-evidence.md`) and the review of shipped agent behavior.

1. **No agent probes for anything.** No shipped coding CLI, chat fetcher or
   browser agent fetches `/llms.txt`, any `/.well-known/*` file or follows
   `<link rel="alternate">` or `rel="describedby"` on its own. The repo
   convention has no web variant: the agents.md project has no proposal for
   one, and IANA declined the `agents.txt`, `agent.txt`, `agents.json` and
   `ai` well-known registrations in March 2026 for lack of implementations.
   Skills discovery (`/.well-known/agent-skills/index.json`) is consumed only
   when a person runs `npx skills add <url>`.
2. **Every agent reads the body it receives**, and the body it receives is
   decided by content negotiation. Claude Code sends
   `Accept: text/markdown, text/html, */*` and a `Claude-User` agent string
   that names claude-code; OpenCode sends a markdown-first `Accept`; Gemini
   CLI does in its direct-fetch mode. Docs platforms that serve the Markdown
   twin on that header (Cloudflare, Mintlify, Stripe, GitHub docs, Shopify,
   Vercel, Next.js, Google's AI docs) have converged on the same move: they
   **open the Markdown with an agent-addressed block**. Cloudflare puts an
   `agent:` front-matter object with `instructions` and a search URL, and
   mirrors it as `<meta name="agent:instructions">` in HTML; Mintlify prepends
   `> ## Agent Instructions` and a documentation-index pointer; Google
   prepends `> ## AI Agent Context`; Stripe opens `llms.txt` with operating
   instructions. Prompt-injection studies prove the same channel the hard way:
   agents read and act on page text.
3. **Hidden markup dies in conversion.** Converters drop `<meta>`, `<link>`,
   `<script>`, comments and hidden elements; browser agents read the
   accessibility tree, which excludes them too. Visible text and links are the
   only universal channel. Response headers reach no model; `Content-Type` and
   the status code are the only metadata every client acts on.
4. **Identity is not reliable, except our own.** Declared fetchers are
   verifiable by IP or signature (a few vendors sign requests); coding CLIs
   use generic clients; browser agents are byte-identical to a human's Chrome.
   Detection can tailor the representation but must never gate the content,
   which is also the line search engines draw against cloaking. bashy is the
   one client we control end to end: it can identify itself and sign.
5. **Editing has no convention at all.** `rel="edit"` is registered and used
   by one docs generator; everyone else ships bare GitHub edit anchors; the
   only agent-facing "propose a change" endpoint found is Vercel's feedback
   API, named in prose at the end of its Markdown pages.

Conclusion: the AGENTS.md of a page has to be **in the page**, at the top of
its Markdown twin and visible in its HTML, and the rest of the convention is a
pointer layer that bashy consumes today and other tools may consume later.

## Design

Three layers, cheapest first. The site template (bashy `examples/shaping/site`)
emits all three; every `<owner>/site` inherits them; bashy is the reference
consumer.

### Layer 0: the in-page agent block (the AGENTS.md of the page)

Every page carries a short section `## For agents {#agents}`: first in the
Markdown twin (after the front matter), visible but unobtrusive in HTML, and
present in JSON as the `agents` field. It is written for an agent that has
nothing but this page, in the imperative, about twelve lines:

- what this site is: an agent-ready, shaping-enabled site built on bashy;
- how to read it: the `.md`/`.json` twins, `Accept: text/markdown`, the index
  `/llms.txt`, the stable section ids and the citation record
  `{url, section_id, revision, section_sha256, quote}`;
- how to equip yourself: the one-line bashy install, then
  `bashy site attach <origin>` (admits the site skill, records the site);
- where the source is and how to propose a change: the public repository, the
  per-page edit link, pull requests;
- how to shape: register the repository as a shaped app on your own engine,
  then wish, verify, preview, approve, undo; publish by pull request;
- a line for the people reading over the agent's shoulder.

**First contact rule.** The hardest part is telling a visiting agent that the
site is agent-friendly at all, before it decides what to do. There is no push
channel: no header reaches a model, no file is probed, nothing is read before
the page body. So the announcement is placed where every agent's first read
starts, in every representation it can receive:

- Markdown twin: the block is the first content after the front matter, and
  the front matter's `agent:` object repeats the three URLs that matter
  (`mcp`, `skills`, `index`). Claude Code answers a question about a page
  through a small model over the fetched text, so the first lines carry the
  most weight; Mintlify and Cloudflare prepend for the same reason.
- HTML: a one-line, DOM-first note (`<p id="agents" role="note">This site is
  agent-ready: instructions at #agents · MCP endpoint … · skill …`) before
  the navigation, so accessibility-tree readers (browser agents) and
  HTML-to-Markdown converters meet it first; the full block follows the
  content. People see it as a discreet "Agent-ready" badge next to the Shape
  badge, which is on brand.
- JSON: `agents` is the first field.
- Error pages: the 404 and 403 bodies carry the same one-line note and the
  index link, because an agent probing a wrong path is still a visitor.
- The one-liners are literal: per client, the exact command to connect to
  the MCP endpoint (`claude mcp add --transport http <name> <url>` and the
  Codex, Gemini CLI and OpenCode equivalents) and the exact `bashy` command,
  so the agent can act or ask its person for the single approval needed.

What this cannot do, honestly: reach an agent whose fetch tool is refused or
disabled (two of the fleet CLIs in the Sprint 693 matrix), or an agent that
is handed a screenshot. For those, the repository README and the installable
skill remain the way in. The feel-at-home matrix measures the rest.

The same facts ride the conventions that already exist, so nothing new has to
be learned by a tool that knows them: Markdown front matter `agent:`
(`instructions`, `index`, `skills`, `source`, `edit`, `cite`), the HTML twin
`<meta name="agent:instructions">`, and the Markdown-first serving rule
described in Layer 1.

### Redundant announcement channels (operator direction, 2026-11-23)

The announcement is cheap, so it is made on every classic channel at once.
Each one is standard pre-agentic HTTP or HTML; none depends on a consumer
existing today; bashy consumes all of them. The table says who reads what,
from the evidence, so nobody mistakes redundancy for reach.

| Channel | Standard | Who reads it today | Note |
|---|---|---|---|
| `/agents.txt` at the site root: plain text, `key: value` lines (`site`, `index`, `markdown`, `json`, `skill`, `mcp`, `source`, `edit`, `shape`, `cite`, `bashy`), the agent block as prose below | plain text at a root path, the `robots.txt` / `humans.txt` / `security.txt` shape; the well-known registration was declined, the root path needs none | nobody automatically; **bashy is the first implementation**, producer and consumer | the file every bashy CLI fetches first when it visits a site |
| `<link rel="alternate" type="text/markdown">`, `application/json`; `rel="describedby"` to `/llms.txt`; per page `rel="edit"`, `rel="via"`; `rel="service-doc"` to `/AGENTS.md` and `rel="service-desc"` to the MCP server card (RFC 8631); `rel="canonical"`, `rel="author"`, `rel="help"` | HTML link types, RFC 8288 `Link` header, all registered relations | Lighthouse's agentic audit, crawlers, bashy; no fetch tool follows them | sent as `Link` headers on every response, including HEAD and errors, because some clients HEAD first |
| `Bashy-Shaped: <comma-separated values>` response header (module, revision, agents.txt, skill, mcp, source, shape) | HTTP allows any field name; the `X-` prefix is deprecated by RFC 6648, so the field is `Bashy-Shaped` | bashy, curl users, proxies | sent on every representation and on errors |
| hidden agent recipe at the start of the body: `<script type="text/bashsharp">` with a short Bash# recipe (fetch the twins, read `/agents.txt`, attach the skill, connect to MCP) and a `<div hidden>` with the same instructions in prose | HTML: unknown script types are inert and legal; `hidden` is a standard attribute | raw-HTML readers (curl-based agents, bashy); converters and accessibility trees drop scripts and hidden elements, so most agents never see this one | redundancy only; the visible block carries the message |
| visible one-line note first in the DOM and the full `## For agents` block | HTML | every agent that fetches the page, every browser agent, every person | the primary channel |
| Markdown twin opening block + `agent:` front matter; `<meta name="agent:instructions">`, `<meta name="generator" content="bashy site <version>">` | Markdown, HTML meta | Claude Code, OpenCode, Gemini CLI by negotiation; Cloudflare precedent for the meta | |
| `/AGENTS.md`, `/README.md`, `/skill.md`, `/llms.txt` with preamble | root text files | `npx skills add` (skill), bashy; others when linked | |
| `/.well-known/agent-skills/index.json`, `/.well-known/mcp/server-card.json`, `/.well-known/agent-card.json` (A2A, registered), `/.well-known/api-catalog` (RFC 9727 linkset naming the MCP endpoint and the twins), `/.well-known/security.txt` (RFC 9116, with `Policy:` → `/AGENTS.md`) | well-known URIs, three of them IANA-registered | `skills` CLI, A2A and MCP clients once pointed, Lighthouse, bashy | |
| `robots.txt` comment block and `Sitemap:`; `sitemap.xml` listing pages and twins; Atom feed advertised with `rel="alternate"` whose description carries the block | robots, sitemaps, Atom, all classic | crawlers and feed readers; fetch tools parse robots without passing it to the model | the robots comment is for people and crawler operators |
| `<noscript>` copy of the agent block | HTML | no-JavaScript readers and a few converters | classic, free |
| JSON-LD `WebSite` with `potentialAction` and `SoftwareSourceCode.codeRepository` | schema.org | search engines' index layer, not agents at fetch time | |
| DNS `TXT _agents.<host>` naming `/agents.txt` and the MCP endpoint | DNS TXT, the SPF/DMARC shape | bashy only | optional, out of band, survives when the web server is down |

Two risks, handled in the stories:

- **Hidden text is a search-engine cloaking signal.** The hidden recipe and
  `<div hidden>` must say exactly what the visible block says, nothing more,
  and the visible block must exist on the same page; the template enforces
  that equivalence in `site check`.
- **A page-supplied script is untrusted input.** bashy never executes the
  `text/bashsharp` recipe by default. `bashy site explore` prints it; running
  it is an explicit choice, in the verifier's sandbox, with the effect cap
  limited to `read,net` and the target restricted to the page's own origin and
  the URLs the recipe names. A recipe that asks for more is shown, not run.

### Layer 1: serving and the pointer layer

- **Markdown first for agents.** Negotiate by `Accept` with ties broken by
  listing order (so Claude Code's header gets Markdown), and additionally
  serve Markdown to the known agent user agents even without an `Accept`
  header, the way Mintlify does. Same content, different representation; no
  cloaking.
- **Fixed paths**: `/llms.txt` (v2, with an operating preamble that points to
  the agent block and the skill), `/AGENTS.md` (the full text of the agent
  block plus the site map; the exact analog of the repo file, cheap and
  honest about having no automatic consumer yet), `/skill.md` and
  `/.well-known/agent-skills/index.json` (schema 0.2.0) so `npx skills add
  <origin>` works, `/robots.txt`.
- **Registered link relations only**: `Link`/`<link>` `rel="describedby"` to
  `/llms.txt`, `rel="alternate" type="text/markdown"` and `application/json`
  to the twins, per page `rel="edit"` to the source file's edit URL and
  `rel="via"` to the repository, `rel="canonical"`. Headers are for caches,
  crawlers and bashy; the block in Layer 0 names the same URLs in text.
- **Revision stays the contract**: strong `ETag` = content revision on every
  representation, `<meta name="revision">` in HTML, `revision` in the
  Markdown front matter and the JSON.

### Layer 2: bashy without the binary, then bashy as the reference consumer

Once an agent has read the block and knows the site is shaping-enabled with
bashy, the cheapest next step is not a download: it is a protocol switch.
Every CLI in the fleet can connect to a remote MCP server from a URL (Claude
Code `claude mcp add --transport http`, Codex, Gemini CLI, OpenCode; chat
products through their connector settings). So the site owner fixes an **MCP
endpoint** and the block names it:

- served by `bashy mcp serve --transport http`, which already exists
  (stateless Streamable HTTP at `/mcp`, outpost identity authentication),
  with a new `site` tool profile backed by the site module: `list_pages`,
  `read_page`, `cite`, and the shape tools (`wish`, `verify`, `preview`,
  `approve`, `undo`) gated to the owner principal by the existing shape
  service;
- reachable at a fixed URL the owner chooses, through outpost or the hosted
  relay like any other app, authenticated per the MCP specification (bearer
  or OAuth 2.1 with the protected-resource metadata), anonymous at most for
  the read tools and only if the owner says so;
- advertised in the agent block and in `/.well-known/mcp/server-card.json`.

This also settles identity: an authenticated MCP session is the one reliable
"cooperative agent" signal, and it costs the agent a single approval instead
of a binary install. The bashy CLI remains the native path for agents that
already run bashy, and bashy honors the whole convention as its reference
consumer:

- `bashy site explore <url>`: fetch with the agent `Accept`, print the agent
  block first, then the index, the twins, the source and edit links, the
  revision; `--json` for the parsed `agent:` object.
- `bashy site attach <url>`: admit the site's skill from
  `/.well-known/agent-skills/index.json` (or `/skill.md`) through the existing
  verified-admission gate (`bashy skills add` learns to take a URL), and
  record the site in the kb.
- `bashy site cite <url>#<id>`: return the citation record for a section at
  its current revision.
- `bashy site shape <url>`: register the site's source repository as a shaped
  app on this host (`bashy app add --type shaped --source <repo>`) and print
  the wish, verify, preview, approve and undo sequence; promotion by pull
  request is the existing `shape push`.
- `bashy fetch` surfaces the agent block first when a page has one, reads
  `/agents.txt` and the `Bashy-Shaped` header, and lists the `Link` relations.
- **bashy identifies itself**: a distinct user agent (today `bashy-fetch`) and,
  on the owner's choice, a signed request in the Web Bot Auth shape using the
  outpost identity, so a dhnt-style site can verify that a bashy agent is
  calling and unlock agent-only affordances (the skill handshake, shaping
  entry points) for it alone. This is the only population we can detect
  reliably, and we detect it because we are both ends.
- **The bashy README and skill** (what an agent reads when it is handed the
  bashy repository) gain a section on agent-ready sites, so an agent that
  knows bashy knows what to do with any such page, and vice versa.

### The acceptance that matters: "feel at home"

Hand each client only a page URL and the instruction "find out how to work
with this site and do what it says". Record, from the server's request log and
the client's transcript: did it read the agent block, fetch the index or the
skill, install or use bashy, cite a section correctly, find the source. Clients
are the ones bashy works with (Claude Code, Codex, Gemini CLI, OpenCode, agy)
plus a headless browser and a chat fetcher. The discovery runner of Sprint 693
(`examples/shaping/discover`) grows a task-prompt leg for this.

## Not doing, and why

A new well-known file or link relation of our own (no consumer, and IANA
rejected the family); `<script>`, comment or hidden-element instructions
(stripped by converters); hiding or changing content by client (cloaking);
WebMCP (origin trial only); an MCP server for the site (follow-up); visitor
shaping on the live hosted plane (Sprint 669 scope). ARD and MCP server cards
can be added to the pointer layer later at no design cost.

## Stories (follow-up sprint, planning only)

| # | Story | Where |
|---|---|---|
| A1 | Template: the redundant announcement channels above (`/agents.txt`, `Bashy-Shaped` header, hidden recipe + visible block, link relations, well-known files, robots/sitemap/feed/noscript/JSON-LD), `agent:` front matter and meta twin, `/AGENTS.md`, `/skill.md`, `/llms.txt` preamble, Markdown-first for listed agent user agents, tie-break by order; `site check` enforces visible/hidden equivalence; regenerate `dhnt/site` | bashy `examples/shaping/site`, `dhnt/site` |
| A2 | Hosted plane serves the new paths, headers and serving rule (absorbs cloudbox follow-up 60b2b1007498); one release; live verification | hosted plane |
| A3 | bashy consumer verbs `site explore`, `attach`, `cite`, `shape`; `skills add` from a URL; `fetch` surfaces the agent block | bashy, yoke |
| A4 | bashy identity for sites: distinct user agent and optional signed requests (Web Bot Auth shape, outpost key); site-side verification in the template | bashy, outpost, template |
| A5 | "Feel at home" acceptance: discovery runner task-prompt leg; matrix on the live site for the fleet clients, a browser and a chat fetcher; findings recorded | bashy `examples/shaping/discover`, evidence |
| A6 | Docs: this design indexed; kb runbook "make your site agent-ready"; bashy README and skill section | umbrella, bashy |

Order: A1 → A2 (live) and A1 → A3 → A4 in parallel; A5 after A2 and A3; A6
alongside. A1 plus A2 is the MVP that changes what every agent sees; A3 to A5
make the claim provable and give bashy agents the native path.

## Decisions reserved for the operator

1. Publish `/AGENTS.md` (recommended, as the honest analog with no consumer
   yet) or rely on the in-page block plus `/skill.md` only.
2. Markdown-first for listed agent user agents (recommended; Mintlify's rule;
   same content, different representation) or `Accept` negotiation only.
3. Signed bashy requests in A4 now, or user agent only and signing later.
4. Whether the shaping entry point on a live site is advertised to every agent
   (register the source as a shaped app on your own engine) or only to
   verified bashy agents.
