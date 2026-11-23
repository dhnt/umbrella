# Plan: effortless bashy install, local-first (humans + agents, every channel)

## Context

bashy already installs from GitHub Releases through one verified path
(`checksums.txt` → `bashy self install`), reachable as a curl/irm one-liner, a
release archive, a `FROM scratch` image, or an agent reading the README. The
operator's direction (2026-11-22): **local first**. The GitHub release is the
first bashy a device ever gets; after that "bashy is all you need", and a team
or org serves its *own* copy (released or freshly shaped/built) from a LAN host
running bashy as the provider (web server, MCP server), without waiting for a
fixed upstream release. Package managers (Homebrew/Scoop/winget) are the
pre-agentic era: not published, docs say so; the stale `dhnt/homebrew-tap` and
`dhnt/scoop-bucket` at v0.32.0 are an operator repo-ops item (archive them),
not a story here. Without bashy, a client uses plain tools: a browser, `curl`,
`git` against loom, or an agentic tool over MCP.

Authoritative source: `github.com/qiangli/bashy` (the user's "github.com/bashy"
meant this; `dhnt/cloudbox` is the hosted side). Sprint 692 (rc.40) stays
focused; this is a new sprint: an **MVP today** (deadline 13:00 PST, so only
existing verbs plus two tiny shell edits) and the **planned stories** behind it.
Backlog sprints 654 (offline bootstrap) and 657 (cooperative chunk transfer,
signed manifests, peer-first self fetch) own the heavy mechanisms and are
referenced, not duplicated.

## Inventory (verified 2026-11-22)

| Surface | Where | State |
|---|---|---|
| One-liners `curl -fsSL https://dhnt.io/install.sh \| sh -s -- --no-service`, `irm https://dhnt.io/install.ps1` | `outpost/scripts/install.sh`, `install.ps1`; dhnt.io → 301 ai.dhnt.io → 302 raw.githubusercontent qiangli/outpost **main** (so a push to outpost main is live immediately, no release) | work (200 verified); todo `8a9f0dede7c6` "404" is stale |
| Installer behaviour | resolves `latest` via api.github.com, fetches `bashy-<os>-<arch>.{tar.gz,zip}` + `checksums.txt` from `github.com/$REPO/releases/download/<tag>`, sha256, extracts `bashy outpost bash sh`, runs `./bashy self install --dir`; env `REPO`, `BASHY_VERSION`, `INSTALL_DIR`/`DHNT_BIN_DIR`; no service by default | no mirror/base knob; Unix prints "Add … to PATH", ps1 edits user PATH |
| `bashy self {fetch,install,build,check,image,seed export}` | `bashy/internal/agentos/self.go`, `self_pair.go`; engine `yoke/pkg/binmgr` | GitHub hard-coded in `bashyReleaseBaseURL`/`resolveBashyRelease`; `self install` with no `--version` installs the 4 **adjacent files** (offline OK); atomic replace; downgrade refusal; `--seed TAR` offline tool cache; first install runs `bashy src fetch bashy` + `examples/defaults/bashy-defaults.bsh apply` |
| `binmgr` | `yoke/pkg/binmgr/{binmgr,github,offline,members,seed}.go` | single verify chokepoint `ensure()`; `download(url)` single URL, no `file://`; **stale-latest bug**: `cachedGitHubTool` answers `latest` from cache before asking GitHub (offline.go:63) |
| LAN push | `bashy remote install <host>` (remote.go) | pushes cached release binary over ssh/scp, version-matched; needs matching-platform archive in cache |
| outpost | `upgrade {--local,--from URL --sha256,--direct}`, `repair binary --from <peer>`, `scp --safe`, `sshd` (:2222, mDNS), mesh `service add NAME 127.0.0.1:PORT` / `mesh dial NAME`, blob-serving template `cmd/outpost/transfer.go` (`model-blobs`), cloudbox `fleet/target` envelope (https-only), post-upgrade bashy auto-install from GitHub (`cmd/outpost/bashy.go`) | peer delivery exists for outpost; none for bashy |
| Serving primitives | `bashy rclone serve http DIR --addr :8080` (LAN bind OK, dir listing), `bashy zot`, `bashy loom` (Gitea; `start --expose`), `bashy src upstream set bashy URL` + `$BASHY_HOME/seed/<repo>` (source channel), `bashy mcp serve --transport http` (**loopback-only by design**: `yoke/mcp/transport.go:23` refuses non-loopback "post-1.0"), `--outpost` app identity for mesh exposure | no `bashy serve`; MCP over LAN only via outpost app/mesh or an ssh forward |
| Agent bootstrap | `bashy/README.md` §For agents (consent a / a+b / no; dag targets install/path/connect/bootstrap/orient), `skill export bashy --user --tool NAME --mcp`, `install-agent NAME` | proven cold start (S591); skill has no "bashy missing" branch; export not refreshed on upgrade (host copy stale since 11-08); PATH step bash-only; MCP writers claude/codex/opencode only |
| Packages | `generate-install-channels.py` (unpublished by decision); deb/rpm/apk built on `-dev` but **dropped on promote** (`promote.yml` glob `dist/bashy-*` misses `bashy_…`; rc.37 stable has 0, dev has 6) | fix glob (S) |
| Docs drift | `docs/install.md`/`setup.md` vs tour README ("Homebrew and Scoop", broken anchor `#install-bashy`); ycode `shell-agent.md` advertises retired `--manifest`/`yc`; S591 todos `51c7c587d8b8`, `b83e76fc7d4b`, `4c99628d6704` fixed in code but open | D1 |

## Design

**Mirror layout = GitHub layout.** A mirror is a directory served over plain
HTTP (or a local path) shaped exactly like the release download base:

```
<base>/latest                      # text: the tag (or build id) to install by default
<base>/<tag>/bashy-<os>-<arch>.tar.gz|.zip   # 5 release platforms
<base>/<tag>/checksums.txt         # "<sha256>  <asset>"
<base>/<tag>/index.json            # {repo, tag, source: github|local-build, assets:[{name,sha256,size}]}
<base>/skill/bashy/SKILL.md        # `bashy skill export bashy --to <base>/skill` (agents read it over HTTP)
<base>/README.md                   # the LAN one-liners, generated
```

Because the layout is identical, one knob serves every path: env
`BASHY_RELEASE_BASE` (http(s) URL or absolute dir). Tag resolution reads
`<base>/latest`; digests come from `checksums.txt` **of the trusted channel**:
GitHub for release tags (default), the team mirror itself for local builds
(operator-trusted, same tier as `--seed`). A mismatch skips the source and
falls back to GitHub. `BASHY_OFFLINE=1` keeps meaning no network.

**Service provider = bashy on the LAN host.** Web: `bashy rclone serve http`
(existing). MCP: `bashy mcp serve --transport http --tools self,skill,kb` on
loopback, reached over LAN through `outpost mesh service add bashy-mcp
127.0.0.1:PORT` (peers) or an ssh forward (no-bashy clients); a LAN bind with
bearer auth is a later story that must respect the post-1.0 note in
`yoke/mcp/transport.go`. Source: `bashy loom` as the git channel
(`bashy src upstream set bashy <loom url>`).

**Local builds are first-class.** `release-mirror publish` takes a built
bashy (`bashy dag dist` output or `bashy self build`) and lands it as
`<base>/<build-id>/…` with its own `checksums.txt` and `index.json
source=local-build`; `latest` may point at it. That is how a team ships a
shaped bashy without an upstream release.

## MVP scenario (today, must work): classroom on one LAN

The organizer (teacher) runs bashy as the service on their laptop (the dev
box, by role "organizer host"). Participants all have an agentic tool; some
have an old bashy, some none. Each participant tells their agent one sentence:

> *"Set up bashy from http://<organizer-host>:8080"*

and ends with the organizer's **latest or custom-built** bashy installed or
upgraded, on macOS, Windows or Linux. Flow:

1. Organizer: `bashy release-mirror publish bin/dist` (after `bashy dag dist`,
   pure-Go cross-build for all platforms; or `publish <archive>` / `fetch`
   for an upstream release) → `bashy release-mirror serve` → prints the
   sentence above plus the raw one-liners.
2. Participant's agent fetches `http://<organizer-host>:8080/README.md`.
   That page is the skill (same shape as bashy's README "For agents"): check
   `bashy --version`; if missing or different from `<base>/latest`, run the
   one-liner for the OS with `BASHY_RELEASE_BASE=http://<organizer-host>:8080`
   (install scripts served from the mirror too, so no internet needed); then
   `bashy skill export bashy --user --tool <tool> --mcp` and
   `bashy install-agent <tool>`; report the version.
3. With `BASHY_RELEASE_BASE` set, the installer takes the archive **and**
   `checksums.txt` from the mirror (the organizer host is the trust anchor on
   this LAN; the GitHub-anchored digest channel is story M1). Everything else
   is unchanged: sha256 check, `./bashy self install --dir`, atomic replace,
   Windows replace-aside, downgrade refusal (`BASHY_SELF_ALLOW_DOWNGRADE=1`
   when a custom build is older than the installed release).

Order of work today: (a) `install.sh`/`install.ps1` `BASHY_RELEASE_BASE`
knob, push outpost main (live via the dhnt.io redirect); (b)
`release-mirror.bsh` `publish`/`fetch`/`serve` writing the pre-baked
`install.sh`/`install.ps1`, `latest`, `checksums.txt`, `README.md` (live
`bashy skill show bashy` + one-liners) and the loom line; (c) smoke on the
organizer host: serve → web one-liner into a temp dir → version check; (d)
register the command, checkpoint the sprint; (e) MVP-3 LAN MCP (yoke + bashy
repin + reinstall), then `claude mcp add` from a second machine by role and
`skill show bashy` through it. `index.json` and L1 only if time remains.

## MVP channels and their one-liners

| Audience | Channel | One-liner (printed by `release-mirror serve`) | How |
|---|---|---|---|
| Human, any OS, bashy or not | **local web** (bashy as web server) | `curl -fsSL http://<organizer-host>:8080/install.sh \| sh` · `irm http://<organizer-host>:8080/install.ps1 \| iex` | `serve` writes `install.sh`/`install.ps1` into the mirror dir **pre-baked** with `BASHY_RELEASE_BASE=http://<organizer-host>:8080` as their default (generated from `outpost/scripts/install.*`, env still overridable); the browser listing at `/` is the manual fallback |
| Human with bashy | **local loom** (bashy as git forge) | `bashy git clone http://<organizer-host>:31881/<org>/bashy && cd bashy && bashy dag build && bashy dag install` | `bashy loom start --expose` + `bashy src upstream set bashy <loom url>` so `self install` defaults/kb also come from loom; loom-hosted release attachments (same URL shape as GitHub) are story L1 |
| Agent (all participants have one) | **bashy MCP on the organizer host** | `claude mcp add --transport http bashy-lan http://<organizer-host>:<port>/mcp --header "Authorization: Bearer <token>"` (codex/opencode equivalents printed) | agent calls tools `skill show bashy`, `self fetch --print-url`, `release-mirror index` and gets the **live** skill/instructions rendered by the organizer's current bashy (the MCP is bashy's own, so it is never stale). Tools run on the organizer host, so the agent then runs the web one-liner **locally** to move bytes. Needs the LAN bind (A3 below) |
| Agent, before A3 lands | web-served skill | agent fetches `http://<organizer-host>:8080/README.md` (= `bashy skill show bashy` + the one-liners, regenerated at every `publish`) | code-free |

MVP pieces:

MVP-1 **curl channel honours a mirror** (outpost repo, live on push to main):
`outpost/scripts/install.sh` lines 39-47 and `install.ps1` lines 25-35: if
`BASHY_RELEASE_BASE` (or `--base-url`/`-BaseUrl`) is set, `release=$(fetch
"$base/latest")` replaces the api.github.com call and the asset comes from
`$BASHY_RELEASE_BASE/$release/`, and so does `checksums.txt` (mirror is the
LAN trust anchor today; `BASHY_RELEASE_CHECKSUMS=github` forces the upstream
digest for release tags); a directory base uses `cp`. Everything else (sha check, `self install
--dir`) unchanged. Acceptance: `sh -n`; local run against MVP-2's server
installs into a temp dir and `bashy --version` matches `<base>/latest`.

MVP-2 **local web server channel** as a skill-script custom command
(memory rule: examples are `.bsh`, never core): `bashy/examples/release-mirror/`
= `release-mirror.bsh` + `README.md` + `register.sh` (pattern:
`bashy/examples/update/`). Verbs:
- `release-mirror fetch [--tag T] [--dir D]` (default `~/.bashy/release-mirror`): resolve tag via the GitHub `releases/latest` redirect, download the 5 archives + `checksums.txt` with `bashy fetch`, verify sha256, write `latest`, `index.json`, `README.md` (one-liners with this host's LAN address by role, for sh and PowerShell), copy `install.sh`/`install.ps1` from raw GitHub (outpost main) into `<dir>/`, and `skill/` via `bashy skill export bashy --to`. Runs the same on a macOS, Windows or Linux provider host (Bash#, no host tools).
- `release-mirror publish <bashy-archive|dist dir> [--id ID]`: local build → `<dir>/<id>/`, own checksums, `source=local-build`; `--latest` repoints `latest`.
- `release-mirror serve [--addr :8080]` → `bashy rclone serve http <dir> --addr …` (browser listing works), prints the LAN one-liners:
  `BASHY_RELEASE_BASE=http://<host>:8080 curl -fsSL https://dhnt.io/install.sh | sh -s -- --no-service` and the PowerShell twin; plus `outpost mesh service add bashy-release 127.0.0.1:8080` when outpost is present.
- `release-mirror mcp [--port P]` → `bashy mcp serve --transport http --listen 127.0.0.1:P --tools self,skill,kb`, prints the mesh/ssh-forward line for clients.
Acceptance: `bashy dag examples/release-mirror/README.md --list`; end-to-end on the dev box: fetch → serve → MVP-1 install from `http://127.0.0.1:8080` into a temp dir → version equality; `index.json` validates with `bashy lens -f json`.

MVP client matrix (today): macOS, Windows and Linux clients, both populations.
- **New user, no bashy**: browser → `http://<host>:8080/` (rclone listing) and download the archive, or the printed one-liner: macOS/Linux `BASHY_RELEASE_BASE=http://<host>:8080 curl -fsSL https://dhnt.io/install.sh | sh -s -- --no-service`; Windows `$env:BASHY_RELEASE_BASE='http://<host>:8080'; & ([scriptblock]::Create((irm https://dhnt.io/install.ps1))) -NoService`. Mirror `fetch` always holds all 5 release platforms so either OS is served. If the LAN host has no internet, clients fetch the scripts from the mirror too: `<base>/install.sh`, `<base>/install.ps1` (copied by `fetch`, so the one-liner's `https://dhnt.io/…` can be swapped for `http://<host>:8080/install.sh`).
- **Existing user, old bashy**: the same one-liner upgrades in place (`self install` is atomic, Windows replace-aside, refuses downgrade; local builds carry a newer `vcs.time`, otherwise `BASHY_SELF_ALLOW_DOWNGRADE=1`). Bashy-native alternative without curl/irm: `bashy fetch http://<host>:8080/<tag>/bashy-<os>-<arch>.tar.gz` then `./bashy self install` (adjacent files, no network). The `--version`-from-mirror form (`bashy self install --base-url …`) is story M2, not today.
- After upgrade both populations run `bashy skill export bashy --user --tool <tool> --mcp` once (A2 automates it later); the printed README on the mirror says so.

MVP-3 **MCP channel = bashy's MCP on the organizer host, LAN-bound** (story A3, pulled into today, second priority after MVP-1/2): `yoke/mcp/transport.go loopbackListenAddress` accepts a non-loopback `--listen` only when a bearer token is supplied (`bashy mcp serve --transport http --listen 0.0.0.0:PORT --token FILE|-` → `authenticate` compares constant-time; `--tools skill,self,release-mirror,kb`, read-only effects only); without a token the existing refusal stands, so the post-1.0 posture is kept. `release-mirror mcp` starts it and prints the `claude mcp add …` line with the token. Repin: push yoke → `bashy mod sync` → rebuild + `bashy dag install` on the organizer host (build budget 5 min). Fallback until it lands: the agent reads `<base>/README.md` (the live skill) over HTTP.

Register the command on the dev box (`bash examples/release-mirror/register.sh`) and record the smoke in the sprint checkpoint. Commits carry Sprint/Story trailers; the outpost edit is pushed first, then the bashy example; umbrella pins bumped after.

## Planned stories (new sprint, after the MVP; dependency order)

| # | Story | Repo | Touch | Acceptance | Size |
|---|---|---|---|---|---|
| R1 | Promote the Linux packages | bashy | `.github/workflows/promote.yml:219-223` add `dist/bashy_*`; `docs/install.md` one line | `scripts/verify-release-asset-set.sh` on `gh release download` of the next promoted tag | S |
| R2 | Fresh `latest` when online | yoke, bashy, outpost | `pkg/binmgr/github.go` `GitHubSpec.FreshLatest`: network first, cache only on failure/offline; set in `self.go resolveBashyRelease` and `outpost/cmd/outpost/bashy.go resolveBashyTool`; redirect-based tag lookup (`HEAD …/releases/latest`) to avoid API quota | `go test ./pkg/binmgr -run 'Latest\|Cached\|Offline'`; `offline-install-smoke.py` still green | S |
| M1 | Release-source engine | yoke | new `pkg/binmgr/release.go`: `ReleaseSpec{Repo,Version,From,Checksums,Peers,NoPeers}` → `Release{Tag,Sums,SumsFrom,Sources}`; `Asset.Mirrors`; `ensure()` tries sources in order with per-source sha check, `file://` branch; digest channel GitHub → operator file → cached `checksums.txt`; `ReleaseMirrorDir()` (`<cache>/releases/<owner>/<repo>/<tag>/`) + `MirrorArchive()` after every verified `EnsureArchive` so **an installed host is a mirror** | `go test ./pkg/binmgr -run Release\|Mirror` (httptest + tmp dirs, both bases, error paths) | M |
| M2 | `self fetch/install` on the engine | bashy, outpost | `self.go`: replace `bashyReleaseBaseURL`/`resolveBashyRelease` with `ResolveRelease`; flags `--base-url` (env `BASHY_RELEASE_BASE`), `--from`, `--checksums`, `--no-peers`; `--print-url --json`; `self source ls\|add\|rm` over `$BASHY_HOME/release-sources.json` (sibling of `src/upstreams.json`); outpost `bashy.go` honours the same env for its auto-install | `go test ./internal/agentos -run Self`; `go test -short ./cmd/outpost -run Bashy`; `bashy self fetch --print-url` with/without env | M |
| M3 | `self fetch --platform GOOS/GOARCH\|all --out DIR` produces the mirror layout natively (supersedes the `.bsh` fetch) | bashy | `selfFetchCmd`, reuse `binmgr.EnsureFor` | `go test -run SelfFetchOut`; `BASHY_RELEASE_BASE=/tmp/m BASHY_OFFLINE=1 bashy self install --dir T` | S |
| M4 | Installers finalised | outpost | MVP-1 hardened: fallback to GitHub on mirror sha mismatch with a warning; install-matrix.yml Linux+Windows legs install from a loopback mirror (`python3 -m http.server`/`bashy rclone serve http`) | `install-matrix.yml` green 3 OS | S |
| P1 | Peer serve over mesh | outpost | `cmd/outpost/release_serve.go` on the `transfer.go` pattern: mesh service `bashy-release`, root `ReleaseMirrorDir`, GET/HEAD only, `/index.json` + `/<tag>/<asset>`, two validated path segments, `os.OpenRoot`, no listing; capability `outpost.release-mirror` enabled by default (sshd pattern) | unit tests for path validation; two-host acceptance by role | M |
| P2 | Peer consume | bashy, outpost | `ReleaseSpec.Peers`: bashy via `meshagent` exec of `mesh dial bashy-release`; outpost in-process `fwd.Listen`; `remote.go` third lookup in `ReleaseMirrorDir` (unblocks cross-platform `remote install`) | `go test` both; `self install` on a fresh LAN host pulls from the peer (counted) | M |
| A1 | Skill knows install/upgrade/mirror | bashy | `skills/bashy/SKILL.md` "Not installed? / Upgrade / Mirror" section; new `skills/bashy/commands/self.md`; README `## path` Windows note | `bashy self --help --format skill`; `skill show bashy` byte-identical | S |
| A2 | Refresh exported skills on upgrade | yoke, bashy | `yoke/pkg/skills/export.go Refresh(home)` re-exports only where a `bashy/` export exists; called from `self install` after a version change; no MCP writes | `go test ./pkg/skills -run Refresh`; dev box: `diff <(bashy skill show bashy) ~/.claude/skills/bashy/SKILL.md` empty | M |
| A3 | LAN-bound MCP for the provider host | yoke, bashy | `yoke/mcp/transport.go`: allow non-loopback only with a bearer token (`bashy mcp serve --listen LAN:PORT --token`), honouring the post-1.0 note (issuer/audience) or documenting the outpost route as the supported path | `go test ./mcp`; client agent `claude mcp add --transport http` against the team host | M |
| L1 | Loom as source + binary channel | bashy | `release-mirror` gains `--loom`: `bashy src upstream set bashy <loom>`; Gitea release attachments via `bashy loom` API (URL shape is GitHub-identical, so it is just another `mirrors[]` entry) | fresh host: `self install` defaults pull from loom; `bashy src fetch bashy` from loom | M |
| D1 | Docs + bookkeeping | bashy, bashsharp-tour, umbrella | `bashy/docs/install.md` + `setup.md` "Local mirror and peers" (local-first; package managers not published, by decision); tour README fix (anchor, Homebrew/Scoop claim); ycode `docs/shell-agent.md` retire `--manifest`/`yc`; close stale todos `8a9f0dede7c6` (redirect chain recorded), `51c7c587d8b8`, `b83e76fc7d4b`, `4c99628d6704` after verifying; save this plan as umbrella `docs/plan-effortless-install.md` + lines in `docs/INDEX.md`/`docs/README.md`; operator note: archive `dhnt/homebrew-tap` + `dhnt/scoop-bucket` (repo-ops, outside this repo) | `bashy todo show`; umbrella lint | S |

Sequencing: MVP-1..3 today → R1, R2 (independent) → M1 → M2 → M3 → M4 →
P1 ∥ A1 → P2, A2, A3 → L1 → D1 (D1 docs for the MVP land with the MVP).

## Deferred (explicit)

- To **654**: ORAS CAS/catalog, Go proxy, `self bootstrap/seal/export/import`, retention. The mirror dir here is a plain directory; 654 ingests it.
- To **657**: desync chunking, Ed25519-signed manifests (hook: `Release.SumsFrom="manifest:<keyid>"`), peer admission/scheduler, transfer service, story `e0d62fe01886` (peer-first self fetch) which replaces P2's single-peer dial.
- Out: Homebrew/Scoop/winget publication; mDNS for curl clients (the mirror prints its one-liner instead); cloudbox `fleet/target` as a bashy source.

## Threat model

Digest channel ≠ byte channel. Release tags: sha from GitHub `checksums.txt`
(or the host's cached copy); mirrors/peers only supply bytes; mismatch → skip
and warn. Local builds: the team mirror is the trust anchor, explicitly
(`BASHY_RELEASE_CHECKSUMS=mirror`, `--checksums FILE`), printed as
`sums: mirror`. `latest` resolved once from the trusted channel. Server is
GET/HEAD static files, validated two-segment paths, no listing over mesh (the
rclone LAN listing is for browsers, by choice). MCP stays loopback until A3.

## Verification

| What | Runner |
|---|---|
| MVP | dev-box end-to-end: `release-mirror fetch && release-mirror serve` → `BASHY_RELEASE_BASE=http://127.0.0.1:8080 sh outpost/scripts/install.sh --dir "$T"` → `"$T/bashy" --version` equals `latest`; `bashy dag examples/release-mirror/README.md --list`; `sh -n`, `pwsh -NoProfile -Command` parse for ps1 |
| R1 | `scripts/verify-release-asset-set.sh` on the promoted tag |
| R2, M1 | `cd yoke && go test ./pkg/binmgr` |
| M2, M3, A1, A2 | `cd bashy && go test ./internal/agentos` (+ yoke `./pkg/skills`); dev-box `bashy dag install` smoke of `self` |
| M4 | `install-matrix.yml` 3 OS (mirror leg) + `offline-install-smoke.py` unchanged-green |
| P1, P2, A3, L1 | unit tests + two LAN hosts by role (serving host, fresh host); evidence record on the sprint |
| D1 | `bashy todo show <id>`; doc link check; umbrella lint |

Heavy legs run on the gate host, never the dev box; build budget 5 min.
