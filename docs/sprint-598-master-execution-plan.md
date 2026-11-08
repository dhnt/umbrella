# Sprint 598: agent-friendly satellite CLI

Goal: agents can discover satellites and run existing daily operations through composable bashy commands with explicit account selection and accurate capability discovery.

## Authorization and scope

The operator authorized delivery after creating the backlog: take the sprint as manager, implement the four stories, add E2E coverage, and verify the features. This supersedes the creation-only restriction recorded on the card and stories. E2E tests run on the remote Windows test host, never on the development host. Coordinate its existing holder before use.

Keep the agreed KISS/MVP boundary: extend existing verbs and account resolution; compose tailored behavior through existing software shaping. No new workflow engine, generic HTTP verb, context store, service API, provisioning, membership administration, upgrades, or recovery implementation.

## Orientation and sequence

- Read all four umbrella stories: S1 `299f93c16dd2`, S2 `f99b5693f5b7`, S3 `d8df96f14240`, S4 `44d88adca4a5`.
- Existing public seams: fleet OwnerClient.Satellites lists ID/name/endpoint/state; NewSatelliteCmd mounts invite/transfer; cloudOverrides and ResolveCloudAccount already provide invocation-scoped selection. The bashy frontend builds schemas from the same Cobra constructors.
- S1 adds list/show and a shared exact-ID-first, unique-exact-name selector. S2 extends account selection. S3 adds transfer JSON/noninteractive behavior using that selector. Serialize edits to these shared constructors. S4 reconciles metadata, recovery-gap claims and concise composition/shaping guidance.
- These are CLI defects/capability gaps within existing contracts. Missing host-to-satellite bearer assignment remains an explicit out-of-scope service gap. Deployed service compatibility must be measured, not inferred from client code.
- Existing tests include satellite invite fixtures, account isolation tests, prune/transfer HTTP fixtures, and bashy fleet frontend/schema tests. Inspect and extend them before creating another harness.

## Verification and delivery

- Focused fixture tests cover list/show, empty/missing/ambiguous results, authorization and unavailable endpoints; account routing/conflicts/no fallback; transfer confirmation, JSON and mutation refusal.
- Extend existing E2E infrastructure as appropriate to exercise the actual built CLI against HTTP fixtures and, where available, existing cloudbox/satellite sandbox services. A composed account -> discovery -> host inspection -> explicit operation must run against fixtures. No real ownership transfer or pairing of operator hosts for a smoke test.
- All E2E execution and heavy builds/test suites run on the remote test host after an agreed claim window. Use isolated candidate source/artifacts and record exact revisions/digests, commands, raw evidence and measured outcomes. Keep private access details and credentials out of public artifacts.
- Run independent final gates on the integrated candidate. Distinguish fixture, sandbox-service and live-service evidence; unavailable live prerequisites are not passes. Use existing runners and proportionate regression checks.
- Delegate bounded implementation; manager independently reviews and gates changes. Preserve foreign Sprint 597 changes and host use. Commit/push within owning submodules before umbrella gitlink updates, with required story trailers and actual author attribution.
- Close accepted stories promptly, retain evidence and continuity, release owned claims, and end only after all required acceptance passes.
