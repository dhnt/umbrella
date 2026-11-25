---
id: 141bc34d3262
kind: feature
title: 'A2a Ship the agent-ready pages without unusable surfaces: no /mcp and no ''bashy site attach'' advertising until both work'
seq: 739
status: done
priority: p0
labels:
    - release
    - hosted-plane
created: 2026-11-25T06:08:18.905704Z
assignee: codex-gpt6.2-astra
sprint: 699
sprint_id: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a
sprint_title: 'Release train 1: one hosted-plane deploy for Sprints 682/697 + live verification'
closed: 2026-11-25T07:41:30.665091Z
closed_by: claude-opus5.5
---

Operator rule 2026-11-24: every released feature is complete and usable; ship the complete part, put the rest in a follow-up sprint. Operator APPROVED A2a on 2026-11-25 (699 decisions form).

PROBLEM (found during train 1 reconciliation): with PUBLIC_SITE_MCP_UPSTREAM unset, the hosted public pages (github.com/dhnt/site v0.2.1, embedded site.json origin https://ai.dhnt.io) still advertise <origin>/mcp: agents.txt (mcp:, mcp_card:), skill.md ('connect to MCP at'), AGENTS.md, humans.txt, the in-page #agent-note, the Link service-desc header, /.well-known/mcp/server-card.json and /.well-known/oauth-protected-resource. Every anonymous or cookie caller of /mcp is denied, so that surface is unusable. The pages also say 'bashy site attach <origin>' (agents.txt bashy:, agent block, index header), a verb no released bashy has (first in bashy 775bcc30, after v1.0.0-rc.40-dev).

DESIGN (smallest change; data-driven, no hosted-plane conditional):
1. dhnt/site (github.com/dhnt/site, main f924301, tag v0.2.1): add two opt-outs to Config in render.go: "mcp": "off" (the literal string; empty keeps today's default <origin>/mcp) and "site_attach": false (pointer or explicit bool; absent = true, so other sites are unchanged). When MCP is off: render no MCP line or sentence anywhere (agents.txt mcp:/mcp_card:, skill.md, AGENTS.md, humans.txt, agent note, llms/index headers), no service-desc Link, and the server card and oauth-protected-resource paths are not served (404). When site_attach is false: no 'bashy site attach' line anywhere. check.go accepts absence when off and still requires presence when on. Set both in site.json for dhnt. Tests: one test per opt-out asserting absence when off and presence when on (render + server + check). Tag v0.2.2.
2. Hosted plane (cloudbox dev): bump github.com/dhnt/site to v0.2.2. In hub/internal/publicsite, serve the server-card path only when the site's MCP is on, and keep Paths/route goldens consistent. Existing pages, twins, agents.txt, skill.md and citation tests stay green. /mcp routing is unchanged (Bearer still goes to the gateway).
3. Not here: bashy's site template (examples/shaping/site/template) parity goes to Sprint 711 F1/F2.

ACCEPT: dhnt/site tests green, v0.2.2 tagged and pushed; cloudbox hub go test for publicsite and server (short, GOWORK=off) green on a gate lane, except the pre-existing 376365ab reds, compared by name; a curl of the locally built hub serving the public pages shows no 'mcp' and no 'site attach' text and a 404 server card. Merge to cloudbox dev BEFORE the 699 freeze (2026-11-25 12:00 PST). No deploy.

WORKER RULES: dhnt/site: branch off main, PR-free fast-forward push of main + tag after green tests. Cloudbox: worktree off origin/dev; one commit; rebase on origin/dev before pushing. Trailers on every commit: Sprint: #699 / Sprint-ID: f30c730a-f8ad-57ba-9122-6f1c2a1cd97a / Story: <seq on this story> / Story-ID: 141bc34d3262 / Agent: <your name>. Hosted-plane code is private: no cloudbox source or paths in public repos. Builds and tests on the gate host lane you claim (bashy claim), never the dev box. Do not touch umbrella pins or any public Go module pins. Submit with bashy sprint submit 699 141bc34d3262 --as <your name> -m '<verify commands, results, SHAs>'.

## Worker verification

The gate host passed `GOWORK=off go test -count=1 ./...` for the
`dhnt/site` v0.2.2 candidate at `7c5928f`. The opt-out tests exercise
each setting independently and cover default discovery, rendering, HTTP
responses and validation.

The hosted candidate at `969c704` passed the short public-page and server
suites in the release workspace. Both also passed with `GOWORK=off` and a
temporary module file carrying the workspace dependencies. The plain standalone
server command required module updates on both the baseline and candidate.
The satellite suite had the same single failure by name on both revisions,
tracked in `376365ab`.

With the upstream unset, curl against the gate-built hub returned 200 for all
19 public paths. Their bodies and headers contained no MCP or site-attach
advertising. The agents index retained its citation format, and GET and HEAD
on the server card both returned 404.

## Integration (release manager, 2026-11-25)

dhnt/site main and tag v0.2.2 at 7c5928f (module proxy checksum equals the hosted go.sum); hosted dev fast-forwarded to 969c704. Worker evidence commit fad625a8d carried here by hand (story-store merge conflict).
