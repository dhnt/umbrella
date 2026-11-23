# Sprint 697: agent-ready sites, the page is the repo root

Epic: software-shaping. State: **backlog, planning only** (filed 2026-11-23,
reviewed with the operator the same day; multi-pronged announcement and the
MCP endpoint agreed). Design of record: `agent-ready-sites.md`. The sprint
card and its stories are authoritative.

## Primary goal

Any agentic tool handed one page URL of a shaping-enabled site finds the
site's instructions in the page itself, reads the pages as structured
content, cites them, and either connects to the owner's bashy MCP endpoint or
installs bashy to act, with no guessing and no hidden files. bashy is the
first client that honors the whole convention.

## Facts the plan stands on

- From Sprint 693's live matrix and the 2026-11-23 review: no shipped agent
  probes well-known files or follows link relations; every agent reads the
  body it receives; Claude Code, OpenCode and Gemini CLI negotiate Markdown;
  converters and accessibility trees drop hidden markup; headers reach no
  model; every fleet CLI can connect to a remote MCP server from a URL.
- Already shipped and reused: the `site` template (bashy
  `examples/shaping/site`, S0/S0c), `github.com/dhnt/site` v0.1.0, the
  hosted-plane public-page adapter (cloudbox v0.18.82), the discovery runner
  (`examples/shaping/discover`), `bashy mcp serve --transport http`
  (stateless Streamable HTTP at `/mcp`, outpost identity auth, tool
  profiles), the skills admission gate, the shape service.
- Agreed channel set (design table): `/agents.txt` first implementation,
  registered link relations as `<link>` and `Link`, the `Bashy-Shaped`
  header, the hidden Bash# recipe as an HTML data block plus a hidden prose
  twin, the visible DOM-first note and `## For agents` block, Markdown-first
  serving, root files, well-known files, robots/sitemap/feed/noscript/JSON-LD,
  optional DNS TXT. Hidden text must equal visible text; recipes are shown,
  never run by default.

## Stories

Dependency order. Vendor is the proposal (agy by default for evaluation;
codex on the hosted plane where it delivered S1a/S1b; claude for bashy
internals; muse for the runner it wrote). Points per the ladder.

| # | Story | Repo | Vendor | Pts | Acceptance |
|---|---|---|---|---|---|
| A1 | Template: every announcement channel, `agent:` front matter and meta twin, `/AGENTS.md`, `/skill.md`, `/llms.txt` preamble, well-known files, Markdown-first for listed agent user agents, Accept tie-break by order, `site check` equivalence rule; regenerate `dhnt/site` v0.2.0 | bashy `examples/shaping/site`, `dhnt/site` | agy | 5 | template tests green on the gate host; sample site and `dhnt/site` pass `site check`; `curl -I` shows `Link` and `Bashy-Shaped`; `/agents.txt` parses with A3b; the three representations agree on links, ids, revision and the block |
| A2 | Hosted plane serves the convention for dhnt.io (paths, headers, serving rule; absorbs cloudbox 60b2b1007498; HTML ETag through the edge decided); one release; live verification | hosted plane | codex | 5 | every rule verified by `curl` through the live edge; existing routes unchanged; release per the cloudbox playbook with operator go |
| A3 | Site MCP endpoint at `<origin>/mcp`: same-origin reverse proxy with the pages' own auth (session cookie or relationship stamp; the site sign-in is the OAuth flow; no redirect) to `bashy mcp serve` profile `site` (list_pages, read_page, cite; shape wish/verify/preview/approve/undo by the proxied principal's tier); server card | hosted plane proxy, outpost app proxy, bashy, yoke, template | claude (+ codex for the hosted-plane proxy) | 8 | Claude Code, Codex, Gemini CLI and OpenCode connect to `<origin>/mcp` from the URL in the agent block and call read_page and cite; a signed-in owner shapes through MCP, a member or anonymous caller is refused by name with the same tier rules as the pages; the engine behind the proxy is the owner's |
| A3b | bashy consumer: `site explore` (reads `/agents.txt` first, then header, relations, block), `site attach` (skill from the well-known index or `/skill.md` through the admission gate; `skills add` from a URL), `site cite`, `site shape`, `site recipe` (prints; runs only on an explicit flag in the sandbox, effects read,net, origin-bound), `fetch` surfaces the block | bashy, yoke | agy | 5 | script tests against the template fixture and against a site with none of the channels (graceful refusal) |
| A4 | bashy identity to sites: stable user agent, optional RFC 9421 signed requests with the outpost key and a key directory; template-side verification; MCP auth as the primary signal; detection never gates content | bashy, outpost, template | claude | 5 | a signed `bashy fetch` is verified by the template server, an unsigned one is served the same content; the MCP endpoint refuses an unauthenticated shape call |
| A5 | Feel-at-home acceptance: discovery runner task leg (URL plus "find out how to work with this site and do what it says"); matrix on the live site for the fleet CLIs, a browser and a chat fetcher; server log plus transcript per client | bashy `examples/shaping/discover`, evidence | muse | 5 | table per client: read the block, fetched index or skill, connected to MCP and which tools, used or installed bashy, cited correctly, time to first correct action; recorded as observed |
| A6 | Docs: design indexed; kb runbook "make your site agent-ready"; bashy README "For agents" and the bashy skill carry the convention and the MCP endpoint | umbrella, bashy | agy | 3 | docs reviewed; scrub gate clean; an agent handed the bashy repo learns what to do with an agent-ready page |

## Lanes and order

```
A1 ──► A2 (hosted plane release) ──► A5 (live matrix) ──► close
 ├───► A3 (MCP endpoint) ──────────────┘
 └───► A3b (bashy verbs) ──► A4 (identity)
A6 alongside, finished after A3
```

- **Wave 1** (parallel, independent files): A1, A3, A3b, A6 draft.
- **Wave 2**: A2 after A1 publishes `dhnt/site` v0.2.0; A4 after A3b.
- **Wave 3**: A5 after A2 and A3 are live; A6 final.

MVP = A1 + A2: that changes what every agent sees on dhnt.io. A3 adds the
no-binary path. A3b, A4 make bashy the reference consumer. A5 makes the claim
measurable.

## Gates and venues

- Per story: its own acceptance plus targeted unit or script tests; builds
  and `go test` on the gate host, never the dev box; browser legs on the gate
  host; no full suites per commit (one run at the release gate).
- A2 follows the cloudbox release playbook (unit suite in the container
  recipe, desktop-journey e2e with `BASHY_TAG` pinned to the latest promoted
  release, tag, host release script, App Platform spec with tags only,
  satellites, live smoke) and needs the operator's go for the tag and deploy.
- Evidence: `docs/sprint-697-evidence.md`, wire-level only; hosts by role;
  no hosted-plane internals.
- Close: A1 to A6 accepted with evidence; `dhnt/site` v0.2.0 live; pins bumped
  where the template is consumed; the feel-at-home table recorded.

## Rules carried from Sprint 693

- Ship trees to the Linux venue with `COPYFILE_DISABLE=1` and no path
  rewriting, or clone on the host; `git ls-files --recurse-submodules` for
  trees with submodules.
- Workers commit on their branch with the provenance trailers; the conductor
  reviews, re-runs the story's tests, fast-forwards and bumps pins per merge.
- A story in another repository must be tracked on the sprint (`sprint
  track`) before it can be assigned.
- Root cause before any fix; a venue failure is fixed in the venue.

## Decisions settled with the operator (2026-11-23)

1. Multi-pronged announcement on classic standards, all channels in the
   design table, including `/agents.txt` as the first implementation.
2. The recipe block stays `type="text/bashsharp"`, an HTML data block, never
   JavaScript; hidden text equals visible text.
3. Agents switch to the owner's fixed MCP endpoint instead of downloading a
   binary; bashy remains the native path.

## Decisions still reserved for the operator

1. (settled 2026-11-23) `<origin>/mcp` is a same-origin proxy with the pages' auth to the owner's engine; no redirect.
2. Signed bashy requests in this sprint (A4) or user agent only now.
3. Whether the shaping entry point is advertised to every agent or only to
   authenticated MCP sessions and verified bashy agents.
4. Vendors as proposed, or reassign.

## Not doing

WebMCP (origin trial only); an MCP server on the hosted plane for visitors
(669 scope); new well-known registrations or link relations of our own;
visitor shaping on the live site; any content change to the dhnt.io pages
beyond the agent block.
