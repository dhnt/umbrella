# Files: porting the fbembed seam to the active File Browser upstream

Sprint 631, story S2b (#216, `82c0ddf40b66`). Companion to
`shapeable-apps-worker-brief.md`. Slice 1 is the seam itself, built and
tested inside a fork of the new upstream. Slice 2 (the last section) removes
the upstream's phone-home, adds owner-only OTel and moves the consumers.

## Why

The File Browser project the `files` surface embeds today
(`github.com/filebrowser/filebrowser/v2`) was archived upstream on
2026-09-01 and receives no security fixes. Our fork (`qiangli/filebrowser`,
master `c7e10f7a`) carries the final upstream catch-up plus the `fbembed`
seam and 27 other commits. Story S2 chose the catch-up first; this story
ports the seam to the active successor so the consumers can move when the
operator decides.

## The base (verified 2026-11-13)

| Fact | Value | Source |
|------|-------|--------|
| Repository | `gtsteffaniak/filebrowser` | GitHub |
| License | Apache-2.0 | `LICENSE` read at the pinned tag; GitHub API `license.spdx_id` |
| Non-permissive directories | none (`ee/`, `premium/`, `enterprise/` absent) | `find` over the checkout |
| Stars | 9,146 | GitHub API `stargazers_count` |
| Latest release | `v2.0.2-stable`, 2026-10-23 | GitHub API releases/latest |
| Last push | 2026-11-12 | GitHub API `pushed_at` |
| Pinned base | tag `v2.0.2-stable` = `2c071d1e` | `git log -1` |
| Go module | `github.com/gtsteffaniak/filebrowser/backend` (nested under `backend/`) | `backend/go.mod` |
| Build | `CGO_ENABLED=0 go build ./...` passes at default tags (modernc sqlite) | run locally |
| Never enable | `-tags mupdf` (MuPDF is AGPL) | story facts |

## The fork

Fork target: `qiangli/filebrowser-quantum` (a GitHub fork of the base; the
name `filebrowser` is taken by the old fork). Branch `fbembed` on
`v2.0.2-stable`, three commits:

| Commit | Content |
|--------|---------|
| `b8ca4bdf` | `feat(embed): seams for in-process embedding` — four small upstream patches |
| `92eae5c2` | `feat(fbembed): in-process embedding package with committed frontend` |
| `88b90a50` | `feat(no-phone-home): remove analytics, update check and CDN origins; add owner-only OTel` (slice 2) |

Push status: branch `fbembed` pushed on 2026-11-13; the branch head on
GitHub is `88b90a50350df8b59b367ce3d16142d4ac1fece3`. The pseudo-version the
consumers pin is `v0.0.0-20261113140828-88b90a50350d` (resolved with
`go list -m` against the fork, module path
`github.com/qiangli/filebrowser-quantum/backend`). Slice 1's head was
`92eae5c2` (`v0.0.0-20261113123010-92eae5c2a3af`).

The module path is unchanged (`github.com/gtsteffaniak/filebrowser/backend`);
consumers point at the fork with a `replace`, exactly as they do for the
old fork today.

### Upstream patches (commit `b8ca4bdf`, 105 insertions, 18 deletions)

All code in the new upstream lives under `backend/internal/`, so the seam
has to be an exported constructor inside the fork. The patches open four
doors and change no behavior for the CLI server:

- `internal/web`: `NewHandler(deps) (http.Handler, error)` builds the full
  router (API, public routes, static assets, index template, logging and
  recovery middleware) without binding a listener. `StartHttp` now calls
  it, so the CLI and an embed serve identical routes.
- `pkg/settings`: `InitializeEmbedded(apply func(*Settings)) error`
  applies defaults, lets the caller mutate them in code, and runs the same
  setup pipeline `Initialize` runs on a loaded YAML file. Validation
  errors are returned instead of exiting. Log sinks are registered once per
  process because the logger is additive.
- `internal/web/static.go`: the index page renders `baseURL` and
  `staticURL` against `X-Forwarded-Prefix` when a path-mounting reverse
  proxy announces one (the cooperative web app prefix contract the old
  seam already honored). Without the header, `http.baseURL` applies.
- `internal/preview`: `StopPreviewGenerator()` releases the generator so an
  embed can be torn down and restarted in one process.

### The package (`backend/fbembed`)

```go
h, closer, err := fbembed.New(fbembed.Options{
    Scope: "/path", AllowWrite: false, SigningKey: key, StateDir: "", Title: "Files",
})
```

| Behavior | Old seam (`filebrowser/v2/fbembed`) | New seam (`backend/fbembed`) |
|----------|-------------------------------------|------------------------------|
| Auth | NoAuth, lone admin user, host is the gate | noauth, lone admin user, host is the gate |
| Write switch | user perms (create/modify/rename/delete) | source `ReadOnly`, enforced by the engine ahead of user perms |
| Sharing, API tokens, WebDAV, update check | off | off (user perms trimmed on boot; WebDAV route not mounted) |
| State | none (static in-memory store) | SQLite state + index databases and preview cache under `StateDir`; empty `StateDir` = temp dir removed by the closer |
| Signing key | `SigningKey []byte` used directly | mapped to `auth.key`; a persistent `StateDir` keeps the key it minted and refuses a differing one |
| Instances per process | any | one (`ErrActive` until the closer runs) |
| Frontend | trimmed `dist.zip` (2.2 MB) | `dist.zip` of the built frontend (5.7 MB; the icon font alone is 3.8 MB gzipped) |
| Prefix contract | `X-Forwarded-Prefix` | `X-Forwarded-Prefix` |
| Indexing | none | the engine scans the scope in the background on boot |

Regenerate the embedded frontend with `go generate ./fbembed` (needs Node 22+
and npm; the build here used Node 26.5 and npm 11.17).

## Evidence (fresh runs on the dev box, darwin/arm64, Go 1.27.2)

| Check | Result |
|-------|--------|
| `CGO_ENABLED=0 go build ./...` in `backend/` | ok |
| `CGO_ENABLED=0 go vet ./fbembed` | ok |
| `CGO_ENABLED=0 go test -v ./fbembed` | 11/11 pass (page against configured base; page against `X-Forwarded-Prefix`; gzip module script and css from the zip; health and listing; hardened lone user; read-only refuses POST and DELETE; AllowWrite creates and deletes; single instance and restart; ephemeral state removed; persistent state with signing key, differing key refused; missing scope rejected) |
| Upstream suites of the patched packages: `internal/web`, `pkg/settings`, `internal/preview`, `internal/state` | all ok |
| Repeated-boot log noise (duplicate sinks) | 0 duplicate lines after the once-guard |

Binary cost of a minimal `main` that mounts the seam (`-trimpath -ldflags "-s -w"`, `CGO_ENABLED=0`):

| Seam | Stripped binary | Non-stdlib packages |
|------|-----------------|---------------------|
| old `filebrowser/v2/fbembed` | 14.9 MB | 90 |
| new `backend/fbembed` | 42.9 MB | 299 |

The new upstream pulls sqlite, ldap, oidc, webauthn, ffmpeg wrappers, 3D
and office preview support into every importer. That is the main cost of
the move and belongs in the S2 decision.

## Consumer migration (not done; plan)

Four consumers import the old seam:

| Consumer | Site | Change |
|----------|------|--------|
| outpost | `cmd/outpost/capability_files.go`, `files_archive_formats_test.go` | import path; `fbhttp.ArchiveFormats` has no counterpart (the new engine's archive set is fixed: zip, tar.gz); pass a `StateDir` under the agent's data dir so the index and key persist |
| yoke | `pkg/webconsole/panel_files.go`, `panel_files_test.go`, `e2e_test.go` | import path; the logo override path (`/static/img/logo.svg`) moves to the new static route |
| bashy | `go.mod` replace only | replace line |
| ycode | `go.mod` replace only | replace line |

Each consumer gets `replace github.com/gtsteffaniak/filebrowser/backend =>
github.com/qiangli/filebrowser-quantum/backend v0.0.0-20261113123010-92eae5c2a3af`; the umbrella `go.work` needs a `use` entry for the fork's
`backend/` directory if the fork is mounted as a sibling.

Open decisions for the S2 owner:

1. Umbrella layout: a new sibling submodule next to `filebrowser/` (keeps
   the old fork recoverable, matches the cutover policy) or replacing the
   `filebrowser/` gitlink's remote. The former is recommended.
2. Binary cost above: accept it for outpost and yoke, or keep the old seam
   for bashy's `files` panel until the frontend work lands.
3. Whether the old fork's `pure-Go, no index` property matters: the new
   engine indexes the scope on boot (a home directory is large).

## Remaining port work (multi-day, frontend)

Re-done on the old Vue frontend and not yet on the new one:

- Apps header control (return to the console) and the console's product mark.
- Theme following of the bashy console instead of the engine's own dark default.
- Hide-dotfiles preference kept in the browser (`?dotfiles=show|hide`).
- Login, users, shares and global-settings routes removed from the SPA
  (the backend already refuses sharing and API tokens; the UI still shows
  the admin panels because the lone user is an admin).
- Static title quoting: the upstream template renders `<title>"Files"</title>`.
- outpost S2a loopback gate (separate story) before any consumer flips.

## Commands run

```
gh api repos/gtsteffaniak/filebrowser --jq '.stargazers_count, .license.spdx_id, .pushed_at'
gh api repos/gtsteffaniak/filebrowser/releases/latest --jq '.tag_name, .published_at'
git clone --branch v2.0.2-stable https://github.com/gtsteffaniak/filebrowser
cd frontend && npm ci && npm run build
cd backend && CGO_ENABLED=0 go build ./... && CGO_ENABLED=0 go test -v ./fbembed
CGO_ENABLED=0 go test ./internal/web/ ./pkg/settings/ ./internal/preview/ ./internal/state/
```

## Slice 2 (2026-11-13): no phone-home, owner-only OTel, consumers moved

Fork commit `88b90a50` on `fbembed`. The S11 gate
(`script/no-phone-home.sh`) found third-party telemetry in the upstream that
had to be removed from the fork, not merely left disabled.

### Removed from the fork

| Upstream feature | Where it lived | What happened |
|------------------|----------------|---------------|
| Deployment analytics reporter (posted snapshots to the vendor API) | `backend/internal/analytics`, started in `cmd/root.go`, toggle API in `internal/web/analytics.go`, state keys in `internal/state/analytics.go`, System Admin toggle + diagnostic prompt in the SPA, seven i18n keys in every locale | deleted |
| Update check (polled the GitHub releases API) | `backend/internal/utils/checkForUpdates.go`, start in `cmd/root.go` | deleted; the page's `updateAvailable` is always empty; `server.disableUpdateCheck` is still accepted (YAML parsing is strict) and documented as a no-op |
| CSP `script-src` allowing the public CDN and two Google origins | `internal/web/static.go` | now `'self'` + nonce only; nothing loaded a reCAPTCHA script, so the Google origins were dead; the OnlyOffice origins the owner configures remain the one opt-in exception |
| Ace editor modules fetched from the public CDN (S2c on the old fork) | `frontend/src/views/files/Editor.vue` | `vite.config.ts` emits `ace-builds`' mode files under `ace/` in the dist (pre-gzipped like every script); the editor's `basePath` is `<baseURL>public/static/ace/` |
| Vendor canonical link in the SPA shell | `frontend/public/index.html` | dropped |

Added: `backend/telemetry` (copied from the old fork's `filebrowser/telemetry`
pattern). The W3C propagator is always installed; spans are exported only
when `OTEL_EXPORTER_OTLP_ENDPOINT` names a collector the owner runs, with no
default endpoint and no vendor host. `web.NewHandler` wraps the router so
the CLI server and an embed both carry it; `StartHttp` flushes on shutdown.
The embed does not shut the provider down in its closer (the provider is
once-per-process and an embed can be restarted).

### Gate evidence

`script/no-phone-home.sh filebrowser-quantum` after the change reports hits
that are all explained; none is an outbound call:

| Hit | Explanation |
|-----|-------------|
| `backend/telemetry/*`, `internal/web/server.go`, `go.mod` OTel lines | the bashy OTel the brief mandates (word `telemetry`, `go.opentelemetry.io` paths); env-gated, no endpoint |
| `disableUpdateCheck` in `pkg/settings/structs.go`, the generated swagger files and `config.generated.yaml` | the retained no-op config key |
| `frontend/scripts/build-icon-subset.js` (`fonts.googleapis.com`) | a developer script (`npm run icons:sync`) that regenerates the committed icon-font subset; not part of `npm run build` and never run by the app |
| `plyrViewer.vue` "update checked states" comments, `pkg/indexing` "plausible" | words, not calls |
| `_docker/src/settings/backend/database.db.old` | an upstream sample database in the docker scaffolding; not built into anything |

Static check of the built binary (`strings` over a stripped build): the
vendor analytics host, `api.github.com`, the CDN, the Google origins and
`fonts.googleapis.com` do not appear. The three remaining vendor-domain
strings are documentation URLs in log messages and the Help prompt's link.

Runtime check: a linux/arm64 build of the CLI server run in podman with
`--network=none` boots against a scratch source, answers `/api/health` and
`/` (CSP `script-src 'self' 'nonce-…'`), and shuts down cleanly; at debug
log level there is no connection attempt or failure.

Fresh runs on the dev box (darwin/arm64, Go 1.27.2, CGO_ENABLED=0,
GOWORK=off): `go build ./...` ok; `go test ./telemetry ./internal/web
./internal/state ./internal/utils ./pkg/settings ./fbembed` ok (fbembed
12/12, the new `TestNoThirdPartyOrigins` pins the CSP, the empty update URL,
the locally served Ace mode and the absence of the analytics API); frontend
`npm run lint` 0 errors, `vitest` 225/225. `dist.zip` grew from 5.7 to
7.2 MB (the Ace modes).

### Consumers moved

Layout (conductor decision 2026-11-13): no new umbrella submodule. The fork is
a plain GitHub repo (`qiangli/filebrowser-quantum`, branch `fbembed`); every
consumer reaches it through its own `go.mod` `replace` to the pinned
pseudo-version, so standalone (`GOWORK=off`) and workspace builds both
resolve it from the module proxy. The old `filebrowser/` submodule stays
recoverable. Final pin: fork `88b90a50` (adds "no logging from package init",
which broke `outpost status --json`).

| Consumer | Commit | Change |
|----------|--------|--------|
| yoke | `dead1ea3` | `pkg/webconsole/panel_files.go` imports the new seam; the engine boots on the first `/files/` request (lazy) because booting indexes the scope in the background and a home directory is large; the folder-icon override moves from `/static/img/logo.svg` to `/public/static/favicon.svg` (the SPA has no header mark); e2e tests use `<mount>/public/static/`, `?path=&source=files`, no token (noauth), and tear down one console before booting the next (one instance per process) |
| outpost | `23712869` | `cmd/outpost/capability_files.go` imports the new seam and keeps the engine's state under `<cache>/files`; the folder-download test drives the fixed zip and tar.gz set through the mounted handler (the nine-format claim and `-tags fb_archives` guard are gone; the tag in `Makefile`/`scripts/lib.sh` is inert and untouched); capability tests redirect `XDG_CACHE_HOME` |
| bashy | `32d937cc`, `ac14ec11` | inert `replace` for the new module (the pinned yoke still imports the old fork), SBOM license entry and sibling path |
| ycode | `654495a` | inert `replace` (bashy's does not propagate to embedding modules) |

Evidence: yoke `go test ./pkg/webconsole` 292 pass + 1 pre-existing failure
(`TestShapeSubmitHTTPMatchesLocalAndDoesNotActivate`, identical on a pristine
worktree at the previous commit); `-tags e2e` files tests pass. Before the
lazy boot the same package ran 10 minutes into its timeout because every
`Handler()` booted the engine over the home directory — the cost noted as
open decision 3 above, now paid only when the tile is opened. outpost
`go test -short ./cmd/outpost -run 'FilesCapability|FolderDownload'` 4/4.
Workspace mode (`go.work`): yoke, outpost, bashy and the seam build and the
same tests pass against the live sibling.

### Open items after slice 2

- **bashy yoke-pin bump**: `internal/agentos/src_mount.go` pins the
  filebrowser source module and fails closed on an unpaired bump; with the
  bump it must move to `github.com/qiangli/filebrowser-quantum/backend`
  (module root is the `backend/` subdirectory, which `self build --local
  --repo filebrowser` and `yoke/pkg/src/repos.go` do not yet expect).
  `TestSrcPinsMatchLinkedModules` already fails at bashy `cd391b5e` (pin
  `d1d2feab` vs linked `c7e10f7a` after the S2 catch-up): pre-existing,
  tracked separately, not repaired here.
- The frontend re-work list above (Apps header, theme following, dotfiles
  preference, hidden login/users/share routes, title quoting) is unchanged.
- The outpost S2a loopback gate precondition is the conductor's call; the
  consumer flips here are on the branch, not released.
- The engine's home-directory index on first open (CPU and disk under the
  state dir) is the remaining cost of open decision 3.
