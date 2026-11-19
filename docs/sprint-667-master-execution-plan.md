# Sprint 667: provable relays and agent authorization across outposts and satellites

Sprint UUID: `d0be82cf-0173-57bb-822c-d3fb5c482050`. Epic: coordination.
Status: **planning only** (filed 2026-11-18). The sprint card and its stories
are authoritative.

## Why

Group work spans people and agents on different outposts and satellites.
Today a relayed message ("the owner approved this", "the hold is lifted") is
a paraphrase: the recipient cannot tell who actually said it, whether it was
changed, or whether it still applies. Approvals, handoffs and owner rulings
travel this way between sprint managers, members and hosts. Without proof,
any cross-host group feature rests on trust in the last relayer.

## Primary goal

Only authorized agents may run critical operations, and anyone receiving a
relayed message, human or agent, on any outpost or satellite, can verify:

- who originally said it;
- who relayed it;
- what it authorizes;
- until when.

An unsigned relay reads as **unverified**, never as authority.

## Design

1. **Signed records.** Every message on the board or in an inbox is a record
   with an id, an author principal, a time, a content hash and a signature by
   the author's key.
   - An agent signs with its seat key.
   - A human signs with a key bound to their cloudbox identity: a passkey or
     a session-bound device key.
2. **Humans sign their own statements.** An agent never signs for a person.
   When a statement is meant to travel, the agent turns it into a one-click
   "sign this statement" prompt, and the person approves it with their own
   key. The same route serves CLI, web and mobile.
3. **Relay by reference.** A relay carries the original record (id, hash and
   signature). The relayer adds their own signature over that reference plus
   any comment. The chain runs author → relayer(s) → recipient. Paraphrase is
   allowed only as a comment, never as the authority.
4. **Verify anywhere.** `bashy mb verify ID [--json]` checks every signature
   and hash in the chain. It reports who said what and when, and who relayed
   it. Keys are resolved through the master for any outpost or satellite
   (public keys only), with offline verification from a cached key set.
5. **Scope and expiry.** A statement names what it authorizes (a sprint, a
   release, a share) and when it expires. A verifier refuses replays past
   expiry or outside scope.
6. **Owner policy.** The owner decides which statements need a signature, for
   example releases, membership and shares. This is declared configuration
   and shapeable like any other route.

## Agent authorization for critical operations

Proof (above) says who decided; authorization says who may act. Some
operations (deploy, release, reading sensitive data, sharing) are critical,
and only some agents may run them.

7. **Agent grants work like token scopes.**
   - An owner grants an agent named permissions, for example `deploy`,
     `release`, `secrets:read` or `share:write`.
   - Each grant is bound to the agent's principal and seat key, carries a
     scope (which host, app, sprint or vault path) and an expiry, and is
     revocable.
   - It uses the same vocabulary and attenuation rules as cloudbox token
     scopes, so an agent's token can never exceed its grants.
8. **Critical operations are protected at the gateway.** bashy's effect
   guard is bound to the principal (the MVP in `bashy-agent-permissions.md`
   §5). A critical operation runs only when:
   - the acting agent holds the grant; and
   - where the owner's policy requires it, a fresh signed human approval
     (S2, S5) for that exact operation is present.

   Otherwise it fails loudly, naming the missing grant or approval and how
   to obtain it, with an explicit, logged escape hatch for the owner.
9. **Audited.** Each critical operation records the grant used and the
   signed approval chain, verifiable with the same `bashy mb verify`.

## Stories (draft; split further when started)

| # | Story |
|---|---|
| S1 | Record format and signing: content hash, signature, agent seat keys, key registry on the master (public keys only, by principal) |
| S2 | Human statements: a one-click sign prompt (CLI, web and mobile) bound to the cloudbox identity, never signed by an agent |
| S3 | Relay by reference on `bashy mb` / inbox / sprint comments; paraphrase only as a comment |
| S4 | `bashy mb verify ID [--json]`: chain check, hash check, cached keys for offline use |
| S5 | Scope and expiry: authorizations that cannot be replayed |
| S6 | Owner policy: which statements require signatures (releases, membership, shares) |
| S7 | Cross-host acceptance: two outposts on one satellite, and two satellites, end to end |
| S8 | Agent grants as scopes: grant/revoke/list per agent principal (scope, expiry), same vocabulary and attenuation as cloudbox token scopes |
| S9 | Critical-operation guard: principal-bound effect guard; deploy, release, secrets read and share require the grant plus, per owner policy, a signed approval; loud refusal naming the fix; logged owner override |
| S10 | Audit: each critical operation records the grant and the approval chain; verifiable |

## Not doing

Encrypting message bodies (a separate concern), and any change to the
meaning of existing unsigned messages beyond labelling them unverified.
