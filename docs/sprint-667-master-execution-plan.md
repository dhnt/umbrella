# Sprint 667: provable relays across outposts and satellites

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

Anyone receiving a relayed message, human or agent, on any outpost or
satellite, can verify:

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

## Not doing

Encrypting message bodies (a separate concern), and any change to the
meaning of existing unsigned messages beyond labelling them unverified.
