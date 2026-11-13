# Whiteboard: removing the phone-home from the excalidraw fork pin

Sprint 632, story S5b (#232, `88e824369d27`). Companion to
`shapeable-apps-worker-brief.md`; the files fork's equivalent record is
`files-fbembed-quantum-port.md`.

## Why

The S5 review (conductor, 2026-11-13) read the pinned whiteboard build as safe,
and the *build* was: the install-time `web-prefix.patch` stripped the Sentry
init, the analytics loader and the Google Fonts preconnect before `yarn
build:app` ran. The *pin* was not. A plain production build of
`a2ec2889babf7d2295469c6d90ebe77fae57df84`, with no patch applied, embeds:

| In the built bundle | Evidence |
|---|---|
| The hard-coded Sentry DSN and `sentry.io` | `grep -rl` over `excalidraw-app/build/assets/*.js` |
| Firebase hosts (`firebasestorage.googleapis.com`, `firebaseio.com`) | same |
| The simpleanalytics loader and `sa_event` call | `excalidraw-app/build/index.html` |
| `fonts.googleapis.com` / `fonts.gstatic.com` preconnect | same |

So anyone consuming the pin without our patch got all of it, and the patch was
load-bearing for privacy rather than for relocation. The brief's rule is
remove, not disable, so the removals belong in the fork.

Two review premises also did not survive checking:

- `VITE_APP_ENABLE_TRACKING` is **not** `false` at build time. `.env.production`
  sets it to `false`, but the `build:app` script — the one the installer runs —
  overrode it with `cross-env VITE_APP_ENABLE_TRACKING=true`. The analytics path
  was inert only because `window.sa_event` was undefined once the patch removed
  the loader, not because the flag gated it.
- The fonts were **not** local. The build injected
  `window.EXCALIDRAW_ASSET_PATH` and four `rel=preload` links pointing at
  `excalidraw.nyc3.cdn.digitaloceanspaces.com`, and rewrote the UI `fonts.css`
  so every `@font-face` tried that CDN first. `script/no-phone-home.sh` does not
  flag it: the pattern list covers jsdelivr, unpkg, cdnjs and the Google font
  hosts, not vendor object storage. Worth adding to the gate.

## The fork

`qiangli/excalidraw-shape` (a GitHub fork of `excalidraw/excalidraw`, MIT,
SPDX `MIT`, LICENSE unchanged). Branch `no-phone-home` on tag `v0.18.1`, three
commits; the fork's default branch `master` and the `0.18.1` branch are
untouched.

| Commit | Content |
|---|---|
| `532b631d` | `feat(no-phone-home): remove Sentry, Firebase, analytics and Excalidraw+` |
| `14bdccb0` | `feat(no-phone-home): serve the fonts from the app's own origin` |
| `1304220c` | `test: drop the removed trackEvent field from the contextmenu snapshot` |

New pin: `1304220cc539d902dfce104bac6cd7c946d9d591`.

### What was removed

| Upstream feature | Where it lived | What happened |
|---|---|---|
| Sentry crash reporting | `excalidraw-app/sentry.ts` (DSN, env map, `beforeSend`), `@sentry/browser` + `callsites` deps, the import in `index.tsx`, the capture in `TopErrorBoundary`, `.github/workflows/sentry-production.yml`, the `trackedToSentry` string in 54 locales | deleted; the error boundary logs to the console and its splash drops the tracking paragraph |
| Firebase scene and file backend | `excalidraw-app/data/firebase.ts`, the `firebase` dep, `firebase-project/`, `VITE_APP_FIREBASE_CONFIG` | replaced by `excalidraw-app/data/localStore.ts` — same five exports over the deployment's own origin, resolved from `import.meta.env.BASE_URL`. Rooms stay end-to-end encrypted with the room key, which never leaves the URL fragment |
| Analytics | `packages/excalidraw/analytics.ts`, every `trackEvent` call and action property, the `trackEvent` field on the `Action` type and the `trackAction` dispatch in the action manager, the `gtag`/`sa_event`/`fathom` globals, the loader in `index.html`, `VITE_APP_ENABLE_TRACKING` | deleted (140 edits across 48 files) |
| Excalidraw+ | `ExportToExcalidrawPlus.tsx`, `ExcalidrawPlusIframeExport.tsx`, `ExcalidrawPlusAppLink.tsx`, the `/excalidraw-plus-export` route, the auto-redirect in `index.html`, two command-palette entries, the export command, the overwrite-confirm action, menu/welcome/footer links, the `plus.excalidraw.com/blog` link in the Help dialog, the `excplus-auth` cookie probe, `VITE_APP_PLUS_*` | deleted |
| Vendor font CDN | `scripts/woff2/woff2-vite-plugins.js` | `EXCALIDRAW_ASSET_PATH` is now the build's own `base`; `fonts.css` is left untransformed so vite emits the UI fonts out of the repo. The CDN preloads are dropped, not rewritten: their hashes were the CDN's, so rewriting them would have produced four 404s |
| Google Fonts preconnect, vendor canonical/og/twitter URLs | `excalidraw-app/index.html` | deleted |
| Default endpoints | `.env.production`, `.env.development` | every vendor host removed. The fork has **no** default endpoint: a deployment supplies its own, and an unset value makes no call. This is the same rule bashy OTel follows |

Kept deliberately: the upstream documentation, GitHub, YouTube and
`libraries.excalidraw.com` links a user clicks, and the README's sponsor badges.
They are user-initiated navigation, not an automatic call, and they carry
upstream's credit. The unused `overwriteConfirm.action.excalidrawPlus.*` and
`welcomeScreen.app.center_heading_plus` locale strings also stay: they contain
no URL and reach no code.

### Evidence

Dev box, darwin/arm64, node 26.5.0, yarn 1.22.22, from a clean clone at the pin.

| Check | Result |
|---|---|
| `yarn install --frozen-lockfile` after the dep removals | green; `yarn.lock` regenerated, 658 lines dropped, no `@sentry/*`, `firebase` or `callsites` entry remains (the surviving `callsites@^3.0.0` is eslint's) |
| `yarn test:code` (eslint, `--max-warnings=0`) | 0 problems |
| `yarn test:typecheck` (`tsc`) | clean |
| `yarn build:app` | green |
| Built bundle scrub | no match for the Sentry DSN, `sentry.io`, `firebase`, `simpleanalytics`, `sa_event`, `fonts.googleapis.com`, `fonts.gstatic.com`, `digitaloceanspaces.com`, or any Excalidraw+ / `json.excalidraw.com` / `oss-collab.excalidraw.com` origin |
| `script/no-phone-home.sh` on the fork tree | 27 hits before (24 naming Sentry, Firebase or the Google font hosts) → 2 after, both the English phrase "latest version" in a code comment (`actionProperties.tsx:1072`, `data/library.ts:624`) |
| `yarn test:app` | 306 failed / 614 passed / 47 skipped, **identical by failing-test name** to the same run on the parent commit |

#### The test suite, by name

The fork's vitest suite is not green in this venue and was not green before the
change: node 26 against the repo's declared `18.0.0 - 22.x.x` leaves
`localStorage` unavailable, which is what the bulk of the failures report. Per
the root-cause rule, the comparison is by name, not by count:

- Run 1 on the change: 307 failed / 613 passed. Diffing failing-test names
  against the parent commit's run gave exactly one extra:
  `MermaidToExcalidraw.test.tsx > should open mermaid popup when active tool is
  mermaid`, a DOM snapshot.
- That test passes in isolation on the change. Re-running the full suite on both
  trees gave 306/614 each, with **empty** name diffs in both directions. So the
  extra failure was order-dependent flake in a venue that is already broken, not
  a regression. Classification: **environment**, pre-existing, tracked here and
  not repaired by this story.
- `contextmenu.test.tsx` fails 17/17 on the parent commit in this venue, so its
  snapshot could not be regenerated honestly here. The `trackEvent` key was
  removed from the stored snapshot mechanically instead (166 occurrences; one
  absent key, every other key and its order untouched, which is what the
  serialiser now emits). **The gate venue still has to confirm that file on a
  supported node.**

## Consumer: `bashy/examples/whiteboard`

bashy branch `s632-s5b-whiteboard`, commit `e235d21a` (pushed; the umbrella
gitlink is deliberately **not** bumped — the conductor reviews, merges and pins).

- `whiteboard.bsh`: pin bumped; `install` no longer stages the eight files the
  removals used to edit, nor deletes `sentry.ts` and the Sentry workflow.
- `web-prefix.patch`: 358 → 31 lines. It is now purely relocation — the
  `/whiteboard/` base prefix and the local scene and socket endpoints.
- `checks/whiteboard.bsh`: the no-phone-home invariants now hold on the source
  as well as the build, and cover the font CDN.
- `server/main_test.go`: a new `TestRoomSceneStorageUnderWebPrefix` pins the
  exact path the frontend's local store uses for a room scene
  (`/whiteboard/files/rooms/<room>/scene`), its 404-on-absent contract, and that
  a room image file does not collide with it.
- `docs/ui-cli-parity.md`: whiteboard rows refreshed (below).

Install-path evidence on the dev box: `bashy whiteboard install` green from a
fresh clone at the new pin; `checks/whiteboard.bsh` exit 0 against the managed
source; its built bundle clean on every pattern above;
`bash whiteboard_test.sh` passes with server tests 9/9.
`script/no-phone-home.sh` on the managed source reports 7 hits — the 2 comments
above, 4 lines of `checks/whiteboard.bsh` (the assertions name what they forbid)
and `server/main_test.go:206 TestTelemetryEnvGated`, which is the owner-only
bashy OTel the brief mandates.

**Still open:** the runtime proof — the service running with outbound traffic
logged or blocked — has to happen on the claimed Linux gate venue. Rule 1 of the
worker brief forbids container and runtime proofs on the dev box, and no gate
host was claimed for this story.

## UI → CLI parity re-check

`bashy/docs/ui-cli-parity.md` lines ~138 and ~170 cited
`examples/whiteboard/server/index.html` and `server/cli.go`, both deleted in
bashy `93a5de97` when this wrapper replaced the desk launcher. Re-auditing
against what the app actually exposes found the gap is wider than the rows said:

- The five Sprint 614 S11 verbs (`bashy whiteboard draw|clear|lock|revoke|download`)
  were cases in `server/cli.go` and went away with it. Nothing replaced them.
- Today `bashy whiteboard` registers only `install|start|stop|status|source`,
  so **no board, scene or room action has a CLI path** — not the seven desk
  verbs on `/whiteboard/api/action`, not scene post/get, not room files, not
  canvas export or import.

The doc now carries one row per web action with its CLI path or a recorded
reason, the stale S614 table is marked stale for whiteboard, and the gap row
names its owner: **S632 A5** (`876cd327`, whiteboard data verbs). Two actions
are recorded as "no verb, not a gap": the live collaboration socket (a browser
transport, whose agent equivalent is reading and writing the board scene) and
the shape-library browser (the vendor service is deliberately unwired; the
control should be hidden rather than given a verb — for S632 S11).
