# Sprint 699 evidence: release train 1 (hosted plane v0.18.83)

Hosts by role. Wire-level only; the private release packet holds the rest.

## Freeze and gates
- Freeze 2026-11-24 23:53 PST: public pins at heads (umbrella 9331a67b0, `bashy mod drift` 0 stale), hosted candidate tagged v0.18.83. dhnt/site v0.2.2 (7c5928f).
- Release e2e on the gate host, all 16 scenarios: 14/16, the two known-blocked scenarios unchanged; desktop-journey 29/29. Equal to the last full-run baseline. Two test-venue causes were found and recorded before the green run (bashy D1 fresh-HOME toolchain download, Sprint 714; harness consent flag in release-artifact mode, pre-existing).
- Deploy gate (full Linux suite + Postgres dialect) and local smoke: PASS.

## Deploy (operator GO 2026-11-25)
- Master on the hosted plane: v0.18.83 ACTIVE; spec change = image tags + the hosted client-IP platform header setting (H4).
- Three satellites: upgrade target accepted, all on v0.18.83 and ready within ~5 minutes.

## Live checklist (agent-run, test requests only)
| Check | Result |
| --- | --- |
| `/version` on the master | v0.18.83, ready |
| Anonymous desktop routes | 401 |
| Public pages `/`, `/about`, `/agents.txt`, `/skill.md`, `/llms.txt`, `/robots.txt` | 200 |
| `agents.txt` advertises `/mcp` or `bashy site attach` (A2a) | no |
| MCP server card | 404 |
| `/mcp`: anonymous, cookie-only, invalid Bearer | 401 each |
| `Link` header on `/about` | no service-desc |
| Accept matrix on `/about` (markdown, json, `text/markdown, text/html, */*`, html) | markdown, json, markdown, html |
| Satellite: `/agents.txt`, `/skill.md`, `/llms.txt`, server card (A2b) | 404 each |
| Satellite signed-out `/` (H3) | 200, `private, no-cache`, sign-in shell |
| Satellite `/` with a session cookie (H3) | 302 to `/periscope/` |
| Client-IP trust (H4): startup setting; forged `X-Forwarded-For` | platform header trusted, no proxies; logged address is the real client |
| H5 master share reaches a satellite; revoke denies | open (test accounts) |
| Re-invite delivers a real mail | open (test accounts) |
| A5 feel-at-home matrix | open (story 4e147ad3) |

Observation: the satellite's static page shell still names the operator's company in its `<title>` and meta description before the app renders the sign-in. Follow-up todo, not a regression of this train.
