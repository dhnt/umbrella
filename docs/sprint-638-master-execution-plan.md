# Sprint 638: website shaping, the Shape badge, the engine-hosted site and shaping levels

Sprint UUID: `88e86a75-5c83-5528-8a5c-44cc29c43030`. Epic: software-shaping.
Status: **planning only**, filed 2026-11-14; no implementation started.
Design of record: `website-shaping-integration.md`. The sprint card and its
stories are authoritative.

## Primary goal

A member clicks **Shape** on the public company website, lands on the engine's
Shape page with that page prefilled, and approves their own verified version;
the owner pushes a revision as a pull request on the website's repo; visitors
see the public page unchanged and may only personalize what the owner
declared.

## What the code showed (2026-11-14)

- The Shape page `/shape/<app>/` ignores `?page=` and `?element=`; the server
  already accepts both in the wish body and the CLI has `--page`/`--element`.
  Prefill is a change to `shape.js`/`shape.html` only.
- The Genie has no link-only mode; every mode fetches the API same-origin. A
  badge is a new, trimmed sibling, vendored into the site. The engine behind
  outpost is a login-required app, so it must not be the visitor's script
  source.
- An anonymous request is served the base revision (`shaped.go`, `active()`).
- `shaped.json` servers are built with `go build` only; a Node server is never
  run. A built single-page app ships as a committed `public/` tree.
- `serveTree` has no fallback for an extensionless miss.
- A directory import drops `.git`; a git-URL import keeps `origin` and uses a
  token from the environment. The root layout (`public/`, `checks/`,
  `contract.bsh`, `shaped.json`) is fixed.
- `shape submit` is local; `shape push --to upstream --pr` reaches
  `gh pr create`, but `remote set` refuses any repo outside a hard-coded list
  of six open-source repos.
- The app record refuses unknown YAML keys; site metadata belongs in the repo.
- Existing building blocks for levels: a per-app protected-path list the
  candidate check enforces, the protected-page request flow, declared
  `properties` the verifier keeps, and a cloud tier header that is explicitly
  not app authorization.

## Stories

Order is dependency order. Tags: example (bashy/examples custom command),
core (yoke engine change, small and separate), docs, verification. Vendor is
the planned assignment by strength; the conductor may reassign.

| # | Story | Tag | Vendor | Acceptance |
|---|---|---|---|---|
| S1 | Shape page prefill from `?page=` and `?element=`: chip "from page … · pointing at …", the POST carries both, the URL is cleaned after reading, `verifydom` test | core, small | codex | `/shape/x/?page=/pricing&element=…` shows the chip with the textarea focused; the candidate shows "from page /pricing"; `bashy shape wish --page` unchanged |
| S2 | `bashy/examples/shaping/badge/badge.bsh` with embedded skill: `snippet APP --engine URL [--tier 0\|1] [--label]`, `js` (prints the vendorable `badge.js`), `link APP --page P [--element E]`, `check URL` through `bashy browser --mode solo`. Tier 1: Shadow DOM, `createElement` only, picker port, `noopener`, `?shape=off`, at most 6 KB, idempotent re-mount | example | glm | `snippet` output validates; `check` passes on the `examples/site` sample; `link` equals the href the button composes |
| S3 | `bashy/examples/shaping/website/website.bsh`: `scaffold DIR` (adds `checks/build.bsh` that runs `bashy npm ci` and `bashy npx vite build` and fails on a diff against the committed `public/`; `contract.bsh` with `read,write,exec,net` as `examples/clip` does; `shaped.json` genie examples; `site.json`; relative-base guard; routing-mode detection), `register NAME --git URL` (`app add --type shaped --source URL`, then `shape remote set upstream URL`), `status NAME` | example | codex | scaffold on a sample Vite app; `bashy shape verify` passes in the verifier's scrubbed environment on the dev box and on the `gate-linux` resource |
| S4 | `shaped.json` `static.fallback`: `serveTree` serves `public/index.html` for an extensionless GET or HEAD miss, never under `api/`, also for preview, history and draft | core, required only with history routing | codex | `/x/pricing` and `/shape/x/preview/<id>/pricing` return `index.html` with the Genie; `/x/missing.png` still 404 |
| S5 | Promotion remote for registered shaped apps: `remoteFor`, `ConfiguredTier` and `SetTier` accept a repo whose managed checkout is a registered shaped app; the acquisition allow-list is unchanged; read the private-release test first | core, small | codex | `shape remote set upstream <private URL>` works for the website app and is still refused for an unregistered name; `shape push --to upstream --pr` reaches `gh pr create` or prints the compare URL |
| S6 | Shape policy levels in `shaped.json` `levels` (name, who, mode `shape\|request\|personalize\|off`, allow and deny globs, effect subset, properties, examples; typed property schema): manifest parse and validation; wish intake resolves principal to level to mode (`request` reuses the protected-page flow); the level's deny list joins the candidate's protected list and the verifier caps effects; the policy path is protected for non-owners; the Shape page shows the level and the allow-list; `bashy shape status --json` reports the caller's level | core, medium | codex / claude | a member wish that touches a denied path is refused naming the path; `request` mode records a request and builds nothing; a non-owner candidate that edits `shaped.json` is refused; the owner path is unchanged; `--json` parity |
| S7 | Public personalization in the scaffold and the badge: `website scaffold` adds property hooks (`prefs.js` reads a per-visitor preferences object and applies declared properties through `data-*` attributes and CSS variables, including language and text variants); badge tier 1 gains a schema-driven **Personalize** panel, no model and no engine call, shown only when the public level is on; `reset` restores defaults | example | glm | on the sample site a visitor changes theme, density and language; only that browser changes; a reload keeps it; reset clears it; with the level `off` the panel is absent |
| S8 | Docs and kb runbook (owner role, generic names): link contract, badge wording, CSP and fail-open, levels and invariants, the visitors-untouched model, the dogfood steps, follow-ups; READMEs under both examples; index entries | docs | muse | docs reviewed; the scrub gate is clean |
| S9 | Company-website dogfood: the website becomes its own repo (operator decision), one pull request adds the scaffold, the tier-0 badge in the no-JavaScript fallback and the footer, and a three-level policy; the engine host registers it behind outpost; run the verification below; record evidence | verification | claude | verification steps 1 to 7 green with recorded candidate and revision ids |

Optional follow-up: `app add --source URL#BRANCH` (pass the branch option
through the import clone) so a scaffold can live on a branch before merging.

## Lanes and dependencies

- Lane A (engine): S1 → S6; S4 and S5 independent of each other, both before S9.
- Lane B (examples): S2 → S7; S3 independent, before S9.
- Lane C (docs): S8 after S2, S3 and S6 settle their verbs and keys.
- S9 last, after every other story is accepted and the operator decisions are
  recorded.

## Gates

Per story: the story's own acceptance plus the relevant regression. Engine
stories run `go test ./pkg/webconsole -tags verifydom` and `go test ./...` in
yoke; example stories run their checks under `bashy shape verify` and
`GOWORK=off go build ./...` in bashy. Headless Chrome and verifier runs on the
dev box; the contained `npm ci` proof on the `gate-linux` resource. Never
containers or virtual machines on the dev box, never the Windows release host,
no hosted CI.

Close: steps 1 to 7 below recorded on S9; pins bumped (yoke in bashy and the
umbrella); the installed binary smoke-tested on the dev box.

## Verification (dogfood)

1. **Badge on the public page.** `bashy browser --mode solo --json` navigate
   and extract: an anchor with accessible name "Shape" or "Shape this app" and
   an `href` matching `<engine>/shape/website/?page=/`; present in the
   no-JavaScript fallback too; the site's CSP header unchanged.
2. **Click to engine.** In `--mode live` (the operator's browser, logged in
   through outpost) the Shape page shows the chip "from page /". Repeat once
   logged out to record whether `?page=` survives the edge login round-trip.
   CLI parity: `bashy shape status website --remote <console> --cookie-file …`.
3. **Wish, verify, preview, approve.** `checks/build.bsh` runs under the
   verifier (it needs `net`); the preview at `/shape/website/preview/<id>/`
   shows the change; after approval `/website/` shows it for that principal
   only; a second principal and an anonymous request see the base.
4. **Undo.** `bashy shape undo website` restores the base; history lists the
   revision.
5. **Submit to pull request.** `shape submit`, `shape remote set upstream`
   (S5), `shape push --to upstream --pr`; a pull-request URL on the website
   repo; the site's deploy ships it (outside this repo).
6. **Levels.** As a member principal, a wish that edits `checks/` or
   `shaped.json` is refused naming the path; a wish inside `public/` builds;
   `shape status --json` shows `level: member`; after the owner edits the
   policy, the next member wish sees the new allow-list.
7. **Public personalization.** Logged out, the Personalize panel offers only
   the declared properties; switching theme or language changes that browser
   only, survives a reload and resets cleanly; with the public level `off`
   the panel is absent and the badge is a plain link.

## Decisions reserved for the operator

1. The company website becomes its own repository (subtree split), or the
   engine gains a manifest `root` key (medium change, not recommended).
2. Link door: `tessaro.sh/shape/<host>/<app>/` path form (recommended) or a
   per-owner subdomain; a hosted-plane ticket either way, through the public
   wire contract.
3. Hash routing on the company page (avoids S4) or history routing (S4
   required).
4. Badge label on the company page: the **Shape** action or the **Shapeable
   with Bashy** capability badge in the footer.
5. Default member level for the company page: `shape` within `public/**`, or
   `request`.

## Not doing

A runtime overlay snippet on the public site, an engine-served badge script,
a browser extension, public natural-language personalization through the
engine, proxied-app Genie injection (S527) and a manifest `root` key. Each is
listed as a follow-up in the design of record.
