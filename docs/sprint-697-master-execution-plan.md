# Sprint 697: agent-ready sites, the page is the repo root

Epic: software-shaping. State: **backlog, planning only** (filed 2026-11-23,
reviewed with the operator the same day; multi-pronged announcement and the
same-origin MCP endpoint agreed; stories reviewed against this plan the same
evening, findings below). Design of record: `agent-ready-sites.md`. The
sprint card and its stories are authoritative; the stories table in the
design doc is the first draft and is superseded by the card (A3 there is now
A3b; A3 is the MCP endpoint).

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
- The MCP endpoint is `<origin>/mcp` on the pages' own origin: a reverse
  proxy with the pages' auth (session cookie or relationship stamp) to the
  owner's `bashy mcp serve`; no redirect. Tool tiers follow the pages' tiers.

## Story review (2026-11-23, evening)

The seven stories (seq 671 to 677, ids on the card) were read against this
plan, the design doc and the card. Findings, each with the proposed change;
none is applied until the operator agrees, since the sprint is planning only.

1. **Stories read as assigned but no worker exists.** All seven carry
   `status: assigned` with an assignee; that came from stamping the vendor
   proposals (commit `3c8f7d005`), not from `sprint assign`. No weave run,
   claim or inbox traffic exists for 697 and the conductor seat is unclaimed,
   yet the card already answers `next` with "A1 [p1/assigned]". Proposed:
   set the seven stories back to `todo`, keep the assignee as the proposal.
   First conductor action after the operator's go.
2. **Priority order contradicts the lane order.** Execution is priority
   first. p1 is A1, A2, A3, A5; p2 is A3b, A4, A6. But A1's acceptance needs
   A3b (`/agents.txt` must parse with the bashy consumer), A3b is in wave 1
   by design, and A5 (p1) cannot start before wave 3. Proposed: A3b to p1 so
   wave 1 is all p1; A5 stays p1 and is recorded as gated on A2 and A3 (a
   priority-first conductor must not pull it forward). A4 and A6 stay p2.
3. **A3's title is stale.** The title still says "published through outpost
   or the hosted relay"; the body and the design doc were reworked to the
   same-origin proxy with no redirect. Proposed: retitle to "A3 Site MCP
   endpoint at `<origin>/mcp`: same-origin proxy with the pages' auth to
   `bashy mcp serve` profile `site`; server card".
4. **The hosted-plane proxy for `/mcp` has no owner story.** A3's body
   splits itself into the engine side (bashy/yoke profile, outpost app proxy,
   template server card) and "the hosted-plane proxy for dhnt.io", but the
   story is one card assigned to claude. The hosted plane is a private
   repository and, by this plan's own rule, work there must be tracked on the
   sprint before it can be assigned; A2 is the only hosted-plane story.
   Proposed: A2 absorbs the `/mcp` route (POST plus SSE GET proxied through
   the pages' auth middleware to the owner's engine, and
   `/.well-known/oauth-protected-resource` pointing at the site sign-in),
   A2 goes from 5 to 8 points, still codex, still one release. A3 becomes
   engine side only. A3's live acceptance (fleet CLIs connect to
   `<origin>/mcp` on dhnt.io) then lands with A5; A3's own acceptance runs
   against the outpost app proxy on a companion or sample site.
5. **A1 is one story for nine channel groups at 5 points.** The channels
   that A2, A3b and the MVP consume are the agent block and twins, `agent:`
   front matter and meta twin, `/agents.txt`, the `Bashy-Shaped` header, the
   `Link` relations, Markdown-first serving with the tie-break, and the
   `site check` equivalence rule. The rest (humans.txt, agent-card.json,
   api-catalog, security.txt, robots/sitemap/feed/noscript/JSON-LD, DNS TXT
   note) is the long tail. Proposed: keep A1 as one story but order its work
   core first, and let the conductor split the long tail into A1b (3 points,
   same vendor) only if A1 misses its first review; `dhnt/site` v0.2.0 is
   tagged when the core channels pass `site check`, the tail can ride v0.2.1.
6. **A4 depends on A3 as well as A3b.** A4's acceptance includes "the MCP
   endpoint refuses an unauthenticated shape call", which is A3's
   deliverable. Proposed: A4 waits for both; that acceptance line stays as
   the cross-check, not as A4's own work.
7. **Vendor load.** The proposals put 13 points on agy (A1, A3b, A6) and 13
   on claude (A3, A4), 5 on codex, 5 on muse. agy-gemini4-carbon is active on
   Sprint 696 at the time of this review and holds the gate host's first
   lane. Proposed: A6 moves to muse (docs, after its A5 runner leg lands) or
   waits until agy's 696 story is accepted; no change to the others.
8. **Decisions list.** The design doc's reserved decisions 1 (publish
   `/AGENTS.md`) and 2 (Markdown-first for listed user agents) were settled
   by the operator's channel direction and are already A1 scope; the plan's
   reserved item 1 was settled the same day. Both lists are consolidated
   below; A6 brings the design doc's lists and stories table in line with
   the card.

Nothing else was found: acceptance lines, venues, worker rules and the
`text/bashsharp` data-block note are consistent across the stories, the
design doc and this plan. `docs/sprint-697-evidence.md` does not exist yet;
the first accepted story creates it.

## Stories

Dependency order. Vendor is the proposal (agy by default for evaluation;
codex on the hosted plane where it delivered S1a/S1b; claude for bashy
internals; muse for the runner it wrote). Points per the ladder; the
"proposed" column shows the review's changes against the card as filed.
Total as filed: 36 points; as proposed: 39.

| # | Story | Repo | Vendor | Pts (filed → proposed) | Prio (filed → proposed) | Acceptance |
|---|---|---|---|---|---|---|
| A1 | Template: every announcement channel, `agent:` front matter and meta twin, `/AGENTS.md`, `/skill.md`, `/llms.txt` preamble, well-known files, Markdown-first for listed agent user agents, Accept tie-break by order, `site check` equivalence rule; regenerate `dhnt/site` v0.2.0. Core channels first (finding 5) | bashy `examples/shaping/site`, `dhnt/site` | agy | 5 | p1 | template tests green on the gate host; sample site and `dhnt/site` pass `site check`; `curl -I` shows `Link` and `Bashy-Shaped`; `/agents.txt` parses with A3b; the three representations agree on links, ids, revision and the block |
| A2 | Hosted plane serves the convention for dhnt.io (paths, headers, serving rule; absorbs cloudbox 60b2b1007498; HTML ETag through the edge decided) **plus the `/mcp` same-origin proxy and `/.well-known/oauth-protected-resource`** (finding 4); one release; live verification | hosted plane | codex | 5 → 8 | p1 | every rule verified by `curl` through the live edge; `/mcp` proxied with the pages' auth to the owner's engine; existing routes unchanged; release per the cloudbox playbook with operator go |
| A3 | Site MCP endpoint, engine side: `bashy mcp serve` profile `site` (list_pages, read_page, cite; shape wish/verify/preview/approve/undo by the proxied principal's tier), the outpost app's same-origin `/mcp` proxy for companion sites, the server card from `site.json` (retitled, finding 3) | bashy, yoke, outpost, template | claude | 8 | p1 | Claude Code, Codex, Gemini CLI and OpenCode connect to `<origin>/mcp` of a companion or sample site from the URL in the agent block and call read_page and cite; a signed-in owner shapes through MCP, a member or anonymous caller is refused by name with the pages' tier rules; the engine behind the proxy is the owner's; the dhnt.io leg is verified in A5 |
| A3b | bashy consumer: `site explore` (reads `/agents.txt` first, then header, relations, block), `site attach` (skill from the well-known index or `/skill.md` through the admission gate; `skills add` from a URL), `site cite`, `site shape`, `site recipe` (prints; runs only on an explicit flag in the sandbox, effects read,net, origin-bound), `fetch` surfaces the block | bashy, yoke | agy | 5 | p2 → p1 | script tests against the template fixture and against a site with none of the channels (graceful refusal) |
| A4 | bashy identity to sites: stable user agent, optional RFC 9421 signed requests with the outpost key and a key directory; template-side verification; MCP auth as the primary signal; detection never gates content | bashy, outpost, template | claude | 5 | p2 | a signed `bashy fetch` is verified by the template server, an unsigned one is served the same content; cross-check: the A3 endpoint refuses an unauthenticated shape call |
| A5 | Feel-at-home acceptance: discovery runner task leg (URL plus "find out how to work with this site and do what it says"); matrix on the live site for the fleet CLIs, a browser and a chat fetcher; server log plus transcript per client; includes the dhnt.io `/mcp` leg | bashy `examples/shaping/discover`, evidence | muse | 5 | p1 (gated on A2, A3) | table per client: read the block, fetched index or skill, connected to MCP and which tools, used or installed bashy, cited correctly, time to first correct action; recorded as observed |
| A6 | Docs: design indexed; design doc's stories table and decisions aligned with the card; kb runbook "make your site agent-ready"; bashy README "For agents" and the bashy skill carry the convention and the MCP endpoint | umbrella, bashy | agy → muse (finding 7) | 3 | p2 | docs reviewed; scrub gate clean; an agent handed the bashy repo learns what to do with an agent-ready page |

## Lanes and order

```
A1 ──► A2 (hosted plane release, incl. /mcp proxy) ──► A5 (live matrix) ──► close
 ├───► A3 (MCP engine side) ─────────────┬───────────────┘
 └───► A3b (bashy verbs) ──► A4 (identity) ◄┘
A6 alongside, finished after A3
```

- **Wave 1** (parallel, independent files, all p1 after finding 2): A1, A3,
  A3b; A6 draft.
- **Wave 2**: A2 after A1 publishes `dhnt/site` v0.2.0 (the `/mcp` route
  can ship before A3 is accepted; it returns the upstream's error until the
  owner's engine serves profile `site`); A4 after A3b and A3.
- **Wave 3**: A5 after A2 and A3 are live; A6 final.

MVP = A1 + A2: that changes what every agent sees on dhnt.io, and with the
`/mcp` route in A2 the no-binary path needs only A3 to light up. A3b, A4
make bashy the reference consumer. A5 makes the claim measurable.

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

## Start checklist (conductor, after the operator's go)

1. Apply the agreed story changes from the review: statuses back to `todo`,
   A3b to p1, A3 retitled, A2 scope and points, A6 vendor.
2. Track A2 on the hosted plane (`sprint track`) before assigning it.
3. Check peers: Sprint 696 is in flight on the gate host's first lane; take
   a lane claim before any 697 build and announce on `mb`.
4. Baseline pins, then assign wave 1.

## Decisions settled with the operator (2026-11-23)

1. Multi-pronged announcement on classic standards, all channels in the
   design table, including `/agents.txt` as the first implementation. This
   also settles the design doc's reserved items 1 and 2: `/AGENTS.md` is
   published and Markdown-first serves the listed agent user agents.
2. The recipe block stays `type="text/bashsharp"`, an HTML data block, never
   JavaScript; hidden text equals visible text.
3. Agents switch to the owner's fixed MCP endpoint instead of downloading a
   binary; bashy remains the native path.
4. `<origin>/mcp` is a same-origin proxy with the pages' auth to the owner's
   engine; no redirect.

## Decisions still reserved for the operator

1. The eight review findings above: accept as proposed, or amend.
2. Signed bashy requests in this sprint (A4) or user agent only now.
3. Whether the shaping entry point is advertised to every agent or only to
   authenticated MCP sessions and verified bashy agents.
4. Vendors as proposed (with A6 to muse), or reassign.
5. When Sprint 697 starts relative to Sprint 696 (shared gate host, shared
   agy worker).

## Not doing

WebMCP (origin trial only); an MCP server on the hosted plane for visitors
(669 scope); new well-known registrations or link relations of our own;
visitor shaping on the live site; any content change to the dhnt.io pages
beyond the agent block.
