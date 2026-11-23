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
| S1a hosted-plane public pages | codex, cloudbox run #65, cloudbox dev `dea63ff` | `go test -race ./internal/publicsite` ok; UI tests green; Linux gate below | accepted 2026-11-23 |
| S1b hosted plane imports `github.com/dhnt/site` v0.1.0 | codex, cloudbox run #66, cloudbox dev `e70a031` (fixture removed; hub JSON byte-equal to the module's `RenderJSON`) | `go test -race ./internal/publicsite` ok; UI tests green; Linux gate below | accepted 2026-11-22 |
| S0c importable library package | agy, run #163, bashy `7473e814` (root `package site`, `cmd/server`, `site init --module`, optional `summary`) | `go vet` + `go test` in `template/` ok 1.0 s; script tests ok 51.3 s; fast-forwarded to bashy main; umbrella pin `9c49d22f0` | accepted 2026-11-22 |
| S3 owner round trip | muse, run #165 | see the section below | accepted 2026-11-23 |

## S1 Linux gate (hosted plane, candidate cloudbox dev `e70a031`)

Venue: the gate host's Linux lane (WSL, podman 4.9.3), the exact cloudbox
`make test` container recipe: `golang:1.27.2-alpine`, `apk add gcc musl-dev
linux-headers git bash`, `GOTOOLCHAIN=auto`, the warm `cloudbox-gomodcache` and
`cloudbox-gobuildcache` volumes, `--cpus 8 --memory 12g`, `go test -short
./hub/...` from the workspace root.

| Run | Result | Notes |
|---|---|---|
| 1, 06:42–06:53Z, default timeout | 40 ok, 2 FAIL | both root-caused to the shipped tree, not the product: `internal/api` `TestNoDirectDBImportFromChokepointConsumers` parsed an AppleDouble `._appstore.go` left by the macOS tar; `internal/provisioning` hit the 10 min default timeout (the package needs about 11.5 min at 8 CPUs) and `TestUserDataEmbedsInstallerVerbatim` failed because the tar path rewrite had changed the `script/install-satellite-vm.sh` symlink target |
| repairs | | `._*` files deleted; symlink restored to `../hub/internal/provisioning/install-satellite-vm.sh`; `internal/api` ok on candidate (76.8 s) and on the base `7e514cc` (76.4 s); the single provisioning test ok on both |
| final, 07:47–07:59Z, `-timeout 30m` | **exit 0, 42 packages ok, 0 FAIL** | includes `internal/server` (route goldens), `internal/publicsite`, `internal/handlers`, `internal/api`, `internal/provisioning` |

The second build host's podman VM, tried first, stopped creating processes
mid-run (`getpwnam(root) failed`, I/O errors in WSL); its system drive was
found completely full shortly after. It was not restarted and is left for the
operator.

## S1 release e2e gate (hosted plane, candidate cloudbox dev `e70a031`)

The release playbook's step 2: `script/e2e-multisat.sh` against the gate
host's Linux lane over the playbook's transport wrapper (ssh-alias route),
affected range `v0.18.81..HEAD`, which selects the `desktop-journey`
scenario, with the Chrome image and the browser checks required.

| Run | bashy / outpost in the sandbox | Result | Cause |
|---|---|---|---|
| 1 | local umbrella build (bashy `c8650eb4`, the rc.40 thin core; outpost `a1c9307`) | FAIL, 21 s, fixture step `member invite` | the adapter command tried to fetch a Go toolchain from go.dev inside the no-network sandbox (bashy finding `4f8f81c2ad8c`) |
| 2 | harness default release `v1.0.0-rc.27` | FAIL, 21 s, fixture step `member invite` | `member: command not found` (the pinned release predates the verb; the previous release's gate had used a pre-rc.40 umbrella bashy) |
| 3 | released `v1.0.0-rc.37` (`BASHY_TAG`), the latest promoted release | **PASS, exit 0, 77 s, 29/29 checks OK** incl. the six browser checks | |

Evidence: `cloudbox/.e2e-multisat/desktop-journey/evidence.json` (private
checkout), identities cloudbox `e70a031…`, bashy `v1.0.0-rc.37`, klatch
`1.2.7`. The candidate is unchanged across the three runs; both failures were
harness pins, not product defects.

Gate status for the hosted-plane release of `e70a031`: unit suite PASS (42
packages), desktop-journey e2e PASS. Release (tag, deploy gate on the host,
images, App Platform spec, satellites, live smoke) awaits the operator's go.

## Live after state (hosted plane v0.18.82, deployed 2026-11-23 12:26Z)

Operator go given 2026-11-23. Tag `v0.18.82` = cloudbox `e70a031`; release
build on the test host: smoke PASS, deploy gate PASS (full Linux suite and
Postgres), images pushed; master App Platform deployment `2fd3aba0…` ACTIVE
12/12 at 12:26Z with only the three image tags changed; `/version` reports
`v0.18.82`, commit `e70a0317`, `mode=master`, `ready:true`; the three
anonymous desktop routes return 401. Fleet before: master and three
satellites on v0.18.80.

Live edge, 2026-11-23T12:26Z:

| Request | Status | Content-Type | ETag | Vary | Link |
|---|---|---|---|---|---|
| `GET /` | 200 | text/html | none through the edge (origin sets it; `<meta name="revision">` = `ae73c65006b9`) | Accept | alternates `/index.md`, `/index.json` |
| `GET /about` | 200 | text/html | none through the edge (meta revision `361e576b8921`) | Accept | alternates `/about.md`, `/about.json` |
| `GET /index.md` | 200 | text/markdown | `"ae73c65006b9"` | Accept | both twins |
| `GET /index.json` | 200 | application/json | `"ae73c65006b9"` | Accept | both twins |
| `GET /about.md` | 200 | text/markdown | `"361e576b8921"` | Accept | both twins |
| `GET /about.json` | 200 | application/json | `"361e576b8921"` | Accept | both twins |
| `GET /robots.txt`, `/llms.txt` | 200 | text/plain | | | |

Negotiation on `/about`: `Accept: text/markdown` → Markdown (ETag
`361e576b8921`); `application/json` → JSON; `*/*` → HTML; a Markdown fetch
followed by a default fetch returns HTML (no variant bleed). The Claude Code
header `text/markdown, text/html, */*` returns HTML because the origin
prefers HTML on equal q; filed as cloudbox follow-up `60b2b1007498`
(tie-break by listing order), together with the edge-stripped HTML ETag.

Same section and revision across the three representations of `/about`:
HTML ids `about team contact`, Markdown `{#about} {#team} {#contact}`, JSON
`about team contact`, all at revision `361e576b8921`. Home: ids `what start
shape` at `ae73c65006b9`. Navigation Home / About / GitHub present in HTML
and Markdown; `/about` links home and home links `/about`; the Shape badge
(`/?shape=open`) is kept on both pages. Citation form proven live:
`https://ai.dhnt.io/about#team @ 361e576b8921`.

Satellites: all three accepted the v0.18.82 target (204) at 12:26Z and still
reported v0.18.80 seven minutes later, the relay blocker recorded at v0.18.81;
the fleet runs mixed and the satellite rollout stays an operator item.

Visitor leg (headless Chrome via `bashy browser --mode solo` on the gate host)
and agent leg (`bashy fetch`) both read `/about`, reached home and returned,
and extracted the same section ids `about, team, contact` (see the discovery
matrix below).

## Discovery matrix (S2), live site, 2026-11-23 12:3xZ

Runner: `bashy --bashsharp bashy/examples/shaping/discover/discover.bsh matrix
https://ai.dhnt.io --md`; every client was handed only the page URL
`https://ai.dhnt.io/about`. Browser leg on the gate host (headless Chrome is
never run on the dev box); agent-CLI legs on the dev box where those CLIs are
installed. "Discovery" is what the client needed to reach a structured
representation: `self-md` = got Markdown by itself, `twin` = found or needed
the direct `.md`/`.json` twin, `skill` = would need the reading skill.

| Client | Request it sent | Received | Section ids it extracted | Discovery | fetched llms.txt | followed rel=alternate |
|---|---|---|---|---|---|---|
| curl (default `*/*`) | GET `*/*` | text/html | about, team, contact | twin (alternate link present) | no | no |
| curl with the Claude Code header | GET `text/markdown, text/html, */*` | text/html (origin prefers HTML on equal q; follow-up filed) | about, team, contact | twin | no | no |
| `bashy fetch` | GET | text/html | about, team, contact | twin | no | no |
| `bashy fetch --md` | GET, converted locally | Markdown from the HTML | about, founder & team, contact (headings, not ids) | self-md | no | no |
| `bashy browser --mode solo` (headless Chrome, gate host) | rendered page | text/html (rendered) | about, team, contact | twin | no | no |
| claude (Claude Code CLI, its fetch tool) | agent fetch | not observed: the CLI's web fetch was not permitted in a non-interactive run | none | skill | no | no |
| codex (its fetch tool) | agent fetch | error, no page read | none | skill | no | no |
| gemini | absent on the host | | | | | |
| agy (its fetch tool) | agent fetch | text/html | about, team, contact; listed `/about.md` and `/about.json` among the links | twin | no | no |
| opencode (its fetch tool) | agent fetch | text/html (inferred; its tool hides response headers) | about, team, contact | twin | no | no |

Findings: every client that could fetch the page extracted the same three
section ids from the server-rendered HTML; none fetched `/llms.txt` or
followed `rel=alternate` on its own (matching the research expectation); the
only negotiated Markdown path that fired by itself is `bashy fetch --md`'s
local conversion; the Claude Code style header did not negotiate Markdown
because the origin breaks ties toward HTML (cloudbox follow-up
`60b2b1007498`). Two agent CLIs could not fetch at all in a non-interactive
run and would need the `dhnt-site` skill (the twins and the citation record)
handed to them. Raw tables: gate host and dev box runs, kept with the sprint
scratch; the dev-box run's agent legs are the clients bashy works with.

## Owner round trip (S3)

Run 2026-11-23T05:42Z–05:47Z on the owner's workstation console (the bashy
apps service on loopback port 22749; the `bashy shape` CLI talks to the same
engine). No engine change. Base: `github.com/dhnt/site` main `be766e2`, tag
`v0.1.0`; base page revisions `/` = `ae73c65006b9`, `/about` =
`361e576b8921`. Every command below was run as recorded; hosts are named by
role only.

### (0) Live before-state

```
curl -sS -D - -o about-before.html https://ai.dhnt.io/about
HTTP/2 200
content-type: text/html; charset=utf-8
(no ETag, no Vary, no Link)
3782 bytes, sha256 f9c64b91fd8b5ebec489712fa2eb43449ee6add3a70898a4a6cfa5ba74eae446
```

### (1) Register the shaped app

```
bashy app add dhnt-site --type shaped --source https://github.com/dhnt/site --label 'DHNT site'
dhnt-site -> /dhnt-site/ (shaped, https://github.com/dhnt/site)

bashy shape status dhnt-site --json
{"app":"dhnt-site","principal":"dhnt:agent/muse-wonder",
 "active":"be766e2ba3909e9733811326f00df07ac24aace0","candidates":[]}

curl -sS http://127.0.0.1:22749/dhnt-site/about.json
HTTP/1.1 403 Forbidden, body "authentication required" (24 bytes)
```

The console refuses anonymous callers, so the owner view below is the
`bashy shape status/show/history --json` output (same engine). The base
itself serves all three twins at the base revision (candidate-module server
run from the imported checkout):

```
GET /about      200 ETag: "361e576b8921" text/html; charset=utf-8        2711 bytes, Vary: Accept
GET /about.md   200 ETag: "361e576b8921" text/markdown; charset=utf-8    1661 bytes, Vary: Accept
GET /about.json 200 ETag: "361e576b8921" application/json; charset=utf-8 3976 bytes, Vary: Accept
```

`bashy shape history dhnt-site --json` after registration: base
`be766e2ba3909e9733811326f00df07ac24aace0`, release `v0.1.0` at
2026-11-23T05:35:20Z.

### (2) Wish — agent route blocked, hand import used

```
bashy shape wish dhnt-site --page /about --element 'section=team revision=361e576b8921' \
  --agent agy:gemini4-carbon "Copy edit in the Founder & team section of content/about.md: \
  change 'leads product and engineering' to 'leads product, engineering and design'. Change nothing else."
```

Result, identically for `agy:gemini4-carbon` (candidate `0f1e269f3ddcbc24`),
fallback `codex:gpt6-astra` (`686dce0db1e8b613`), fallback `claude:opus5`
(`d8c3d6fdad2f26a5`), and a repeat from a directory containing a `go.mod`
(`0e4fd400ee67c081`): `status: failed`, error `shaping agent: delegate:
exit status 1: go: go.mod file not found in current directory or any parent
directory; see 'go help modules'`. The delegate runs outside any module
directory on this venue, so no agent-generated candidate was produced; the
exact refusal is recorded here and the run continued per plan.

The identical one-line edit was then imported by hand:

```
bashy shape wish dhnt-site --page /about --element 'section=team revision=361e576b8921' \
  --from <hand-made copy of the base checkout with only that line changed> \
  "Copy edit in the Founder & team section of content/about.md: change \
  'leads product and engineering' to 'leads product, engineering and design'. Change nothing else."
{"id":"9f5cf68fe47e7700","status":"ready",
 "base_rev":"be766e2ba3909e9733811326f00df07ac24aace0",
 "rev":"59b3ce0d212c64547811dc702194fdcd3a673ed1"}
```

Candidate id: `9f5cf68fe47e7700`. Source diff is exactly one line in
`content/about.md` (`leads product and engineering` → `leads product,
engineering and design`); the engine's `shape diff` also lists the
auto-created shaping tracking files under `docs/todo/`, which are engine
bookkeeping, not content.

### (3) Stale base

A second wish carrying the home page's revision was imported the same way
(candidate `edd68ddeff2459fc`, `section=team revision=ae73c65006b9`).
`bashy shape verify dhnt-site edd68ddeff2459fc` returned `verdict pass`:
the `--from` import carries no wish-provenance file into the candidate, so
the frozen `checks/stale-base.bsh` had no element to compare on this path
and passed vacuously — a real gap in the import path, recorded as observed,
not as the expected refusal. Running that same frozen check directly
against the true base with the stale element gives the contract refusal:

```
SITE_BASE_DIR=<base checkout> SITE_WISH_PAGE=/about \
SITE_WISH_ELEMENT='section=team revision=ae73c65006b9' checks/stale-base.bsh
stale-base: fail (stale, re-read: page /about section team is at revision 361e576b8921, wish had ae73c65006b9)
exit 1
```

The same direct check with `revision=361e576b8921` prints `stale-base: pass`
(exit 0). The stale candidate was then discarded:
`bashy shape reject dhnt-site edd68ddeff2459fc` → `status: rejected` (its
isolated workspace is removed on reject; a later `shape show` for it finds
no candidate record). This matches the earlier hermetic S0b record, where
an agent-carried stale wish was refused by name at verify; on this venue
the refusal is proven for the frozen check itself, and the import path's
missing provenance is the honest delta.

### (4) Verify, diff, preview — one new revision in three representations

```
bashy shape verify dhnt-site 9f5cf68fe47e7700
status: verified, verdict pass (checks/links-resolve, checks/render-determinism,
checks/stale-base, checks/unique-ids, shape/compat), seal
253dded54a7af1d5b85449c4a511600a58f7bc980b465cfa85098bf4c1fa14f1

bashy shape diff dhnt-site 9f5cf68fe47e7700
one content line in content/about.md, as in (2)

bashy shape preview dhnt-site 9f5cf68fe47e7700
url: http://127.0.0.1:22749/shape/dhnt-site/preview/9f5cf68fe47e7700/
```

Anonymous fetches of the preview's `/about`, `/about.md` and `/about.json`
each return `HTTP/1.1 403 Forbidden` / `authentication required` — the
console's refusal, recorded, never candidate bytes. The owner view is the
candidate module's own server/render from its isolated workspace (the same
code the preview proxies), and all three representations carry ONE new
revision, `6960548106fa` (base `361e576b8921`):

```
GET /about      200 ETag: "6960548106fa" text/html; charset=utf-8        2719 bytes, Vary: Accept
GET /about.md   200 ETag: "6960548106fa" text/markdown; charset=utf-8    1669 bytes, Vary: Accept
GET /about.json 200 ETag: "6960548106fa" application/json; charset=utf-8 3992 bytes, Vary: Accept
HTML  <meta name="revision" content="6960548106fa">, section ids about, team, contact
MD    front matter "revision: 6960548106fa", headings {#about} {#team} {#contact}
JSON  {"path":"/about","revision":"6960548106fa","sections":["about","team","contact"]}
All three show: "leads product, engineering and design"
```

That is the owner (HTML) and Bashy (Markdown/JSON) inspecting the same
candidate: one revision, the edited copy, unchanged section ids
`[about team contact]` in every representation.

### (5) Approve and isolation

```
bashy shape approve dhnt-site 9f5cf68fe47e7700   → status: approved
bashy shape status dhnt-site --json
active: 59b3ce0d212c64547811dc702194fdcd3a673ed1 (the candidate, owner principal)
curl -sS http://127.0.0.1:22749/dhnt-site/about.json   (anonymous, no cookie)
HTTP/1.1 403 Forbidden, "authentication required" — a refusal, never the candidate
```

A second principal cannot be minted on this console here (no pairing was
performed), so the honest limit is: no second browser principal was
exercised. At the CLI layer, `bashy shape status dhnt-site --user
'dhnt:agent/second-principal-probe' --json` resolves to a different
represented user and still shows `active:
be766e2ba3909e9733811326f00df07ac24aace0` (the base) with no candidates —
the approved candidate is active only for the owner's principal.

### (6) Undo and history

```
bashy shape undo dhnt-site
{"Revision":"be766e2ba3909e9733811326f00df07ac24aace0",
 "Previous":"59b3ce0d212c64547811dc702194fdcd3a673ed1"}
bashy shape status dhnt-site --json   → active be766e2ba3909e9733811326f00df07ac24aace0 (base again)
bashy shape history dhnt-site --json  → two versions listed:
  activate 59b3ce0d212c64547811dc702194fdcd3a673ed1  v0.0.0-20261123054334-59b3ce0d212c  2026-11-23T05:46:35Z
  undo     be766e2ba3909e9733811326f00df07ac24aace0  v0.1.0                              2026-11-23T05:47:01Z
  plus release v0.1.0 be766e2ba3909e9733811326f00df07ac24aace0
```

### (7) Live after-state

```
curl -sS -D - -o about-after.html https://ai.dhnt.io/about   (2026-11-23T05:47:07Z)
HTTP/2 200, content-type: text/html; charset=utf-8, no ETag
3782 bytes, sha256 f9c64b91fd8b5ebec489712fa2eb43449ee6add3a70898a4a6cfa5ba74eae446
cmp about-before.html about-after.html → byte-identical
```

The public page kept its published revision; S1 has not been released yet,
so the live shell is untouched by the engine round trip, as required.

### Outcome and limits

Proven on the owner's engine host: registration by git URL, a verified
candidate (`9f5cf68fe47e7700`) whose HTML, Markdown and JSON agree on one
new revision (`6960548106fa`) with only the requested copy edit, approval
scoped to the owner principal, anonymous refusal, undo to the base, both
versions in history, and a byte-identical live page before and after.
Not proven here, recorded plainly: agent-generated wishes (all three
routes refused by the delegate's working directory, see step 2); the
stale-base refusal at `verify` time for `--from` imports (the frozen check
itself refuses by name when given the provenance, see step 3); and a
second paired browser principal (none minted, see step 5).
