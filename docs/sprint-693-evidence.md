# Sprint 693 evidence: dhnt.io navigation and shaping for people and agents

Sprint UUID `cdef0a9b-7ae4-54d0-bd26-139ef3609d4a`. Plan:
`sprint-693-master-execution-plan.md`. Wire-level records only: URLs, headers,
bodies, commit and revision ids. Hosts by role. Nothing from the hosted plane's
internals.

## Before state (live edge, 2026-11-23T05:01Z)

| Request | Status | Content-Type | ETag / Vary / Link | Body |
|---|---|---|---|---|
| `GET https://ai.dhnt.io/` | 200 | text/html | none | 3782 bytes, single-page shell |
| `GET https://ai.dhnt.io/about` | 200 | text/html | none | 3782 bytes, the same shell |
| `GET /about` with `Accept: text/markdown` | 200 | text/html | none | HTML (negotiation ignored) |
| `GET /about` with `Accept: application/json` | 200 | text/html | none | HTML (negotiation ignored) |
| `GET /about.md` | 404 | | | |
| `GET /robots.txt` | 404 | | | |
| `GET /llms.txt` | 404 | | | |

`dhnt.io` and `www.dhnt.io` answer `301` to `ai.dhnt.io` with the path kept
(probed 2026-11-23T02:53Z). The shell's no-JavaScript block was identical on
both paths and carried no section ids and no revision.

## Story records

| Story | Delivery | Verification by the conductor | State |
|---|---|---|---|
| S0 generic site template (bashy `examples/shaping/site`) | agy, run #159, bashy `6226a196`, 23 files | `GOWORK=off go test ./...` in `template/` ok 1.4 s; `go test ./...` script tests ok 44.5 s; scrub-grep clean; fast-forwarded to bashy main; umbrella pin `7305646b6` | accepted 2026-11-22; gap filed as S0c (renderer is `package main`, not importable) |
| S2a discovery runner (bashy `examples/shaping/discover`) | muse, run #160, bashy `dcde5281` + `27298e41`, 13 files | `GOWORK=off go test ./...` ok 3.98 s; fixture server implements the plan contract; fast-forwarded to bashy main; umbrella pin `6b971eef8` | accepted 2026-11-22 |
| S0b `dhnt/site` content | claude, run #161, `github.com/dhnt/site` main `6067c3fc` (content, `site.json`, LICENSE, NOTICE, README, `skills/dhnt-site/SKILL.md`) | content fetched from GitHub and read; front matter `title/path/summary/sections`, `## Heading {#id}` | superseded by the S0b assembly below |
| S0b `dhnt/site` final assembly | claude-opus5.5, run #164, `github.com/dhnt/site` main `be766e2` + annotated tag `v0.1.0`, generated from the bashy site template at bashy `7473e814` | `GOWORK=off go build ./...`, `go vet ./...`, `go test -count=1 ./...` ok 0.328 s; `site check .` all four frozen checks pass; `bashy shape verify` pass, sealed `86a667c9`, hermetic `HOME`/`BASHY_HOME`, no public host, parent env scrubbed; stale wish refused (`stale, re-read`); three-representation parity per page via the exported extractors; `go get github.com/dhnt/site@v0.1.0` from GitHub then `go build ./...` ok in a scratch module | submitted 2026-11-23; revisions `/` `ae73c65006b9`, `/about` `361e576b8921`; unblocks S1b and S3 |
| S1a hosted-plane public pages | codex, cloudbox run #65, cloudbox dev `dea63ff` | `go test -race ./internal/publicsite` ok; UI tests green; route-golden and server-package tests need a Linux venue (`make test CONTAINER_RUNTIME="bashy podman"` on the Linux test host) | merged to dev, submitted; Linux gate owed at the S1 release gate |
| S0c importable library package | agy, run #163 | | working |

## Live after state

Pending S1 (hosted-plane release).

## Discovery matrix (S2)

Pending the live release. Runner: `bashy --bashsharp bashy/examples/shaping/discover/discover.bsh matrix https://ai.dhnt.io --md`.

## Owner round trip (S3)

S0b delivered the shaped-app face, so S3 is unblocked. One round trip is
already proven on `github.com/dhnt/site` `be766e2` in a hermetic
`HOME`/`BASHY_HOME` (registered locally, never a public host): a wish on
`/about` carrying `section=team revision=361e576b8921` yields a candidate
whose `bashy shape verify` passes all four frozen checks plus `shape/compat`,
sealed `86a667c908ec61ba9d6fbb5e744c6a3adfc01bb5c29f6caa96d06a6fa19f95d4`;
a wish carrying a superseded revision is refused with `stale, re-read: page
/about section team is at revision 361e576b8921`. S3 still owes the owner's
engine host: candidate preview in all three representations at the new
revision, `approve` isolation across principals, `undo`, and the live
`ETag` held stable throughout.
