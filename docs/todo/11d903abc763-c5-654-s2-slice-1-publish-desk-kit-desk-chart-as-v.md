---
id: 11d903abc763
kind: feature
title: 'C5 (654 S2 slice 1): publish desk-kit/desk-chart as versioned modules into a local Go module proxy; apps require them without replace; shaped and verifier builds use the proxy'
seq: 683
status: done
priority: p0
labels:
    - shaping
    - gomod
created: 2026-11-23T20:11:40.028144Z
assignee: claude-opus5.5
sprint: 682
closed: 2026-11-24T01:28:52.261994Z
closed_by: claude-fable5.1
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

## Prior decision found (2026-11-23, conductor): this story is a slice of Sprint 654 S2

- Sprint 654 "Self-contained offline bashy" (backlog, planning handoff complete, `docs/plan-self-contained-offline-bashy.md`) already decided the proxy: **reuse the MIT `goproxy` handler/fetcher embedded in bashy, with Athens used only by narrowly copying MIT code and tests where a mechanism is missing (integration only, upstream semantics preserved); module ZIPs and hashes via `golang.org/x/mod`; verbs `bashy go proxy serve/publish/status`; sealed Go invocations use the local proxy with no direct fallback.** Story **S2 `2cdd5b99ad8e` "Embed Go proxy and immutable internal module publication"** (p0, todo) carries it; S0 `6b538b5383c5` locks the reuse boundaries and attribution.
- Standalone todo `eafe84d42f70` (operator, 2026-11-17): serve the always-on host's Go module cache to the LAN as a GOPROXY; "prefer a bashy verb or skill-script over a third-party proxy (bashy is all you need); the protocol is simple static files (list, .info, .mod, .zip)". This is the "not Athens as a service, our own small verb" decision.
- yoke story `61c28d52cf73` (S516.4) places the same proxy on the peers' S3 layer.

Consequence: do not design a second proxy here. This story becomes the **first MVP slice of 654 S2**: publish `desk-kit`/`desk-chart` from the checkout as versioned modules into the local proxy layout (x/mod), make the eight apps `require` them, and have shaped and verifier builds use the local proxy (`GOPROXY=file://` locally, the embedded goproxy handler when served). The S2 acceptance (clean-cache consumer build, identical ZIP regeneration, overwrite refused) applies to the slice. Open for the operator: run this slice now (start 654 with it, or as a standalone p1 story) or wait for 654 as a whole; Sprint 682 C4 waits on it either way.

## Implementation slice, operator go 2026-11-23 ("do it now since it is needed")

Sprint 682 story C5; the first slice of Sprint 654 S2 `2cdd5b99ad8e` (its full scope stays there). Design of record: Sprint 654 plan "Go proxy and publication"; the rule: every app builds independently of any other app or sibling directory.

Deliver, smallest robust version:
1. **`bashy mod proxy publish DIR [--version V] [--dir PROXYDIR]`** (yoke `pkg/gomod`, alongside `mod dir/drift/sync`): writes `<modulepath>/@v/{list,V.info,V.mod,V.zip}` in Go module proxy layout from a module directory, using `golang.org/x/mod/zip.CreateFromDir` and `modfile`. Default version = the pseudo-version of DIR's git commit (`v0.0.0-<yyyymmddhhmmss>-<sha12>`); explicit `--version` allowed. An existing version is never overwritten (refuse, exit non-zero). Default PROXYDIR = `$BASHY_HOME/gomod-proxy`. `bashy mod proxy status [--dir]` lists modules and versions. No daemon in this slice: consumers use `GOPROXY=file://PROXYDIR`. (`mod proxy serve` over the embedded MIT goproxy handler is the next slice, per 654 S2.)
2. **Module paths.** `desk-kit` and `desk-chart` get fetchable paths: `github.com/qiangli/bashy/examples/desk/kit` and `github.com/qiangli/bashy/examples/desk/chart` (go refuses a first path element without a dot for proxy fetches). Update the two `go.mod` files and the imports in the eight consumers: `examples/calendar`, `examples/desk/{form,chart,page,viewer,notepad}`, `examples/brainstorm/server`, `examples/session`. Remove every `replace … => ../kit|../chart|../desk/kit`; `require` the published pseudo-versions; `go.sum` updated with `GOPROXY=file://` (`GONOSUMDB=github.com/qiangli/bashy/examples`). Keep other dependencies untouched.
3. **Builds use the proxy.** `yoke/pkg/webconsole/shaped_server.go buildServer` and the verifier's candidate Go build (`yoke/pkg/shape/verify/program_go.go`) set `GOPROXY=file://<proxydir>,<inherited GOPROXY or https://proxy.golang.org>,direct`, `GONOSUMDB=github.com/qiangli/bashy/examples`, `GOFLAGS=-mod=mod` (proxydir from `BASHY_GOMOD_PROXY`, default `$BASHY_HOME/gomod-proxy`). `bashy app add --type shaped` fails loudly, naming the fix, when the source `go.mod` has a relative `replace` that escapes the source directory.
4. **Publication of the two modules** is an explicit step: `examples/desk/register-modules.sh` (or a `dag` target) that runs `bashy mod proxy publish` for kit and chart; each app's `register.sh` calls it first so registration is self-sufficient. Idempotent: an already published version is a no-op.
5. **Tests.** (a) `pkg/gomod`: publish creates the layout, refuses overwrite, `go list -m` against `GOPROXY=file://` resolves the version. (b) `examples/desk/shaped_test.go`: for every shaped tool, copy the app directory alone to a temp dir (no siblings) and build its server main with the proxy env of step 3: this is the console path that was never covered. (c) webconsole: a shaped build with a relative-replace module fails at `app add` with the named fix.

Acceptance (conductor verifies): unit tests of 5(a)-(c) green on the gate host; `GOWORK=off` builds of bashy and yoke green; the five Sprint 682 apps register and their member instances build in the retained gate-host installation (`s682-c4-66a4bb89`: re-register with the new candidate, open each app as the paired member, no incident); then the C4 matrix runs.

WORKER RULES: branch off origin/main in the weave workspace (umbrella workspace with submodules); edits in bashy and yoke on branches `s682-11d903abc763`; commit with trailers `Sprint: #682` / `Sprint-ID: 623586bb-742f-570e-87c9-9af0c101bac1` / `Story: #<seq on the card>` / `Story-ID: 11d903abc763` / `Agent: agy-opus5.5`; module-local unit tests on the dev box only, every build and full package test on the gate host under a claimed lane (claim the gate host's lane resource by its registered name; lane 1 or 3; lane 2 is Sprint 697's); do not push bashy/yoke main or bump umbrella pins (the conductor merges and pins); no shared-checkout edits; root cause before any fix; submit with `bashy sprint submit 682 11d903abc763 --as agy-opus5.5 -m '<commands, results, SHAs>'`.

## Run 190 (agy-opus5.5) stopped by vendor quota, 2026-11-23 20:37 UTC

Vendor refusal, authoritative: "Individual quota reached. Please upgrade your subscription to increase your limits. Resets in 109h" (agy, model opus5.5). Classification: window exhaustion (resets about 2026-11-28 10:00 UTC); not a code or venue failure. The worker had only begun (one untracked draft `yoke/pkg/gomod/proxy.go`, preserved as `run190-proxy.go.draft` in the conductor's s682-c5 evidence dir; the next worker may read it but starts from origin/main). Run 190 abandoned; story reassigned to claude-opus5.5. WORKER RULES unchanged except the trailer `Agent: claude-opus5.5` and the submit `--as claude-opus5.5`.
