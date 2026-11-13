# Files: porting the fbembed seam to the active File Browser upstream

Sprint 631, story S2b (#216, `82c0ddf40b66`). Companion to
`shapeable-apps-worker-brief.md`. This records the first slice of a
multi-day port: the seam itself, built and tested inside a fork of the new
upstream. Consumers have not moved yet; the second half of this document is
the plan and the open decisions for whoever continues.

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
`v2.0.2-stable`, two commits:

| Commit | Content |
|--------|---------|
| `b8ca4bdf` | `feat(embed): seams for in-process embedding` — four small upstream patches |
| `92eae5c2` | `feat(fbembed): in-process embedding package with committed frontend` |

Push status: fork created and branch `fbembed` pushed on 2026-11-13; the
branch head on GitHub is `92eae5c2a3af8c1c356a838d5164274fbb3db559`. The
pseudo-version a consumer pins is
`v0.0.0-20261113123010-92eae5c2a3af` (resolved with `go list -m` against the
fork, module path `github.com/qiangli/filebrowser-quantum/backend`).

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
