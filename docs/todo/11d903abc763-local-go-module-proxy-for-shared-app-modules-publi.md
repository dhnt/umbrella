---
id: 11d903abc763
kind: feature
title: 'Local Go module proxy for shared app modules: publish desk-kit/desk-chart as versioned modules, apps require them without replace directives, shaped builds set GOPROXY'
seq: 683
status: todo
priority: p1
labels:
    - shaping
    - gomod
created: 2026-11-23T20:11:40.028144Z
---

Operator direction 2026-11-23 (see bug d35e0de8): every app builds independently of any other app or sibling directory; no copying of sibling modules, no vendoring, no build-time path rewrites. Deliver: (1) bashy mod proxy: a local Go module proxy (GOPROXY protocol: @v/list, .info, .mod, .zip) that bashy runs on the host, with a publish verb that cuts a version (tag or pseudo-version) of a module directory from the checkout; (2) desk-kit and desk-chart published; the eight consumers (calendar, desk/form, desk/chart, desk/page, desk/viewer, desk/notepad, brainstorm/server, session) switch from replace to require vX.Y.Z with go.sum entries; module paths renamed to proper paths if go or the proxy requires it; (3) webconsole shaped builds and verifier candidate builds set GOPROXY=<local>,direct plus GONOSUMDB/GOPRIVATE for those paths; (4) bashy app add --type shaped fails loudly, with the fix, when go.mod has a relative replace escaping the source dir; (5) test: register an app and build it from the extracted tree with no siblings present. Related: yoke story 61c28d52cf73 (S516.4 S3-layer GOPROXY cache). Unblocks Sprint 682 C4. Scope decision (which sprint; who) is the operator's; filed unowned.

## Existing mechanism check (2026-11-23, conductor)

Operator: "the proxy code I believe is already included in bashy". Search by protocol markers (`@v/list`, `.info`/`.mod`/`.zip` handlers, `GOPROXY=file`) across bashy, yoke, outpost and ycode found no standalone Go module proxy server in the Go code. Two shipped or previously used mechanisms fit, to be confirmed by the operator before implementation:
1. `bashy loom` = a managed Gitea forge (binary `gitea bashy-v28.1.0-4`). Gitea's package registry speaks the GOPROXY protocol (`GOPROXY=<loom>/api/packages/<owner>/go`), so publishing `desk-kit`/`desk-chart` versions there needs no new server; the console build sets `GOPROXY` to the loom front proxy. Loom is installed on the dev box but currently stopped; registry support in the shipped build is unverified.
2. The Sprint 512 technique: a file-tree module proxy (`GOPROXY=file://…`, directory with `@v/list`, `.info`, `.mod`, `.zip`) generated from `git archive` with `golang.org/x/mod/zip.CreateFromDir`. Used once ad hoc, not shipped as a verb; would become `bashy mod proxy publish DIR@VERSION` writing into a local proxy tree. No daemon, works offline, pins by commit.
Either way the apps `require` versions and drop `replace`; `bashy mod` is the natural home for the publish verb. Decision owner: operator.

## Open-source candidates, permissive licenses (web search 2026-11-23, conductor)

| Candidate | License | State | Fit |
|---|---|---|---|
| `github.com/goproxy/goproxy` (Aofei Sheng) | MIT | v0.27.0, 2026-10-17; ~1.3k stars | Minimalist, embeddable `http.Handler` (`&goproxy.Goproxy{}`), 3 structs + 2 interfaces (`Fetcher`, `Cacher`, `DirCacher`), built-in GOPROXY/GONOPROXY/GOSUMDB/GONOSUMDB/GOPRIVATE semantics. 34 imports. Natural core for a `bashy mod proxy serve` verb: a `DirCacher` pre-populated by a publish step serves local modules; upstream fetch optional. |
| `github.com/gomods/athens` | MIT | v0.18.x, 2026-06; healthy cadence | Full enterprise proxy with many storage backends; heavy for an embedded verb, fine as an external service. |
| Gitea package registry (already shipped as `bashy loom`) | MIT (Gitea) | shipped build `gitea bashy-v28.1.0-4`, registry support unverified | GOPROXY-compatible at `/api/packages/{owner}/go`; publish = `PUT .../go/upload` with the module zip. Needs loom running; no new code if the shipped build has packages enabled. |
| `golang.org/x/mod` (`zip.CreateFromDir`, `module`, `modfile`) | BSD-3 | stdlib-adjacent | The publish half in any design: build `<path>/@v/<ver>.{info,mod,zip}` + `list` from a checkout. Used once in Sprint 512. |
| `GOPROXY=file://<dir>` | none (Go toolchain feature) | always available | The zero-dependency serving half for local builds: a directory in proxy layout; works offline, pins by commit; serve the same directory over HTTP (any static server, or goproxy's handler) for peers. |

Recommended shape for the story: publish with x/mod into a proxy-layout directory (`bashy mod proxy publish DIR@VERSION`); local builds use `GOPROXY=file://` on that directory; `bashy mod proxy serve` wraps goproxy/goproxy (MIT) around the same directory when peers need it; loom's registry stays an alternative if the shipped build has it. No GPL/AGPL candidates were considered.
