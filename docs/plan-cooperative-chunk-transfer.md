# Cooperative chunk transfer for bashy and sphere

Sprint: **657**. Sprint-ID: `0060bff8-31f3-58f8-815c-ce48e79d1e06`.

## Status

Sprint 657 closed as **won’t do** on 2026-11-25. For the primary use case,
clients on a LAN can download artifacts directly from the satellite or the
owner’s outpost acting as the artifact server. All seven stories closed as
`wontfix`. The design below preserves the original proposal.

## Proposed outcome

Provide one embedded, pure-Go chunk-transfer engine for files, directories,
and bashy releases. Fetch an authenticated manifest first, reuse local data,
coordinate missing chunks across outposts, retrieve different origin chunks
concurrently, exchange verified chunks among participants, and reconstruct the
original content. GitHub Releases is the initial public fallback store.

Use `github.com/folbricht/desync` as a library, not an external executable.
Reuse its chunking, compression, indexes, directory archives, and reassembly.
Pin a reviewed version and require the transfer import closure to build with
`CGO_ENABLED=0`. Upstream's release configuration explicitly uses that setting;
our pinned dependency and consumer builds still need independent validation.

## Download sphere membership

Sphere currently describes execution tier 4, exposed through `bashy peer`
(`sphere` is an alias), not a durable shared membership object. Download
cooperation is an owner-anchored transfer policy over the existing identities.

The initiating owner anchors a download group. Its eligible participants are:

1. All participating outposts paired with cloudbox under that owner/email.
2. Participating outposts paired under other owners/emails with an active
   mutual membership relationship with the initiating owner.

Include all qualifying mutual members for the MVP. Do not filter by circle.
A teacher can initiate a group across students, or an organization admin
across employees. Students or employees need no membership relationship with
one another. Relationships are evaluated directly against the initiating
owner; friends of members do not gain admission transitively.

Existing circles are private, owner-scoped labels, not globally shared groups.
Matching circle names grant nothing. The existing membership contract requires
both directional rows to be active; pending or one-sided entries do not qualify.
See `yoke/docs/cloudbox-members-attach-wire.md`, sections 2 and 2b.

Authenticate host ownership and mutual membership using the authority's public
authorization contract, not a self-advertised email. Key groups by the
authority-qualified initiating-owner identity and a transfer-session ID.
Session admission grants access only to that session's public chunks. Private
file transfers require explicit artifact and recipient grants.

Revalidate admission using the existing membership-cache lifetime (30 seconds).
Revocation stops new assignments and unauthorized serving; it cannot retract
public bytes already received. A coordination timeout must never bypass
membership checks. Reuse authorization only for its established validity.

## Source-verified integration facts and gaps

- `yoke/external/sphere` delegates to the outpost mesh agent at runtime. Keep
  bashy independent of outpost at build time.
- `outpost/internal/agent/peerstatus` consumes an owned/shared host roster.
  Its current rows do not provide an authenticated owner/mutual-member binding
  sufficient for the new admission rule. Add a narrowly scoped public transfer
  authorization contract and fixtures; do not infer authority from visibility.
- The mesh has persistent libp2p identities, rendezvous, mDNS, service discovery,
  and loopback service forwarding. mDNS can connect nearby outposts outside the
  authorized roster. Connectivity does not establish download membership.
- Mesh `PeerLinkInfo` reports direct `tp`, `lan`, or `wan` links and a local LAN
  label. Use these as locality hints, never durable authorization/group IDs.
- The existing forwarder checks service exposure, not transfer-session
  authorization. Authenticate the transfer service and session itself; do not
  assume its loopback listener can identify the original remote caller.
- Mesh peer IDs and SSH discovery fingerprints are distinct identities. Bind
  authorization to the actual authenticated transport identity explicitly.
- Bashy's `self fetch` and versioned `self install` resolve release archives
  through binmgr and install the expected product members. Integrate there,
  preserving existing Windows and other platform installation behavior.

The public cloudbox authorization extension is a real delivery dependency, not
an existing endpoint to assume. This public sprint may define its wire contract
and test against fixtures; any private service implementation belongs outside
this public repository. End-to-end completion requires deployed contract
evidence without copying private source or raw private evidence into this repo.

## Engine and command interfaces

- Put the reusable engine in `yoke/pkg/transfer`. Put mesh integration in
  outpost and command/install integration in bashy; preserve import direction.
- Provide publishing, fetching, sending, inspection, and pruning APIs, with
  context cancellation and bounded resource use. Backends expose manifest and
  chunk lookup/read/write as appropriate.
- Use a versioned manifest binding artifact identity, index digest,
  complete-content digest, and chunking profile. Release manifests also bind
  release version, source commit, and platform.
- Store verified chunks by content hash. Verify before atomic cache writes;
  retain completed chunks after interruption and reconstruct into staging.
- Expose `transfer publish`, `fetch`, `send`, `inspect`, and `prune`. Publishing
  initially writes a local chunk store; fetching supports local, HTTP, and
  sphere sources. Sending targets an authorized peer's designated inbox.
- Support files and directories, executable permissions, and safe relative
  symlinks. Reject traversal and special files. Report metadata that the
  destination cannot represent rather than silently changing it.
- Enforce manifest/index size, chunk/decompressed size, concurrency, cache,
  retry, and cancellation bounds. Offer explicit pruning that respects active
  transfers. Never upload private transfers to GitHub automatically.

## Coordination and rate limits

One outpost transfer manager coalesces requests for an identical chunk across
jobs and sessions. Use an outpost-owned service, with CLI requests routed
through it when present. Standalone fetching remains available without outpost.

Run the coordinator on an initiating-owner outpost. Prefer a configured eligible
coordinator; otherwise choose the lowest eligible initiating-owner mesh peer
ID. Advertise coordinator identity and epoch, settle competing views, and
reconcile stale assignments after a coordinator change.

Before origin access, query admitted participants for verified chunks. Artifact
sessions use the verified manifest digest; chunk leases use content hashes.
Assign distinct missing chunks to participants that need them and have available
capacity. Announce completion immediately after verification so other members
can fetch from peers. Session authorization permits student-to-student public
chunk exchange without granting unrelated host or file access.

Locality and membership are separate. Prefer local cache, direct local peer
copies, authorized remote cached copies, then origin access. Remote admitted
members may participate, but avoid assignments that add unnecessary WAN hops.
Use observed links and transfer performance for scheduling. Do not infer a
shared internet connection from common ownership or membership.

Apply shared origin concurrency/bandwidth limits across local jobs, group
origin concurrency limits across participants, and separate peer upload/download
limits. Add configurable network-domain budgets where explicitly configured;
do not automatically treat a subnet or public IP as a common budget boundary.
Schedule fairly so a large release cannot starve other transfers.

Leases expire and renew while work progresses. Reassign stalled owners. After
a coordinator timeout, continue independently under local limits, without
relaxing authorization. Suppress redundant work when coordination recovers.
One origin fetch per chunk is a healthy-operation target within a coordinated
group, not an exactly-once promise across partitions or overlapping groups.
The aggregate group limit can temporarily be exceeded during independent mode.

## GitHub publication and explicit upgrades

- Publish individual compressed chunk assets, desync indexes, an Ed25519-signed
  release manifest, and its signature. Adapt chunk IDs to flat asset names.
- Chunk the final uncompressed product members, not a whole compressed archive,
  so installed binaries can seed reusable chunks. Include all members required
  by the existing product installer and deduplicate chunks within a release.
- Pin trusted signing public keys in clients; keep private keys in release
  infrastructure. Bind signatures to the exact manifest bytes and verify
  referenced indexes and reconstructed content.
- Preflight the complete release asset count, including existing archives,
  signatures, indexes, and checksums, against GitHub's 1,000-asset limit. Fail
  before publication if over budget; do not silently omit artifacts.
- Publish chunks and indexes before exposing the completed signed manifest.
  Resolve `latest` once to a concrete release to avoid mixing versions.
- Integrate with existing explicit `self fetch` and versioned `self install`.
  Preserve archive compatibility only when an older release has no chunk
  manifest. Invalid signatures or malformed manifests fail closed.
- Add no automatic background upgrade trigger. Preserve release approval,
  candidate verification, staging, and platform replacement gates. Filing this
  sprint authorizes no release, infrastructure provisioning, or key creation.

## Defaults

| Setting | MVP default |
| --- | --- |
| Chunk minimum / average / maximum | 2 / 8 / 32 MiB |
| Origin concurrency per outpost | 4 |
| Origin concurrency per group | 8 |
| Bandwidth cap | Configurable; no fixed byte-rate cap initially |
| Chunk lease lifetime / renewal | 30 / 10 seconds |
| Unreachable coordinator timeout | 10 seconds before independent operation |
| Cross-owner admission | All active mutual members; no circle filter |
| Release authenticity | Ed25519-signed manifest |

## Dependency-ordered implementation stories

| Step | Story-ID | Dependency |
| --- | --- | --- |
| S1 Engine and local CLI | `3d4b621a248c` | None |
| S2 Admission and group model | `d35bccc01e28` | S1 interfaces |
| S3 Peer transfer service | `4a7a9dbde6db` | S1, S2 |
| S4 Cooperative scheduler | `6c846a9986c7` | S3 |
| S5 Signed GitHub publication | `f18a3fc2ad92` | S1 |
| S6 Self fetch/install | `e0d62fe01886` | S3, S4, S5 |
| S7 Integration acceptance | `489b9bc6944c` | S1-S6 |

1. **S1 Engine and local CLI:** pin desync, verified stores/manifests,
   file/directory publish and fetch, resume, inspection and pruning. Prove
   pure-Go builds and safe reconstruction. Depends on no new service contract.
2. **S2 Admission contract and group model:** public authorization contract and
   fixtures, authority-qualified identities, same-owner/mutual-member admission,
   session-scoped chunk exchange, refresh and revocation. Depends on S1 shapes;
   record the private-service integration dependency explicitly.
3. **S3 Outpost transfer service and peer exchange:** authenticated service over
   existing mesh forwarding, batched availability, send/inbox, peer fetching,
   shared local request coalescing and local limits. Depends on S1 and S2.
4. **S4 Cooperative scheduler:** coordinator discovery/epochs, distinct chunk
   leases, fair assignment, group limits, locality preference, recovery and
   independent mode. Depends on S3.
5. **S5 Release publication and signing:** deterministic release-member chunking,
   individual GitHub assets, asset-budget preflight, signed-manifest generation
   and verification. Depends on S1; rollout must preserve existing release gates.
6. **S6 Self fetch/install integration:** concrete-release resolution, installed
   member seeds, peer-first coordinated retrieval, complete-member verification,
   old-release archive fallback and existing platform installation. Depends on
   S3, S4 and S5.
7. **S7 Integration acceptance and operations:** deployed authorization-contract
   evidence, multi-owner/classroom fixtures and live acceptance, failure recovery,
   observable counters, user documentation and supported-platform verification.
   Depends on all preceding stories. Do not mark done from fixture-only evidence.

All stories remain unassigned and unstarted unless the operator appoints a
manager. Delivery commits must carry the sprint/story trailers. Implement and
push changes inside each submodule before committing umbrella pin bumps.

## Acceptance and evidence

- Exact file/directory reconstruction, empty files, duplicate chunks, executable
  permissions, safe symlinks, unsupported metadata, traversal and special files.
- Teacher plus students: same-owner outposts and active mutual-member outposts
  cooperate without student-to-student membership; pending, one-sided, unrelated
  and transitively related owners are denied. Revocation prevents new access.
- Simultaneous cold starts fetch different missing chunks from origin and
  distribute verified chunks to other participants. A later participant reuses
  cached chunks. Count origin requests and bytes, not only successful exits.
- Concurrent local jobs coalesce the same chunk; overlapping sessions retain
  local limits. Test local/remote suppliers, fairness, configured caps, slow or
  corrupt peers, owner stalls, cancellation, restart/resume, partitions and
  coordinator change. Assert documented duplicate/overshoot exceptions.
- Reject manifest/index tampering, wrong platform or release, missing members,
  unauthorized session access, oversized data and incomplete publication.
- Verify legacy archive fallback, installed-member reuse, signature trust and
  Windows replacement, including a failure before installation leaves the
  existing installation intact.
- Expose participant scope, coordinator/epoch, lease ownership, wait time,
  origin/peer bytes, cache hits, retries, duplicate fetches and rate allocations.
- Run focused package tests, standalone dependency builds and pure-Go builds,
  then required affected repository checks through established self-hosted
  lanes. Heavy suites do not run on the development machine. Bind evidence to
  exact candidate revisions and separate pre-existing failures from regressions.

## Resume instructions

Read the sprint card and its seven stories, then this spec. Appoint the manager
before starting execution; no manager or conductor lease is implied by filing.
Start with S1 and S2's public wire-contract design, explicitly recording the
authorization-service gap rather than inventing an existing endpoint. Keep
private service source and deployment evidence outside this public repository.
No implementation tests or release claims exist yet.
