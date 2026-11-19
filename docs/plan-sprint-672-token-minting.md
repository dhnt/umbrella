# Plan — Sprint 672: token minting and CLI parity for access tokens

Operator request 2026-11-19: "need a token that can mint others; all UI
operations must be performable via the bashy CLI; then shorten token
lifetimes; then rotate the exposed tokens."

## Gap

- A host's pairing credential carries only the `host` scope, and the public
  token API mints only a subset of the caller's own scopes. So no CLI path
  can create a scoped host token; Sprint 671 needed the console.
- The console can edit a token (name, scopes, requests per day, route
  policy). The bearer API has mint, list and revoke but no edit.
- A console-made session token for one host has a 10-year lifetime.
- Four satellite attachment tokens were partially exposed in a session
  transcript.

## Model

Per-host tokens are the policy layer: each host holds one revocable token
whose scopes the owner chooses. An **owner minter** token holds the
non-admin scopes the owner wants to delegate and lives only in the vault;
the CLI uses it to mint, edit, list and revoke host tokens. The first minter
must come from the console session (the only parent that can grant scopes a
bearer token does not hold); everything after is CLI.

## Stories

- K1 cloudbox: bearer `PUT /api/v1/tokens/:id` — edit name, scopes, requests
  per day, route policy. Same rule as bearer revoke: not the calling token
  itself; the caller must hold the target's current scopes; new scopes must
  be a subset of the caller's; admin scopes never; OAuth tokens refused;
  audited.
- K2 yoke: `bashy token edit`; `--token-secret NAME` on create, list, edit
  and revoke so the minter authenticates from the vault without printing.
- K3 bootstrap the minter once (`bashy browser`, value straight to the
  vault); re-mint the dev box's session token from the CLI with a lifetime
  of at most 365 days; revoke the 10-year one.
- K4 rotate the four exposed satellite attachment tokens and verify the host
  reconnects.

## Non-goals

No change to pairing, satellite attachment or the scope catalog. No
automatic minting at pairing time.

## Acceptance and venue

Unit tests beside the changed code on the dev box; end-to-end mint, edit,
list and revoke against the live control plane after its release. The
control-plane release needs the operator's go-ahead.

## Rollback

Revert the endpoint and CLI commits; revoke any minted token by id.
