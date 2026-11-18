# Sprint 664: desktop wish route as runtime data

Epic: software-shaping. Parent: Sprint 641 M6 (`ccab603b5e2e`, "the allowance is
policy, not a constant"). Filed 2026-11-18 on the operator's instruction: changing
the wish route's key or model must not need a redeploy or restart.

## Why

The hosted desktop turns a wish into a validated patch by calling an
OpenAI-compatible chat-completions route. Today the route is read only from four
environment variables (`DESKTOP_WISH_URL`, `_TOKEN`, `_MODEL`, `_DAILY_LIMIT`). On
the hosted platform an environment change takes effect only through a new
deployment, so rotating a key or trying another model is a deploy.

The neighbouring setting is already right: the daily allowance is a database row
the superadmin changes at runtime (`bashy desktop policy set`, wire
`/api/v1/desktop-policy/allowance`), and the hub already seals stored credentials
with its master key. The route was simply never moved onto them.

## Outcome

The superadmin changes the route with one verb, and the next wish uses it:

```
bashy desktop policy route set --url URL --model MODEL --token-stdin < key
bashy desktop policy route get --json      # url, model, token_set, source, updated_by
bashy desktop policy route test --json     # one probe wish; reports bare-JSON or why not
bashy desktop policy route unset           # back to the environment fallback
```

## Design

- **One row, scope `*`.** URL, model, sealed token, updated-by, updated-at. The key
  is a scope so a later phase can add per-satellite or per-account routes without
  a schema change; this sprint writes only `*`. The daily limit stays where it is
  (the allowance policy rows); `DESKTOP_WISH_DAILY_LIMIT` remains its fallback.
- **Resolved per wish, no cache.** Every wish and every `allowance` read resolves
  row, then environment. A primary-key read per wish is cheap, and having no cache
  means every replica sees a change at once.
- **The token is write-only.** It is sealed with the hub's existing master key on
  write and never returned; reads report `token_set` only. A `PUT` without a token
  keeps the stored one, so changing the model does not re-enter the key.
- **Probe before save, with an escape hatch.** `PUT` sends one fixed probe wish
  through the candidate route and refuses to save (`route_probe_failed`, with the
  reason) unless the reply is a bare JSON object the wish decoder accepts.
  `--no-probe` (`"probe": false`) skips it, and the response says it was skipped.
  The probe touches no document and no allowance.
- **Only HTTPS routes** (loopback allowed for tests). Redirects stay refused.
- **Same guard as the allowance policy**: the master's superadmin, or a satellite's
  owner on that satellite, through a signed-in session; API tokens are refused.
- **Carried by backup**: the new table is admitted by export and import, and the
  schema revision and route goldens are updated (the lesson of the 641 export fixes).

### Wire (public contract)

| Method | Path | Body / result |
|---|---|---|
| GET | `/api/v1/desktop-policy/route` | `{url, model, token_set, source: "row"\|"env"\|"none", updated_by, updated_at}` |
| PUT | `/api/v1/desktop-policy/route` | `{url, model, token?, probe?: true}` → the GET shape plus `probe: {ok, ms, reason?}` |
| DELETE | `/api/v1/desktop-policy/route` | 204; falls back to the environment |
| POST | `/api/v1/desktop-policy/route/test` | `{wish?}` → `{ok, ms, source, reason?}` against the resolved route |

Errors use the desktop policy envelope (`invalid_change`, `forbidden`,
`route_probe_failed`). The CLI exit codes are those of `bashy desktop policy`.

## Stories

| # | Story | Where | Done when |
|---|---|---|---|
| W0 | Interim route through the environment | live master | wishes available on the master through the four keys (done 2026-11-18, below) |
| W1 | Route as data on the hub | cloudbox (private) | unit and handler tests: superadmin-only, token never returned, row-then-env resolution, probe refusal and skip, a rotation applied to the next wish without restart, export/import round trip, schema and route goldens |
| W2 | CLI parity | yoke `pkg/fleet/desktop_cmd.go`, bashy pin | `route get\|set\|unset\|test --json`, token only from stdin, help described, parity row, focused tests |
| W3 | One cloudbox release | release host | build and unit tests on the gate host, release image, minimal production smoke; tag and deploy with operator approval |
| W4 | Cutover and rotation drill | live master | route set by the verb (`source: row`), the four environment keys removed (the last deploy for this), then a model change applied with no deploy and a wish succeeding on it |

Order: W1 and W2 in parallel (W2 against W1's wire), then W3, then W4.

## W0 evidence (2026-11-18)

- Route: AWS Bedrock's OpenAI-compatible endpoint in us-west-2, model
  `qwen.qwen3-next-80b-a3b-instruct`. A dedicated IAM user with an
  inference-only policy holds a 365-day Bedrock API key, kept in the operator vault;
  a USD 10 monthly budget alerts at 50% and 100%.
- Model choice, measured on the wish prompt: bare correct JSON for three ordinary
  wishes and a proper `error` for an out-of-schema one, about 0.6 s each. Rejected:
  `openai.gpt-oss-20b` (a `<reasoning>` block in the content),
  `mistral.ministral-3-8b-instruct` and `google.gemma-3-12b-it` (JSON in a code fence).
- The live spec gained exactly the four keys (structural diff), applied as one
  rolling deployment. Tracked by todo `0325a8fa3a6d`.

## Venues and gates

Dev box: focused package tests only (`hub/internal/desktop`, `hub/internal/handlers`,
`hub/internal/export`, yoke `pkg/fleet`). Release build and full hub unit tests on
the gate host. No hosted CI. Release tagging and every live-spec change need
operator approval; none is implied by this card beyond W0.

## Out of scope

Per-satellite and per-account routes (the scope key leaves room), the S646
own-subscription routing, a web UI for the route (CLI parity is one way), and
hosted voice transcription (Sprint 641 J1 gap).
