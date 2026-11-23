# Sprint 691: hosted bashy and the trove virtual drive for cloudbox users without a live outpost

Sprint UUID: `2c1803fe-634b-51fb-818c-9ac8e2a5428c`. Epic: bashy-hosting.
Status: **planning only**, rescoped 2026-11-23 from a one-story capacity spike; no
implementation started, no manager appointed. The sprint card and its stories are
authoritative; this document records the framing, the review and the decisions.

## Operator framing (2026-11-23)

Three tiers of "bashy for a person":

| Tier | Who | What runs bashy | State |
|---|---|---|---|
| Public shaping | any visitor of a shaping-enabled site; no cloudbox account needed | the site's own hosted shaping (Sprint 641 phase A, pooled route) | exists |
| **This sprint** | **cloudbox-registered users with no paired outpost, or whose outpost is offline** | a dhnt-provisioned, on-demand bashy instance acting as that user | gap |
| Full shaping | users with a live paired outpost | their own outpost (`bashy mcp serve --outpost` behind the Sprint 646 gateway) | exists |

The middle tier, kept to its MVP: offer bashy's features to **all cloudbox users** from
whatever agentic tool they already use (Muse, claude.ai, Codex, …), including features
that tool lacks natively (Gmail and Drive, GitHub, cloud CLIs), and the member-level use
of shaping-enabled sites and apps they were invited to. A live paired outpost always
wins the route; the hosted runner is the fallback. Personal data is reached through
**one virtual drive**, the trove, instead of a different endpoint per verb.

## What the review showed (2026-11-23)

- The card as filed covered compute only: a stateless per-call runner (scratch
  directory, timeout, output cap), sized in a research note kept outside this repo,
  with one load-test story. Identity, routing, credentials and storage were open.
- The gateway on the cloudbox master (Sprint 646) already serves any agentic tool over
  remote MCP (OAuth 2.1 for connectors, scoped bearer for headless clients), routes
  `run` to a live outpost (`sync`) or to a durable task (`pull`), settles gated effects
  through digest-bound `approve`, and reports `route` on every reply. Sprint 641 J7
  added master-native desktop tools for people with no host.
- `bashy mcp serve` has an identity mode for outposts (`--outpost`: the signed caller
  verified per request from a 0600 key file, loopback only, fail closed), an effect
  policy (`--allow destroy,spend,cred,priv`), hash-chained audit and output spill.
- Every bashy command is reachable over MCP today through the untyped `bashy` script
  tool; typed, effect-gated tools exist only for verbs with an atlas entry, which the
  Tier-6 cloud CLIs (`aws`, `az`, `gcloud`, `doctl`, `gws`, …) lack. Not a blocker;
  filed as an optional story.
- Credentials on an outpost live on its disk: Google under the bashy config directory
  per account, gh and aws in their own stores, the account inventory as metadata only.
  The cloudbox vault behind `bashy secret` (per user, encrypted, `secrets:read|write`
  scopes, names `<provider>/<account>/<purpose>`, `secret exec` for one command)
  already exists and is the hosted replacement for that disk.
- The trove (Sprint 639) is designed and unbuilt: mounts over `dir:`, `dir:@host`,
  `git:`, `drive:`, `gh:` with `bashy-node-v1` rows; the read-only tree seam, the
  Google verbs (`bashy google`, bring-your-own-project OAuth) and `bashy gh` exist.
- Member-level shaping policy (638 S6) was retired into Sprint 669 M3 (backlog);
  per-principal activation for web apps exists.

## Where a hosted user's state lives

| On an outpost | Hosted (this sprint) |
|---|---|
| Google credentials file per account under the bashy config directory | vault `google/<account>/credentials`, projected into the call's scratch as that file for the call only |
| gh store, `GH_TOKEN`, `AWS_PROFILE` files | vault `github/<account>/token`, `aws/<account>/*`, exported as environment by `bashy secret exec` for the call only |
| the account inventory | derived from the vault names (`google/*`, `github/*`, `aws/*`); no second inventory |
| `gws auth login` with a browser loopback callback on the host | a connected-accounts consent step through the master (the user's own bring-your-own-project OAuth client with a web redirect to the master; refresh token written to the user's vault). Users with a laptop run `bashy google auth-login` there and push it with `bashy google auth-export --to-vault` |

Nothing persists on the runner; a runner disk holds no credential.

## The trove as the virtual drive

One small JSON of mount points, no storage of its own, tokens in the vault, the layout
in the vault too (`trove/layout`) so a hosted call and every outpost of the user read
the same drive. Keys are virtual paths; values reuse the lens locator grammar;
`account` names the vault entry holding the token:

```json
{
  "schema_version": "bashy-trove-v1",
  "/home":  {"locator": "dir:/srv/home@studio-host"},
  "/drive": {"locator": "drive:My Drive/bashy", "account": "me@example.com"},
  "/repo":  {"locator": "gh:owner/repo",        "account": "owner"}
}
```

Common API: `trove mount add|ls|rm`, `trove ls|find|stat|cat|put|add PATH --json`,
rows in `bashy-node-v1` plus trove attributes. A `dir:@host` mount resolves through
the user's outpost and answers exit 3 "host offline" from a hosted call when that
outpost is down; `drive:` and `gh:` work from anywhere with the vault token. This is
639 S1 slimmed (path-keyed, layout in the vault, no grants yet) plus the `drive:` half
of 639 S4; the rest of 639 (presenters, contribute provenance, circle rules, explorer,
shapeable hooks, `app:`/`mail:`/`cal:`) stays there and builds on this.

## Stories

Every verb: `--json`, `--dry-run` where it writes, exit 0/3/1; flows are Bash#
skill-scripts; nothing from the hosted control plane is quoted here.

| # | Story | Tag | Vendor | Acceptance |
|---|---|---|---|---|
| H1 | `bashy mcp serve --hosted`: HTTP only; each request carries a master-signed, versioned, short-TTL per-call identity (caller, task id, idempotency key, secrets token) verified as `--outpost` does from a 0600 runner key re-read per request; fresh home and scratch per call, removed after; timeout; output cap; shell session tools absent; the caller is the principal in audit; effect policy unchanged (gated calls answer `gated`); fail closed | core (bashy + yoke/mcp), medium | codex | tests: valid, expired, replayed and unsigned identity; scratch gone after the call; session tools absent from `tools/list`; principal in the audit line; `run_tool echo` round-trips; a `destroy` verb answers gated |
| H2 | Vault-backed credentials for hosted calls: the verb runs under `bashy secret exec --no-cache` with the per-call `secrets:read` token; one file-typed mapping for Google (`google/<account>/credentials` → the per-account credentials file in scratch, 0600, removed with it); `bashy google auth-status` reads vault presence; new `bashy google auth-export --to-vault`; the account list derives from vault names; naming table in the `bashy secret` doc | yoke (`pkg/secrets`) + `examples/google`, small | codex | fake-vault test: environment present during the call and gone after; the Google file lands 0600 in scratch and is gone after; `auth-export --to-vault` round-trips; a missing secret yields one error naming the vault path to set; the secret-on-argv guard holds |
| H3 | Public wire and routing: `route: hosted` beside `sync` and `pull`; rule = live paired outpost → `sync`; registered caller with no host or host offline → `hosted`; owner-host-bound verbs → `pull` as today; per-call identity payload and `secrets:read` token minting; hosted gated calls settle by the caller on the master; audit `mcp-hosted`; runner registration; connected accounts (consent step writing the user's Google refresh token to their vault). Master side = a cloudbox ticket referenced by id | docs + private dependency | muse (doc); ticket by the operator | hosted section in `docs/vendor-chat-gateway-mvp.md` reviewed by the cloudbox owner; ticket id on the story |
| H4 | Pilot runner on the primary Linux build host: image from the base Containerfile plus release bashy and the `google` example; entry `bashy mcp serve --transport http --hosted` on loopback; one handler per call; tunnel to the master; `examples/hosted-runner/` skill-script (`build|start|stop|status`, `--json`); host taken with `bashy claim` | infra + skill-script | agy | image builds on the build host, never the dev box; a gateway call returns `route: hosted`; allocation per the research |
| H5 | Load test (the original story, kept): on the H4 pilot with the MVP tool mix (`run_tool echo`, `google gmail-list` against a fake gws, `trove ls /drive` fake, `gh pr list` fake); p50/p95/p99, burst drain, CPU per call, peak RSS, scratch; warm floor, secondary host, off-site decision | spike | agy | as written on the story; decision on the card |
| H6 | MVP trove, the virtual drive: `bashy/examples/trove/trove.bsh` with `register.sh`, embedded skill and hermetic tests; layout `bashy-trove-v1` path-keyed, read from and written to the vault entry `trove/layout` (local file override for tests and offline outposts); `mount add|ls|rm`; `ls|find|stat|cat PATH --json` over `bashy lens -t listing` for `dir:`, `dir:@host`, `git:`; `put SRC PATH` and `add URL PATH` to writable `dir:` mounts; exit 0/3/1, host offline = 3 by name | example | claude | rows pass the `bashy-node-v1` validation; `trove cat` of a peer-host file equals `lens` output; unknown path not-found; no live account in tests; inside a hosted call `trove ls` and `trove put` leave no state on the runner |
| H6b | `drive:` (read and write via `bashy google drive-*`, account → vault credential projected by H2) and `gh:` (read-only via `bashy gh api`) mounts for the trove; hermetic fakes | example | glm | `trove ls /drive` and `/repo` list and `cat`; `trove put` lands in Drive; tests need no live account; one live smoke on the operator's own account recorded by role |
| T1 | Test case: a registered user with no outpost asks their agent for their latest Gmail threads and saves a note into `/drive/notes`: `route: hosted`, zero spend, no send; then the same prompts with a paired test outpost online (`route: sync`) and stopped (`route: hosted`); a `/home` mount on that outpost answers "host offline" when stopped; one member action on a shared shaping-enabled app through `run` shows the existing path untouched | test case, skill-script | claude | one Bash# script composing `run` calls; people and hosts by role; ids recorded |
| O1 | Optional, p2: atlas entries for the Tier-6 cloud CLIs (effects `cred`, `net`, `remote`; `spend` on billable providers) so they become typed, effect-gated MCP tools | core (yoke/atlas), small | agy | `bashy mcp tools --tools aws --json` lists it with effects; denied without `--allow cred` |

## Lanes

H3 (wire) and H1 start together; H6 starts at once (hermetic; its hosted acceptance
waits for H1 and H2); H2 after H1; H6b after H2 and H6; H4 after H1 and H2; H5 and T1
after H4, H6b and the master ticket; O1 anytime, optional.

## Gates and venues

Unit tests on the dev box: `go test ./mcp/... ./pkg/secrets/... ./pkg/atlas/...` in
yoke, `GOWORK=off go build ./...` and the MCP tests in bashy, the trove example tests
with fake gws and gh. The pilot image, the end-to-end hosted call, the load test and
T1 run on the primary Linux build host under `bashy claim`, never the dev box, no
hosted CI. Fixtures are synthetic and public; the scrub gate runs at pre-commit.
Every story starts from current heads (`bashy mod drift`, pins bumped, build and unit
tests first); commits carry the sprint trailers; submodule edits are committed and
pushed inside the submodule before the pin bump.

Close: H1–H4, H6 and H6b accepted; H5 recorded; T1 recorded by role; the hosted
section merged; no private plane internals in this repo.

## Decisions (operator, 2026-11-23)

Hosted-first, for cloudbox-registered users with no live outpost; a live paired
outpost always wins the route. No credential passes through the gateway; the runner
pulls the caller's secrets itself with a short-lived caller-scoped token. The trove is
the virtual drive of every cloudbox user: path-keyed mount points, layout in the
vault, no storage of its own. Effects policy unchanged; with no owning host the caller
settles approvals on the master. Member shaping of an invited production app waits for
Sprint 669 M3 and is not pulled in.

## Not doing

Trove grants, presenters, explorer and the other 639 stories (they build on H6); a
member authorization vocabulary (669 M3); a local-install journey (tier 3 has
`install-agent --mcp`); a dhnt-owned Google OAuth client (bring-your-own-project
stays); persistent hosted shells; GitHub writes through the trove (639 S4b); any
cloudbox code in this repo.
